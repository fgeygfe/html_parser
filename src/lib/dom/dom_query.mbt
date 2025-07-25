///|
pub fn query_dom_by_tag_name(
  nodes : Array[@parser.DomNode],
  tag_name : String,
) -> Array[@parser.DomNode] {
  let result = []
  for i in 0..<nodes.length() {
    if nodes[i] is @parser.DomNode::Element(name, children) {
      if name == tag_name {
        result.push(nodes[i])
      }
      let child_result = query_dom_by_tag_name(children, tag_name)
      for j in 0..<child_result.length() {
        result.push(child_result[j])
      }
    }
  }
  result
}

// 获取节点及其所有子节点的文本内容

///|
pub fn get_node_inner_text(node : @parser.DomNode) -> String {
  match node {
    @parser.DomNode::Element(_, children) => {
      let text = StringBuilder::new()
      for i in 0..<children.length() {
        text.write_string(get_node_inner_text(children[i]))
      }
      text.to_string()
    }
    @parser.DomNode::TextNode(content) => content
    _ => ""
  }
}

// 获取节点的指定属性值（当前结构无属性，直接返回 None）

///|
pub fn get_node_attribute(
  _node : @parser.DomNode,
  _attr_name : String,
) -> String? {
  ...
}
