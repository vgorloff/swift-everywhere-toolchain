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

var path = require("path");
const cp = require("child_process");

var Config = require("./Config");
var Folder = require("./Folder");
var Component = require("./Components/Component");
var Arch = require("./Archs/Arch");

module.exports = class Paths {
  static sourcesDirPath(/** @type {Component} */ component) {
    return path.join(Config.toolChain, Folder.sources, component.sources);
  }
  constructor(/** @type {String} */ platform, /** @type {Component} */ component, /** @type {Arch} */ arch) {
    this.sources = Paths.sourcesDirPath(component)
    this.patches = path.join(Config.root, Folder.patches, component.name);
    this.builds = path.join(Config.toolChain, Folder.build, `${platform}-${arch.name}`, component.name);
    this.installs = path.join(Config.toolChain, Folder.install, `${platform}-${arch.name}`, component.name);
    this.lib = path.join(this.installs, 'lib')
    this.developerDir = cp.execSync("xcode-select --print-path").toString().trim()
    this.xcToolchainPath = path.join(this.developerDir, 'Toolchains/XcodeDefault.xctoolchain')
    this.xcMacOsSdkPath = path.join(this.developerDir, 'Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk') // The `xcrun --show-sdk-path` can be used instead.
  }
};
