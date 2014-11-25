---
layout: post
title: "Web应用开发的七项原则"
date: 2014-11-17 22:30:42 +0800
comments: true
categories:
- tips
- architecture
---

这篇文章主要介绍构建使用Javascript来控制UI的网站在设计时的7个原则。它们是我作为一名开发人员的经验所得，也是我作为一名互联网资深用户的体会和总结。

Javascript毫无疑问早已成为了前端开发人员不可或缺的工具。但现在它的使用范围还在不断扩展到其他的领域，比如[服务器端][3]甚至是[微控制器][4]。在斯坦福这样的声望卓越的大学里面，它也已经被选为计算机科学[入门课程][5]的教学语言。 

   [3]: http://nodejs.org/
   [4]: https://tessel.io/
   [5]: http://web.stanford.edu/class/cs101/

即便如此，它在web开发中究竟应该扮演什么样的角色或者说负责哪方面的作用，仍然是个迷：即便对于很多框架和类库的作者而言也是如此：

  * JavaScript应该被用来替代像`history`，`navigation`和`page rendering` 这样的浏览器函数么？
  * 服务器端开发是不是到头了？是不是根本就不该在服务器端渲染HTML了？
  * Single Page Applications (SPAs) 是不是代表着未来的趋势?
  * 一个网站和一个Web应用之间的区别精确的描述起来究竟是什么? 是不是应该就是一个东西?
  * 在网站上，JS应该用来 _增强_ 页面的效果，而在Web应用中，则被用来 _渲染_ 整个页面?
  * 是否应该使用像PJAX或者TurboLinks这样的技术?

下面就是我试着回答这些问题做的一些分析。我的分析是通过用户体验(UX)层面，特别是如何最小化用户拿到他们感兴趣的 _数据_ 的时间，作为切入点，来验证对Javascript的 _各种_ 使用方式。我会从网络通信的基础入手，一直说到对未来趋势的预测。

  1. [Server渲染页面仍然是必须的](#server-rendered-pages-are-not-optional)
  2. [对用户输入立刻响应](#act-immediately-on-user-input)
  3. [数据变更时的应对](#react-to-data-changes)
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

这里提到的从波士顿到斯坦福路上花费的85ms，当然会随着时间的推移不断的改善：如果你现在测试一下说不定已经大大增速了。但需要注意很重要的一点：就算达到了光速，这两个海岸间最少也需要 **50ms** 才能完成通信。

换句话说，用户间连接的带宽再怎么显著提高，花在传输路上的延迟总有无法突破的速度极限。所以，在页面上显示信息时减少请求次数，也就是减少信息被传输在路上的次数，对于良好的用户体验和出色的响应速度而言，至关重要。

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

第一个原则里，在描述为什么要尽量减少前端和后端之间数据来回传输的次数时，主要是基于传输速度有理论上限的事实。实际上另一个需要考虑的要素就是网络的质量。我们都知道，当网络连接状况不好时，就会有数据包需要被重传。所以，你觉得应该一个来回就传输完毕的数据，可能实际上要花去好几个。

在这方面，Javascript正好可以帮上忙：通过客户端的代码来驱动UI，人工的构造出零延迟，就可以_掩盖网络的延迟_，制造一切操作都很顺畅的假象。比如，网页和网页之间是通过超链接，`<a>`标签，链接在一起的。传统网页上，当一个链接被点击时，浏览器就发送一个可能会耗时很久的请求，然后处理请求并把内容呈现给用户。

但Javascript允许你**立刻响应**（有些地方把这个叫**乐观响应**）：当一个链接或者按钮被点击时，页面立刻做出响应而不需要去访问网络。这方面著名的例子就是Gmail（包括最近Google的新产品Inbox）的"邮件归档"功能。当你点击"归档"，UI上邮件立刻会被显示为归档状态，而服务器的请求和处理是异步进行的。

再比如，我们处理的是一个表单。也许你觉得一个表单在数据被提交到服务器，处理结果返回之前，不能做太多的事情。但其实当用户完成输入并点击提交的时候，我们就可以开始响应了。甚至有些做到极致的应用，比如Google搜索页面，当用户开始输入的时候，展示搜索结果的页面就已经开始渲染了。

![Google Homepage](/downloads/images/2014_11/google_homepage.gif "Google Homepage")
图4. Google在用户输入搜素关键字时就开始渲染搜索结果页面

这种行为被称为 _layout adaptation_。 它的思路是当前页面知道操作后状态的页面layout，所以在没有数据填充的情况下，它就可以过渡到下面那个状态的layout。这样的处理是"乐观"的，是因为有可能后面那个页面的数据一直没有返回，而这时候页面的layout已经画在那里了。

Google的主页的演进，非常清楚的说明了我们这里强调的第一和第二个原则。

首先，分析访问`www.google.com`时TCP连接的[包数据][27]可以看到整个首页的数据都被一次性发出来了。整个交互，包括关闭连接，耗时几十毫秒而已。而且，似乎在Google[一开始的版本][28]就做到了这点。

   [27]: https://gist.github.com/guille/3e1b2d7529009370b986
   [28]: http://en.wikipedia.org/wiki/Google#mediaviewer/File:Google1998.png

在2004年晚些时候, Google[标杆性地][29]使用了JavaScript完成`输入时动态提示`功能（和Gmail一样，也是一个20%创新时间产出的项目），这一功能也启发了很多网站开始大量的使用[AJAX][30]:

   [29]: http://googleblog.blogspot.com/2004/12/ive-got-suggestion.html
   [30]: http://www.adaptivepath.com/ideas/ajax-new-approach-web-applications/

{% blockquote %}
Take a look at Google Suggest. Watch the way the suggested terms update as you type, almost instantly with no waiting for pages to reload. Google Suggest and Google Maps are two examples of a new approach to web applications that we at Adaptive Path have been calling Ajax
{% endblockquote %}

到了2010年，Google又[推出了][32]_及时搜索_，也就是我们前面看到的效果：当用户输入关键字时，整个页面无需刷新就可以展示搜索的结果。

   [32]: http://googleblog.blogspot.com/2010/09/search-now-faster-than-speed-of-type.html

另一个例子是iOS。在很早期的版本，iPhone就要求开发者提供一个`default.png`图片，用来在应用被加载完成之前显示给用户:

![iPhone default](/downloads/images/2014_11/iphone_default_png.png "iPhone default")

图5. iPhone OS强制在应用加载前显示一个default.png

当然，这里OS不是在隐藏网络延迟，而是CPU处理延迟。对于iPhone初期版本来说，这样来弥补硬件的弱点非常重要。当然就和网页上使用提前加载一样，这种手法有可能会崩坏：当加载来的数据和`default.png`不匹配的时候。Marco Arment在2010年对它可能带来的影响进行了 [透彻的分析][34]。

   [34]: http://www.marco.org/2010/11/11/my-default-png-dilemma

除开处理表单和输入，Javascript还被大量用于处理**文件上传**。我们可以通过各种前端表现来满足用户上传文件的需求：拖拽，粘贴以及各种file picker。特别是有了[HTML5的新API][36]之后，我们可以在文件完成传输前就显示它的信息。在Cloudup网站的上传文件中，就使用了类似的实现。从图片中可以看到，在用户选择了文件之后，缩略图就立刻生成并显示在用户界面上了：

   [36]: https://developer.mozilla.org/en-US/docs/Using_files_from_web_applications

![Cloudup upload](/downloads/images/2014_11/cldup_upload.gif "Cloudup upload")
图6. 在上传完成前图片就被显示出来并且加入了虚化效果

上面的方式都是采用前端技术来制造_速度的假象_，但这种方式其实在很多地方都被证明是有效的。[一个例子][38]是在美国休斯顿机场，通过_增加_到达乘客走到行李提取处的距离，而不是实际上的行李处理速度，就大大的_减少_了旅客抱怨行李领取太慢的问题。

   [38]: http://www.nytimes.com/2012/08/19/opinion/sunday/why-waiting-in-line-is-torture.html

运用了这种设计原则的应用，使用`spinners`或者`loading`提示符来提醒用户页面正在刷新的场景会非常少出现。整个页面的动线，都应该被_实际数据_来驱动。

当然，立即响应这个原则也不能被滥用。在特定的用户交互场景下，立即响应是有害的：比如用户在注销或者是支付的流程中，我们当然不能让他"乐观"的认为没有真正完成的操作已经完成了。但即使在这些场景下，使用`spinners`或者`loading`提示符也不应该**被提倡**。 只有在你觉得应该提醒用户这个操作会非常长，你可以去干别的事情时，才应该显示它们。那是多长？在UX设计中经常被引用的[Nielsen的研究报告][39]上是这么说的：

   [39]: http://www.nngroup.com/articles/response-times-3-important-limits/

{% blockquote %}
The basic advice regarding response times has been about the same for thirty years Miller 1968; Card et al. 1991:
0.1 second is about the limit for having the user feel that the system is reacting instantaneously, meaning that no special feedback is necessary except to display the result.
1.0 second is about the limit for the user’s flow of thought to stay uninterrupted, even though the user will notice the delay.Normally, no special feedback is necessary during delays of more than 0.1 but less than 1.0 second, but the user does lose the feeling of operating directly on the data.
10 seconds is about the limit for keeping the user’s attention focused on the dialogue. For longer delays, users will want to perform other tasks while waiting for the computer to finish.
{% endblockquote %}

像PJAX或者TurboLinks这样的技术，则很大程度上完全不具备提前渲染状态迁移后下一个页面的基础layout的能力。只有当服务器端的返回传输到客户端，客户端才能开始响应。
