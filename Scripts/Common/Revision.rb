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

class Revision

   # See also: $ToolChain/Sources/swift/utils/update_checkout/update-checkout-config.json

   def self.swift
      # 1.0.49 @ swift-DEVELOPMENT-SNAPSHOT-2019-09-16-a: f302da0f9b856592992206afa75dd95668a192e1
      # 1.0.49 @ swift-DEVELOPMENT-SNAPSHOT-2019-08-30-a: dcd0893efe43639dddf6fc1637022822080e6a6a
      # 1.0.47 @ master / swift-DEVELOPMENT-SNAPSHOT-2019-08-13-a: 9d1470dc565c6cf94be070d38599ca50966f1b7f
      # master @ 1.0.47: f82572a573af91bfbe1495c1b747165d64df5f02 (Breaks Build)
      # master @ 1.0.47: f34ef5db8525f286236abf84b4f909c15c07aca2
      # master @ 1.0.40: 10a4e3ef41059608ffe9eded039350055064ce9f
      # master @ 1.0.30: 17d65dc861727e0c8b2f676f30d5b03d021f896c
      # master @ 1.0.29: b70cd7031fe7a2c400976007abbfff1597189174
      # master @ 1.0.28: 131bee791658c1beee0a48868b59a3000030702c
      # master @ 1.0.26: ee6688d264d1012e669eda37c357d55e9de62dba
      # master @ 1.0.23: 7beb3585d5edfc24e945afca513c24205e7a47a5
      return "f302da0f9b856592992206afa75dd95668a192e1"
   end

   def self.dispatch
      # 1.0.49 @ swift-DEVELOPMENT-SNAPSHOT-2019-09-26-a: 970d562fcaee756bae9d20386e64bba90e635818
      # 1.0.49 @ swift-DEVELOPMENT-SNAPSHOT-2019-09-16-a: c023edd1cd02720407c62f4fac6a3f2c92cd0069
      # 1.0.49 @ swift-DEVELOPMENT-SNAPSHOT-2019-09-02-a: 90a45ce22f62c7c380339aa847dae4ab2d66ee30
      # 1.0.49 @ swift-DEVELOPMENT-SNAPSHOT-2019-08-22-a: 3da29ddcab09e4d09b015624e377f73a82c8dc9c
      # master @ 1.0.42: 68875cb3bacc1061716ed8c91a4e408fa015552e
      # master @ 1.0.40: 6d32c4d424e24ceea6e1c6e57ee9b6b5e5d375d7
      # master @ 1.0.37: f911a44a403a2cb48723604236bda9caa0f8a771
      # master @ 1.0.26: 4169c8d3382fd1083289ee3b22a349acef584141
      # master @ 1.0.24: 90a84a1c6cf8c2f8abbd0eb60b1cf23ad8f66f99
      return "970d562fcaee756bae9d20386e64bba90e635818"
   end

   def self.foundation
      # 1.0.49 @ swift-DEVELOPMENT-SNAPSHOT-2019-09-02-a: 3e5366251756d7ffcf289c0faff865ca7dd23417
      # 1.0.49 @ swift-DEVELOPMENT-SNAPSHOT-2019-08-14-a: f2d055cf77f59568c23412b2179e72193abac052
      # master @ 1.0.42: 84d6a68f05793f55c1a3aecf553c74fe2fae2ae9
      # master @ 1.0.42: e6d968fa1636db8f3dc2ebfee3f28477240d1dc0
      # master @ 1.0.40: c5c35c1a59b0a9a05b2e1ffbf8a7bab0a3e59baa
      # master @ 1.0.37: 7c9fb6a14643ae9ec6f37fef8161ec391ef38bff
      # master @ 1.0.36: fdc818a038385a2cdcad4fac42c32a6473568e6f
      # master @ 1.0.32: 664c8a023aeba4b3dbe015b1073e3bf4e7d49fa7
      # master @ 1.0.31: 73f2a6217b69f8b781fc1f40963d3c5c2f2a269b
      # master @ 1.0.27: 52334ad24dd36c608ace1b0a0c789f1d79d1ba23
      # master @ 1.0.26: ef19b4ff14954978affacb8b3388380062916479
      # master @ 1.0.24: 9e50b4014aceacf26ab341143bc19a85d8bd9962
      return "f2d055cf77f59568c23412b2179e72193abac052"
   end

   def self.spm
      # master @ 1.0.43 3dad9e7cfe20d1b48256afca13df293bdca870b9
      # swift-5.0-branch @ 1.0.43 3a57975e10be0b1a8b87992ddf3a49701036f96c
      # swift-5.1-branch @ 1.0.37 0996526dbf2d5adbdef4b133312e441c0deb3db7
      return "3dad9e7cfe20d1b48256afca13df293bdca870b9"
   end

   def self.llb
      # master @ 1.0.43 5bf016632c0e85d835c63b84b43d3c887f01418f
      # swift-5.0-branch @ 1.0.43 4f77fc47e2f5fcddc057abc8391f7c23d1e8d275
      # swift-5.1-branch @ 1.0.37 f73b84bc1525998e5e267f9d830c1411487ac65e
      return "5bf016632c0e85d835c63b84b43d3c887f01418f"
   end

   def self.llvm
      # swift-5.1-branch @ 1.0.39: 688b71e2f9b709fd7ae3839172f2234eb8bd469a
      # swift-5.1-branch @ 1.0.26: 42c6b79618828d5d536b1f527ea14c33fc7474d7
      return "688b71e2f9b709fd7ae3839172f2234eb8bd469a"
   end

   def self.clang
      # swift-5.1-branch @ 1.0.39: cb082b2ada7a959cfa27a48b1c3777a8a496114c
      # swift-5.1-branch @ 1.0.26: 2a6d22b018a5348a03000b8abfa0bde207ffd08d
      return "cb082b2ada7a959cfa27a48b1c3777a8a496114c"
   end

   def self.crt
      # swift-5.1-branch @ 1.0.39: 79b188b8d0e744baa86f58cebb721a8613d1adb2
      # swift-5.1-branch @ 1.0.26: cfe3fd986aaceb308a7736c159bfa8bd688b381b
      return "79b188b8d0e744baa86f58cebb721a8613d1adb2"
   end

   def self.cmark
      # swift-5.1-branch @ 1.0.39: 32fa49671d0fc5d1f65d2bcbabfb1511a9d65c27
      # swift-5.1-branch @ 1.0.26: 32fa49671d0fc5d1f65d2bcbabfb1511a9d65c27
      return "32fa49671d0fc5d1f65d2bcbabfb1511a9d65c27"
   end

   def self.ssl
      # OpenSSL_1_1_1c: 97ace46e11dba4c4c2b7cb67140b6ec152cfaaf4 (1.0.26)
      # OpenSSL_1_1_1b: 50eaac9f3337667259de725451f201e784599687
      # OpenSSL_1_1_1a: d1c28d791a7391a8dc101713cd8646df96491d03
      return "97ace46e11dba4c4c2b7cb67140b6ec152cfaaf4"
   end

   def self.icu
      # v64-2: e2d85306162d3a0691b070b4f0a73e4012433444 (1.0.26)
      # v64-rc2: 67d218f2476ac543de2ed843fa080892972c604a
      return "e2d85306162d3a0691b070b4f0a73e4012433444"
   end

   def self.curl
      # 7_65_1: 69248b58f649e35b09a126c12781353e3471f5c6 (1.0.26)
      # 7.65.0: 885ce31401b6789c959131754b1e5ae518964072
      # 7.64.1: 521bbbe29928f9bc1c61306df612e856d45cbe5a
      # 7.63.0: 4258dc02d86e7e4de9f795a1af3a0bc6732d4ab5
      return "69248b58f649e35b09a126c12781353e3471f5c6"
   end

   def self.xml
      # v2.9.9: f8a8c1f59db355b46962577e7b74f1a1e8149dc6 (1.0.26)
      return "f8a8c1f59db355b46962577e7b74f1a1e8149dc6"
   end

end
