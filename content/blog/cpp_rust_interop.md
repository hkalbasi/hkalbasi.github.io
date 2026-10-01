+++
title = "Interop"
date = 2026-09-28
description = "My vision on it."
+++

## Why doing C/C++/Rust interop at all?

C and C++ are not memory safe.

You can do one-shot rewrites (probably with an LLM) but in many cases,
it is not feasible without sacrificing quality (will [expand it later](#why-not-ai)), so we need incremental rewrites,
or in some cases not rewriting some parts of code at all. So C/C++ code needs to interop with the Rust code.

## Not all C/C++/Rust interop users are equal

Different users have different constraints on which compilers they can use,
some users are tied to a single version of a C or C++ or Rust compiler,
or they can't change their build system and have complex setup there.
Some users may even need to support multiple toolchains, each imposing some restriction on the project.
On the other hand, some users may be ok with whatever compiler and build system that is available
and don't mind switching their toolchain for better interop experience.
The more flexible users are about their compiler and build system,
the more features the interop system can provide to them.

With that observation, we can put C/Rust and C++/Rust interop tools in an spectrum:
* C/Rust interop tools:
  * bindgen
  * cbindgen
  * CO2
* C++/Rust interop tools:
  * Zngur/CXX
  * autozng/autocxx
  * Crubit
  * CO2++

While these tools have some overlap in their use cases,
I don't think a single tool can cover the whole spectrum.
Hence, I'm involved in more than one tool in that list (CO2, Zngur, autozng, CO2++)
to cover all C/C++/Rust interop users. Below,
I will explain the subset of the tools which I think would cover everything.

## The minimal tools covering the whole spectrum

* bindgen/cbindgen: These are the most basic interop tools which I think are still useful for some cases.
  bindgen emits Rust code from a C header, and cbindgen emits a C header from Rust code.
  These tools have almost no compiler and build system restrictions.
  The bindgen uses libclang to parse the C headers, but since header files and implementation files are separated in C,
  you can use non-ISO C extensions too as long as your headers are valid ISO C.
  The cbindgen uses `syn` to parse Rust code, so it is impercise and uses heuristics in some cases,
  but it remains very compiler independent. If you can afford a nightly compiler but otherwise limited to this level,
  you can also use cheadergen which is based on rustdoc json emited files.
  These tools are for people who can't afford a C++ compiler and have very specific compiler and build system needs.
* CO2: If you can avoid replacing Rust toolchain with CO2 toolchain (which is very similar to a nightly Rust)
  you can use CO2 instead of bindgen or cbindgen. CO2 is a PL backward compatible with C,
  but with Rust interop features. Its code exists as a crate and builds with Cargo,
  so you can use a crate with `#include<header.h>` in its `lib.co2` instead of bindgen.
  Or for cbindgen, you can just `use` items from Rust crates in CO2 code, including items not expressible using cbindgen,
  like generic items or functions with Rust ABI. You can either port your whole C code to CO2
  (useful for rewrite projects) or use CO2 as a layer between C and Rust.
* Zngur: If you can't choose your toolchain and build system, but a C++ compiler is available,
  you can use Zngur. Zngur goes further than bindgen and cbindgen and can generate code for methods,
  destructors, traits and similar things not directly representable in a C ABI. Zngur emits bindings for both directions,
  so it may limits your flexibility in build systems in some way. Another tool at this level of spectrum is CXX,
  created by famous dtolnay, but I didn't include it since Zngur supports almost all patterns supported by CXX.
  Zngur requires you 
* autozng
* CO2++

## Why not ai
a rust rewrite is a reimplementation, unless you want an unsafe translation
reimplementation needs judgement, which LLMs miss currently
