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
      # v5.1 @ master: 131bee791658c1beee0a48868b59a3000030702c (1.0.28)
      # v5.1 @ master: ee6688d264d1012e669eda37c357d55e9de62dba (1.0.26)
      # v5.1 @ master: 7beb3585d5edfc24e945afca513c24205e7a47a5 (1.0.23)
      # v5.1 @ master: d272bfa18dc105db01afe01472a8c08f2025f9df
      # v5.1 @ master: 50a8567c36b880676217bca63c4134fb6341faa3
      # v5.1 @ master: 036e74a6a64438b8f8e5e1546f362ca7490ae233
      return "131bee791658c1beee0a48868b59a3000030702c"
   end

   def self.dispatch
      # v5.1 @ master: 4169c8d3382fd1083289ee3b22a349acef584141 (1.0.26)
      # v5.1 @ master: 90a84a1c6cf8c2f8abbd0eb60b1cf23ad8f66f99 (1.0.24)
      # v5.1 @ master: e8d020e49cdb82513186e63989398db7b7aaefab
      # v5.1 @ master: a18aa1f600361c1397b810a488a2e073f6f03985
      return "4169c8d3382fd1083289ee3b22a349acef584141"
   end

   def self.foundation
      # v5.1 @ master: 52334ad24dd36c608ace1b0a0c789f1d79d1ba23 (1.0.27)
      # v5.1 @ master: ef19b4ff14954978affacb8b3388380062916479 (1.0.26)
      # v5.1 @ master: 9e50b4014aceacf26ab341143bc19a85d8bd9962 (1.0.24)
      # v5.1 @ master: f9b18eb92d068a68006d8d288fc32406b1e91009
      # v5.1 @ master: 75fa8e0a0f4dd6d6570cfa51cd6d0901870c9162
      # v5.1 @ master: c5357f39dd15ae858dc72d15bbabe5435376db70
      return "52334ad24dd36c608ace1b0a0c789f1d79d1ba23"
   end

   def self.cmark
      # 5.1-master: 32fa49671d0fc5d1f65d2bcbabfb1511a9d65c27
      # 5.0.1: acd1105eb5dae681e71cc47b2cd0fe592a1ab529
      return "32fa49671d0fc5d1f65d2bcbabfb1511a9d65c27"
   end

   def self.clang
      # swift-5.1-branch: 2a6d22b018a5348a03000b8abfa0bde207ffd08d (1.0.26)
      # 5.1-stable: 2a360740a35b97d3c6e779ce3e7ed1d00d7af2b3
      # 5.0.1: 5c9d04dc0697297a47b5edb0c1a581b306a42bdb
      return "2a6d22b018a5348a03000b8abfa0bde207ffd08d"
   end

   def self.llvm
      # swift-5.1-branch: 42c6b79618828d5d536b1f527ea14c33fc7474d7 (1.0.26)
      # 5.1-stable: 082dec2e222ca228125e187a726ee87c5b83ad54
      # 5.0.1: 34250a6eef79ee8a83c5cfb4deb1583176dcbb63
      return "42c6b79618828d5d536b1f527ea14c33fc7474d7"
   end

   def self.crt
      # swift-5.1-branch: cfe3fd986aaceb308a7736c159bfa8bd688b381b (1.0.26)
      # 5.1-stable: f201a2894735c781f7da4ef74931fa390de16b31
      # 5.0.1: b7035fda6caf881c33e3a346a6c76d10a499e6b2
      return "cfe3fd986aaceb308a7736c159bfa8bd688b381b"
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
