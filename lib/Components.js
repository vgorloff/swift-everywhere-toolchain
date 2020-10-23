var LLVMComponent = require("./Components/LLVMComponent");
var SwiftStdLibComponent = require("./Components/SwiftStdLibComponent");
var ICUCompoment = require("./Components/ICUCompoment");

module.exports = {
  llvm: new LLVMComponent(),
  stdlib: new SwiftStdLibComponent(),
  icu: new ICUCompoment(),
};
