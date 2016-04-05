---
layout: post
title: "人工智能，奇点及其他(二)"
date: 2016-03-20 16:01:14 +0800
comments: true
categories: 

- writing
- AI
- cs

---

[上一篇](http://lenciel.com/2016/03/alphago-and-ai/)留下了几个问题：

* 人工智能和人类智慧究竟有没有一点点可比性？
* 如果有，究竟发展到什么阶段了呢？
* 既然发展到这里了，奇点到底存不存在？人类要不要完呢？

人类有这些疑问是自然而然的，特别是人工智能目前由“认知派”扛大旗：既然是模拟大脑的工作原理，难免就要被拿来和大脑本身的机能做比较。

本座谨慎地尝试一下从窘迫了几十年的“认知派”们为了科研经费发明的各种古里古怪的名词里面（比如因为AlphaGo蹿红的“深度学习”，就是辛顿在多年的神经网络研究受冷遇好不容易化到缘之后搞出来的新瓶装旧酒的词）脱身，站在更高层面上来回答一下这些问题。


### 人工智能和人类智慧

目前显然是没有什么可比性的。

不说直觉，情感等等，就拿学习能力来说，李世乭在几盘对弈里面各种充满策略的尝试，还没有机器能完成：人类如何通过极少的样本迅速地提升对本来未知领域的学习能力，还是个谜。

那为什么很多比我们靠近前沿的专家对如此羸弱的人工智能忧心忡忡呢？

这很大程度上是基于人类科技发展速度的一个推断。

比如这两天刘诗诗和吴奇隆结婚画面太感人，本座看到微信评论里面有一条“想穿越回清朝去见见四阿哥”被顶了几千次。

不知道迷恋这类穿越戏码的人有没有想过一个问题：如果把社会把他/她作为神接受的程度叫做”装神认可度”，在时间轴上不同年代的人，要达到类似神的地位，需要往前穿越多少年？

比如从现代穿回清代，召集当时社会最聪明的100个人，要用什么来证明自己是神呢？可控核聚变、相对论还是引力波？是不是手机就够了？要不飞机地铁？或者国家电网？

在人类生活的方方面面，可以说出各种东西把当时最聪明的人骇到瞠目结舌。

那么如果是一个清代的人要刷到相同的装神认可度，需要往前穿越多久呢？

如果穿的时间距离差不多，到元明这些时候，那么还是在封建社会，可能并没有办法当神。但如果来到刀耕火种的农业社会，比如夏商周，只需要表演一次九九乘法表，可能性就会大大增加。

那么如果是一个商朝的人要获得相同的装神接受度，需要往前穿越多久呢？

大概穿越到石器时代都不太够，可能得往公元前几十万年还不会好好保存火的年代去了。

这种装神接受度的剧烈变化，说明了两个问题：

1. 人类的进化过程是非常缓慢的
2. 人类科技发展是具有加速度的

上篇提到过的明斯基的高徒，也是奇点理论的宣传者[库兹韦尔](https://zh.wikipedia.org/wiki/%E9%9B%B7%E8%92%99%E5%BE%B7%C2%B7%E5%BA%93%E8%8C%A8%E9%AD%8F%E5%B0%94)的预测是：人类在2000到2020年20年间的科技发展成就，要相当于前面2000年的总和。

也正是在“科技在以很大的加速度发展，人类自己的进化却非常缓慢”这样所有人都容易认可的理论支撑下，人工智能的威胁才被很多主流科学家拿出来讨论：他们觉得作为提供加速度的一方，还是有必要提醒一下缓慢的一方。

比如斯蒂芬·霍金就说过：

{% blockquote %}
一旦发展出相当于或者超越人类智慧的人工智能技术，它（人工智能）就会脱离控制，以不断加快的速度重新设计自己。但是人类受到缓慢生物进化的限制，无法与其竞争，甚至可能最终被超越。
{% endblockquote %}

那么，这种虽然现在还很蠢，但进化得超快的东西，究竟要多久超越我们呢？

### 人工智能的发展阶段

和那些科幻片里面自以为是最后遭遇灭顶之灾的人类一样，我们早就给“人工智能”的发展划分了严格的阶段：

* Artificial Narrow Intelligence (ANI)
* Artificial General Intelligence (AGI)
* Artificial Superintelligence (ASI)


#### ANI

指能够有效处理的问题域有局限的AI，在很多文章里面也被称为`Weak AI`：除开下围棋下赢李世乭，其实我们每天的生活里面也充满了ANI：

* 你的手机里面有siri这样的个人助手，有网易云音乐这种可以给你推荐你喜爱风格歌曲的音乐程序等等ANI系统
* 当你在京东上搜了情趣内衣，你上其他网站的时候老是有情趣小窗弹出来：广告系统里面也到处都是ANI
* Google的在线翻译，微信的语音识别，Soundcloud的你哼它猜，凡此种种都是ANI
* 但你其实连不上Google，因为GFW也是用ANI在[识别加密流量](http://arxiv.org/abs/1603.04865)啊
* 你觉得烦，扔掉电脑和手机，开车出门：车里面的ANI系统更多了，什么ABS，什么智能省油，而且，车都快不需要你开了你也知道吧

如果我们仅仅处于ANI里面，好像也无伤大雅。甚至可能有些开心：因为机器做了枯燥的事情，我们则去处理需要创意的部分。

 Vernor Vinge, 1993[里面](https://www-rohan.sdsu.edu/faculty/vinge/misc/singularity.html)说过：
 
{% blockquote %}
We are on the edge of change comparable to the rise of human life on Earth.
{% endblockquote %}

这个变化，就是从ANI到AGI的变化。

#### AGI

AGI，在AlphaGo的总结里面也[提到了](https://googleblog.blogspot.hk/2016/03/what-we-learned-in-seoul-with-alphago.html)，很多文章里面也被称为`Strong AI`，Linda Gottfredson对它有个比较正式的定义：

{% blockquote %}
A very general mental capability that, among other things, involves the ability to reason, plan, solve problems, think abstractly, comprehend complex ideas, learn quickly, and learn from experience.
{% endblockquote %}

从ANI到AGI，难点在哪里？为什么计算，策略，语言翻译等等，对电脑来说越来越容易；视觉，感觉，运动，和预测，对电脑来说仍然很难？

Knuth老爹的评价最好懂：

{% blockquote %}
AI has by now succeeded in doing essentially everything that requires ‘thinking’ but has failed to do most of what people and animals do ‘without thinking.'
{% endblockquote %}

的确，我们对自己的大脑是如何工作的本来就不清楚。当我们伸手去撩妹的时候，这么个看起来不需要“过脑”的动作，其实是需要肌肉，神经，骨骼由大脑统一指挥，由几百万年进化形成的复杂系统配合完成的。对于计算机来说，如果看不准，或者力道控制不好，可能撩出骨髓穿刺等各种令人遗憾的效果。

即像“看准”，“捏稳”等等范畴的问题解决了，那也只是“认识世界”，要达到人类的智力水平，更难的事情摆在后面：感受世界。

高兴、满意、解脱和苟且要如何区别？眉来眼去之后要不要跟一个欲说还休？《霸王别姬》比《霸王硬上弓》好在哪里？

#### 从ANI到AGI

看起来如此遥不可及的目标，靠人类科技的大爆发怎么到达？

##### 计算能力爆炸

科学家认为人类大脑的计算能力是每秒10的16次方这个量级的。

确实很变态，但其实已经有一台计算机已经超越了这个数字：那就是中国国防科大研制的[天河二](https://www.zhihu.com/question/21217971)。

当然，造价一亿美金，占地720平方米，24兆瓦功耗（满配跑一年电费1.5亿人民币）不是一个很容易接受的超越方式对不对？

但不要忘了摩尔定律：假设计算能力会以每十年便宜100倍的速度降价，所以高高在上的模拟人脑需要的计算能力，很快就不是问题了。

#### 更巧妙的解










AI Caliber 2) Artificial General Intelligence (AGI): Sometimes referred to as Strong AI, or Human-Level AI, Artificial General Intelligence refers to a computer that is as smart as a human across the board—a machine that can perform any intellectual task that a human being can. Creating AGI is a much harder task than creating ANI, and we’re yet to do it. Professor Linda Gottfredson describes intelligence as “a very general mental capability that, among other things, involves the ability to reason, plan, solve problems, think abstractly, comprehend complex ideas, learn quickly, and learn from experience.” AGI would be able to do all of those things as easily as you can.

AI Caliber 3) Artificial Superintelligence (ASI): Oxford philosopher and leading AI thinker Nick Bostrom defines superintelligence as “an intellect that is much smarter than the best human brains in practically every field, including scientific creativity, general wisdom and social skills.” Artificial Superintelligence ranges from a computer that’s just a little smarter than a human to one that’s trillions of times smarter—across the board. ASI is the reason the topic of AI is such a spicy meatball and why the words “immortality” and “extinction” will both appear in these posts multiple times.

#### 目前的阶段：世界已经被ANI

在特定的问题域，机器已经远远超过了人类，因此我们日常生活中遍布着ANI：



### 奇点

Secondly, you’ve probably heard the term “singularity” or “technological singularity.” This term has been used in math to describe an asymptote-like situation where normal rules no longer apply. It’s been used in physics to describe a phenomenon like an infinitely small, dense black hole or the point we were all squished into right before the Big Bang. Again, situations where the usual rules don’t apply. In 1993, Vernor Vinge wrote a famous essay in which he applied the term to the moment in the future when our technology’s intelligence exceeds our own—a moment for him when life as we know it will be forever changed and normal rules will no longer apply. Ray Kurzweil then muddled things a bit by defining the singularity as the time when the Law of Accelerating Returns has reached such an extreme pace that technological progress is happening at a seemingly-infinite pace, and after which we’ll be living in a whole new world. I found that many of today’s AI thinkers have stopped using the term, and it’s confusing anyway, so I won’t use it much here (even though we’ll be focusing on that idea throughout).

站在历史的进程里面，如果是大牛的视线是这样的：

而≤


