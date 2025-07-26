///|
test "test_query_dom_by_tag_name" {
  let span1 = @parser.DomNode::Element("span", [])
  let span2 = @parser.DomNode::Element("span", [])
  let p = @parser.DomNode::Element("p", [])
  let div = @parser.DomNode::Element("div", [span1, span2, p])
  let nodes = [div]

  // 查询所有 span 节点
  let result = query_dom_by_tag_name(nodes, "span")
  assert_eq(result.length(), 2)
  match result.get(0) {
    Some(@parser.DomNode::Element(name, _)) => assert_eq(name, "span")
    _ => abort("test_query_dom_by_tag_name failed")
  }
  match result.get(1) {
    Some(@parser.DomNode::Element(name, _)) => assert_eq(name, "span")
    _ => abort("test_query_dom_by_tag_name failed")
  }

  // 查询 p 节点
  let result_p = query_dom_by_tag_name(nodes, "p")
  assert_eq(result_p.length(), 1)
  match result_p.get(0) {
    Some(@parser.DomNode::Element(name, _)) => assert_eq(name, "p")
    _ => abort("test_query_dom_by_tag_name failed")
  }

  // 查询不存在的标签
  let result_none = query_dom_by_tag_name(nodes, "ul")
  assert_eq(result_none.length(), 0)
}
