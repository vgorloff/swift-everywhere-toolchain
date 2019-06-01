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

require_relative "Location.rb"

class Config

   def self.root
      return File.realpath(File.dirname(__FILE__) + "/../../")
   end

   def self.toolChain
      return "#{root}/#{Location.toolChain}"
   end

   def self.toolchainDir
      return "#{toolChain}/swift-android-toolchain"
   end

   def self.sources
      return "#{toolChain}/#{Location.sources}"
   end

   def self.build
      return "#{toolChain}/#{Location.build}"
   end

   def self.install
      return "#{toolChain}/#{Location.install}"
   end

   def self.patches
      return "#{root}/#{Location.patches}"
   end

   def self.projects
      return "#{root}/#{Location.projects}"
   end

end
