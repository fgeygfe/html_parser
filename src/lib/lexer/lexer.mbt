// HTML 分词器模块
// 负责将 HTML 字符串分解为标记(Token)序列

/// HTML token type definition
pub enum HtmlToken {
  /// Start tag, e.g. <div>, <p>
  StartTag(String)
  /// End tag, e.g. </div>, </p>
  EndTag(String)
  /// Self-closing tag, e.g. <br/>, <img/>
  SelfClosingTag(String)
  /// Text content
  Text(String)
  /// HTML comment
  Comment(String)
}

/// Internal state of the tokenizer
priv struct TokenizerState {
  input: String      // Input HTML string
  position: Int      // Current parsing position
  length: Int        // Total string length
}

//

/// Create a new tokenizer state from the given HTML string.
/// 
/// # Arguments
/// * `html` - The HTML string to be tokenized.
/// 
/// # Returns
/// A TokenizerState struct initialized at position 0.
fn create_state(html: String) -> TokenizerState {
  { input: html, position: 0, length: html.length() }
}

/// Get the character at the current position in the tokenizer state.
/// 
/// # Arguments
/// * `state` - The current TokenizerState.
/// 
/// # Returns
/// An Option[Char] containing the character at the current position, or None if out of bounds.
fn current_char(state: TokenizerState) -> Option[Char] {
  if state.position < state.length {
    match state.input.get(state.position) {
      Some(code) => Some(code.unsafe_to_char())
      None => None
    }
  } else {
    None
  }
}

/// Safely get the character at the specified position in the input string.
/// 
/// # Arguments
/// * `input` - The HTML input string.
/// * `position` - The position to retrieve the character from.
/// 
/// # Returns
/// An Option[Char] containing the character at the given position, or None if out of bounds.
fn get_char_at(input: String, position: Int) -> Option[Char] {
  match input.get(position) {
    Some(code) => Some(code.unsafe_to_char())
    None => None
  }
}

/// Advance the tokenizer state to the next character.
/// 
/// # Arguments
/// * `state` - The current TokenizerState.
/// 
/// # Returns
/// A new TokenizerState with the position incremented by 1.
fn advance(state: TokenizerState) -> TokenizerState {
  { input: state.input, position: state.position + 1, length: state.length }
}

/// Skip whitespace characters (space, tab, newline, carriage return) in the tokenizer state.
/// 
/// # Arguments
/// * `state` - The current TokenizerState.
/// 
/// # Returns
/// A TokenizerState advanced past any whitespace characters.
fn skip_whitespace(state: TokenizerState) -> TokenizerState {
  let mut current_state = state
  while true {
    match current_char(current_state) {
      Some(' ') | Some('\t') | Some('\n') | Some('\r') => {
        current_state = advance(current_state)
      }
      _ => break
    }
  }
  current_state
}

/// Read the tag name from the current position until a '>', '/', or whitespace character is encountered.
/// 
/// # Arguments
/// * `state` - The current TokenizerState, positioned at the start of a tag name.
/// 
/// # Returns
/// A tuple containing the tag name as a String and the updated TokenizerState.
fn read_tag_name(state: TokenizerState) -> (String, TokenizerState) {
  let mut current_state = state
  let chars = []
  
  while true {
    match current_char(current_state) {
      Some(c) => {
        if c == '>' || c == '/' || c == ' ' || c == '\t' || c == '\n' || c == '\r' {
          break
        }
        chars.push(c)
        current_state = advance(current_state)
      }
      None => break
    }
  }
  
  // 将字符数组转换为字符串
  let mut result = ""
  for char in chars {
    result = result + char.to_string()
  }
  
  (result, current_state)
}

/// Read text content from the current position until a '<' character is encountered.
/// 
/// # Arguments
/// * `state` - The current TokenizerState, positioned at the start of text content.
/// 
/// # Returns
/// A tuple containing the text content as a String and the updated TokenizerState.
fn read_text_content(state: TokenizerState) -> (String, TokenizerState) {
  let mut current_state = state
  let chars = []
  
  while true {
    match current_char(current_state) {
      Some('<') => break
      Some(c) => {
        chars.push(c)
        current_state = advance(current_state)
      }
      None => break
    }
  }
  
  // 将字符数组转换为字符串
  let mut result = ""
  for char in chars {
    result = result + char.to_string()
  }
  
  (result, current_state)
}

/// Check if the current tag is a self-closing tag by looking for a '/' before the '>' character.
/// 
/// # Arguments
/// * `state` - The current TokenizerState.
/// 
/// # Returns
/// True if the tag is self-closing, otherwise false.
fn is_self_closing(state: TokenizerState) -> Bool {
  if state.position > 0 {
    match get_char_at(state.input, state.position - 1) {
      Some('/') => true
      _ => false
    }
  } else {
    false
  }
}

/// Process a tag (start tag, end tag, or self-closing tag) and return the corresponding token.
/// 
/// # Arguments
/// * `state` - The TokenizerState at the start of a tag (at '<').
/// 
/// # Returns
/// A tuple containing the parsed HtmlToken and the updated TokenizerState.
fn process_tag(state: TokenizerState) -> (HtmlToken, TokenizerState) {
  let mut current_state = advance(state) // 跳过 '<'
  
  // 检查是否为结束标签
  let is_end_tag = match current_char(current_state) {
    Some('/') => {
      current_state = advance(current_state)
      true
    }
    _ => false
  }
  
  // 读取标签名
  let (tag_name, new_state) = read_tag_name(current_state)
  current_state = new_state
  
  // 跳过到 '>'
  while true {
    match current_char(current_state) {
      Some('>') => {
        current_state = advance(current_state)
        break
      }
      Some(_) => {
        current_state = advance(current_state)
      }
      None => break
    }
  }
  
  // 检查是否为自闭合标签（在 '>' 前有 '/'）
  if current_state.position > 1 {
    match get_char_at(current_state.input, current_state.position - 2) {
      Some('/') => (SelfClosingTag(tag_name), current_state)
      _ => {
        if is_end_tag {
          (EndTag(tag_name), current_state)
        } else {
          (StartTag(tag_name), current_state)
        }
      }
    }
  } else if is_end_tag {
    (EndTag(tag_name), current_state)
  } else {
    (StartTag(tag_name), current_state)
  }
}

/// Process an HTML comment and return the comment token.
/// 
/// # Arguments
/// * `state` - The TokenizerState at the start of a comment (at '<').
/// 
/// # Returns
/// A tuple containing the Comment token and the updated TokenizerState.
fn process_comment(state: TokenizerState) -> (HtmlToken, TokenizerState) {
  let mut current_state = state
  
  // 跳过 "<!--"
  if current_state.position + 3 < current_state.length &&
     get_char_at(current_state.input, current_state.position + 1) == Some('!') &&
     get_char_at(current_state.input, current_state.position + 2) == Some('-') &&
     get_char_at(current_state.input, current_state.position + 3) == Some('-') {
    current_state = { input: current_state.input, position: current_state.position + 4, length: current_state.length }
  }
  
  let comment_chars = []
  
  // 读取注释内容直到 "-->"
  while current_state.position + 2 < current_state.length {
    if get_char_at(current_state.input, current_state.position) == Some('-') &&
       get_char_at(current_state.input, current_state.position + 1) == Some('-') &&
       get_char_at(current_state.input, current_state.position + 2) == Some('>') {
      current_state = { input: current_state.input, position: current_state.position + 3, length: current_state.length }
      break
    }
    
    match current_char(current_state) {
      Some(c) => {
        comment_chars.push(c)
        current_state = advance(current_state)
      }
      None => break
    }
  }
  
  // 将字符数组转换为字符串
  let mut comment_text = ""
  for char in comment_chars {
    comment_text = comment_text + char.to_string()
  }
  
  (Comment(comment_text), current_state)
}

/// Check if the current position is the start of an HTML comment ("<!--").
/// 
/// # Arguments
/// * `state` - The current TokenizerState.
/// 
/// # Returns
/// True if the next characters are "<!--", otherwise false.
fn is_comment_start(state: TokenizerState) -> Bool {
  state.position + 3 < state.length &&
  get_char_at(state.input, state.position + 1) == Some('!') &&
  get_char_at(state.input, state.position + 2) == Some('-') &&
  get_char_at(state.input, state.position + 3) == Some('-')
}

/// Check if the current position is the start of an end tag ("</").
/// 
/// # Arguments
/// * `state` - The current TokenizerState.
/// 
/// # Returns
/// True if the next characters are "</", otherwise false.
fn is_end_tag_start(state: TokenizerState) -> Bool {
  state.position + 1 < state.length &&
  get_char_at(state.input, state.position + 1) == Some('/')
}

// ============================================================================
// 公共接口函数
// ============================================================================

/// 主要的分词函数
/// Main tokenization function. Converts an HTML string into an array of tokens.
/// 
/// # Arguments
/// * `html` - The HTML string to tokenize.
/// 
/// # Returns
/// An array of HtmlToken representing the tokenized HTML input.
pub fn tokenize(html: String) -> Array[HtmlToken] {
  let tokens = []
  let mut state = create_state(html)
  
  while state.position < state.length {
    // 跳过空白字符
    state = skip_whitespace(state)
    
    if state.position >= state.length {
      break
    }
    
    match current_char(state) {
      Some('<') => {
        if is_comment_start(state) {
          // 处理注释
          let (token, new_state) = process_comment(state)
          tokens.push(token)
          state = new_state
        } else {
          // 处理标签
          let (token, new_state) = process_tag(state)
          tokens.push(token)
          state = new_state
        }
      }
      Some(_) => {
        // 处理文本内容
        let (text, new_state) = read_text_content(state)
        if text != "" {
          tokens.push(Text(text))
        }
        state = new_state
      }
      None => break
    }
  }
  
  tokens
}

/// 将标记转换为字符串表示（用于调试和测试）
/// Convert an HTML token to its string representation (for debugging and testing).
/// 
/// # Arguments
/// * `token` - The HtmlToken to convert.
/// 
/// # Returns
/// A String representation of the token.
pub fn token_to_string(token: HtmlToken) -> String {
  match token {
    StartTag(name) => "<" + name + ">"
    EndTag(name) => "</" + name + ">"
    SelfClosingTag(name) => "<" + name + "/>"
    Text(content) => "TEXT(\"" + content + "\")"
    Comment(content) => "<!-- " + content + " -->"
  }
}


