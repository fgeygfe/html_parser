///|
pub(all) enum Node {
  Element(Element)
  Text(String)
} derive(Eq, Compare)

///|
pub(all) struct Element {
  tag : String
  attrs : Array[Attribute]
  children : Array[Node]
} derive(Eq, Compare)

///|
pub(all) struct Attribute {
  name : String
  value : String
} derive(Show, Eq, Compare)

// Manual Show implementation for recursive types
pub impl Show for Element with output(self, logger) {
  logger.write_string("<")
  logger.write_string(self.tag)
  for attr in self.attrs {
    logger.write_string(" ")
    logger.write_string(attr.name)
    if attr.value.length() > 0 {
      logger.write_string("=\"")
      logger.write_string(attr.value)
      logger.write_string("\"")
    }
  }
  logger.write_string(">")
  for child in self.children {
    child.output(logger)
  }
  logger.write_string("</")
  logger.write_string(self.tag)
  logger.write_string(">")
}

pub impl Show for Node with output(self, logger) {
  match self {
    Element(elem) => elem.output(logger)
    Text(text) => logger.write_string(text)
  }
}

