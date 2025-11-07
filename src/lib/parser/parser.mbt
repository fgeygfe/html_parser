
pub(all) enum Token {
  EOF
  TAG_NAME(String)
  TEXT(String)
  ATTR_NAME(String)
  ATTR_VALUE(String)
  ATTR_VALUE_QUOTED(String)
  LANGLE
  RANGLE
  SLASH
  EQUAL
  QUOTE
  SELF_CLOSE
  CLOSE_TAG_START
} derive(Show)

pub fn Token::kind(self : Token) -> TokenKind {
  match self {
    EOF => TK_EOF
    TAG_NAME(_) => TK_TAG_NAME
    TEXT(_) => TK_TEXT
    ATTR_NAME(_) => TK_ATTR_NAME
    ATTR_VALUE(_) => TK_ATTR_VALUE
    ATTR_VALUE_QUOTED(_) => TK_ATTR_VALUE_QUOTED
    LANGLE => TK_LANGLE
    RANGLE => TK_RANGLE
    SLASH => TK_SLASH
    EQUAL => TK_EQUAL
    QUOTE => TK_QUOTE
    SELF_CLOSE => TK_SELF_CLOSE
    CLOSE_TAG_START => TK_CLOSE_TAG_START
  }
}

pub(all) enum TokenKind {
  TK_EOF
  TK_TAG_NAME
  TK_TEXT
  TK_ATTR_NAME
  TK_ATTR_VALUE
  TK_ATTR_VALUE_QUOTED
  TK_LANGLE
  TK_RANGLE
  TK_SLASH
  TK_EQUAL
  TK_QUOTE
  TK_SELF_CLOSE
  TK_CLOSE_TAG_START
}

pub impl Show for TokenKind with output(self, logger) {
  logger.write_string(
    match self {
      TK_EOF => "EOF"
      TK_TAG_NAME => "TAG_NAME"
      TK_TEXT => "TEXT"
      TK_ATTR_NAME => "ATTR_NAME"
      TK_ATTR_VALUE => "ATTR_VALUE"
      TK_ATTR_VALUE_QUOTED => "ATTR_VALUE_QUOTED"
      TK_LANGLE => "\"<\""
      TK_RANGLE => "\">\""
      TK_SLASH => "\"/\""
      TK_EQUAL => "\"=\""
      TK_QUOTE => "\"\\\""
      TK_SELF_CLOSE => "\"/>\""
      TK_CLOSE_TAG_START => "\"</\""
    }
  )
}

pub suberror ParseError {
  UnexpectedToken(Token, (Int, Int), Array[TokenKind])
} derive(Show)

typealias Error as YYObj

priv suberror YYObj_Void

priv suberror YYObj_Array__ast_Node_ Array[@ast.Node]

priv suberror YYObj_Array__ast_Attribute_ Array[@ast.Attribute]

priv suberror YYObj_String String

priv suberror YYObj__ast_Node @ast.Node

priv suberror YYObj__ast_Attribute @ast.Attribute

typealias (YYSymbol) -> YYDecision as YYState

typealias (Int, ArrayView[(YYObj, Int, Int)]) -> YYObj as YYAction

priv enum YYDecision {
  Accept
  Shift(YYState)
  Reduce(Int, YYSymbol, YYAction)
  ReduceNoLookahead(Int, YYSymbol, YYAction)
  Error
}

priv enum YYSymbol {
  T_EOF
  T_TAG_NAME
  T_TEXT
  T_ATTR_NAME
  T_ATTR_VALUE
  T_ATTR_VALUE_QUOTED
  T_LANGLE
  T_RANGLE
  T_SLASH
  T_EQUAL
  T_QUOTE
  T_SELF_CLOSE
  T_CLOSE_TAG_START
  NT_html_document
  NT_element
  NT_tag_element
  NT_element_list
  NT_attribute_list
  NT_attribute
  NT_text_content
  EOI
}

// Workaround for EOI unused warning
fn init {
  match (EOI : YYSymbol) {
    EOI => ()
    _ => ()
  }
}

// file:///./parser.mbty
// 37|    element html_document            { [$1] + $2 }
fn yy_action_0(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[0].0 is YYObj__ast_Node(_dollar1)
  guard _args[1].0 is YYObj_Array__ast_Node_(_dollar2)
  YYObj_Array__ast_Node_({();  [_dollar1] + _dollar2 })
}

// file:///./parser.mbty
// 38|    element EOF                      { [$1] }
fn yy_action_1(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[0].0 is YYObj__ast_Node(_dollar1)
  YYObj_Array__ast_Node_({();  [_dollar1] })
}

// file:///./parser.mbty
// 39|    EOF                              { [] }
fn yy_action_2(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  YYObj_Array__ast_Node_({();  [] })
}

// file:///./parser.mbty
// 49|    LANGLE TAG_NAME attribute_list RANGLE element_list CLOSE_TAG_START TAG_NAME RANGLE
// 50|    { @ast.Element({ tag: $2, attrs: $3, children: $5 }) }
fn yy_action_3(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[1].0 is YYObj_String(_dollar2)
  guard _args[2].0 is YYObj_Array__ast_Attribute_(_dollar3)
  guard _args[4].0 is YYObj_Array__ast_Node_(_dollar5)
  YYObj__ast_Node({();  @ast.Element({ tag: _dollar2, attrs: _dollar3, children: _dollar5 }) })
}

// file:///./parser.mbty
// 52|    LANGLE TAG_NAME attribute_list SELF_CLOSE
// 53|    { @ast.Element({ tag: $2, attrs: $3, children: [] }) }
fn yy_action_4(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[1].0 is YYObj_String(_dollar2)
  guard _args[2].0 is YYObj_Array__ast_Attribute_(_dollar3)
  YYObj__ast_Node({();  @ast.Element({ tag: _dollar2, attrs: _dollar3, children: [] }) })
}

// file:///./parser.mbty
// 55|    LANGLE TAG_NAME RANGLE element_list CLOSE_TAG_START TAG_NAME RANGLE
// 56|    { @ast.Element({ tag: $2, attrs: [], children: $4 }) }
fn yy_action_5(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[1].0 is YYObj_String(_dollar2)
  guard _args[3].0 is YYObj_Array__ast_Node_(_dollar4)
  YYObj__ast_Node({();  @ast.Element({ tag: _dollar2, attrs: [], children: _dollar4 }) })
}

// file:///./parser.mbty
// 43|    tag_element                     { $1 }
fn yy_action_6(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[0].0 is YYObj__ast_Node(_dollar1)
  YYObj__ast_Node({();  _dollar1 })
}

// file:///./parser.mbty
// 44|    text_content                    { @ast.Text($1) }
fn yy_action_7(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[0].0 is YYObj_String(_dollar1)
  YYObj__ast_Node({();  @ast.Text(_dollar1) })
}

// file:///./parser.mbty
// 63|    element element_list             { [$1] + $2 }
fn yy_action_8(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[0].0 is YYObj__ast_Node(_dollar1)
  guard _args[1].0 is YYObj_Array__ast_Node_(_dollar2)
  YYObj_Array__ast_Node_({();  [_dollar1] + _dollar2 })
}

// file:///./parser.mbty
// 64|    element                          { [$1] }
fn yy_action_9(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[0].0 is YYObj__ast_Node(_dollar1)
  YYObj_Array__ast_Node_({();  [_dollar1] })
}

// file:///./parser.mbty
// 65|                                     { [] }
fn yy_action_10(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  YYObj_Array__ast_Node_({();  [] })
}

// file:///./parser.mbty
// 58|    LANGLE TAG_NAME SELF_CLOSE
// 59|    { @ast.Element({ tag: $2, attrs: [], children: [] }) }
fn yy_action_11(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[1].0 is YYObj_String(_dollar2)
  YYObj__ast_Node({();  @ast.Element({ tag: _dollar2, attrs: [], children: [] }) })
}

// file:///./parser.mbty
// 69|    attribute attribute_list        { [$1] + $2 }
fn yy_action_12(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[0].0 is YYObj__ast_Attribute(_dollar1)
  guard _args[1].0 is YYObj_Array__ast_Attribute_(_dollar2)
  YYObj_Array__ast_Attribute_({();  [_dollar1] + _dollar2 })
}

// file:///./parser.mbty
// 70|    attribute                       { [$1] }
fn yy_action_13(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[0].0 is YYObj__ast_Attribute(_dollar1)
  YYObj_Array__ast_Attribute_({();  [_dollar1] })
}

// file:///./parser.mbty
// 76|    ATTR_NAME EQUAL QUOTE ATTR_VALUE_QUOTED QUOTE
// 77|    { { name: $1, value: $4 } }
fn yy_action_14(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[0].0 is YYObj_String(_dollar1)
  guard _args[3].0 is YYObj_String(_dollar4)
  YYObj__ast_Attribute({();  { name: _dollar1, value: _dollar4 } })
}

// file:///./parser.mbty
// 79|    ATTR_NAME EQUAL ATTR_VALUE
// 80|    { { name: $1, value: $3 } }
fn yy_action_15(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[0].0 is YYObj_String(_dollar1)
  guard _args[2].0 is YYObj_String(_dollar3)
  YYObj__ast_Attribute({();  { name: _dollar1, value: _dollar3 } })
}

// file:///./parser.mbty
// 82|    ATTR_NAME
// 83|    { { name: $1, value: "" } }
fn yy_action_16(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[0].0 is YYObj_String(_dollar1)
  YYObj__ast_Attribute({();  { name: _dollar1, value: "" } })
}

// file:///./parser.mbty
// 87|    TEXT                            { $1 }
fn yy_action_17(_last_pos : Int, _args : ArrayView[(YYObj, Int, Int)]) -> YYObj {
  guard _args[0].0 is YYObj_String(_dollar1)
  YYObj_String({();  _dollar1 })
}

fn yy_input(token : Token, _start_pos : Int, _end_pos : Int) -> (YYSymbol, YYObj) {
  match token {
    EOF => (T_EOF, YYObj_Void)
    TAG_NAME(data) => (T_TAG_NAME, YYObj_String(data))
    TEXT(data) => (T_TEXT, YYObj_String(data))
    ATTR_NAME(data) => (T_ATTR_NAME, YYObj_String(data))
    ATTR_VALUE(data) => (T_ATTR_VALUE, YYObj_String(data))
    ATTR_VALUE_QUOTED(data) => (T_ATTR_VALUE_QUOTED, YYObj_String(data))
    LANGLE => (T_LANGLE, YYObj_Void)
    RANGLE => (T_RANGLE, YYObj_Void)
    SLASH => (T_SLASH, YYObj_Void)
    EQUAL => (T_EQUAL, YYObj_Void)
    QUOTE => (T_QUOTE, YYObj_Void)
    SELF_CLOSE => (T_SELF_CLOSE, YYObj_Void)
    CLOSE_TAG_START => (T_CLOSE_TAG_START, YYObj_Void)
  }
}

// [0, html_document → • element html_document, $]
// [1, html_document → • element EOF, $]
// [2, html_document → • EOF, $]
// [3, element → • tag_element, EOF / TEXT / LANGLE]
// [4, element → • text_content, EOF / TEXT / LANGLE]
// [5, tag_element → • LANGLE TAG_NAME attribute_list RANGLE element_list CLOSE_TAG_START TAG_NAME RANGLE, EOF / TEXT / LANGLE]
// [6, tag_element → • LANGLE TAG_NAME attribute_list SELF_CLOSE, EOF / TEXT / LANGLE]
// [7, tag_element → • LANGLE TAG_NAME RANGLE element_list CLOSE_TAG_START TAG_NAME RANGLE, EOF / TEXT / LANGLE]
// [8, tag_element → • LANGLE TAG_NAME SELF_CLOSE, EOF / TEXT / LANGLE]
// [18, text_content → • TEXT, EOF / TEXT / LANGLE]
// [19, html_document_prime → • html_document, $]
fn yy_state_0(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    NT_html_document => Shift(yy_state_1)
    T_TEXT => Shift(yy_state_2)
    T_LANGLE => Shift(yy_state_3)
    NT_text_content => Shift(yy_state_17)
    NT_tag_element => Shift(yy_state_18)
    T_EOF => Shift(yy_state_30)
    NT_element => Shift(yy_state_31)
    _ => Error
  }
}

// [19, html_document_prime → html_document •, $]
fn yy_state_1(_lookahead : YYSymbol) -> YYDecision {
  Accept
}

// [18, text_content → TEXT •, EOF / TEXT / LANGLE / CLOSE_TAG_START]
fn yy_state_2(_lookahead : YYSymbol) -> YYDecision {
  ReduceNoLookahead(1, NT_text_content, yy_action_17)
}

// [5, tag_element → LANGLE • TAG_NAME attribute_list RANGLE element_list CLOSE_TAG_START TAG_NAME RANGLE, EOF / TEXT / LANGLE / CLOSE_TAG_START]
// [6, tag_element → LANGLE • TAG_NAME attribute_list SELF_CLOSE, EOF / TEXT / LANGLE / CLOSE_TAG_START]
// [7, tag_element → LANGLE • TAG_NAME RANGLE element_list CLOSE_TAG_START TAG_NAME RANGLE, EOF / TEXT / LANGLE / CLOSE_TAG_START]
// [8, tag_element → LANGLE • TAG_NAME SELF_CLOSE, EOF / TEXT / LANGLE / CLOSE_TAG_START]
fn yy_state_3(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_TAG_NAME => Shift(yy_state_4)
    _ => Error
  }
}

// [5, tag_element → LANGLE TAG_NAME • attribute_list RANGLE element_list CLOSE_TAG_START TAG_NAME RANGLE, EOF / TEXT / LANGLE / CLOSE_TAG_START]
// [6, tag_element → LANGLE TAG_NAME • attribute_list SELF_CLOSE, EOF / TEXT / LANGLE / CLOSE_TAG_START]
// [7, tag_element → LANGLE TAG_NAME • RANGLE element_list CLOSE_TAG_START TAG_NAME RANGLE, EOF / TEXT / LANGLE / CLOSE_TAG_START]
// [8, tag_element → LANGLE TAG_NAME • SELF_CLOSE, EOF / TEXT / LANGLE / CLOSE_TAG_START]
// [12, attribute_list → • attribute attribute_list, RANGLE / SELF_CLOSE]
// [13, attribute_list → • attribute, RANGLE / SELF_CLOSE]
// [14, attribute_list → •, RANGLE / SELF_CLOSE]
// [15, attribute → • ATTR_NAME EQUAL QUOTE ATTR_VALUE_QUOTED QUOTE, ATTR_NAME / RANGLE / SELF_CLOSE]
// [16, attribute → • ATTR_NAME EQUAL ATTR_VALUE, ATTR_NAME / RANGLE / SELF_CLOSE]
// [17, attribute → • ATTR_NAME, ATTR_NAME / RANGLE / SELF_CLOSE]
fn yy_state_4(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_ATTR_NAME => Shift(yy_state_5)
    NT_attribute => Shift(yy_state_11)
    T_SELF_CLOSE => Shift(yy_state_13)
    T_RANGLE => Shift(yy_state_14)
    NT_attribute_list => Shift(yy_state_23)
    _ => Error
  }
}

// [15, attribute → ATTR_NAME • EQUAL QUOTE ATTR_VALUE_QUOTED QUOTE, ATTR_NAME / RANGLE / SELF_CLOSE]
// [16, attribute → ATTR_NAME • EQUAL ATTR_VALUE, ATTR_NAME / RANGLE / SELF_CLOSE]
// [17, attribute → ATTR_NAME •, ATTR_NAME / RANGLE / SELF_CLOSE]
fn yy_state_5(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_EQUAL => Shift(yy_state_6)
    T_ATTR_NAME | T_RANGLE | T_SELF_CLOSE => Reduce(1, NT_attribute, yy_action_16)
    _ => Error
  }
}

// [15, attribute → ATTR_NAME EQUAL • QUOTE ATTR_VALUE_QUOTED QUOTE, ATTR_NAME / RANGLE / SELF_CLOSE]
// [16, attribute → ATTR_NAME EQUAL • ATTR_VALUE, ATTR_NAME / RANGLE / SELF_CLOSE]
fn yy_state_6(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_ATTR_VALUE => Shift(yy_state_7)
    T_QUOTE => Shift(yy_state_8)
    _ => Error
  }
}

// [16, attribute → ATTR_NAME EQUAL ATTR_VALUE •, ATTR_NAME / RANGLE / SELF_CLOSE]
fn yy_state_7(_lookahead : YYSymbol) -> YYDecision {
  ReduceNoLookahead(3, NT_attribute, yy_action_15)
}

// [15, attribute → ATTR_NAME EQUAL QUOTE • ATTR_VALUE_QUOTED QUOTE, ATTR_NAME / RANGLE / SELF_CLOSE]
fn yy_state_8(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_ATTR_VALUE_QUOTED => Shift(yy_state_9)
    _ => Error
  }
}

// [15, attribute → ATTR_NAME EQUAL QUOTE ATTR_VALUE_QUOTED • QUOTE, ATTR_NAME / RANGLE / SELF_CLOSE]
fn yy_state_9(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_QUOTE => Shift(yy_state_10)
    _ => Error
  }
}

// [15, attribute → ATTR_NAME EQUAL QUOTE ATTR_VALUE_QUOTED QUOTE •, ATTR_NAME / RANGLE / SELF_CLOSE]
fn yy_state_10(_lookahead : YYSymbol) -> YYDecision {
  ReduceNoLookahead(5, NT_attribute, yy_action_14)
}

// [12, attribute_list → • attribute attribute_list, RANGLE / SELF_CLOSE]
// [12, attribute_list → attribute • attribute_list, RANGLE / SELF_CLOSE]
// [13, attribute_list → • attribute, RANGLE / SELF_CLOSE]
// [13, attribute_list → attribute •, RANGLE / SELF_CLOSE]
// [14, attribute_list → •, RANGLE / SELF_CLOSE]
// [15, attribute → • ATTR_NAME EQUAL QUOTE ATTR_VALUE_QUOTED QUOTE, ATTR_NAME / RANGLE / SELF_CLOSE]
// [16, attribute → • ATTR_NAME EQUAL ATTR_VALUE, ATTR_NAME / RANGLE / SELF_CLOSE]
// [17, attribute → • ATTR_NAME, ATTR_NAME / RANGLE / SELF_CLOSE]
fn yy_state_11(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_ATTR_NAME => Shift(yy_state_5)
    NT_attribute => Shift(yy_state_11)
    NT_attribute_list => Shift(yy_state_12)
    T_RANGLE | T_SELF_CLOSE => Reduce(1, NT_attribute_list, yy_action_13)
    _ => Error
  }
}

// [12, attribute_list → attribute attribute_list •, RANGLE / SELF_CLOSE]
fn yy_state_12(_lookahead : YYSymbol) -> YYDecision {
  ReduceNoLookahead(2, NT_attribute_list, yy_action_12)
}

// [8, tag_element → LANGLE TAG_NAME SELF_CLOSE •, EOF / TEXT / LANGLE / CLOSE_TAG_START]
fn yy_state_13(_lookahead : YYSymbol) -> YYDecision {
  ReduceNoLookahead(3, NT_tag_element, yy_action_11)
}

// [3, element → • tag_element, TEXT / LANGLE / CLOSE_TAG_START]
// [4, element → • text_content, TEXT / LANGLE / CLOSE_TAG_START]
// [5, tag_element → • LANGLE TAG_NAME attribute_list RANGLE element_list CLOSE_TAG_START TAG_NAME RANGLE, TEXT / LANGLE / CLOSE_TAG_START]
// [6, tag_element → • LANGLE TAG_NAME attribute_list SELF_CLOSE, TEXT / LANGLE / CLOSE_TAG_START]
// [7, tag_element → • LANGLE TAG_NAME RANGLE element_list CLOSE_TAG_START TAG_NAME RANGLE, TEXT / LANGLE / CLOSE_TAG_START]
// [7, tag_element → LANGLE TAG_NAME RANGLE • element_list CLOSE_TAG_START TAG_NAME RANGLE, EOF / TEXT / LANGLE / CLOSE_TAG_START]
// [8, tag_element → • LANGLE TAG_NAME SELF_CLOSE, TEXT / LANGLE / CLOSE_TAG_START]
// [9, element_list → • element element_list, CLOSE_TAG_START]
// [10, element_list → • element, CLOSE_TAG_START]
// [11, element_list → •, CLOSE_TAG_START]
// [18, text_content → • TEXT, TEXT / LANGLE / CLOSE_TAG_START]
fn yy_state_14(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_TEXT => Shift(yy_state_2)
    T_LANGLE => Shift(yy_state_3)
    NT_element => Shift(yy_state_15)
    NT_text_content => Shift(yy_state_17)
    NT_tag_element => Shift(yy_state_18)
    NT_element_list => Shift(yy_state_19)
    T_CLOSE_TAG_START => Reduce(0, NT_element_list, yy_action_10)
    _ => Error
  }
}

// [3, element → • tag_element, TEXT / LANGLE / CLOSE_TAG_START]
// [4, element → • text_content, TEXT / LANGLE / CLOSE_TAG_START]
// [5, tag_element → • LANGLE TAG_NAME attribute_list RANGLE element_list CLOSE_TAG_START TAG_NAME RANGLE, TEXT / LANGLE / CLOSE_TAG_START]
// [6, tag_element → • LANGLE TAG_NAME attribute_list SELF_CLOSE, TEXT / LANGLE / CLOSE_TAG_START]
// [7, tag_element → • LANGLE TAG_NAME RANGLE element_list CLOSE_TAG_START TAG_NAME RANGLE, TEXT / LANGLE / CLOSE_TAG_START]
// [8, tag_element → • LANGLE TAG_NAME SELF_CLOSE, TEXT / LANGLE / CLOSE_TAG_START]
// [9, element_list → • element element_list, CLOSE_TAG_START]
// [9, element_list → element • element_list, CLOSE_TAG_START]
// [10, element_list → • element, CLOSE_TAG_START]
// [10, element_list → element •, CLOSE_TAG_START]
// [11, element_list → •, CLOSE_TAG_START]
// [18, text_content → • TEXT, TEXT / LANGLE / CLOSE_TAG_START]
fn yy_state_15(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_TEXT => Shift(yy_state_2)
    T_LANGLE => Shift(yy_state_3)
    NT_element => Shift(yy_state_15)
    NT_element_list => Shift(yy_state_16)
    NT_text_content => Shift(yy_state_17)
    NT_tag_element => Shift(yy_state_18)
    T_CLOSE_TAG_START => Reduce(1, NT_element_list, yy_action_9)
    _ => Error
  }
}

// [9, element_list → element element_list •, CLOSE_TAG_START]
fn yy_state_16(_lookahead : YYSymbol) -> YYDecision {
  ReduceNoLookahead(2, NT_element_list, yy_action_8)
}

// [4, element → text_content •, EOF / TEXT / LANGLE / CLOSE_TAG_START]
fn yy_state_17(_lookahead : YYSymbol) -> YYDecision {
  ReduceNoLookahead(1, NT_element, yy_action_7)
}

// [3, element → tag_element •, EOF / TEXT / LANGLE / CLOSE_TAG_START]
fn yy_state_18(_lookahead : YYSymbol) -> YYDecision {
  ReduceNoLookahead(1, NT_element, yy_action_6)
}

// [7, tag_element → LANGLE TAG_NAME RANGLE element_list • CLOSE_TAG_START TAG_NAME RANGLE, EOF / TEXT / LANGLE / CLOSE_TAG_START]
fn yy_state_19(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_CLOSE_TAG_START => Shift(yy_state_20)
    _ => Error
  }
}

// [7, tag_element → LANGLE TAG_NAME RANGLE element_list CLOSE_TAG_START • TAG_NAME RANGLE, EOF / TEXT / LANGLE / CLOSE_TAG_START]
fn yy_state_20(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_TAG_NAME => Shift(yy_state_21)
    _ => Error
  }
}

// [7, tag_element → LANGLE TAG_NAME RANGLE element_list CLOSE_TAG_START TAG_NAME • RANGLE, EOF / TEXT / LANGLE / CLOSE_TAG_START]
fn yy_state_21(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_RANGLE => Shift(yy_state_22)
    _ => Error
  }
}

// [7, tag_element → LANGLE TAG_NAME RANGLE element_list CLOSE_TAG_START TAG_NAME RANGLE •, EOF / TEXT / LANGLE / CLOSE_TAG_START]
fn yy_state_22(_lookahead : YYSymbol) -> YYDecision {
  ReduceNoLookahead(7, NT_tag_element, yy_action_5)
}

// [5, tag_element → LANGLE TAG_NAME attribute_list • RANGLE element_list CLOSE_TAG_START TAG_NAME RANGLE, EOF / TEXT / LANGLE / CLOSE_TAG_START]
// [6, tag_element → LANGLE TAG_NAME attribute_list • SELF_CLOSE, EOF / TEXT / LANGLE / CLOSE_TAG_START]
fn yy_state_23(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_SELF_CLOSE => Shift(yy_state_24)
    T_RANGLE => Shift(yy_state_25)
    _ => Error
  }
}

// [6, tag_element → LANGLE TAG_NAME attribute_list SELF_CLOSE •, EOF / TEXT / LANGLE / CLOSE_TAG_START]
fn yy_state_24(_lookahead : YYSymbol) -> YYDecision {
  ReduceNoLookahead(4, NT_tag_element, yy_action_4)
}

// [3, element → • tag_element, TEXT / LANGLE / CLOSE_TAG_START]
// [4, element → • text_content, TEXT / LANGLE / CLOSE_TAG_START]
// [5, tag_element → • LANGLE TAG_NAME attribute_list RANGLE element_list CLOSE_TAG_START TAG_NAME RANGLE, TEXT / LANGLE / CLOSE_TAG_START]
// [5, tag_element → LANGLE TAG_NAME attribute_list RANGLE • element_list CLOSE_TAG_START TAG_NAME RANGLE, EOF / TEXT / LANGLE / CLOSE_TAG_START]
// [6, tag_element → • LANGLE TAG_NAME attribute_list SELF_CLOSE, TEXT / LANGLE / CLOSE_TAG_START]
// [7, tag_element → • LANGLE TAG_NAME RANGLE element_list CLOSE_TAG_START TAG_NAME RANGLE, TEXT / LANGLE / CLOSE_TAG_START]
// [8, tag_element → • LANGLE TAG_NAME SELF_CLOSE, TEXT / LANGLE / CLOSE_TAG_START]
// [9, element_list → • element element_list, CLOSE_TAG_START]
// [10, element_list → • element, CLOSE_TAG_START]
// [11, element_list → •, CLOSE_TAG_START]
// [18, text_content → • TEXT, TEXT / LANGLE / CLOSE_TAG_START]
fn yy_state_25(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_TEXT => Shift(yy_state_2)
    T_LANGLE => Shift(yy_state_3)
    NT_element => Shift(yy_state_15)
    NT_text_content => Shift(yy_state_17)
    NT_tag_element => Shift(yy_state_18)
    NT_element_list => Shift(yy_state_26)
    T_CLOSE_TAG_START => Reduce(0, NT_element_list, yy_action_10)
    _ => Error
  }
}

// [5, tag_element → LANGLE TAG_NAME attribute_list RANGLE element_list • CLOSE_TAG_START TAG_NAME RANGLE, EOF / TEXT / LANGLE / CLOSE_TAG_START]
fn yy_state_26(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_CLOSE_TAG_START => Shift(yy_state_27)
    _ => Error
  }
}

// [5, tag_element → LANGLE TAG_NAME attribute_list RANGLE element_list CLOSE_TAG_START • TAG_NAME RANGLE, EOF / TEXT / LANGLE / CLOSE_TAG_START]
fn yy_state_27(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_TAG_NAME => Shift(yy_state_28)
    _ => Error
  }
}

// [5, tag_element → LANGLE TAG_NAME attribute_list RANGLE element_list CLOSE_TAG_START TAG_NAME • RANGLE, EOF / TEXT / LANGLE / CLOSE_TAG_START]
fn yy_state_28(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_RANGLE => Shift(yy_state_29)
    _ => Error
  }
}

// [5, tag_element → LANGLE TAG_NAME attribute_list RANGLE element_list CLOSE_TAG_START TAG_NAME RANGLE •, EOF / TEXT / LANGLE / CLOSE_TAG_START]
fn yy_state_29(_lookahead : YYSymbol) -> YYDecision {
  ReduceNoLookahead(8, NT_tag_element, yy_action_3)
}

// [2, html_document → EOF •, $]
fn yy_state_30(_lookahead : YYSymbol) -> YYDecision {
  ReduceNoLookahead(1, NT_html_document, yy_action_2)
}

// [0, html_document → • element html_document, $]
// [0, html_document → element • html_document, $]
// [1, html_document → • element EOF, $]
// [1, html_document → element • EOF, $]
// [2, html_document → • EOF, $]
// [3, element → • tag_element, EOF / TEXT / LANGLE]
// [4, element → • text_content, EOF / TEXT / LANGLE]
// [5, tag_element → • LANGLE TAG_NAME attribute_list RANGLE element_list CLOSE_TAG_START TAG_NAME RANGLE, EOF / TEXT / LANGLE]
// [6, tag_element → • LANGLE TAG_NAME attribute_list SELF_CLOSE, EOF / TEXT / LANGLE]
// [7, tag_element → • LANGLE TAG_NAME RANGLE element_list CLOSE_TAG_START TAG_NAME RANGLE, EOF / TEXT / LANGLE]
// [8, tag_element → • LANGLE TAG_NAME SELF_CLOSE, EOF / TEXT / LANGLE]
// [18, text_content → • TEXT, EOF / TEXT / LANGLE]
fn yy_state_31(_lookahead : YYSymbol) -> YYDecision {
  match _lookahead {
    T_TEXT => Shift(yy_state_2)
    T_LANGLE => Shift(yy_state_3)
    NT_text_content => Shift(yy_state_17)
    NT_tag_element => Shift(yy_state_18)
    NT_element => Shift(yy_state_31)
    T_EOF => Shift(yy_state_32)
    NT_html_document => Shift(yy_state_33)
    _ => Error
  }
}

// [1, html_document → element EOF •, $]
// [2, html_document → EOF •, $]
fn yy_state_32(_lookahead : YYSymbol) -> YYDecision {
  ReduceNoLookahead(2, NT_html_document, yy_action_1)
}

// [0, html_document → element html_document •, $]
fn yy_state_33(_lookahead : YYSymbol) -> YYDecision {
  ReduceNoLookahead(2, NT_html_document, yy_action_0)
}

fn[T] yy_parse(
  read_token : () -> (Token, Int, Int),
  start_pos : Int,
  start : YYState,
  return_ : (YYObj) -> T
) -> T raise ParseError {
  let mut state_stack : @list.List[YYState] = @list.cons(start, @list.empty())
  let data_stack : Array[(YYObj, Int, Int)] = []
  let mut last_pos = start_pos
  let mut state = start
  let mut lookahead : Option[(YYSymbol, (YYObj, Int, Int), Token)] = None
  let mut last_shifted_state_stack = state_stack
  while true {
    let decision = match state(EOI) {
      ReduceNoLookahead(_) | Accept as t => t
      _ => {
        match lookahead {
          Some(la) => state(la.0)
          None => {
            let (token, start_pos, end_pos) = read_token()
            let (symbol, data) = yy_input(token, start_pos, end_pos)
            lookahead = Some((symbol, (data, start_pos, end_pos), token))
            state(symbol)
          }
        }
      }
    }
    match decision {
      Accept => return return_(data_stack.unsafe_pop().0)
      Shift(next_state) => {
        guard lookahead is Some(la)
        data_stack.push(la.1)
        state_stack = @list.cons(next_state, state_stack)
        last_shifted_state_stack = state_stack
        state = next_state
        last_pos = la.1.2
        lookahead = None
      }
      Reduce(count, symbol, action)
      | ReduceNoLookahead(count, symbol, action) => {
        loop (count, symbol, action) {
          _ => {
            let args = data_stack[data_stack.length() - count:]
            let data = action(last_pos, args)
            let (start_pos, end_pos) = if args.length() == 0 {
              (last_pos, last_pos)
            } else {
              (args[0].1, args[args.length() - 1].2)
            }
            for i in 0..<count {
              ignore(data_stack.unsafe_pop())
              state_stack = state_stack.unsafe_tail()
            }
            state = state_stack.unsafe_head()
            data_stack.push((data, start_pos, end_pos))
            match state(symbol) {
              Accept => return return_(data_stack.unsafe_pop().0)
              Shift(next_state) => {
                state_stack = @list.cons(next_state, state_stack)
                state = next_state
              }
              Reduce(count, symbol, action)
              | ReduceNoLookahead(count, symbol, action) => continue (count, symbol, action)
              _ => panic()
            }
          }
        }
      }
      Error => {
        let (_, (_, start_pos, end_pos), token) = lookahead.unwrap()
        error(last_shifted_state_stack, token, (start_pos, end_pos))
      }
    }
  }
  panic()
}

fn error(stack : @list.List[YYState], token : Token, loc : (Int, Int)) -> Unit raise ParseError {
  let expected = []
  fn try_add(symbol : YYSymbol, kind : TokenKind) {
    fn go(stack : @list.List[YYState]) {
      match stack {
        Empty => ()
        More(state, ..) => {
          match state(symbol) {
            Accept | Shift(_) => expected.push(kind)
            Reduce(count, symbol, _) | ReduceNoLookahead(count, symbol, _) => {
              fn inner_go(stack : @list.List[YYState], count, symbol) {
                let stack = stack.drop(count)
                guard stack is More(state, ..)
                match state(symbol) {
                  Shift(state) => go(@list.cons(state, stack))
                  Reduce(count, symbol, _) | ReduceNoLookahead(count, symbol, _) => inner_go(stack, count, symbol)
                  _ => panic()
                }
              }
              inner_go(stack, count, symbol)
            }
            Error => ()
          }
        }
      }
    }
    go(stack)
  }
  for term in ([(T_EOF, TK_EOF), (T_TAG_NAME, TK_TAG_NAME), (T_TEXT, TK_TEXT), (T_ATTR_NAME, TK_ATTR_NAME), (T_ATTR_VALUE, TK_ATTR_VALUE), (T_ATTR_VALUE_QUOTED, TK_ATTR_VALUE_QUOTED), (T_LANGLE, TK_LANGLE), (T_RANGLE, TK_RANGLE), (T_SLASH, TK_SLASH), (T_EQUAL, TK_EQUAL), (T_QUOTE, TK_QUOTE), (T_SELF_CLOSE, TK_SELF_CLOSE), (T_CLOSE_TAG_START, TK_CLOSE_TAG_START)] : Array[(YYSymbol, TokenKind)]) {
    try_add(term.0, term.1)
  }
  raise UnexpectedToken(token, loc, expected)
}

pub fn html_document(read_token : () -> (Token, Int, Int), start_pos : Int) -> Array[@ast.Node] raise ParseError {
  yy_parse(
    read_token,
    start_pos,
    yy_state_0,
    (it) => {
      guard it is YYObj_Array__ast_Node_(result)
      result
    },
  )
}


// Footer code
// Note: The HTML AST types (Node, Element, Attribute)
// should be defined in a separate module file (e.g., html.mbt)
//
// Example structure:
//
// pub enum Node {
//   Element(Element)
//   Text(String)
// }
//
// pub struct Element {
//   tag : String
//   attrs : Array[Attribute]
//   children : Array[Node]
// }
//
// pub struct Attribute {
//   name : String
//   value : String
// }

fn init {
  ()
}

