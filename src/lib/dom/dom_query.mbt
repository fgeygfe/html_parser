pub fn query_dom_by_tag_name(
  nodes: Array[@parser.DomNode], tag_name: String
) -> Array[@parser.DomNode] {
  let result: Array[@parser.DomNode] = []
  let mut i: Int = 0
  while i < nodes.length() {
    match nodes[i] {
      @parser.DomNode::Element(name, children) => {
        if name == tag_name {
          result.push(nodes[i])
        }
        let child_result: Array[@parser.DomNode] = query_dom_by_tag_name(children, tag_name)
        let mut j: Int = 0
        while j < child_result.length() {
          result.push(child_result[j])
          j = j + 1
        }
      }
      _ => ignore({})
    }
    i = i + 1
  }
  result
}

// 获取节点及其所有子节点的文本内容
pub fn get_node_inner_text(node: @parser.DomNode) -> String {
  match node {
    @parser.DomNode::Element(_, children) => {
      let mut text = ""
      let mut i = 0
      while i < children.length() {
        text = text + get_node_inner_text(children[i])
        i = i + 1
      }
      text
    }
    @parser.DomNode::TextNode(content) => content
    _ => ""
  }
}

// 获取节点的指定属性值（当前结构无属性，直接返回 None）
pub fn get_node_attribute(_node: @parser.DomNode, _attr_name: String) -> Option[String] {
  None
}