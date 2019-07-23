#
# The MIT License
#
# Copyright (c) 2019 Volodymyr Gorlov (https://github.com/vgorloff)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

require_relative "Settings.rb"
require 'yaml'

class NDK

   def initialize()
      @settings = Settings.new()
   end

   def api
      return "24"
   end

   def gcc
      return "4.9"
   end

   def sources
      return @settings.ndkDir
   end

   def toolchain
      isMacOS = Tool.new().isMacOS?
      subPath = isMacOS ? "darwin-x86_64" : "linux-x86_64"
      return "#{@settings.ndkDir}/toolchains/llvm/prebuilt/#{subPath}"
   end

end
