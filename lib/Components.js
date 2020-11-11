/*
 * The MIT License
 *
 * Copyright (c) 2019 Volodymyr Gorlov (https://github.com/vgorloff)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

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
var SPMComponent = require("./Components/SPMComponent");

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
  spm: new SPMComponent()
};
