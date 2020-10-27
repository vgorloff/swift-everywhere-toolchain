var LLVMComponent = require("./Components/LLVMComponent");
var SwiftStdLibComponent = require("./Components/SwiftStdLibComponent");
var ICUCompoment = require("./Components/ICUCompoment");
var SwiftComponent = require("./Components/SwiftComponent");
var CMarkComponent = require("./Components/CMarkComponent");
var DispatchComponent = require("./Components/DispatchComponent");

module.exports = {
  llvm: new LLVMComponent(),
  stdlib: new SwiftStdLibComponent(),
  icu: new ICUCompoment(),
  swift: new SwiftComponent(),
  cmark: new CMarkComponent(),
  dispatch: new DispatchComponent(),
};
