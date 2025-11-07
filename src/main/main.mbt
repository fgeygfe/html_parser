fn main {
  let html = "<div id=\"main\" class=\"container\"><p>Hello World</p><p class=\"highlight\">Highlighted</p></div>"
  
  println("=== HTML Parser Demo ===")
  println("Input: " + html)
  println("")
  
  let tokens = @lexer.tokenize(html)
  let mut index = 0
  fn read_token() -> (@parser.Token, Int, Int) {
    if index < tokens.length() {
      let token = tokens[index]
      index += 1
      token
    } else {
      (@parser.EOF, 0, 0)
    }
  }
  
  try @parser.html_document(read_token, 0) catch {
    err => {
      println("Parse error: " + err.to_string())
      return
    }
  } noraise {
    result => {
      println("✅ Parsing successful!")
      println("")
      
      println("DOM Queries:")
      
      let paragraphs = @dom.find_by_tag(result, "p")
      println("- Found " + paragraphs.length().to_string() + " <p> elements")
      
      match @dom.find_by_id(result, "main") {
        Some(elem) => println("- Found element with id='main': <" + elem.tag + ">")
        None => ()
      }
      
      let highlights = @dom.find_by_class(result, "highlight")
      println("- Found " + highlights.length().to_string() + " elements with class='highlight'")
      
      let text = @dom.get_text_content(result)
      println("- Text content: " + text)
      
      println("")
      println("Run `moon test` to see comprehensive test examples!")
    }
  }
  
}
