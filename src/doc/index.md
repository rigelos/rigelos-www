% Rust文档

欢迎来到Rust的文档! 你可以利用头部的的链接跳到特定的部分。

# 开始

如果你一点也不了解Rust, 你要做的第一件事是阅读[30分钟介绍](intro.html). 它让你看一下Rust的整体思路。

一旦你知道你真的想学习Rust, 下一步就是阅读[开发指南](guide.html). 它是对Rust的语法和概念的冗长的解释。 在完成阅读开发指南后, 你将会成为Rust的中级开发者,
并且对Rust背后的基本理念有了很好的把握。

# 社区和获取帮助

如果你在某些方面需要帮助, 或者想和别人讨论Rust,
这里有几个交流的地方可以做这些事情:

The Rust IRC channels on [irc.mozilla.org](http://irc.mozilla.org/) 是获取帮助最快的办法.
[`#rust`](http://chat.mibbit.com/?server=irc.mozilla.org&channel=%23rust) is
the general discussion channel, and you'll find people willing to help you with
any questions you may have.

There are also three specialty channels:
[`#rust-gamedev`](http://chat.mibbit.com/?server=irc.mozilla.org&channel=%23rust-gamedev)
and
[`#rust-osdev`](http://chat.mibbit.com/?server=irc.mozilla.org&channel=%23rust-osdev)
are for game development and operating system development, respectively.
There's also
[`#rust-internals`](http://chat.mibbit.com/?server=irc.mozilla.org&channel=%23rust-internals), which is for discussion of the development of Rust itself.

You can also get help on [Stack
Overflow](http://stackoverflow.com/questions/tagged/rust). Searching for your
problem might reveal someone who has asked it before!

There is an active [subreddit](http://reddit.com/r/rust) with lots of
discussion about Rust.

There is also a [developer forum](http://discuss.rust-lang.org/), where the
development of Rust itself is discussed.

# 规格说明

Rust没有精确的语言规格说明, but an effort to describe as much of
the language in as much detail as possible is in [the reference](reference.html).

# 开发指南

Rust Guides are in-depth looks at a particular topic that's relevant to Rust
development. If you're trying to figure out how to do something, there may be
a guide that can help you out:

* [字符串](guide-strings.html)
* [指针](guide-pointers.html)
* [引用和生存周期](guide-lifetimes.html)
* [Crates和模块](guide-crates.html)
* [Task和Task通信](guide-tasks.html)
* [错误处理](guide-error-handling.html)
* [Foreign Function Interface](guide-ffi.html)
* [书写不安全的低级代码](guide-unsafe.html)
* [宏](guide-macros.html)
* [测试](guide-testing.html)
* [编译插件](guide-plugin.html)

# 工具

Rust's still a young language, so there isn't a ton of tooling yet, but the
tools we have are really nice.

[Cargo](http://crates.io) is Rust's package manager, and its website contains
lots of good documentation.

[The `rustdoc` manual](rustdoc.html) contains information about Rust's
documentation tool.

# 常见问题

There are questions that are asked quite often, and so we've made FAQs for them:

* [Language Design FAQ](complement-design-faq.html)
* [Language FAQ](complement-lang-faq.html)
* [Project FAQ](complement-project-faq.html)
* [How to submit a bug report](complement-bugreport.html)

# 标准库

We have [API documentation for the entire standard
library](std/index.html). There's a list of crates on the left with more
specific sections, or you can use the search bar at the top to search for
something if you know its name.

# 外部文档

*Note: While these are great resources for learning Rust, they may track a
particular version of Rust that is likely not exactly the same as that for
which this documentation was generated.*

* [Rust by Example] - Short examples of common tasks in Rust (tracks the master
  branch).
* [Rust for Rubyists] - The first community tutorial for Rust. Tracks the last
  stable release. Not just for Ruby programmers.

[Rust by Example]: http://rustbyexample.com/
[Rust for Rubyists]: http://www.rustforrubyists.com/
