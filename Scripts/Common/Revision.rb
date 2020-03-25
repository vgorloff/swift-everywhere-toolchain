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
      return "443e9a41d1a7c1fcae280490144fcbf8461d3499"
      # 1.0.54 @ 2020.03.24 @ swift-5.2-RELEASE: 443e9a41d1a7c1fcae280490144fcbf8461d3499
      # 1.0.53 @ swift-DEVELOPMENT-SNAPSHOT-2020-01-13-a: 3b9014dc9acae3d95255a83befd85b52e7176acb
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
      return "62809e9e2f918e6c11e47cd6a8d858429c77b743"
      # 1.0.53 @ swift-DEVELOPMENT-SNAPSHOT-2020-01-05-a: 62809e9e2f918e6c11e47cd6a8d858429c77b743
      # 1.0.53 @ swift-DEVELOPMENT-SNAPSHOT-2019-12-27-a: 86eec6148c1e4ef1c56dbd5e53c5cbf6d023f202
      # 1.0.53 @ swift-DEVELOPMENT-SNAPSHOT-2019-11-30-a: 2195121bf063e2db7c71080fcae7e76e8a43950e
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
      return "c2133f2b08047708b17230b598cb789062143650"
      # 1.0.54 @ 2020.03.23 @ swift-5.2-RELEASE: c2133f2b08047708b17230b598cb789062143650
      # 1.0.54 @ swift-5.1.5-RELEASE: 198fa1e3efcce2fd302f7aaa077aec443a82394b
      # 1.0.51 @ swift-DEVELOPMENT-SNAPSHOT-2020-01-03-a: 019936b2100dc33c8946928d424b5cff4211acea
   end

   def self.cmark
      return "bfa95d55b535fa178f75484b5e8f82ae3d8517af"
      # 1.0.54 @ 2019.10.10 @ swift-5.2-RELEASE: bfa95d55b535fa178f75484b5e8f82ae3d8517af
      # 1.0.51 @ swift-DEVELOPMENT-SNAPSHOT-2020-01-03-a: 31e12547c4de3dfcacc69855d93298cb90fd4f27
      # 1.0.50 @ swift-DEVELOPMENT-SNAPSHOT-2019-10-14-a: bfa95d55b535fa178f75484b5e8f82ae3d8517af
      # 1.0.49 @ swift-5.1.1-RELEASE: 32fa49671d0fc5d1f65d2bcbabfb1511a9d65c27
   end

   def self.ssl
      return "894da2fb7ed5d314ee5c2fc9fd2d9b8b74111596"
      # 1.0.53 @ OpenSSL_1_1_1d: 894da2fb7ed5d314ee5c2fc9fd2d9b8b74111596
      # OpenSSL_1_1_1c: 97ace46e11dba4c4c2b7cb67140b6ec152cfaaf4 (1.0.26)
      # OpenSSL_1_1_1b: 50eaac9f3337667259de725451f201e784599687
      # OpenSSL_1_1_1a: d1c28d791a7391a8dc101713cd8646df96491d03
   end

   def self.icu
      return "e2d85306162d3a0691b070b4f0a73e4012433444"
      # 1.0.26 @ v64-2: e2d85306162d3a0691b070b4f0a73e4012433444
      # v64-rc2: 67d218f2476ac543de2ed843fa080892972c604a
   end

   def self.curl
      return "2cfac302fbeec68f1727cba3d1705e16f02220ad"
      # 1.0.53 @ curl-7_68_0: 2cfac302fbeec68f1727cba3d1705e16f02220ad
      # 1.0.26 @ 7_65_1: 69248b58f649e35b09a126c12781353e3471f5c6
   end

   def self.xml
      # v2.9.9: f8a8c1f59db355b46962577e7b74f1a1e8149dc6 (1.0.26)
      return "f8a8c1f59db355b46962577e7b74f1a1e8149dc6"
   end

end
