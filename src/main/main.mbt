fn main {
  let tokens = @lexer.tokenize("<html><head><title>Test</title></head><body><h1>Hello</h1><p>World!</p></body></html>")
  let result = @parser.parse_dom(tokens)
  println("\nDOM Tree:")
  @parser.print_dom_tree(result)
}