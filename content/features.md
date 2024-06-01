---
title: "Features"
date: 2022-08-31T14:22:54+02:00
---

Capy is meant to be easy to learn. In the meaning that, much like Zig, you can hold the entire
library of components and layouting in your mind. Instead of having to look up even the most
basic constructs due to feature-itis, it aims to be easy to grasp.

## Native, really

Today, when we speak about a native UI, we often just means it runs directly as an app on the
native platform. We say it for Electron, [Tauri](https://tauri.app), [Fyne](https://fyne.io),
but Capy chose to use the native toolkit of each platform.

This means on Windows, win32 is used. On macOS, Cocoa is used, and so on.

The reason for this is because it helps reduce the cognitive load. Otherwise people have to think
again about a process that they've already learned. Reinventing the wheel is a tradeoff, and it's
usually a bad one.

## Performance

Capy is coded in a systems programmnig language in order to free yourself from the overhead
of a VM or a garbage collector.

Besides, Capy's goal is to be able to sustain 60 fps (and more on 120/144Hz monitors) animations,
without any lag spikes or noticeable discontuinity.

## Tiny

So far, when you compile every example in Capy, you get an executable smaller than 2 MB *without linking
to libc*. This is smaller than the size of an [Hello World program in Go](https://stackoverflow.com/questions/28576173/reason-for-huge-size-of-compiled-executable-of-go)

## Accessibility

Unlike most new cross-platform GUI libraries, Capy is following accessibility from the get go.  
The human right to software is a requirement.
