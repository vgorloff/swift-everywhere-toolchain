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

  // 1.0.66 - a51d2fefc70a41cf765853739c5037c182bdaad9 - tag:swift-5.3.3-RELEASE @ 25. January 2021 at 10:31:21 CET
  // 1.0.62 - 253ea65ba72933c92850803f0c26aa768757b3ab - tag:swift-5.3.1-RELEASE @ 12. November 2020 at 09:17:14 CET
  // 1.0.56 - e7c2f897ad2766b1664b56f3a77d939b844dd135 - tag:swift-5.3-RELEASE @ 11. September 2020 at 03:51:47 CEST
  // 1.0.54 - 443e9a41d1a7c1fcae280490144fcbf8461d3499 - tag:swift-5.2-RELEASE @ 24. March 2020 at 19:15:32 CET
  swift: "a51d2fefc70a41cf765853739c5037c182bdaad9",

  // 1.0.62 - 25ea083a3af4ca09eee2b6dbdf58f1b163f87008 - tag:swift-5.3.1-RELEASE @ 2. September 2020 at 09:28:48 CEST
  // 1.0.56 - 25ea083a3af4ca09eee2b6dbdf58f1b163f87008 - tag:swift-5.3-RELEASE @ 2. September 2020 at 09:28:48 CEST
  // 1.0.54 - c992dacf3ca114806e6ac9ffc9113b19255be9fe - tag:swift-5.2-RELEASE @ 1. October 2019 at 17:57:33 CEST
  dispatch: "25ea083a3af4ca09eee2b6dbdf58f1b163f87008",

  // 1.0.66 - f129bcb67fb961868bf818143fae95a9fab71093 - tag:swift-5.3.3-RELEASE @ 17. January 2021 at 13:47:37 CET
  // 1.0.62 - 1ad3b0ea7d0f711b05b737a3ff8ca47e03b8bdae - tag:swift-5.3.1-RELEASE @ 11. November 2020 at 17:42:12 CET
  // 1.0.56 - dfb10f7f74b73ba5742f3defcbb4d011abe9f2d4 - tag:swift-5.3-RELEASE @ 7. May 2020 at 11:59:46 CEST
  // 1.0.55 - 9a9402ba492bbae1cab2ef2d9f61c9d7c24659f9 - tag:swift-5.2.4-RELEASE @ 16. April 2020 at 20:36:00 CEST
  // 1.0.54 - 8d0871530c52456278ef8c83cb049e6d70b28a6b - tag:swift-5.2-RELEASE @ 18. March 2020 at 08:25:12 CET
  foundation: "f129bcb67fb961868bf818143fae95a9fab71093",

  // 1.0.67 - 439a44695a0534a26557cc34b4fe650dccb46aed - tag:swift-5.4-RELEASE @ 13. April 2021 at 19:37:22 CEST
  // 1.0.62 - 3093af41dd65ad466dcd5603e9289244edfee4f5 - tag:swift-5.3.1-RELEASE @ 21. October 2020 at 01:10:23 CEST
  // 1.0.56 - c39a810ec308dd4a8d93c5011fb73a5c987e8680 - tag:swift-5.3-RELEASE @ 10. September 2020 at 08:07:01 CEST
  llvm: "3093af41dd65ad466dcd5603e9289244edfee4f5",

  // 1.0.62 - 1168665f6b36be747ffe6b7b90bc54cfc17f42b7 - tag:swift-5.3.1-RELEASE @ 27. January 2020 at 22:00:52 CET
  // 1.0.56 - 1168665f6b36be747ffe6b7b90bc54cfc17f42b7 - tag:swift-5.3-RELEASE @ 27. January 2020 at 22:00:52 CET
  // 1.0.54 - bfa95d55b535fa178f75484b5e8f82ae3d8517af - tag:swift-5.2-RELEASE @ 10. October 2019 at 06:08:52 CEST
  cmark: "1168665f6b36be747ffe6b7b90bc54cfc17f42b7",

  // 1.0.53 - 894da2fb7ed5d314ee5c2fc9fd2d9b8b74111596 - tag:OpenSSL_1_1_1d @ 10. September 2019 at 15:13:07 CEST
  ssl: "894da2fb7ed5d314ee5c2fc9fd2d9b8b74111596",

  // 1.0.26 - e2d85306162d3a0691b070b4f0a73e4012433444 - tag:v64-2 @ 17. April 2019 at 17:58:08 CEST
  icu: "e2d85306162d3a0691b070b4f0a73e4012433444",

  // 1.0.67 - 566b74a0e19b9aa610f4931e5bfd339bcf8e9147 - tag:curl-7_76_1 @ 14. April 2021 at 07:56:23 CEST
  // 1.0.53 - 2cfac302fbeec68f1727cba3d1705e16f02220ad - tag:curl-7_68_0 @ 4. January 2020 at 22:48:15 CET
  curl: "566b74a0e19b9aa610f4931e5bfd339bcf8e9147",

  // 1.0.26 - f8a8c1f59db355b46962577e7b74f1a1e8149dc6 - tag:v2.9.9 @ 3. January 2019 at 19:14:17 CET
  xml: "f8a8c1f59db355b46962577e7b74f1a1e8149dc6",

  // 1.0.66 - 06d96d033ffdcbf97b741ed79d62127c4fe419b3 - tag:swift-5.3.3-RELEASE @ 6. January 2021 at 19:38:25 CET
  // 1.0.62 - 2bec212061295719620c7f4cf2d2e257a95aab39 - tag:swift-5.3.1-RELEASE @ 21. September 2020 at 23:23:26 CEST
  // 1.0.56 - 91bdc78dbd4595e69a45654d1e80eb334e1977c4 - tag:swift-5.3-RELEASE @ 10. September 2020 at 19:12:36 CEST
  spm: "06d96d033ffdcbf97b741ed79d62127c4fe419b3",

  // 1.0.62 - ef2e9ba657fd0a4e6e25fff05051b328bf27aeaf - tag:swift-5.3.1-RELEASE @ 10. September 2020 at 18:55:53 CEST
  // 1.0.57 - ef2e9ba657fd0a4e6e25fff05051b328bf27aeaf - tag:swift-5.3-RELEASE @ 10. September 2020 at 18:55:53 CEST
  llb: "ef2e9ba657fd0a4e6e25fff05051b328bf27aeaf",

  // 1.0.57 - 8c3dfd42a36d0416345143eae4567d9314c12246 - branch:origin/release/5.3 @ 16. September 2020 at 21:54:27 CEST
  tsc: "8c3dfd42a36d0416345143eae4567d9314c12246"

};
