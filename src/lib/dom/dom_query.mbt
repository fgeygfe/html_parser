pub fn get_attr(elem : @ast.Element, name : String) -> String? {
  for attr in elem.attrs {
    if attr.name == name {
      return Some(attr.value)
    }
  }
  None
}

pub fn has_attr(elem : @ast.Element, name : String) -> Bool {
  for attr in elem.attrs {
    if attr.name == name {
      return true
    }
  }
  false
}

pub fn get_classes(elem : @ast.Element) -> Array[String] {
  match get_attr(elem, "class") {
    Some(class_str) => {
      let parts : Array[String] = []
      let current = StringBuilder::new()
      let space_code = ' '.to_int()
      let tab_code = '\t'.to_int()
      let newline_code = '\n'.to_int()
      let return_code = '\r'.to_int()
      
      for i = 0; i < class_str.length(); i = i + 1 {
        let c = class_str[i]
        if c == space_code || c == tab_code || c == newline_code || c == return_code {
          let s = current.to_string()
          if s.length() > 0 {
            parts.push(s)
            current.reset()
          }
        } else {
          current.write_char(c.unsafe_to_char())
        }
      }
      let s = current.to_string()
      if s.length() > 0 {
        parts.push(s)
      }
      parts
    }
    None => []
  }
}

pub fn has_class(elem : @ast.Element, class_name : String) -> Bool {
  let classes = get_classes(elem)
  for cls in classes {
    if cls == class_name {
      return true
    }
  }
  false
}

pub fn get_id(elem : @ast.Element) -> String? {
  get_attr(elem, "id")
}

pub fn get_text_from_element(elem : @ast.Element) -> String {
  let buf = StringBuilder::new()
  fn collect_text(node : @ast.Node) {
    match node {
      @ast.Text(text) => buf.write_string(text)
      @ast.Element(e) => {
        for child in e.children {
          collect_text(child)
        }
      }
    }
  }
  for child in elem.children {
    collect_text(child)
  }
  buf.to_string()
}

pub fn get_text_from_node(node : @ast.Node) -> String {
  match node {
    @ast.Text(text) => text
    @ast.Element(elem) => get_text_from_element(elem)
  }
}

pub fn find_by_tag(nodes : Array[@ast.Node], tag : String) -> Array[@ast.Element] {
  let result = []
  fn traverse(node : @ast.Node) {
    match node {
      @ast.Element(elem) => {
        if elem.tag == tag {
          result.push(elem)
        }
        for child in elem.children {
          traverse(child)
        }
      }
      @ast.Text(_) => ()
    }
  }
  for node in nodes {
    traverse(node)
  }
  result
}

pub fn find_first_by_tag(nodes : Array[@ast.Node], tag : String) -> @ast.Element? {
  fn traverse(node : @ast.Node) -> @ast.Element? {
    match node {
      @ast.Element(elem) => {
        if elem.tag == tag {
          return Some(elem)
        }
        for child in elem.children {
          match traverse(child) {
            Some(found) => return Some(found)
            None => ()
          }
        }
        None
      }
      @ast.Text(_) => None
    }
  }
  for node in nodes {
    match traverse(node) {
      Some(found) => return Some(found)
      None => ()
    }
  }
  None
}

pub fn find_by_id(nodes : Array[@ast.Node], id : String) -> @ast.Element? {
  fn traverse(node : @ast.Node) -> @ast.Element? {
    match node {
      @ast.Element(elem) => {
        match get_id(elem) {
          Some(elem_id) => {
            if elem_id == id {
              return Some(elem)
            }
          }
          None => ()
        }
        for child in elem.children {
          match traverse(child) {
            Some(found) => return Some(found)
            None => ()
          }
        }
        None
      }
      @ast.Text(_) => None
    }
  }
  for node in nodes {
    match traverse(node) {
      Some(found) => return Some(found)
      None => ()
    }
  }
  None
}

pub fn find_by_class(nodes : Array[@ast.Node], class_name : String) -> Array[@ast.Element] {
  let result = []
  fn traverse(node : @ast.Node) {
    match node {
      @ast.Element(elem) => {
        if has_class(elem, class_name) {
          result.push(elem)
        }
        for child in elem.children {
          traverse(child)
        }
      }
      @ast.Text(_) => ()
    }
  }
  for node in nodes {
    traverse(node)
  }
  result
}

pub fn find_by_attr(
  nodes : Array[@ast.Node],
  attr_name : String,
  attr_value : String
) -> Array[@ast.Element] {
  let result = []
  fn traverse(node : @ast.Node) {
    match node {
      @ast.Element(elem) => {
        match get_attr(elem, attr_name) {
          Some(value) => {
            if value == attr_value {
              result.push(elem)
            }
          }
          None => ()
        }
        for child in elem.children {
          traverse(child)
        }
      }
      @ast.Text(_) => ()
    }
  }
  for node in nodes {
    traverse(node)
  }
  result
}

pub fn find_with_attr(nodes : Array[@ast.Node], attr_name : String) -> Array[@ast.Element] {
  let result = []
  fn traverse(node : @ast.Node) {
    match node {
      @ast.Element(elem) => {
        if has_attr(elem, attr_name) {
          result.push(elem)
        }
        for child in elem.children {
          traverse(child)
        }
      }
      @ast.Text(_) => ()
    }
  }
  for node in nodes {
    traverse(node)
  }
  result
}

pub fn get_all_elements(nodes : Array[@ast.Node]) -> Array[@ast.Element] {
  let result = []
  fn traverse(node : @ast.Node) {
    match node {
      @ast.Element(elem) => {
        result.push(elem)
        for child in elem.children {
          traverse(child)
        }
      }
      @ast.Text(_) => ()
    }
  }
  for node in nodes {
    traverse(node)
  }
  result
}

pub fn get_all_text_nodes(nodes : Array[@ast.Node]) -> Array[String] {
  let result = []
  fn traverse(node : @ast.Node) {
    match node {
      @ast.Text(text) => result.push(text)
      @ast.Element(elem) => {
        for child in elem.children {
          traverse(child)
        }
      }
    }
  }
  for node in nodes {
    traverse(node)
  }
  result
}

pub fn get_text_content(nodes : Array[@ast.Node]) -> String {
  let buf = StringBuilder::new()
  fn traverse(node : @ast.Node) {
    match node {
      @ast.Text(text) => buf.write_string(text)
      @ast.Element(elem) => {
        for child in elem.children {
          traverse(child)
        }
      }
    }
  }
  for node in nodes {
    traverse(node)
  }
  buf.to_string()
}

pub fn filter_elements(
  nodes : Array[@ast.Node],
  predicate : (@ast.Element) -> Bool
) -> Array[@ast.Element] {
  let result = []
  fn traverse(node : @ast.Node) {
    match node {
      @ast.Element(elem) => {
        if predicate(elem) {
          result.push(elem)
        }
        for child in elem.children {
          traverse(child)
        }
      }
      @ast.Text(_) => ()
    }
  }
  for node in nodes {
    traverse(node)
  }
  result
}

pub fn count_by_tag(nodes : Array[@ast.Node], tag : String) -> Int {
  let mut count = 0
  fn traverse(node : @ast.Node) {
    match node {
      @ast.Element(elem) => {
        if elem.tag == tag {
          count += 1
        }
        for child in elem.children {
          traverse(child)
        }
      }
      @ast.Text(_) => ()
    }
  }
  for node in nodes {
    traverse(node)
  }
  count
}

pub fn get_children(elem : @ast.Element) -> Array[@ast.Element] {
  let result = []
  for child in elem.children {
    match child {
      @ast.Element(e) => result.push(e)
      @ast.Text(_) => ()
    }
  }
  result
}

pub fn get_children_by_tag(elem : @ast.Element, tag : String) -> Array[@ast.Element] {
  let result = []
  for child in elem.children {
    match child {
      @ast.Element(e) => {
        if e.tag == tag {
          result.push(e)
        }
      }
      @ast.Text(_) => ()
    }
  }
  result
}

pub fn has_children(elem : @ast.Element) -> Bool {
  for child in elem.children {
    match child {
      @ast.Element(_) => return true
      @ast.Text(_) => ()
    }
  }
  false
}

pub fn count_children(elem : @ast.Element) -> Int {
  let mut count = 0
  for child in elem.children {
    match child {
      @ast.Element(_) => count += 1
      @ast.Text(_) => ()
    }
  }
  count
}
