fn parse_html(html : String) -> Result[Array[@ast.Node], @parser.ParseError] {
  let tokens = @lexer.tokenize(html)
  let mut index = 0
  let tokens_ref = tokens
  fn read_token() -> (@parser.Token, Int, Int) {
    if index < tokens_ref.length() {
      let token = tokens_ref[index]
      index += 1
      token
    } else {
      (@parser.EOF, 0, 0)
    }
  }
  
  try {
    Ok(@parser.html_document(read_token, 0))
  } catch {
    err => Err(err)
  }
}

test "parse empty tag" {
  let result = parse_html("<div></div>")
  assert_true(result is Ok(_))
  let expected = 
    #|Ok([<div></div>])
  inspect(result, content=expected)
}

test "parse tag with text" {
  let result = parse_html("<p>Hello World</p>")
  assert_true(result is Ok(_))
  let expected = 
    #|Ok([<p>Hello World</p>])
  inspect(result, content=expected)
}

test "parse tag with attributes" {
  let result = parse_html("<div id=\"main\"></div>")
  assert_true(result is Ok(_))
  let expected = 
    #|Ok([<div id="main"></div>])
  inspect(result, content=expected)
}

test "parse self-closing tag" {
  let result = parse_html("<br/>")
  assert_true(result is Ok(_))
  let expected = 
    #|Ok([<br></br>])
  inspect(result, content=expected)
}

test "parse self-closing tag with attributes" {
  let result = parse_html("<img src=\"image.jpg\"/>")
  assert_true(result is Ok(_))
  let expected = 
    #|Ok([<img src="image.jpg"></img>])
  inspect(result, content=expected)
}

test "parse nested tags" {
  let result = parse_html("<div><p>Nested</p></div>")
  assert_true(result is Ok(_))
  let expected = 
    #|Ok([<div><p>Nested</p></div>])
  inspect(result, content=expected)
}

test "parse multiple attributes" {
  let result = parse_html("<a href=\"#\" class=\"link\">Link</a>")
  assert_true(result is Ok(_))
  let expected = 
    #|Ok([<a href="#" class="link">Link</a>])
  inspect(result, content=expected)
}

test "parse complex nesting" {
  let result = parse_html("<div><p>Paragraph</p><span>Span</span></div>")
  assert_true(result is Ok(_))
  let expected = 
    #|Ok([<div><p>Paragraph</p><span>Span</span></div>])
  inspect(result, content=expected)
}

test "parse mixed text and tags" {
  let result = parse_html("<div>Text before<p>Paragraph</p>Text after</div>")
  assert_true(result is Ok(_))
  let expected = 
    #|Ok([<div>Text before<p>Paragraph</p>Text after</div>])
  inspect(result, content=expected)
}

test "parse boolean attribute" {
  let result = parse_html("<input disabled></input>")
  assert_true(result is Ok(_))
  let expected = 
    #|Ok([<input disabled></input>])
  inspect(result, content=expected)
}

test "parse deep nesting" {
  let result = parse_html("<div><section><article><p>Deep</p></article></section></div>")
  assert_true(result is Ok(_))
}

test "parse multiple siblings" {
  let result = parse_html("<div><p>First</p><p>Second</p><p>Third</p></div>")
  assert_true(result is Ok(_))
}

test "parse error on unclosed tag" {
  let result = parse_html("<div><p>Text</div>")
  assert_true(result is Err(_))
}

test "parse error on missing closing tag" {
  let result = parse_html("<div>")
  assert_true(result is Err(_))
}

test "parse empty document" {
  let result = parse_html("")
  assert_true(result is Ok(_))
  let expected = 
    #|Ok([])
  inspect(result, content=expected)
}

