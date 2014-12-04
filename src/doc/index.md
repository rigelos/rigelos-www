% Rust文档

欢迎来到Rust的文档! 你可以利用头部的的链接跳到文档特定的部分。

# 开始

如果你一点也不了解Rust, 你要做的第一件事是阅读[30分钟介绍](intro.html). 它让你看一下Rust的整体思路。

一旦你知道你真的想学习Rust, 下一步就是阅读[开发指南](guide.html). 它是对Rust的语法和概念的冗长的解释。 在完成阅读开发指南后, 你将会成为Rust的中级开发者,
并且对Rust背后设计的基本理念有了很好的把握。

# 社区和获取帮助

如果你在某些方面需要帮助, 或者想和别人讨论Rust,
这里有几个交流的地方可以做这些事情:

Rust IRC在[irc.mozilla.org](http://irc.mozilla.org/) 的讨论渠道是获取帮助最快的办法.
[`#rust`](http://chat.mibbit.com/?server=irc.mozilla.org&channel=%23rust) 是一般的讨论渠道, 在这里你遇到的任何问题都可以找到乐意帮你解答的人。

这里也有几个专门的讨论渠道:
[`#rust-gamedev`](http://chat.mibbit.com/?server=irc.mozilla.org&channel=%23rust-gamedev)
和
[`#rust-osdev`](http://chat.mibbit.com/?server=irc.mozilla.org&channel=%23rust-osdev)
分别是专门讨论游戏和操作系统开发的。
这里也有一个Rust自身开发的讨论渠道
[`#rust-internals`](http://chat.mibbit.com/?server=irc.mozilla.org&channel=%23rust-internals)。

你也可以通过[Stack
Overflow](http://stackoverflow.com/questions/tagged/rust)获取帮助. 在你提问之前，最好先找一下你的问题之前是否有人已经遇到过!

[subreddit](http://reddit.com/r/rust) 拥有大量Rust相关的讨论。

这里是Rust本身开发的讨论论坛[开发者论坛](http://discuss.rust-lang.org/)。

# 规格说明

Rust没有精确的语言规格说明, 但是我们在[Rust参考](reference.html)里面，尽可能详细的描述了Rust。

# 开发指南

开发者指南在一定深度上对Rust相关的特定主题做了介绍。如果你试图弄明白一些问题，这里的几篇文章可以帮助你:

* [字符串](guide-strings.html)
* [指针](guide-pointers.html)
* [引用和生存周期](guide-lifetimes.html)
* [Crates和模块](guide-crates.html)
* [Task和Task通信](guide-tasks.html)
* [错误处理](guide-error-handling.html)
* [其它语言调用接口](guide-ffi.html)
* [不安全的低级代码](guide-unsafe.html)
* [宏](guide-macros.html)
* [测试](guide-testing.html)
* [编译插件](guide-plugin.html)

# 工具

Rust依然是一个年轻的语言, 所以目前还没有很多的工具, 但是目前拥有的工具都相当的好。

[Cargo](http://crates.io)是Rust的包管理器, 它的网站包含了大量很好的文档。

[rustdoc手册](rustdoc.html) 包含Rust的文档工具解释。

# 常见问题

这些问题都经常的被问到， 所以我们整理了常见问题解答:

* [语言设计常见问题解答](complement-design-faq.html)
* [语言常见问题解答](complement-lang-faq.html)
* [工程常见问题解答](complement-project-faq.html)
* [如何发送一个bug报告](complement-bugreport.html)

# 标准库

我们有[标准库API文档](std/index.html). 文档里有一列很具体的crate的列表，或者你可以使用顶部的搜索栏按名字查找。

# 外部文档

*注意: 有大量的资源学习Rust, 但是他们可能仅仅是针对特定的Rust版本，有很多的可能和这篇文档描述精确的一致。*

* [Rust例子] - 短小的Rust例子 (和Rust主分支一致).
* [Rust for Rubyists] - 第一个Rust新手社区。 和Rust主分支一致. 不光是为了Ruby的开发者.

[Rust例子]: http://rustbyexample.com/
[Rust for Rubyists]: http://www.rustforrubyists.com/
