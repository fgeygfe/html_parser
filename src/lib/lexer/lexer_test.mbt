// HTML parser test file
// Provides test functions to verify the tokenizer functionality

///| Test basic HTML tokenizing functionality
test "basic_html_tokenizer" {
  println("🔍 Testing HTML Tokenizer")
  println("=========================")
  let html = "<div><p>Hello World!</p><!-- comment --><br/></div>"
  println("Input: " + html)
  let tokens = tokenize(html)
  println("\nTokens (" + tokens.length().to_string() + " found):")
  let mut i = 0
  while i < tokens.length() {
    println("  " + (i + 1).to_string() + ". " + token_to_string(tokens[i]))
    i = i + 1
  }
}

///| Test complex HTML tokenizing
test "complex_html_tokenizing" {
  println("\n🧪 Testing Complex HTML Tokenizing")
  println("===================================")
  let complex_html = "<div class=\"container\"><p>Hello <strong>World</strong>!</p></div>"
  println("Input: " + complex_html)
  let tokens = tokenize(complex_html)
  println("\nTokens: " + tokens.length().to_string())
  let mut i = 0
  while i < tokens.length() {
    println("  " + (i + 1).to_string() + ". " + token_to_string(tokens[i]))
    i = i + 1
  }
}

///| Test self-closing tags tokenizing
test "self_closing_tags_tokenizing" {
  println("\n🏷️  Testing Self-Closing Tags Tokenizing")
  println("=========================================")
  let html = "<div><img src=\"test.jpg\"/><br/><hr/><input type=\"text\"/></div>"
  println("Input: " + html)
  let tokens = tokenize(html)
  println("\nTokens:")
  let mut i = 0
  while i < tokens.length() {
    println("  " + (i + 1).to_string() + ". " + token_to_string(tokens[i]))
    i = i + 1
  }
}

///| Test comment tokenizing
test "comment_tokenizing" {
  println("\n💬 Testing Comment Tokenizing")
  println("==============================")
  let html = "<!-- Header comment --><div><!-- Inline comment --><p>Text</p><!-- Footer comment --></div>"
  println("Input: " + html)
  let tokens = tokenize(html)
  println("\nTokens:")
  let mut i = 0
  while i < tokens.length() {
    println("  " + (i + 1).to_string() + ". " + token_to_string(tokens[i]))
    i = i + 1
  }
}

///| Test basic case
test "basic_functionality" {
  println("\n✅ Testing Basic Functionality")
  println("===============================")
  let simple_html = "<div><p>Hello!</p></div>"
  let tokens = tokenize(simple_html)
  println("Input: " + simple_html)
  println("Token count: " + tokens.length().to_string())

  // Verify basic structure
  if tokens.length() == 4 {
    println("✅ Correct token count")
  } else {
    println("❌ Unexpected token count")
  }
}
