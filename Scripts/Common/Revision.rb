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
      return "3b9014dc9acae3d95255a83befd85b52e7176acb"
      # 1.0.52 @ swift-DEVELOPMENT-SNAPSHOT-2020-01-13-a: 3b9014dc9acae3d95255a83befd85b52e7176acb
      # 1.0.51 @ swift-DEVELOPMENT-SNAPSHOT-2019-12-27-a: 746b58e8e1c1ef1ac09d8031875fd2a08b65597c
      # 1.0.50 @ swift-DEVELOPMENT-SNAPSHOT-2019-10-14-a: 9a4abf47a450aeff6a3231225fd2cf18cc7a940a
      # 1.0.50 @ swift-DEVELOPMENT-SNAPSHOT-2019-09-26-a: 8a91e9802448de399df4ee3ed24c63dc25af7e67
      # 1.0.50 @ swift-DEVELOPMENT-SNAPSHOT-2019-09-18-a: 4dac0d1e8bffee79728f04784961b3bc26ed9dbc
      # 1.0.49 @ swift-DEVELOPMENT-SNAPSHOT-2019-09-16-a: f302da0f9b856592992206afa75dd95668a192e1
      # 1.0.49 @ swift-DEVELOPMENT-SNAPSHOT-2019-08-30-a: dcd0893efe43639dddf6fc1637022822080e6a6a
   end

   def self.dispatch
      return "c992dacf3ca114806e6ac9ffc9113b19255be9fe"
      # 1.0.52 @ swift-DEVELOPMENT-SNAPSHOT-2020-01-13-a: c992dacf3ca114806e6ac9ffc9113b19255be9fe
      # 1.0.52 @ swift-DEVELOPMENT-SNAPSHOT-2019-09-29-a: 2accb0b97738b9ba9a0ffc1cb335716b70f9f65a
      # 1.0.49 @ swift-DEVELOPMENT-SNAPSHOT-2019-09-26-a: 970d562fcaee756bae9d20386e64bba90e635818
      # 1.0.49 @ swift-DEVELOPMENT-SNAPSHOT-2019-09-16-a: c023edd1cd02720407c62f4fac6a3f2c92cd0069
      # 1.0.49 @ swift-DEVELOPMENT-SNAPSHOT-2019-09-02-a: 90a45ce22f62c7c380339aa847dae4ab2d66ee30
      # 1.0.49 @ swift-DEVELOPMENT-SNAPSHOT-2019-08-22-a: 3da29ddcab09e4d09b015624e377f73a82c8dc9c
   end

   def self.foundation
      return "c093eb65ed3aabb334857714e01989ecfb875120"
      # 1.0.53 @ swift-DEVELOPMENT-SNAPSHOT-2019-11-06-a: c093eb65ed3aabb334857714e01989ecfb875120
      # 1.0.49 @ swift-DEVELOPMENT-SNAPSHOT-2019-11-01-a: facf5715d25d1765f10e4319b0701f300d9248e0
      # 1.0.49 @ swift-DEVELOPMENT-SNAPSHOT-2019-10-30-a: 5bb98287f5945a8cbb37df5a69741328488d2dd0
      # 1.0.49 @ swift-DEVELOPMENT-SNAPSHOT-2019-09-30-a: f62c026cb2f2f162bb3b3d93ae49969b60652e0b
      # 1.0.49 @ swift-DEVELOPMENT-SNAPSHOT-2019-09-04-a: c9c34a9447682131ae49332e3d2a20b8c82ca01e
      # 1.0.49 @ swift-DEVELOPMENT-SNAPSHOT-2019-09-02-a: 3e5366251756d7ffcf289c0faff865ca7dd23417
      # 1.0.49 @ swift-DEVELOPMENT-SNAPSHOT-2019-08-28-a: d99abed49a0763eefb7e1e1cdaa9654fb38c7c1b
      # 1.0.49 @ swift-DEVELOPMENT-SNAPSHOT-2019-08-16-a: 2e4734c674247b011a67996a9472f15ecb394e5e
      # 1.0.49 @ swift-DEVELOPMENT-SNAPSHOT-2019-08-14-a: f2d055cf77f59568c23412b2179e72193abac052
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
      return "019936b2100dc33c8946928d424b5cff4211acea"
      # 1.0.51 @ swift-DEVELOPMENT-SNAPSHOT-2020-01-03-a: 019936b2100dc33c8946928d424b5cff4211acea
   end

   def self.cmark
      return "31e12547c4de3dfcacc69855d93298cb90fd4f27"
      # 1.0.51 @ swift-DEVELOPMENT-SNAPSHOT-2020-01-03-a: 31e12547c4de3dfcacc69855d93298cb90fd4f27
      # 1.0.50 @ swift-DEVELOPMENT-SNAPSHOT-2019-10-14-a: bfa95d55b535fa178f75484b5e8f82ae3d8517af
      # 1.0.49 @ swift-5.1.1-RELEASE: 32fa49671d0fc5d1f65d2bcbabfb1511a9d65c27
      # swift-5.1-branch @ 1.0.39: 32fa49671d0fc5d1f65d2bcbabfb1511a9d65c27
      # swift-5.1-branch @ 1.0.26: 32fa49671d0fc5d1f65d2bcbabfb1511a9d65c27
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
