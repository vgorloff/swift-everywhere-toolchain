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

var ICUBaseBuilder = require("./ICUBaseBuilder");
const Archs = require("../Archs");

module.exports = class ICUHostBuilder extends ICUBaseBuilder {
  constructor() {
    super(Archs.host);
  }

  executeConfigure() {
    var hostSystem = "MacOSX"; // Other option "Linux"

    var cmd = `cd ${this.paths.builds} &&
    CFLAGS='-Os'
    CXXFLAGS='--std=c++11'
    ${this.paths.sources}/source/runConfigureICU ${hostSystem} --prefix=${this.paths.installs}

    // Below option should not be set. Otherwize you will have ICU without embed data.
    // See:
    // - ICU Data - ICU User Guide: http://userguide.icu-project.org/icudata#TOC-Building-and-Linking-against-ICU-data
    // - https://forums.swift.org/t/partial-nightlies-for-android-sdk/25909/43?u=v.gorlov
    // --enable-tools=no

    --enable-static --enable-shared=no --enable-extras=no --enable-strict=no --enable-icuio=no --enable-layout=no
    --enable-layoutex=no --enable-tests=no --enable-samples=no --enable-dyload=no
`;
    this.executeCommands(cmd);
  }

  executeBuild() {
    this.execute(`cd ${this.paths.builds} && make`);
  }

  executeInstall() {
    this.logInfo("ICU Host Build not require to install. It is just used for `Cross Compilation`.");
  }
};
