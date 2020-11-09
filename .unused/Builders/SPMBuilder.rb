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

require_relative "../Common/Builder.rb"
require_relative "SwiftSPMBuilder.rb"

class SPMBuilder < Builder

   def initialize()
      super(Lib.spm, Arch.host)
      @llb = LLBBuilder.new()
      @swift = SwiftSPMBuilder.new()
      @args = []
      # @args << "-v"
      @args << "--swiftc \"#{@swift.builds}/bin/swiftc\""
      @args << "--sbt #{@llb.builds}/bin/swift-build-tool"
      @args << "--release"
      @args << "--build #{@builds} --prefix #{@installs}"
      @args << "--llbuild-build-dir #{@llb.builds} --llbuild-source-dir #{@llb.sources}"
   end

   def executeBuild
      execute "cd #{@sources} && Utilities/bootstrap #{@args.join(' ')}"
   end

   def executeClean
      execute "cd #{@sources} && Utilities/bootstrap clean #{@args.join(' ')}"
   end

   def executeInstall
      execute "cd #{@sources} && Utilities/bootstrap install #{@args.join(' ')}"
   end

end
