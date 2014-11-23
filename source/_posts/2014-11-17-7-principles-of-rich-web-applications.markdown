---
layout: post
title: "Web应用开发的七项原则"
date: 2014-11-17 22:30:42 +0800
comments: true
categories:
---

这篇文章主要介绍构建使用Javascript来控制UI的网站在设计时的7个原则。它们是我作为一名开发人员的经验所得，也是我作为一名互联网资深用户的体会和总结。

Javascript毫无疑问早已成为了前端开发人员不可或缺的工具。但现在它的使用范围还在不断扩展到其他的领域，比如[服务器端][3]甚至是[微控制器][4]。在斯坦福这样的声望卓越的大学里面，它也已经被选为计算机科学[入门课程][5]的教学语言。 

   [3]: http://nodejs.org/
   [4]: https://tessel.io/
   [5]: http://web.stanford.edu/class/cs101/

即便如此，它在web开发中究竟应该扮演什么样的角色或者说负责哪方面的作用，仍然是个迷：即便对于很多框架和类库的作者而言也是如此：

  * JavaScript应该被用来替代像`history`，`navigation`和`page rendering` 这样的浏览器函数么？
  * 后端是不是到头了？是不是根本就不该在后端渲染HTML了？
  * Single Page Applications (SPAs) 是不是代表着未来的趋势?
  * JS是否应该用来 _增强_ 页面在网站的渲染效果，但 _渲染_ 页面还是应该在web应用里面做?
  * 是否应该使用像PJAX或者TurboLinks这样的技术?
  * 一个网站和一个web应用之间的区别精确的描述起来究竟是什么? 是不是应该就是一个东西?

下面就是我试着回答这些问题做的一些分析。我分析的方式是通过用户体验(UX)，特别是如何最小化用户拿到他们感兴趣的 _数据_ 的时间，作为分析的切入点，来验证对Javascript的 _各种_ 使用方式。我会从网络通信的基础入手，一直说到对未来趋势的预测。

  1. [Server渲染页面仍然是必须的](#server-rendered-pages-are-not-optional)
  2. [对用户输入立刻响应](#react-to-data-changes)
  3. [数据变更时的应对](#act-immediately-on-user-input)
  4. [控制与服务器的数据交互](#control-the-data-exchange-with-the-server)
  5. [不要搞乱history，增强它](#dont-break-history-enhance-it)
  6. [Push更新](#push-code-updates)
  7. [行为预测](#predict-behavior)

## 1. Server渲染页面仍然是必须的<a name="server-rendered-pages-are-not-optional"></a>

**TL;DR**: _服务器端渲染与SEO无关，它主要的考虑是性能：需要考虑的包括不在服务器渲染的话，请求脚本、页面样式、页面资源和API请求造成的额外的开销，以及考虑在HTTP2.0里加入的`PUSH of resources`_.

首先需要指出，在业界有一种错误的二分法："server-rendered apps" 和 "single-page apps"的对立。如果我们的目标是用户体验和性能的最优化，那么选择其中任何一个而抛弃另一个都是错误的决定。原因其实很明显：整个互联网用于传输页面的介质，有一个理论上可计算的速度局限。关于这点，Stuart Cheshire有个著名的文献 (或者说是吐槽？)，[“It’s the latency, stupid”][14] :

   [14]: http://rescomp.stanford.edu/~cheshire/rants/Latency.html

{% blockquote %}
The distance from Stanford to Boston is 4320km.
The speed of light in vacuum is 300 x 10^6 m/s.
The speed of light in fibre is roughly 66% of the speed of light in vacuum.
The speed of light in fibre is 300 x 10^6 m/s * 0.66 = 200 x 10^6 m/s.
The one-way delay to Boston is 4320 km / 200 x 10^6 m/s = 21.6ms.
The round-trip time to Boston and back is 43.2ms.
The current ping time from Stanford to Boston over today’s Internet is about 85ms (…)
So: the hardware of the Internet can currently achieve within a factor of two of the speed of light.
{% endblockquote %}

这里提到的从波士顿到斯坦福路上花费的85ms，当然会随着时间的推移不断的改善：如果你现在测试一下说不定已经大大增速了。但需要注意很重要的一点：理论上两个海岸间最少也需要 **50ms** 才能完成通信。

换句话说，用户间连接的带宽再怎么显著提高，花在传输路上的延迟总有无法突破的极限。所以，在页面上显示信息时减少请求次数，也就是减少信息被传输在路上的次数，对于良好的用户体验和出色的响应速度而言，至关重要。

这一点在Javascript驱动的Web应用流行起来之后显得尤为明显。这些应用一般`<body>`标签内什么东西都没有，只有`<script>`和`<link>`标签，被称为"Single Page Applications"或者"SPA"。就像它的名字所暗示的一样，服务器返回时一直在重用同一个页面，其他的页面内容都是在客户端被处理和渲染的。

考虑下面的这个场景：用户在浏览器上访问`http://app.com/orders/`，如果这是一个传统的网页，那么在后台处理这个请求的时，就会带回重要的 _信息_ ，用来完成页面的显示：比如，从数据库里面查询出订单，然后把它们的数据放在请求的返回里面。但如果这是一个SPA，那么第一次可能会立刻返回一个包含`<script>`标签的空页面，然后再跑一趟才能拿回用来渲染页面的内容和数据。


![SPA code breakdown](/downloads/images/2014_11/spa_code_breakdown.png "SPA code breakdown")
图1. 服务器端发送的SPA的每个页面组成结构分析

目前大多数的开发者都大方接受了这个额外的 _网络传输过程_ 是因为他们确信这只发生一次：后面反正是有cache的。也就是说，大家形成了这么一个共识，既然整个代码包一旦加载一次，就可以不用再请求其他的脚本和资源就完成对绝大多数的用户交互（包括跳转到应用的其他页面）的处理，那么这个开销就是可以接受的。

但实际上，虽然有cache，脚本解析和执行的时间仍然会带来性能上的下降。[“Is jQuery Too Big For Mobile?”][16] 这篇文章就探讨了即便是加载一个jQuery库，就会花去一些浏览器数百毫秒的时间。

   [16]: http://modernweb.com/2014/03/10/is-jquery-too-big-for-mobile/

更糟糕的是，和以前网速慢那种图片慢慢加载的效果不同，如果是脚本正在加载，用户什么都看不到：在整个页面被渲染出来之前，只能显示空白的页面。

最重要的是，目前互联网数据传输主要的协议TCP _建立_ 比较慢。

首先，我们知道，一个TCP连接先需要握手。如果处于安全考虑使用了SSL，就还需要额外的两个来回（客户端重用了session的话，也需要一个额外的来回）。这些流程完毕之后，服务器才能开始往客户端发送数据。换句话说，再小的代码包实际上也需要几个来回才能完成传输，这就让前面描述的问题变得更加糟糕。

其次，TCP协议里面有一个流控机制，被称为 `slow start`，也就是在连接建立过程中逐渐增加传输的分段(`segments`)大小，入下图所示：

![TCP segments chart](/downloads/images/2014_11/tcp_segments_chart.png "TCP segments chart")
图1. 服务器端在TCP连接的不同阶段能够发送的分段大小(KB)

这对SPA有两个很大的影响：

  1. 文件比较大的脚本，花在下载上的时间比你想象中的要长得多。Google的Ilya Grigorik在他的专著[“High Performance Browser Networking”][17] 里面说过，“4个来回(…)和数百毫秒的延迟都花在从服务器下载64KB的文件到客户端上了”，从前面的图也可以看到，基本是比较高速的网络连接，比如伦敦和纽约之间，一个TCP连接要达到最大速度，也需要花上大概225ms。

   [17]: http://chimera.labs.oreilly.com/books/1230000000545/ch02.html#thats_four_rou

  2. 因为前面说的延迟对首个页面访问也是有效的，所以你让什么数据最先被传输就显得非常重要了。Paul Irish在他的演讲[“Delivering the Goods”][18]给出的结论是，一个Web应用最开始的 **14kb** 数据是最重要的。

   [18]: https://docs.google.com/presentation/d/1MtDBNTH1g7CZzhwlJ1raEJagA8qM3uoV7ta6i66bO2M/present#slide=id.g3eb97ca8f_10


在足够短的时间窗内完成内容传输（哪怕只是呈现基本的没有数据的layout）的网站，就是响应良好的。这也是为什么对于很多习惯了在服务器端处理数据的软件开发者觉得Javascript很多时候根本没必要用，或者是在很有限的情况下用用就行了。当这些开发者使用的是配置良好的服务器和数据库，又有CDN来做部署和分发时，他们这种感觉会非常明显。

但是，服务器在辅助和加速页面内容的分发和渲染中应该被怎么使用，也是需要根据每个应用场景仔细分析的，绝对不是“把整个页面交给服务器渲染吧”那么简单的事情。在一些情况下，如果页面上的内容对用户并不是非看不可的，就可以不放在第一个响应中返回，而是让客户端在后面的操作中到服务器去取。

比如，有的应用会先把一个"壳"页面返回给客户端，然后在这个页面上并发的请求多个部分的数据。这样即使在后台连接速度较慢的情况下，仍然能够有较好的响应速度。还有的应用会把 “[浏览器里面的第一个整屏][20]” 显示的页面做预渲染。

   [20]: http://www.feedthebot.com/pagespeed/prioritize-visible-content.html

服务器能够根据当前处理的`session`，用户和URL对脚本和样式文件进行分类也是很重要的。举例来说，用来对订单进行分类的脚本，对于`/orders`这个URL显然是重要的，而处理"首选项"的逻辑的脚本就不那么重要。再比如说，我们可以对CSS样式表进行分类，比如区分“结构性的样式”和“皮肤和模板的样式”等。前面这类很可能对Javascript的正确运行是必须的，因此需要 _阻塞_ 的方式加载， 后面这类则可以用异步的方式加载。

到目前为止，在服务器端处理一部分或者所有的页面，仍然是避免过多客户端与服务器的交互的主要手段。[StackOverflow in 4096 bytes][21]很不错地展示了如何降低和服务器的来回交互次数。作为概念验证的SPA，它理论上可以做到在握手后的第一个TCP连接中完成加载！当然，要做到这些，它使用了[SPDY 或者 HTTP/2 server push][22]，因此可以在一个hop里面传输所有客户端可以缓存的代码。

   [21]: http://danlec.com/blog/stackoverflow-in-4096-bytes
   [22]: http://www.chromium.org/spdy/link-headers-and-server-hint

![StackOverflow clone in 4096 bytes](/downloads/images/2014_11/st4k.png "StackOverflow clone in 4096 bytes")
图3. 使用了内链CSS和JS技术的`Stackoverflow in 4096 bytes`

   [23]: https://cldup.com/NeV5qFDaVR.png (StackOverflow clone in 4096 bytes)

如果我们有一个足够灵活的系统，可以在浏览器和服务器直接共享渲染页面的代码（比如双方都是js），并且提供工具增量的加载脚本和样式，那么 _网站_ 和 _Web应用_ 就可以合一而不再是两个模棱两可难以区分的词了：它们本身就有一样的UX要素。比如一个博客页面和一个复杂的CRM，都有URL，都需要跳转，都展示数据，本质上并没有太大不同。即便是像数据表格这样复杂的东西，传统上主要是客户端提供的功能来完成对数据的处理，但也首先需要给用户展示那些需要他处理的数据 。降低客户端和服务器交互的次数，对实现我们说的这样的系统非常重要。

在我看来，我们看到的大量系统上采用了这样那样性能上的权宜之策，是因为整个技术栈的复杂度在不断累加。Javascript和CSS这样的技术是被逐渐加入到系统的，它们的风靡又花了一段时间。尽管有人希望在协议上做出改进，来增强性能（比如SPDY或者QUIC），但应用层显然才是最需要改进的地方。

要理解速度的重要性，去重温一下WWW和HTML创立之初的一些讨论是非常有用的。特别是在1997年提议在HTML里加入`img`这个标签的时候，Marc Andreessen在[下面这个邮件thread][24]里反复强调了提供信息的速度有多么重要： 

   [24]: http://1997.webhistory.org/www.lists/www-talk.1993q1/0260.html


{% blockquote %}
“If a document has to be pieced together on the fly, it could get arbitrarily complex, and even if that were limited, we’d certainly start experiencing major hits on performance for documents structured in this way. This essentially throws the **single-hop principle of WWW** out the door (well, IMG does that too, but for a very specific reason and in a very limited sense) — are we sure we want to do that?”
{% endblockquote %}

## 2. 对用户输入立刻响应<a name="act-immediately-on-user-input"></a>

**TL;DR**: _我们可以使用JavaScript来掩盖网络的延迟，把它作为设计原则，就可以在你自己的应用里面去掉绝大多数的`spinner`或者`loading`。使用PJAX和TurboLink的话，你就会失去了这些改善用户速度体验的机会。_.

TBA
