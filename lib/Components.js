var LLVMComponent = require("./Components/LLVMComponent");
var SwiftStdLibComponent = require("./Components/SwiftStdLibComponent");
var ICUCompoment = require("./Components/ICUCompoment");
var SwiftComponent = require("./Components/SwiftComponent");
var CMarkComponent = require("./Components/CMarkComponent");
var DispatchComponent = require("./Components/DispatchComponent");
var FoundationComponent = require("./Components/FoundationComponent");
var XMLComponent = require("./Components/XMLComponent");
var CURLComponent = require("./Components/CURLComponent");
var SSLComponent = require("./Components/SSLComponent");

module.exports = {
  llvm: new LLVMComponent(),
  stdlib: new SwiftStdLibComponent(),
  icu: new ICUCompoment(),
  swift: new SwiftComponent(),
  cmark: new CMarkComponent(),
  dispatch: new DispatchComponent(),
  foundation: new FoundationComponent(),
  xml: new XMLComponent(),
  curl: new CURLComponent(),
  ssl: new SSLComponent(),
};
