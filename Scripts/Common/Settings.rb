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

require_relative "Config.rb"

class Settings

   def initialize()
      @settingsFilePath = Config.root + "/local.properties.yml"
      if File.exist?(@settingsFilePath)
         @config = YAML.load_file(@settingsFilePath)
      else
         raise "File \"#{@settingsFilePath}\" not exists."
      end
   end

   def isVagrant?
      return !ENV['AUTOMATION_IS_INSIDE_VAGRANT_BOX'].nil?
   end

   def ndkDir
      if isVagrant?
         return '/android-ndk'
      end

      isMacOS = Tool.new().isMacOS?
      settingKey = isMacOS ? 'ndk.dir.macos' : 'ndk.dir.linux'
      ndkDir = @config[settingKey]
      if ndkDir.nil?
         raise "Setting \"#{settingKey}\" is missed in file \"#{@settingsFilePath}\"."
      end

      return File.expand_path(ndkDir)
   end

end
