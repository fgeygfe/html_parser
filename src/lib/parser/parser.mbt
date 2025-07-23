// DOM tree parser module
// Responsible for converting HTML tokens into a DOM tree structure

/// DOM node type definition.
/// Represents a node in the DOM tree, which can be an element, text, or comment.
pub enum DomNode {
  /// Element node, contains tag name and child nodes.
  Element(String, Array[DomNode])
  /// Text node, contains text content.
  TextNode(String)
  /// Comment node, contains comment content.
  CommentNode(String)
}

/// Parser state for DOM construction.
/// Holds the token array and the current parsing position.
priv struct DomParserState {
  tokens: Array[@lexer.HtmlToken]  // Input token array
  position: Int                    // Current parsing position
}

/// Create a new DOM parser state from a token array.
/// Initializes the parser state at the beginning of the token list.
/// 
/// # Arguments
/// * `tokens` - The array of HTML tokens to parse.
/// 
/// # Returns
/// A new DomParserState with position set to 0.
fn new_dom_parser_state(tokens: Array[@lexer.HtmlToken]) -> DomParserState {
  { tokens, position: 0 }
}

/// Check if there are more tokens to process in the parser state.
/// 
/// # Arguments
/// * `state` - The current DomParserState.
/// 
/// # Returns
/// True if there are more tokens, false otherwise.
fn has_more_tokens(state: DomParserState) -> Bool {
  state.position < state.tokens.length()
}

/// Get the current token from the parser state.
/// 
/// # Arguments
/// * `state` - The current DomParserState.
/// 
/// # Returns
/// The current HtmlToken if available, otherwise None.
fn current_token(state: DomParserState) -> @lexer.HtmlToken? {
  if has_more_tokens(state) {
    Some(state.tokens[state.position])
  } else {
    None
  }
}

/// Advance the parser state to the next token.
/// 
/// # Arguments
/// * `state` - The current DomParserState.
/// 
/// # Returns
/// A new DomParserState with the position incremented by 1.
fn advance_token(state: DomParserState) -> DomParserState {
  { tokens: state.tokens, position: state.position + 1 }
}

/// Parse the DOM tree from a list of HTML tokens.
/// 
/// # Arguments
/// * `tokens` - The array of HTML tokens to parse.
/// 
/// # Returns
/// An array of DomNode representing the root nodes of the DOM tree.
pub fn parse_dom(tokens: Array[@lexer.HtmlToken]) -> Array[DomNode] {
  let state = new_dom_parser_state(tokens)
  parse_nodes(state).0
}

/// Parse a list of DOM nodes from the current parser state.
/// Continues parsing until no more tokens or an end tag is encountered.
/// 
/// # Arguments
/// * `state` - The current DomParserState.
/// 
/// # Returns
/// A tuple containing the parsed nodes and the updated parser state.
fn parse_nodes(state: DomParserState) -> (Array[DomNode], DomParserState) {
  let nodes: Array[DomNode] = []
  let mut current_state = state
  
  while has_more_tokens(current_state) {
    match current_token(current_state) {
      Some(StartTag(tag_name)) => {
        current_state = advance_token(current_state)
        let (children, new_state) = parse_children(current_state, tag_name)
        nodes.push(Element(tag_name, children))
        current_state = new_state
      }
      Some(SelfClosingTag(tag_name)) => {
        current_state = advance_token(current_state)
        nodes.push(Element(tag_name, []))
      }
      Some(Text(content)) => {
        current_state = advance_token(current_state)
        // Simple whitespace check, trim leading and trailing spaces
        if content != "" && content != " " && content != "\n" && content != "\t" {
          nodes.push(TextNode(content))
        }
      }
      Some(Comment(content)) => {
        current_state = advance_token(current_state)
        nodes.push(CommentNode(content))
      }
      Some(EndTag(_)) => {
        // Stop parsing current level when encountering an end tag
        break
      }
      None => break
    }
  }
  
  (nodes, current_state)
}

/// Parse child nodes for a given parent tag until the corresponding end tag is found.
/// 
/// # Arguments
/// * `state` - The current DomParserState.
/// * `parent_tag` - The tag name of the parent element.
/// 
/// # Returns
/// A tuple containing the parsed child nodes and the updated parser state.
fn parse_children(state: DomParserState, parent_tag: String) -> (Array[DomNode], DomParserState) {
  let children: Array[DomNode] = []
  let mut current_state = state
  
  while has_more_tokens(current_state) {
    match current_token(current_state) {
      Some(EndTag(tag_name)) => {
        if tag_name == parent_tag {
          current_state = advance_token(current_state)  // Skip end tag
          break
        } else {
          // Unmatched end tag, continue parsing
          current_state = advance_token(current_state)
        }
      }
      Some(StartTag(tag_name)) => {
        current_state = advance_token(current_state)
        let (grandchildren, new_state) = parse_children(current_state, tag_name)
        children.push(Element(tag_name, grandchildren))
        current_state = new_state
      }
      Some(SelfClosingTag(tag_name)) => {
        current_state = advance_token(current_state)
        children.push(Element(tag_name, []))
      }
      Some(Text(content)) => {
        current_state = advance_token(current_state)
        // Simple whitespace check, trim leading and trailing spaces
        if content != "" && content != " " && content != "\n" && content != "\t" {
          children.push(TextNode(content))
        }
      }
      Some(Comment(content)) => {
        current_state = advance_token(current_state)
        children.push(CommentNode(content))
      }
      None => break
    }
  }
  
  (children, current_state)
}

/// Print the DOM tree structure to the console.
/// 
/// # Arguments
/// * `nodes` - The array of DomNode to print.
/// 
/// # Returns
/// Unit. Prints the DOM tree to the standard output.
pub fn print_dom_tree(nodes: Array[DomNode]) -> Unit {
  print_dom_tree_with_indent(nodes, 0)
}

/// Print the DOM tree with indentation for better readability.
/// 
/// # Arguments
/// * `nodes` - The array of DomNode to print.
/// * `indent` - The current indentation level.
/// 
/// # Returns
/// Unit. Prints the DOM tree to the standard output with indentation.
fn print_dom_tree_with_indent(nodes: Array[DomNode], indent: Int) -> Unit {
  let indent_str = "  ".repeat(indent)
  
  let mut i = 0
  while i < nodes.length() {
    match nodes[i] {
      Element(tag_name, children) => {
        println(indent_str + "📦 <" + tag_name + ">")
        if children.length() > 0 {
          print_dom_tree_with_indent(children, indent + 1)
        }
      }
      TextNode(content) => {
        println(indent_str + "📝 \"" + content + "\"")
      }
      CommentNode(content) => {
        println(indent_str + "💬 <!-- " + content + " -->")
      }
    }
    i = i + 1
  }
}

/// Count all node types in the DOM tree, including elements, text nodes, and comments.
/// 
/// # Arguments
/// * `nodes` - The array of DomNode to count.
/// 
/// # Returns
/// A tuple (element_count, text_node_count, comment_count).
pub fn count_all_nodes(nodes: Array[DomNode]) -> (Int, Int, Int) {
  let mut elements = 0
  let mut text_nodes = 0
  let mut comments = 0
  
  let mut i = 0
  while i < nodes.length() {
    match nodes[i] {
      Element(_, children) => {
        elements = elements + 1
        let (child_elements, child_text, child_comments) = count_all_nodes(children)
        elements = elements + child_elements
        text_nodes = text_nodes + child_text
        comments = comments + child_comments
      }
      TextNode(_) => {
        text_nodes = text_nodes + 1
      }
      CommentNode(_) => {
        comments = comments + 1
      }
    }
    i = i + 1
  }
  
  (elements, text_nodes, comments)
}