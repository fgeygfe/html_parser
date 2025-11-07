# HTML Parser

一个使用 [MoonBit 语言](https://www.moonbitlang.com/) 实现的轻量级 HTML 解析器，包含完整的词法分析器（Lexer）和语法分析器（Parser）。

[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](LICENSE)
[![MoonBit](https://img.shields.io/badge/MoonBit-0.1.0-orange.svg)](https://www.moonbitlang.com/)

## ✨ 特性

- 🚀 **完整的 HTML 解析** - 支持标准 HTML 标签、属性和文本内容
- 🔧 **基于 MoonYacc** - 使用 LR 语法分析器生成器构建
- 🌳 **AST 生成** - 将 HTML 解析为抽象语法树（Abstract Syntax Tree）
- ✅ **全面测试** - 包含 15+ 个测试用例，覆盖各种 HTML 结构
- 📦 **模块化设计** - 清晰的分层架构（Lexer、Parser、AST）
- 🎯 **支持多种标签** - 普通标签、自闭合标签、嵌套标签等

## 📋 支持的 HTML 特性

- ✅ 普通标签：`<div>...</div>`
- ✅ 自闭合标签：`<br/>`, `<img/>`
- ✅ 标签属性：`<div id="main" class="container">`
- ✅ 带引号的属性值：`class="value"`
- ✅ 无引号的属性值：`width=100`
- ✅ 文本内容：`<p>Hello World</p>`
- ✅ 嵌套结构：`<div><p><span>...</span></p></div>`
- ✅ 注释：`<!-- comment -->`
- ✅ DOCTYPE：`<!DOCTYPE html>`
- ✅ CDATA：`<![CDATA[...]]>`

## 🏗️ 项目结构

```
html_parser/
├── src/
│   ├── lib/
│   │   ├── ast/              # 抽象语法树定义
│   │   │   ├── ast.mbt       # AST 数据结构
│   │   │   └── moon.pkg.json
│   │   ├── lexer/            # 词法分析器
│   │   │   ├── lexer.mbt     # Token 化逻辑
│   │   │   └── moon.pkg.json
│   │   └── parser/           # 语法分析器
│   │       ├── parser.mbty   # MoonYacc 语法定义
│   │       ├── parser.mbt    # 生成的 Parser 代码
│   │       └── moon.pkg.json
│   └── test/                 # 测试文件
│       ├── parser_wbtest.mbt # 解析器测试
│       └── moon.pkg.json
├── moon.mod.json             # MoonBit 项目配置
├── LICENSE                   # Apache-2.0 许可证
└── README.md                 # 本文档
```

## 🚀 快速开始

### 前置要求

- [MoonBit CLI](https://www.moonbitlang.com/download/) - 安装 MoonBit 工具链

### 安装

```bash
# 克隆仓库
git clone <repository-url>
cd html_parser

# 构建项目
moon build
```

### 基本使用

```moonbit
import "@html_parser/lib/lexer"
import "@html_parser/lib/parser"
import "@html_parser/lib/ast"

fn main {
  // 准备 HTML 字符串
  let html = "<div><p>Hello World</p></div>"
  
  // 第一步：词法分析
  let tokens = @lexer.tokenize(html)
  
  // 第二步：准备 token 读取函数
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
  
  // 第三步：语法分析
  try @parser.html_document(read_token, 0) catch {
    err => {
      println("解析错误：")
      println(err)
    }
  } noraise {
    result => {
      println("解析成功：")
      println(result)  // 输出 AST
    }
  }
}
```

### 运行示例

```bash
# 编译并运行（JavaScript 目标）
moon run --target js src/main

# 编译并运行（WebAssembly 目标）
moon run --target wasm-gc src/main
```

## 🧪 测试

项目包含全面的测试套件，覆盖各种 HTML 解析场景。

### 运行测试

```bash
# 运行所有测试
moon test

# 运行特定目标的测试
moon test --target wasm-gc
moon test --target js
```

### 测试覆盖

测试文件 `src/test/parser_wbtest.mbt` 包含以下测试用例：

1. **基础标签测试**
   - 空标签：`<div></div>`
   - 带属性的空标签：`<div id="main"></div>`
   - 带文本的标签：`<p>Hello World</p>`

2. **自闭合标签测试**
   - 有属性：`<img src="image.jpg" />`
   - 无属性：`<br/>`

3. **嵌套结构测试**
   - 简单嵌套：`<div><p>Text</p></div>`
   - 复杂嵌套：`<div><p><span>Text</span></p></div>`
   - 深层嵌套：多层嵌套结构

4. **混合内容测试**
   - 文本与标签混合
   - 多个兄弟元素
   - 带多个属性的标签

5. **错误处理测试**
   - 不匹配的标签
   - 无效的 HTML 结构

### 测试结果

```
Total tests: 15, passed: 15, failed: 0 ✅
```

## 🔧 技术细节

### 词法分析器（Lexer）

词法分析器负责将 HTML 字符串转换为 Token 流。

**支持的 Token 类型：**

```moonbit
Token
  | EOF                      // 文件结束
  | TAG_NAME(String)         // 标签名：div, span, p 等
  | TEXT(String)             // 文本内容
  | ATTR_NAME(String)        // 属性名
  | ATTR_VALUE(String)       // 属性值（无引号）
  | ATTR_VALUE_QUOTED(String) // 属性值（带引号）
  | LANGLE                   // <
  | RANGLE                   // >
  | SLASH                    // /
  | EQUAL                    // =
  | QUOTE                    // "
  | SELF_CLOSE               // />
  | CLOSE_TAG_START          // </
```

**关键设计决策：**
- `CLOSE_TAG_START` (`</`) 作为单个 token 处理，避免了 LR 解析器的 shift/reduce 冲突
- 支持带引号和不带引号的属性值
- 自动跳过标签间的空白字符

### 语法分析器（Parser）

使用 [MoonYacc](https://github.com/moonbitlang/yacc) 生成的 LR 语法分析器。

**语法规则摘要：**

```
html_document → element_list

element → tag_element | text_content

tag_element → 
  | LANGLE TAG_NAME attribute_list RANGLE element_list CLOSE_TAG_START TAG_NAME RANGLE
  | LANGLE TAG_NAME RANGLE element_list CLOSE_TAG_START TAG_NAME RANGLE
  | LANGLE TAG_NAME attribute_list SELF_CLOSE
  | LANGLE TAG_NAME SELF_CLOSE

attribute → 
  | ATTR_NAME EQUAL QUOTE ATTR_VALUE_QUOTED QUOTE
  | ATTR_NAME EQUAL ATTR_VALUE
  | ATTR_NAME
```

### 抽象语法树（AST）

解析器生成的 AST 使用以下数据结构：

```moonbit
// AST 节点类型
pub enum Node {
  Element(Element)  // 元素节点
  Text(String)      // 文本节点
}

// 元素结构
pub struct Element {
  tag : String           // 标签名
  attrs : Array[Attribute]  // 属性列表
  children : Array[Node]    // 子节点列表
}

// 属性结构
pub struct Attribute {
  name : String   // 属性名
  value : String  // 属性值
}
```

**AST 示例：**

HTML: `<div id="main"><p>Hello</p></div>`

AST:
```
[
  Element({
    tag: "div",
    attrs: [{ name: "id", value: "main" }],
    children: [
      Element({
        tag: "p",
        attrs: [],
        children: [Text("Hello")]
      })
    ]
  })
]
```

## 🐛 已知问题与解决方案

### 已解决：Shift/Reduce 冲突

**问题：** 早期版本中，解析器在遇到结束标签时会报错：
```
UnexpectedToken(SLASH, (6, 7), [TAG_NAME])
```

**原因：** 当解析器看到 `<` 时，无法区分是开始标签 `<tag>` 还是结束标签 `</tag>`，导致 shift/reduce 冲突。

**解决方案：** 
1. 引入新的 token `CLOSE_TAG_START` 代表 `</`
2. 将结束标签 tokenize 为 `CLOSE_TAG_START` + `TAG_NAME` + `RANGLE`
3. 更新语法规则，消除歧义

这个设计决策是本解析器的关键创新点之一。

## 📚 API 参考

### Lexer API

```moonbit
// 将 HTML 字符串 tokenize
pub fn tokenize(input : String) -> Array[(Token, Int, Int)]
```

**参数：**
- `input`: 要解析的 HTML 字符串

**返回值：**
- Token 数组，每个元素是 `(token, start_pos, end_pos)` 三元组

### Parser API

```moonbit
// 解析 HTML 文档
pub fn html_document(
  read_token : () -> (Token, Int, Int),
  start_pos : Int
) -> Result[Array[Node], ParseError]!
```

**参数：**
- `read_token`: 读取下一个 token 的函数
- `start_pos`: 起始位置（通常为 0）

**返回值：**
- 成功：`Array[Node]` - AST 节点数组
- 失败：`ParseError` - 解析错误信息

### DOM Query API

#### 查询函数

```moonbit
// 按标签名查找所有元素
pub fn find_by_tag(nodes : Array[Node], tag : String) -> Array[Element]

// 按标签名查找第一个元素
pub fn find_first_by_tag(nodes : Array[Node], tag : String) -> Element?

// 按 ID 查找元素
pub fn find_by_id(nodes : Array[Node], id : String) -> Element?

// 按 class 名查找所有元素
pub fn find_by_class(nodes : Array[Node], class_name : String) -> Array[Element]

// 按属性查找元素（精确匹配）
pub fn find_by_attr(
  nodes : Array[Node],
  attr_name : String,
  attr_value : String
) -> Array[Element]

// 查找拥有指定属性的所有元素（不关心值）
pub fn find_with_attr(nodes : Array[Node], attr_name : String) -> Array[Element]

// 使用自定义谓词过滤元素
pub fn filter_elements(
  nodes : Array[Node],
  predicate : (Element) -> Bool
) -> Array[Element]
```

#### 辅助函数

```moonbit
// 获取元素的属性值
pub fn get_attr(elem : Element, name : String) -> String?

// 检查元素是否有某个属性
pub fn has_attr(elem : Element, name : String) -> Bool

// 获取元素的所有 class 名
pub fn get_classes(elem : Element) -> Array[String]

// 检查元素是否有某个 class
pub fn has_class(elem : Element, class_name : String) -> Bool

// 获取元素的 ID
pub fn get_id(elem : Element) -> String?

// 获取元素的所有文本内容（递归）
pub fn get_text_from_element(elem : Element) -> String

// 获取节点的文本内容
pub fn get_text_from_node(node : Node) -> String

// 获取所有文本内容（拼接）
pub fn get_text_content(nodes : Array[Node]) -> String
```

#### 遍历函数

```moonbit
// 获取所有元素节点（DFS）
pub fn get_all_elements(nodes : Array[Node]) -> Array[Element]

// 获取所有文本节点
pub fn get_all_text_nodes(nodes : Array[Node]) -> Array[String]

// 按标签计数
pub fn count_by_tag(nodes : Array[Node], tag : String) -> Int
```

#### 子元素函数

```moonbit
// 获取直接子元素
pub fn get_children(elem : Element) -> Array[Element]

// 获取指定标签的直接子元素
pub fn get_children_by_tag(elem : Element, tag : String) -> Array[Element]

// 检查是否有子元素
pub fn has_children(elem : Element) -> Bool

// 计算子元素数量
pub fn count_children(elem : Element) -> Int
```

#### 使用示例

```moonbit
import "@html_parser/lib/lexer"
import "@html_parser/lib/parser"
import "@html_parser/lib/dom"

fn main {
  let html = "<div id=\"main\" class=\"container\"><p>Hello</p></div>"
  
  // 解析 HTML
  let tokens = @lexer.tokenize(html)
  let mut index = 0
  fn read_token() -> (@parser.Token, Int, Int) {
    if index < tokens.length() {
      let token = tokens[index]
      index += 1
      token
    } else {
      (@parser.EOF, 0, 0)
    }
  }
  
  let result = try @parser.html_document(read_token, 0) catch {
    err => {
      println("Error: " + err.to_string())
      return
    }
  } noraise {
    nodes => nodes
  }
  
  // DOM 查询
  // 1. 按标签查找
  let paragraphs = @dom.find_by_tag(result, "p")
  println("Found " + paragraphs.length().to_string() + " paragraphs")
  
  // 2. 按 ID 查找
  match @dom.find_by_id(result, "main") {
    Some(elem) => println("Found element with id='main'")
    None => println("Not found")
  }
  
  // 3. 按 class 查找
  let containers = @dom.find_by_class(result, "container")
  
  // 4. 获取文本内容
  let text = @dom.get_text_content(result)
  println("Text: " + text)
  
  // 5. 获取属性
  match @dom.find_by_id(result, "main") {
    Some(elem) => {
      match @dom.get_attr(elem, "class") {
        Some(cls) => println("Class: " + cls)
        None => ()
      }
    }
    None => ()
  }
}
```

## 🤝 贡献

欢迎贡献！如果你发现 bug 或有改进建议，请：

1. Fork 本仓库
2. 创建你的特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交你的更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启一个 Pull Request

### 开发指南

1. **修改语法规则**：编辑 `src/lib/parser/parser.mbty`
2. **修改词法规则**：编辑 `src/lib/lexer/lexer.mbt`
3. **添加测试**：在 `src/test/parser_wbtest.mbt` 中添加测试用例
4. **重新构建**：`moon build`
5. **运行测试**：`moon test`

## 🔮 未来计划

- [ ] 支持更多 HTML5 特性
- [ ] 添加 CSS 选择器支持
- [ ] DOM 查询 API
- [ ] HTML 美化输出
- [ ] 错误恢复机制
- [ ] 性能优化
- [ ] 更详细的错误信息

## 📄 许可证

本项目采用 Apache-2.0 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🙏 致谢

- [MoonBit](https://www.moonbitlang.com/) - 现代化的编程语言
- [MoonYacc](https://github.com/moonbitlang/yacc) - LR 语法分析器生成器

## 📞 联系方式

如有问题或建议，欢迎：
- 提交 Issue
- 发起 Discussion
- 提交 Pull Request

---

**Happy Parsing! 🎉**
