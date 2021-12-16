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

// See also: $ToolChain/Sources/swift/utils/update_checkout/update-checkout-config.json

module.exports = {
  // 1.0.77 - 4c45f525dc315a618868caae7d976d95359700a4 - tag:swift-5.5.2-RELEASE
  // 1.0.76 - 11a4d5a4f54cdfb803b3c75e3c4dd5d2dfc1974c - tag:swift-5.5.1-RELEASE
  // 1.0.74 - d2054e1c741f549caffbe1f286a9b11066b5c696 - tag:swift-5.5-RELEASE
  // 1.0.73 - 282fe25d1757ff9974ade028d92111acdae6876a - tag:swift-5.4.3-RELEASE
  swift: "4c45f525dc315a618868caae7d976d95359700a4",

  // 1.0.77 - 5cc1c6679822fd18368664482a5bba57270467f4 - tag:swift-5.5.2-RELEASE
  // 1.0.76 - e7c11bcb69c785c3470c91daf9c5d1b13162e7a6 - tag:swift-5.5.1-RELEASE
  // 1.0.74 - 851fbd3cb89385ba733bc37d6149280996715898 - tag:swift-5.5-RELEASE
  // 1.0.73 - f13ea5dcc055e5d2d7c02e90d8c9907ca9dc72e1 - tag:swift-5.4.3-RELEASE
  dispatch: "5cc1c6679822fd18368664482a5bba57270467f4",

  // 1.0.77 - 491a217baa8a0ef4ae9c8603c434c069cc090c50 - tag:swift-5.5.2-RELEASE
  // 1.0.74 - 5663ff1147d8f162f1cb44bfdb3e8c42addb7b69 - tag:swift-5.5-RELEASE
  // 1.0.73 - dee1e194a44e660c205960adb470ea0981f78b49 - tag:swift-5.4.3-RELEASE
  foundation: "491a217baa8a0ef4ae9c8603c434c069cc090c50",

  // 1.0.77 - c315411fac10439aa7a09dce976b5716af9f149c - tag:swift-5.5.2-RELEASE
  // 1.0.76 - 47e0531f53ce4508b522a28d407ac39b639781f4 - tag:swift-5.5.1-RELEASE
  // 1.0.74 - fbf00809f11885f819457563beb069a2298b368f - tag:swift-5.5-RELEASE
  // 1.0.73 - 8ee67e3af469eb38c9616f971abd5a47fe8d6405 - tag:swift-5.4.3-RELEASE
  llvm: "c315411fac10439aa7a09dce976b5716af9f149c",

  // 1.0.77 - 9c8096a23f44794bde297452d87c455fc4f76d42 - tag:swift-5.5.2-RELEASE
  // 1.0.74 - 9c8096a23f44794bde297452d87c455fc4f76d42 - tag:swift-5.5-RELEASE
  // 1.0.73 - 9c8096a23f44794bde297452d87c455fc4f76d42 - tag:swift-5.4.3-RELEASE
  cmark: "9c8096a23f44794bde297452d87c455fc4f76d42",

  // 1.0.77 - 7a1f113534689c77b3a4110288478580b7b8d91c - tag:swift-5.5.2-RELEASE
  // 1.0.74 - 519aa4a70db7d49e894ed83ea61d2a4d24c098f0 - tag:swift-5.5-RELEASE
  // 1.0.73 - 374cdb42d7b146837de70489a04c5df956092685 - tag:swift-5.4.3-RELEASE
  spm: "7a1f113534689c77b3a4110288478580b7b8d91c",

  // 1.0.77 - 83c4bcb8dfca48cc065325287b55d08ff7b26428 - tag:swift-5.5.2-RELEASE
  // 1.0.74 - b5d9b4a9995c05688ae5f3b87a0d7ac0dc45c6c6 - tag:swift-5.5-RELEASE
  // 1.0.73 - eb56a00ed9dfd62c2ce4ec86183ff0bc0afda997 - tag:swift-5.4.3-RELEASE
  llb: "83c4bcb8dfca48cc065325287b55d08ff7b26428",

  // 1.0.77 - 3b586ce12865db205081acdcea79fe5509b28152 - tag:swift-5.5.2-RELEASE
  // 1.0.74 - 1b21e2ce36891ed4f458421a83b5d9e886acd4cd - tag:swift-5.5-RELEASE
  // 1.0.73 - d7bd4375c26e7dab2c17791cfa06f9b981d02339 - tag:swift-5.4.3-RELEASE
  tsc: "3b586ce12865db205081acdcea79fe5509b28152",

  // 1.0.77 - 86c54dacd270e0c43374c0cb9b2ceb2924c9ea72 - tag:swift-5.5.2-RELEASE
  // 1.0.74 - 12cd468c8182b4e1038268c664354005803fcdef - tag:swift-5.5-RELEASE
  // 1.0.73 - 93e8b927225a62b963ebe13ab11e04192fa8a67b - tag:swift-5.4.3-RELEASE
  sd: "86c54dacd270e0c43374c0cb9b2ceb2924c9ea72",

  // 1.0.71 - 986d191f94cec88f6350056da59c2e59e83d1229 - tag:0.4.3
  // 1.0.70 - 986d191f94cec88f6350056da59c2e59e83d1229 - tag:0.4.3
  // 1.0.69 - 831ed5e860a70e745bc1337830af4786b2576881 - tag:0.4.1
  sap: "986d191f94cec88f6350056da59c2e59e83d1229",

  // 1.0.71 - 9ff1cc9327586db4e0c8f46f064b6a82ec1566fa - tag:4.0.6
  // 1.0.70 - 9ff1cc9327586db4e0c8f46f064b6a82ec1566fa - tag:4.0.6
  // 1.0.69 - 81a65c4069c28011ee432f2858ba0de49b086677 - tag:3.0.1
  yams: "9ff1cc9327586db4e0c8f46f064b6a82ec1566fa",

  // 1.0.74 - 0141f53dd525706c803b0c20aa8ad36f9ecd45e5 - tag:1.1.5
  sc: "0141f53dd525706c803b0c20aa8ad36f9ecd45e5",

  // 1.0.53 - 894da2fb7ed5d314ee5c2fc9fd2d9b8b74111596 - tag:OpenSSL_1_1_1d @ 10. September 2019 at 15:13:07 CEST
  ssl: "894da2fb7ed5d314ee5c2fc9fd2d9b8b74111596",

  // 1.0.26 - e2d85306162d3a0691b070b4f0a73e4012433444 - tag:v64-2 @ 17. April 2019 at 17:58:08 CEST
  icu: "e2d85306162d3a0691b070b4f0a73e4012433444",

  // 1.0.67 - 566b74a0e19b9aa610f4931e5bfd339bcf8e9147 - tag:curl-7_76_1 @ 14. April 2021 at 07:56:23 CEST
  // 1.0.53 - 2cfac302fbeec68f1727cba3d1705e16f02220ad - tag:curl-7_68_0 @ 4. January 2020 at 22:48:15 CET
  curl: "566b74a0e19b9aa610f4931e5bfd339bcf8e9147",

  // 1.0.26 - f8a8c1f59db355b46962577e7b74f1a1e8149dc6 - tag:v2.9.9 @ 3. January 2019 at 19:14:17 CET
  xml: "f8a8c1f59db355b46962577e7b74f1a1e8149dc6",
};
