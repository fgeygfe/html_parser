fn main {
  let tokens = @lexer.tokenize(
    "<html><head><title>Test</title></head><body><h1>Hello</h1><p>World!</p><h1>zl</h1></body></html>",
  )
  let result = @parser.parse_dom(tokens)
  println("\nDOM Tree:")
  @parser.print_dom_tree(result)
  let h1_nodes = @dom.query_dom_by_tag_name(result, "h1")
  println("\nAll <h1> nodes:")
  for node in h1_nodes {
    @parser.print_dom_tree([node])  // 将单个节点包装成数组
  }
}