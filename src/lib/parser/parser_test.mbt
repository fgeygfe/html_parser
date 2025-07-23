// DOM parser test file
// Specially for testing DOM tree construction

/// Test DOM tree construction
test "dom_tree_builder" {
  println("🌳 Testing DOM Tree Builder")
  println("============================")
  
  let html = "<html><head><title>Test</title></head><body><h1>Hello</h1><p>World!</p></body></html>"
  println("Input: " + html)
  
  let tokens = @lexer.tokenize(html)
  let dom_tree = @parser.parse_dom(tokens)
  
  println("\nDOM Tree:")
  print_dom_tree(dom_tree)
  
  let (elements, text_nodes, comments) = count_all_nodes(dom_tree)
  println("\nStatistics:")
  println("- Elements: " + elements.to_string())
  println("- Text Nodes: " + text_nodes.to_string())
  println("- Comments: " + comments.to_string())
}

/// Test complex DOM parsing
test "complex_dom_parsing" {
  println("\n🧪 Testing Complex DOM Parsing")
  println("===============================")
  
  let complex_html = "<div><header><h1>Title</h1></header><main><p>Content with <strong>bold</strong> text.</p><!-- comment --></main></div>"
  
  println("Input: " + complex_html)
  
  let tokens = @lexer.tokenize(complex_html)
  let dom_tree = @parser.parse_dom(tokens)
  
  // tokens.length() is now a tuple array, print token count as tokens.length().to_string()
  println("\nTokens: " + tokens.length().to_string())
  print_dom_tree(dom_tree)
  
  let (elements, text_nodes, comments) = count_all_nodes(dom_tree)
  println("\nStatistics:")
  println("- Elements: " + elements.to_string())
  println("- Text Nodes: " + text_nodes.to_string()) 
  println("- Comments: " + comments.to_string())
  println("- Total: " + (elements + text_nodes + comments).to_string())
}

/// Test simple DOM structure
test "simple_dom_structure" {
  println("\n🏠 Testing Simple DOM Structure")
  println("================================")
  
  let simple_html = "<div><p>Hello!</p><span>World!</span></div>"
  println("Input: " + simple_html)
  
  let tokens = @lexer.tokenize(simple_html)
  let dom_tree = @parser.parse_dom(tokens)
  
  println("\nDOM Tree:")
  print_dom_tree(dom_tree)
  
  let (elements, text_nodes, comments) = count_all_nodes(dom_tree)
  println("\nStatistics:")
  println("- Elements: " + elements.to_string())
  println("- Text Nodes: " + text_nodes.to_string())
  println("- Comments: " + comments.to_string())
}

/// Test nested DOM structure
test "nested_dom_structure" {
  println("\n🪆 Testing Nested DOM Structure")
  println("================================")
  
  let nested_html = "<article><section><div><p><span>Deep nesting</span></p></div></section></article>"
  println("Input: " + nested_html)
  
  let tokens = @lexer.tokenize(nested_html)
  let dom_tree = @parser.parse_dom(tokens)
  
  println("\nDOM Tree:")
  print_dom_tree(dom_tree)
  
  let (elements, text_nodes, comments) = count_all_nodes(dom_tree)
  println("\nStatistics:")
  println("- Elements: " + elements.to_string())
  println("- Text Nodes: " + text_nodes.to_string())
  println("- Comments: " + comments.to_string())
}

/// Test self-closing tags in DOM
test "self_closing_tags_dom" {
  println("\n🏷️  Testing Self-Closing Tags in DOM")
  println("=====================================")
  
  let html = "<div><img src=\"test.jpg\"/><br/><p>Text after self-closing tags</p></div>"
  println("Input: " + html)
  
  let tokens = @lexer.tokenize(html)
  let dom_tree = @parser.parse_dom(tokens)
  
  println("\nDOM Tree:")
  print_dom_tree(dom_tree)
  
  let (elements, text_nodes, comments) = count_all_nodes(dom_tree)
  println("\nStatistics:")
  println("- Elements: " + elements.to_string())
  println("- Text Nodes: " + text_nodes.to_string())
  println("- Comments: " + comments.to_string())
}

/// Test DOM with comments
test "dom_with_comments" {
  println("\n💬 Testing DOM with Comments")
  println("=============================")
  
  let html = "<!-- Page header --><div><!-- Content section --><p>Main content</p><!-- End content --></div><!-- Page footer -->"
  println("Input: " + html)
  
  let tokens = @lexer.tokenize(html)
  let dom_tree = @parser.parse_dom(tokens)
  
  println("\nDOM Tree:")
  print_dom_tree(dom_tree)
  
  let (elements, text_nodes, comments) = count_all_nodes(dom_tree)
  println("\nStatistics:")
  println("- Elements: " + elements.to_string())
  println("- Text Nodes: " + text_nodes.to_string())
  println("- Comments: " + comments.to_string())
}
