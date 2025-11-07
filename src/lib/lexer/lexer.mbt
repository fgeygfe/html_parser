///|
priv suberror EndOfInput

///|
pub fn tokenize(
  input : String
) -> Array[(@parser.Token, Int, Int)] {
  let tokens : Array[(@parser.Token, Int, Int)] = []
  let end = input.length()
  let mut cursor = 0
  
  fn peek_char() raise {
    guard cursor < end else { raise EndOfInput }
    input.get_char(cursor).unwrap()
  }

  fn advance() {
    cursor += 1
  }

  fn skip_whitespace() {
    while true {
      try peek_char() catch {
        _ => break
      } noraise {
        c => if c == ' ' || c == '\t' || c == '\r' || c == '\n' {
          advance()
        } else {
          break
        }
      }
    }
  }

  letrec read_identifier = fn() -> String {
    let buf = StringBuilder::new()
    while true {
      try peek_char() catch {
        _ => break
      } noraise {
        c => if (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || 
                 (c >= '0' && c <= '9') || c == '-' || c == '_' || c == ':' {
          buf.write_char(c)
          advance()
        } else {
          break
        }
      }
    }
    buf.to_string()
  }

  letrec read_text = fn() -> String raise {
    let buf = StringBuilder::new()
    while true {
      try peek_char() catch {
        EndOfInput => break
        err => raise err
      } noraise {
        '<' => break
        c => {
          buf.write_char(c)
          advance()
        }
      }
    }
    buf.to_string()
  }

  // 读取未引号的属性值（直到空白字符或 > 或 =）
  letrec read_unquoted_value = fn() -> String {
    let buf = StringBuilder::new()
    while true {
      try peek_char() catch {
        _ => break
      } noraise {
        c => if c == ' ' || c == '\t' || c == '\r' || c == '\n' || 
                 c == '>' || c == '=' || c == '/' {
          break
        } else {
          buf.write_char(c)
          advance()
        }
      }
    }
    buf.to_string()
  }

  // 读取引号内的属性值
  letrec read_quoted_value = fn(quote_char : Char) -> String raise {
    advance() // 跳过开始引号
    let buf = StringBuilder::new()
    while true {
      try peek_char() catch {
        EndOfInput => raise EndOfInput
        err => raise err
      } noraise {
        c => if c == quote_char {
          break
        } else {
          buf.write_char(c)
          advance()
        }
      }
    }
    advance() // 跳过结束引号
    buf.to_string()
  }

  // 跳过注释 <!-- ... -->
  fn skip_comment() raise {
    // 已经读取了 '<' 和 '!'
    // 检查是否是 "<!--"
    let c1 = peek_char()
    advance()
    let c2 = peek_char()
    advance()
    if c1 == '-' && c2 == '-' {
      // 读取直到 "-->"
      while true {
        try peek_char() catch {
          _ => break
        } noraise {
          '>' => {
            // 检查前两个字符是否是 "--"
            if cursor >= 2 {
              let prev1 = input.get_char(cursor - 1).unwrap()
              let prev2 = input.get_char(cursor - 2).unwrap()
              if prev1 == '-' && prev2 == '-' {
                advance() // 跳过 '>'
                break
              }
            }
            advance()
          }
          _ => advance()
        }
      }
    }
  }

  // 跳过 DOCTYPE <!DOCTYPE ... >
  fn skip_doctype() {
    // 已经读取了 '<' 和 '!'
    // 读取直到 '>'
    while true {
      try peek_char() catch {
        _ => break
      } noraise {
        '>' => {
          advance()
          break
        }
        _ => advance()
      }
    }
  }

  // 跳过 CDATA <![CDATA[ ... ]]>
  fn skip_cdata() raise {
    // 已经读取了 '<' 和 '!'
    // 检查是否是 "[CDATA["
    let c = peek_char()
    if c == '[' {
      advance()
      // 读取直到 "]]>"
      while true {
        try peek_char() catch {
          _ => break
        } noraise {
          '>' => {
            // 检查前两个字符是否是 "]]"
            if cursor >= 2 {
              let prev1 = input.get_char(cursor - 1).unwrap()
              let prev2 = input.get_char(cursor - 2).unwrap()
              if prev1 == ']' && prev2 == ']' {
                advance() // 跳过 '>'
                break
              }
            }
            advance()
          }
          _ => advance()
        }
      }
    }
  }

  // 读取标签内的属性
  fn read_attributes() -> Array[(@parser.Token, Int, Int)] raise {
    let attrs : Array[(@parser.Token, Int, Int)] = []
    skip_whitespace()
    
    while true {
      try peek_char() catch {
        _ => break
      } noraise {
        '>' => break
        '/' => {
          // 可能是自闭合标签 "/>"
          let start = cursor
          advance()
          try peek_char() catch {
            _ => break
          } noraise {
            '>' => {
              advance()
              attrs.push((@parser.SELF_CLOSE, start, cursor))
              break
            }
            _ => {
              // 单独的 '/'，可能是属性名的一部分，回退
              cursor = start
              break
            }
          }
        }
        c => if c == ' ' || c == '\t' || c == '\r' || c == '\n' {
          skip_whitespace()
        } else {
          // 读取属性名
          let attr_start = cursor
          let attr_name = read_identifier()
          if attr_name.length() > 0 {
            attrs.push((@parser.ATTR_NAME(attr_name), attr_start, cursor))
            skip_whitespace()
            
            // 检查是否有 '='
            try peek_char() catch {
              _ => break
            } noraise {
              '=' => {
                let eq_start = cursor
                advance()
                attrs.push((@parser.EQUAL, eq_start, cursor))
                skip_whitespace()
                
                // 读取属性值
                try peek_char() catch {
                  _ => break
                } noraise {
                  '"' => {
                    let quote_start = cursor
                    attrs.push((@parser.QUOTE, quote_start, quote_start + 1))
                    let value = read_quoted_value('"')
                    let value_end = cursor - 1
                    attrs.push((@parser.ATTR_VALUE_QUOTED(value), quote_start + 1, value_end))
                    attrs.push((@parser.QUOTE, value_end, cursor))
                  }
                  '\'' => {
                    let quote_start = cursor
                    attrs.push((@parser.QUOTE, quote_start, quote_start + 1))
                    let value = read_quoted_value('\'')
                    let value_end = cursor - 1
                    attrs.push((@parser.ATTR_VALUE_QUOTED(value), quote_start + 1, value_end))
                    attrs.push((@parser.QUOTE, value_end, cursor))
                  }
                  _ => {
                    // 未引号的值
                    let value_start = cursor
                    let value = read_unquoted_value()
                    attrs.push((@parser.ATTR_VALUE(value), value_start, cursor))
                  }
                }
                skip_whitespace()
              }
              _ => {
                // 布尔属性，没有值
                skip_whitespace()
              }
            }
          } else {
            break
          }
        }
      }
    }
    attrs
  }

  // 重新设计：使用状态机来处理标签
  letrec process_input = fn() raise {
    while cursor < end {
      try peek_char() catch {
        _ => break
      } noraise {
        '<' => {
          let langle_start = cursor
          advance()
          match peek_char() {
            '/' => {
              // 结束标签 </tag>
              let slash_start = cursor
              advance()
              skip_whitespace()
              let tag_start = cursor
              let tag_name = read_identifier()
              skip_whitespace()
              match peek_char() {
                '>' => {
                  advance()
                  let rangle_start = cursor - 1
                  // 输出：CLOSE_TAG_START, TAG_NAME, RANGLE
                  tokens.push((@parser.CLOSE_TAG_START, langle_start, slash_start + 1))
                  tokens.push((@parser.TAG_NAME(tag_name), tag_start, tag_start + tag_name.length()))
                  tokens.push((@parser.RANGLE, rangle_start, cursor))
                }
                _ => panic()
              }
            }
            '!' => {
              // 可能是注释、DOCTYPE 或 CDATA
              advance()
              try peek_char() catch {
                _ => break
              } noraise {
                '-' => {
                  // 注释 <!--
                  skip_comment()
                }
                '[' => {
                  // CDATA <![CDATA[
                  skip_cdata()
                }
                _ => {
                  // DOCTYPE <!DOCTYPE
                  skip_doctype()
                }
              }
            }
            _ => {
              // 开始标签 <tag 或 <tag/> 或 <tag attr="value">
              let tag_start = cursor
              let tag_name = read_identifier()
              if tag_name.length() > 0 {
                // 输出 LANGLE 和 TAG_NAME
                tokens.push((@parser.LANGLE, langle_start, langle_start + 1))
                tokens.push((@parser.TAG_NAME(tag_name), tag_start, cursor))
                
                // 读取属性
                let attrs = read_attributes()
                let mut has_self_close = false
                for attr in attrs {
                  match attr.0 {
                    @parser.SELF_CLOSE => has_self_close = true
                    _ => ()
                  }
                  tokens.push(attr)
                }
                
                // 如果已经有 SELF_CLOSE，就不需要再输出 RANGLE
                // 否则检查是否还有 '>'
                if !has_self_close {
                  try peek_char() catch {
                    _ => break
                  } noraise {
                    '>' => {
                      let rangle_start = cursor
                      advance()
                      tokens.push((@parser.RANGLE, rangle_start, cursor))
                    }
                    _ => ()
                  }
                }
              } else {
                // 无效的标签，跳过
                break
              }
            }
          }
        }
        ' ' | '\t' | '\r' | '\n' => {
          skip_whitespace()
        }
        _ => {
          // 文本内容
          let text_start = cursor
          let text = read_text()
          if text.length() > 0 {
            tokens.push((@parser.TEXT(text), text_start, cursor))
          }
        }
      }
    }
  }

  try process_input() catch {
    EndOfInput => ()
    _ => ()
  }
  // 添加 EOF token
  tokens.push((@parser.EOF, cursor, cursor))
  tokens
}
