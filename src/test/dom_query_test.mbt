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
  try @parser.html_document(read_token, 0) catch {
    err => Err(err)
  } noraise {
    result => Ok(result)
  }
}

test "find by tag" {
  let html = "<div><p>First</p><p>Second</p><span>Third</span></div>"
  let nodes = parse_html(html)
  assert_true(nodes is Ok(_))
  match nodes {
    Ok(n) => {
      let paras = @dom.find_by_tag(n, "p")
      assert_eq(paras.length(), 2)
      assert_eq(paras[0].tag, "p")
    }
    Err(_) => ()
  }
}

test "find by id" {
  let html = "<div><p id=\"main\">Content</p><span>Other</span></div>"
  let nodes = parse_html(html)
  assert_true(nodes is Ok(_))
  match nodes {
    Ok(n) => {
      match @dom.find_by_id(n, "main") {
        Some(elem) => {
          assert_eq(elem.tag, "p")
          assert_eq(@dom.get_text_from_element(elem), "Content")
        }
        None => fail("Element with id 'main' not found")
      }
    }
    Err(_) => ()
  }
}

test "find by class" {
  let html = "<div><p class=\"highlight\">First</p><span class=\"highlight\">Second</span></div>"
  let nodes = parse_html(html)
  assert_true(nodes is Ok(_))
  match nodes {
    Ok(n) => {
      let highlights = @dom.find_by_class(n, "highlight")
      assert_eq(highlights.length(), 2)
    }
    Err(_) => ()
  }
}

test "find by attribute" {
  let html = "<div><a href=\"page1\">Link1</a><a href=\"page2\">Link2</a></div>"
  let nodes = parse_html(html)
  assert_true(nodes is Ok(_))
  match nodes {
    Ok(n) => {
      let links = @dom.find_by_attr(n, "href", "page1")
      assert_eq(links.length(), 1)
      assert_eq(links[0].tag, "a")
    }
    Err(_) => ()
  }
}

test "find with attribute" {
  let html = "<div><img src=\"pic1.jpg\"/><img/><p>Text</p></div>"
  let nodes = parse_html(html)
  assert_true(nodes is Ok(_))
  match nodes {
    Ok(n) => {
      let images_with_src = @dom.find_with_attr(n, "src")
      assert_eq(images_with_src.length(), 1)
    }
    Err(_) => ()
  }
}

test "get attribute" {
  let html = "<div id=\"main\" class=\"container\">Content</div>"
  let nodes = parse_html(html)
  assert_true(nodes is Ok(_))
  match nodes {
    Ok(n) => {
      let elems = @dom.get_all_elements(n)
      assert_eq(elems.length(), 1)
      let elem = elems[0]
      match @dom.get_attr(elem, "id") {
        Some(id) => assert_eq(id, "main")
        None => fail("id attribute not found")
      }
      match @dom.get_attr(elem, "class") {
        Some(cls) => assert_eq(cls, "container")
        None => fail("class attribute not found")
      }
    }
    Err(_) => ()
  }
}

test "get classes" {
  let html = "<div class=\"red large bold\">Content</div>"
  let nodes = parse_html(html)
  assert_true(nodes is Ok(_))
  match nodes {
    Ok(n) => {
      let elems = @dom.get_all_elements(n)
      let classes = @dom.get_classes(elems[0])
      assert_eq(classes.length(), 3)
      assert_eq(classes[0], "red")
      assert_eq(classes[1], "large")
      assert_eq(classes[2], "bold")
    }
    Err(_) => ()
  }
}

test "has class" {
  let html = "<div class=\"container main\">Content</div>"
  let nodes = parse_html(html)
  assert_true(nodes is Ok(_))
  match nodes {
    Ok(n) => {
      let elems = @dom.get_all_elements(n)
      assert_true(@dom.has_class(elems[0], "container"))
      assert_true(@dom.has_class(elems[0], "main"))
      assert_false(@dom.has_class(elems[0], "notexist"))
    }
    Err(_) => ()
  }
}

test "get text content" {
  let html = "<div><p>Hello</p><span>World</span></div>"
  let nodes = parse_html(html)
  assert_true(nodes is Ok(_))
  match nodes {
    Ok(n) => {
      let text = @dom.get_text_content(n)
      assert_eq(text, "HelloWorld")
    }
    Err(_) => ()
  }
}

test "get all elements" {
  let html = "<div><p><span>Text</span></p><a>Link</a></div>"
  let nodes = parse_html(html)
  assert_true(nodes is Ok(_))
  match nodes {
    Ok(n) => {
      let all_elems = @dom.get_all_elements(n)
      assert_eq(all_elems.length(), 4)
    }
    Err(_) => ()
  }
}

test "get all text nodes" {
  let html = "<div>First<p>Second</p>Third</div>"
  let nodes = parse_html(html)
  assert_true(nodes is Ok(_))
  match nodes {
    Ok(n) => {
      let texts = @dom.get_all_text_nodes(n)
      assert_eq(texts.length(), 3)
      assert_eq(texts[0], "First")
      assert_eq(texts[1], "Second")
      assert_eq(texts[2], "Third")
    }
    Err(_) => ()
  }
}

test "count by tag" {
  let html = "<div><p>A</p><p>B</p><span>C</span><p>D</p></div>"
  let nodes = parse_html(html)
  assert_true(nodes is Ok(_))
  match nodes {
    Ok(n) => {
      let p_count = @dom.count_by_tag(n, "p")
      assert_eq(p_count, 3)
      let span_count = @dom.count_by_tag(n, "span")
      assert_eq(span_count, 1)
    }
    Err(_) => ()
  }
}

test "filter elements" {
  let html = "<div><p id=\"a\">A</p><p>B</p><p id=\"c\">C</p></div>"
  let nodes = parse_html(html)
  assert_true(nodes is Ok(_))
  match nodes {
    Ok(n) => {
      let with_id = @dom.filter_elements(n, fn(elem) { @dom.has_attr(elem, "id") })
      assert_eq(with_id.length(), 2)
    }
    Err(_) => ()
  }
}

test "get children" {
  let html = "<div><p>A</p>Text<span>B</span></div>"
  let nodes = parse_html(html)
  assert_true(nodes is Ok(_))
  match nodes {
    Ok(n) => {
      let elems = @dom.get_all_elements(n)
      let div = elems[0]
      let children = @dom.get_children(div)
      assert_eq(children.length(), 2)
      assert_eq(children[0].tag, "p")
      assert_eq(children[1].tag, "span")
    }
    Err(_) => ()
  }
}

test "get children by tag" {
  let html = "<div><p>A</p><span>B</span><p>C</p></div>"
  let nodes = parse_html(html)
  assert_true(nodes is Ok(_))
  match nodes {
    Ok(n) => {
      let elems = @dom.get_all_elements(n)
      let div = elems[0]
      let p_children = @dom.get_children_by_tag(div, "p")
      assert_eq(p_children.length(), 2)
    }
    Err(_) => ()
  }
}

test "has children and count" {
  let html = "<div><p>A</p><span>B</span></div>"
  let nodes = parse_html(html)
  assert_true(nodes is Ok(_))
  match nodes {
    Ok(n) => {
      let elems = @dom.get_all_elements(n)
      let div = elems[0]
      assert_true(@dom.has_children(div))
      assert_eq(@dom.count_children(div), 2)
    }
    Err(_) => ()
  }
}

