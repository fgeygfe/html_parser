fn main {
  let tokens = @lexer.tokenize("<html><head><title>Test</title></head><body><h1>Hello</h1><p>World!</p></body></html>")
  let result = @parser.parse_dom(tokens)
  println("\nDOM Tree:")
  @parser.print_dom_tree(result)
  let h1_nodes = @dom.query_dom_by_tag_name([result], "h1")
  println("\nAll <h1> nodes:")
  let mut i = 0
  while i < h1_nodes.length() {
    @parser.print_dom_tree(h1_nodes[i])
    i = i + 1
  }
}