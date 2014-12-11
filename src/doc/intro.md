% Rust的30分钟介绍

Rust是一个现代的系统编程语言，它关注于安全和速度。它没有使用垃圾收集而达到了内存安全的目的。

这个介绍会让你粗略的了解Rust是什么样子的，遗漏了大部分的细节。 它不需要预先的系统编程经验, 但是如果你之前有过了大括号式的语言(如:C或JavaScript)的使用经验, 你会发现语法相当简单。
这个设计理念比语法更重要，所以你不用担心还没有获取最终的语言细节: 你可以阅读[开发指南](guide.html)获取更完整的解释.

因为这些是高级的设计理念, 你不必真的安装Rust. 如果你真的想安装, 请阅读[主页](http://rust-lang.org)上面的说明.

为了演示Rust, 让我们讨论下使用Rust是多么的简单。
然后我们会探讨一下Rust最兴趣的特性, **所有权**, 之后讨论如何使并发变得很简单。 最后,
我们会谈一下Rust如果在速度和安全方面做的平衡。

# 工具

开始一个新的Rust工程难以置信的简单, 这需要感谢Rust的包管理器[Cargo](http://crates.io).

用Cargo开始一个新工程, 使用`cargo new`:

```{bash}
$ cargo new hello_world --bin
```

我们传递 `--bin` 因为我们要开发一个二进制程序: 如果我们开发一个库，我们就不使用这个参数。

让我们检查下Cargo为我们产生的文件:

```{bash}
$ cd hello_world
$ tree .
.
├── Cargo.toml
└── src
    └── main.rs

1 directory, 2 files
```

这就是我们开始的全部文件。 首先, 让我们查看下`Cargo.toml`:

```{toml}
[package]

name = "hello_world"
version = "0.0.1"
authors = ["Your Name <you@example.com>"]
```

这个叫做 **manifest**, 这个文件包括了Cargo编译工程的所有元数据。

这是 `src/main.rs` 里面的内容:

```{rust}
fn main() {
    println!("Hello, world!")
}
```

Cargo 产生了一个 'hello world'程序. 我们稍后将会讨论语法，但是这就是Rust的代码的样子。 让我们编译并运行它:

```{bash}
$ cargo run
   Compiling hello_world v0.0.1 (file:///Users/you/src/hello_world)
     Running `target/hello_world`
Hello, world!
```

使用外部的依赖也是难以置信的简单。你需要添加一行到 `Cargo.toml`:

```{toml}
[package]

name = "hello_world"
version = "0.0.1"
authors = ["Your Name <someone@example.com>"]

[dependencies.semver]

git = "https://github.com/rust-lang/semver.git"
```

你将会添加 `semver`库, 这个库可以解析版本号并且根据[SemVer规范](http://semver.org/)对比。

现在你可以在`main.rs`中使用`extern crate`拉取那个库。

```{rust,ignore}
extern crate semver;

use semver::Version;

fn main() {
    assert!(Version::parse("1.2.3") == Ok(Version {
        major: 1u,
        minor: 2u,
        patch: 3u,
        pre: vec!(),
        build: vec!(),
    }));

    println!("Versions compared successfully!");
}
```

再次强调下，我们很快会讨论语言的精确的语法细节。现在，我们编译运行它:

```{bash}
$ cargo run
    Updating git repository `https://github.com/rust-lang/semver.git`
   Compiling semver v0.0.1 (https://github.com/rust-lang/semver.git#bf739419)
   Compiling hello_world v0.0.1 (file:///home/you/projects/hello_world)
     Running `target/hello_world`
Versions compared successfully!
```

因为我们仅仅指定了一个代码仓库而没有指定它的版本，如果有人在稍后的时候，运行我们的编译命令，而此时`semver`, 已经更新了，他们可能会获取一个和上面不一致的版本。
为了解决这个问题，Cargo产生了一个文件`Cargo.lock`, 他会记录依赖的版本。这个文件保证了我们可以重复构建。

这里有很多的工具， 这个文章只是快速的介绍，如果你使用了以下的工具，你要觉得很自然:比如 [Bundler](http://bundler.io/),
[npm](https://www.npmjs.org/), 或者 [pip](https://pip.pypa.io/en/latest/).
这里没有`Makefile`或者无限的`autotools`输出. (Rust's tooling does
[play nice with external libraries written in those
tools](http://crates.io/native-build.html), 如果你需要的话.)

工具已经讨论的足够多了， 让我们看下代码吧!

# 所有权

Rust定义的特征是'内存安全没有垃圾回收机制'。让我们花点时间讨论下这句话的含义。**内存安全** 意味着这个编程语言消除了某类bug, 比如[缓冲区溢出](http://en.wikipedia.org/wiki/Buffer_overflow)
和[悬空指针](http://en.wikipedia.org/wiki/Dangling_pointer)。这些问题导致了无限制的内存访问。这有一个Ruby的代码例子:

```{ruby}
v = [];

v.push("Hello");

x = v[0];

v.push("world");

puts x
```

我们声明了一个数组`v`, 然后调用该数组的`push`方法. `push`可以在数组尾部添加一个元素。

接下来, 我们声明了一个新的变量`x`, 这个变量等于数组的第一个元素。非常简单，但是一个bug将会出现。

让我们继续。 我们再次调用`push`方法, 把"world"推入数组的尾部。`v`现在是`["Hello", "world"]`.

最后, 我们用`puts`方法打印`x`。 这个会打印出"Hello"。

所有都很正常? 让我们看下另外一个相似但稍有不同的例子, 用C++书写的:

```{cpp}
#include<iostream>
#include<vector>
#include<string>

int main() {
    std::vector<std::string> v;

    v.push_back("Hello");

    std::string& x = v[0];

    v.push_back("world");

    std::cout << x;
}
```

由于静态的类型这个代码更加详细, 但是它和上面几乎是一样的东西。 我们声明了一个`std::string`类型的`std::vector`, 我们调用它的`push_back`方法 (和上面的
`push`一样), 拿到vector第一个元素的引用, 然后再次调用`push_back`, 然后打印这个引用出来。

这里有两个非常大的不同: 第一, 他们是不一样的,
第二，...

```{bash}
$ g++ hello.cpp -Wall -Werror
$ ./a.out 
Segmentation fault (core dumped)
```

一个崩溃! (注意这个崩溃是独立于系统的。因为是一个无效的索引，所以导致了一个不确定的行为, 编译器可以做些事情吗，包括正确的事情!)
即使我们编译的时候传递了参数给编译器，让它尽可能多的提供错误和警告,并让编译器把警告当作错误处理，但是我们没有收到任何错误信息。
当我们可以运行程序的时候，它崩溃了。

为什么会发生这种事情? 当我们追加一个元素到数组, 它的长度就发生了变化。既然长度变化了，我们就需要分配更多的内存。
在Ruby中, 这也会发生, 但是我们经常不会考虑这一点。但是为什么C++版本的代码分配更多内存的时候会导致段错误？

The answer is that in the C++ version, `x` is a **reference** to the memory
location where the first element of the array is stored. But in Ruby, `x` is a
standalone value, not connected to the underyling array at all. Let's dig into
the details for a moment. Your program has access to memory, provided to it by
the operating system. Each location in memory has an address.  So when we make
our vector, `v`, it's stored in a memory location somewhere:

| location | name | value |
|----------|------|-------|
| 0x30     | v    |       |

(Address numbers made up, and in hexadecimal. Those of you with deep C++
knowledge, there are some simplifications going on here, like the lack of an
allocated length for the vector. This is an introduction.)

When we push our first string onto the array, we allocate some memory,
and `v` refers to it:

| location | name | value    |
|----------|------|----------|
| 0x30     | v    | 0x18     |
| 0x18     |      | "Hello"  |

We then make a reference to that first element. A reference is a variable
that points to a memory location, so its value is the memory location of
the `"Hello"` string:

| location | name | value    |
|----------|------|----------|
| 0x30     | v    | 0x18     |
| 0x18     |      | "Hello"  |
| 0x14     | x    | 0x18     |

When we push `"world"` onto the vector with `push_back`, there's no room:
we only allocated one element. So, we need to allocate two elements,
copy the `"Hello"` string over, and update the reference. Like this:

| location | name | value    |
|----------|------|----------|
| 0x30     | v    | 0x08     |
| 0x18     |      | GARBAGE  |
| 0x14     | x    | 0x18     |
| 0x08     |      | "Hello"  |
| 0x04     |      | "world"  |

Note that `v` now refers to the new list, which has two elements. It's all
good. But our `x` didn't get updated! It still points at the old location,
which isn't valid anymore. In fact, [the documentation for `push_back` mentions
this](http://en.cppreference.com/w/cpp/container/vector/push_back):

> If the new `size()` is greater than `capacity()` then all iterators and
> references (including the past-the-end iterator) are invalidated.

Finding where these iterators and references are is a difficult problem, and
even in this simple case, `g++` can't help us here. While the bug is obvious in
this case, in real code, it can be difficult to track down the source of the
error.

Before we talk about this solution, why didn't our Ruby code have this problem?
The semantics are a little more complicated, and explaining Ruby's internals is
out of the scope of a guide to Rust. But in a nutshell, Ruby's garbage
collector keeps track of references, and makes sure that everything works as
you might expect. This comes at an efficiency cost, and the internals are more
complex.  If you'd really like to dig into the details, [this
article](http://patshaughnessy.net/2012/1/18/seeing-double-how-ruby-shares-string-values)
can give you more information.

Garbage collection is a valid approach to memory safety, but Rust chooses a
different path.  Let's examine what the Rust version of this looks like:

```{rust,ignore}
fn main() {
    let mut v = vec![];

    v.push("Hello");

    let x = &v[0];

    v.push("world");

    println!("{}", x);
}
```

This looks like a bit of both: fewer type annotations, but we do create new
variables with `let`. The method name is `push`, some other stuff is different,
but it's pretty close. So what happens when we compile this code?  Does Rust
print `"Hello"`, or does Rust crash?

Neither. It refuses to compile:

```{notrust,ignore}
$ cargo run
   Compiling hello_world v0.0.1 (file:///Users/you/src/hello_world)
main.rs:8:5: 8:6 error: cannot borrow `v` as mutable because it is also borrowed as immutable
main.rs:8     v.push("world");
              ^
main.rs:6:14: 6:15 note: previous borrow of `v` occurs here; the immutable borrow prevents subsequent moves or mutable borrows of `v` until the borrow ends
main.rs:6     let x = &v[0];
                       ^
main.rs:11:2: 11:2 note: previous borrow ends here
main.rs:1 fn main() {
...
main.rs:11 }
           ^
error: aborting due to previous error
```

When we try to mutate the array by `push`ing it the second time, Rust throws
an error. It says that we "cannot borrow v as mutable because it is also
borrowed as immutable." What's up with "borrowed"?

In Rust, the type system encodes the notion of **ownership**. The variable `v`
is an "owner" of the vector. When we make a reference to `v`, we let that
variable (in this case, `x`) 'borrow' it for a while. Just like if you own a
book, and you lend it to me, I'm borrowing the book.

So, when I try to modify the vector with the second call to `push`, I need
to be owning it. But `x` is borrowing it. You can't modify something that
you've lent to someone. And so Rust throws an error.

So how do we fix this problem? Well, we can make a copy of the element:


```{rust}
fn main() {
    let mut v = vec![];

    v.push("Hello");

    let x = v[0].clone();

    v.push("world");

    println!("{}", x);
}
```

Note the addition of `clone()`. This creates a copy of the element, leaving
the original untouched. Now, we no longer have two references to the same
memory, and so the compiler is happy. Let's give that a try:

```{bash}
$ cargo run
   Compiling hello_world v0.0.1 (file:///Users/you/src/hello_world)
     Running `target/hello_world`
Hello
```

Same result. Now, making a copy can be inefficient, so this solution may not be
acceptable. There are other ways to get around this problem, but this is a toy
example, and because we're in an introduction, we'll leave that for later.

The point is, the Rust compiler and its notion of ownership has saved us from a
bug that would crash the program. We've achieved safety, at compile time,
without needing to rely on a garbage collector to handle our memory.

# 并发

Rust's ownership model can help in other ways, as well. For example, take
concurrency. Concurrency is a big topic, and an important one for any modern
programming language. Let's take a look at how ownership can help you write
safe concurrent programs.

这里是一个Rust的并发程序示例程序:

```{rust}
fn main() {
    for _ in range(0u, 10u) {
        spawn(proc() {
            println!("Hello, world!");
        });
    }
}
```

这个程序创建了10个线程, 这些线程全部打印`Hello, world!`。 `spawn`
函数需要一个参数`proc`。 'proc'是'procedure的简写,' 它是一个闭包的形式。 这个闭包在`spawn`创建的一个新线程内执行。

在并发程序里面，一个普遍形式的问题是'数据竞争（data race）'。 这个会发生在两个线程非同步的形势下试图访问内存的同一块区域。, 至少有一个是写入操作。 
如果一个线程是读，另外一个线程是写入，你将不确定你的数据会不会被破坏。 Note the first half of that requirement:
two threads that attempt to access the same location in memory. Rust's
ownership model can track which pointers own which memory locations, which
solves this problem.

让我们看一个例子。 这段Rust代码不会被编译通过:

```{rust,ignore}
fn main() {
    let mut numbers = vec![1i, 2i, 3i];

    for i in range(0u, 3u) {
        spawn(proc() {
            for j in range(0, 3) { numbers[j] += 1 }
        });
    }
}
```

它会给出这个错误:

```{notrust,ignore}
6:71 error: capture of moved value: `numbers`
    for j in range(0, 3) { numbers[j] += 1 }
               ^~~~~~~
7:50 note: `numbers` moved into closure environment here because it has type `proc():Send`, which is non-copyable (perhaps you meant to use clone()?)
    spawn(proc() {
        for j in range(0, 3) { numbers[j] += 1 }
    });
6:79 error: cannot assign to immutable dereference (dereference is implicit, due to indexing)
        for j in range(0, 3) { numbers[j] += 1 }
                           ^~~~~~~~~~~~~~~
```

It mentions that "numbers moved into closure environment". Because we referred
to `numbers` inside of our `proc`, and we create three `proc`s, we would have
three references. Rust detects this and gives us the error: we claim that
`numbers` has ownership, but our code tries to make three owners. This may
cause a safety problem, so Rust disallows it.

What to do here? Rust has two types that helps us: `Arc<T>` and `Mutex<T>`.
"Arc" stands for "atomically reference counted." In other words, an Arc will
keep track of the number of references to something, and not free the
associated resource until the count is zero. The 'atomic' portion refers to an
Arc's usage of concurrency primitives to atomically update the count, making it
safe across threads. If we use an Arc, we can have our three references. But,
an Arc does not allow mutable borrows of the data it holds, and we want to
modify what we're sharing. In this case, we can use a `Mutex<T>` inside of our
Arc. A Mutex will synchronize our accesses, so that we can ensure that our
mutation doesn't cause a data race.

Here's what using an Arc with a Mutex looks like:

```{rust}
use std::sync::{Arc,Mutex};

fn main() {
    let numbers = Arc::new(Mutex::new(vec![1i, 2i, 3i]));

    for i in range(0u, 3u) {
        let number = numbers.clone();
        spawn(proc() {
            let mut array = number.lock();

            (*array)[i] += 1;

            println!("numbers[{}] is {}", i, (*array)[i]);
        });
    }
}
```

We first have to `use` the appropriate library, and then we wrap our vector in
an Arc with the call to `Arc::new()`. Inside of the loop, we make a new
reference to the Arc with the `clone()` method. This will increment the
reference count. When each new `numbers` variable binding goes out of scope, it
will decrement the count. The `lock()` call will return us a reference to the
value inside the Mutex, and block any other calls to `lock()` until said
reference goes out of scope.

We can compile and run this program without error, and in fact, see the
non-deterministic aspect:

```{shell}
$ cargo run
   Compiling hello_world v0.0.1 (file:///Users/you/src/hello_world)
     Running `target/hello_world`
numbers[1] is 3
numbers[0] is 2
numbers[2] is 4
$ cargo run
     Running `target/hello_world`
numbers[2] is 4
numbers[1] is 3
numbers[0] is 2
```

Each time, we get a slightly different output, because each thread works in a
different order. You may not get the same output as this sample, even.

The important part here is that the Rust compiler was able to use ownership to
give us assurance _at compile time_ that we weren't doing something incorrect
with regards to concurrency. In order to share ownership, we were forced to be
explicit and use a mechanism to ensure that it would be properly handled.

# Safety _and_ speed

Safety and speed are always presented as a continuum. On one hand, you have
maximum speed, but no safety. On the other, you have absolute safety, with no
speed. Rust seeks to break out of this mode by introducing safety at compile
time, ensuring that you haven't done anything wrong, while compiling to the
same low-level code you'd expect without the safety.

As an example, Rust's ownership system is _entirely_ at compile time. The
safety check that makes this an error about moved values:

```{rust,ignore}
fn main() {
    let vec = vec![1i, 2, 3];

    for i in range(1u, 3) {
        spawn(proc() {
            println!("{}", vec[i]);
        });
    }
}
```

carries no runtime penalty. And while some of Rust's safety features do have
a run-time cost, there's often a way to write your code in such a way that
you can remove it. As an example, this is a poor way to iterate through
a vector:

```{rust}
let vec = vec![1i, 2, 3];

for i in range(1u, vec.len()) {
     println!("{}", vec[i]);
}
```

The reason is that the access of `vec[i]` does bounds checking, to ensure
that we don't try to access an invalid index. However, we can remove this
while retaining safety. The answer is iterators:

```{rust}
let vec = vec![1i, 2, 3];

for x in vec.iter() {
    println!("{}", x);
}
```

This version uses an iterator that yields each element of the vector in turn.
Because we have a reference to the element, rather than the whole vector itself,
there's no array access bounds to check.

# 学习更多

I hope that this taste of Rust has given you an idea if Rust is the right
language for you. We talked about Rust's tooling, how encoding ownership into
the type system helps you find bugs, how Rust can help you write correct
concurrent code, and how you don't have to pay a speed cost for much of this
safety.

To continue your Rustic education, read [the guide](guide.html) for a more
in-depth exploration of Rust's syntax and concepts.
