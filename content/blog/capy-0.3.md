---
title: "Capy 0.3 Release Notes"
authors: ["Zen1th"]
date: 2023-02-12T10:35:14+01:00
tags: ["capy", "release"]
---

**Reminder: Capy is NOT ready for use in production as I'm still making breaking changes**

[Capy](https://github.com/capy-ui/capy) is a **GUI framework** for Zig made with performance, cross-compilation and native widgets in mind. The goal is to be able to seamlessly cross-compile from any platform to any other one. This includes Windows, Linux, WebAssembly, and soon will include macOS, Android and iOS.

It's been 6 months since the 0.2 update, but Capy is getting forward at its own slow pace.

![image 'showcasing' capy's features](/img/balls-0.3.png)  
*[Balls](https://github.com/capy-ui/capy/blob/master/examples/balls.zig)*

## Improved the build process

The build process has been simplified as much as possible.

The 50-line `install()` function you had to copy has been removed. So has the requirement to supply the path where Capy has been installed. Alongside that, a [template](https://github.com/capy-ui/zig-template) has been added which allows to get started with Capy much faster than before.

In practice this means you can do that:

```zig
// Usual build functions..
const exe = b.addExecutable("my-gui-app", "src/main.zig");
exe.setTarget(target);
exe.setBuildMode(mode);

// one-liner for using Capy
try deps.imports.capy.install(exe, .{});

// Usual build functions..
exe.install();
```

## New components

I experimented with using Zig's comptime abilities so that one method could be used to
get, set, and bind a property like if we were in a dynamic language.  
This allows to switch from `setText("Hello, World")` to `set("text", "Hello, World")`.  
I'm still wondering if this is better and whether `setProperty` would be a better name for it,
but this atleast removes the burden of having to create 3 functions each time you add a property
to a component.

- Added `enabled` property to Button
- Added `CheckBox` component
- Added `Align` component.

It's aim is to replace the former `alignX` and `alignY` properties which
were a confusing bit of API design. Adding Align made the API should now be clearer and easier to understand,
while also simplyfing the implementation of layouting.

```zig
Button(.{ .alignX = 0.5 })
```
becomes
```zig
Align(.{ .x = 0.5 }, Button(.{}))
```

- Added an experimental for-each component (`ColumnList`). You can see it used in the [hacker-news example](https://github.com/capy-ui/capy/blob/master/examples/hacker-news.zig) but
it is currently highly experimental.
- Added ScrollView, which allows to make any component scrollable

## Wrapping containers
Added `wrapping` property, this allows the elements to wrap instead of going off to infinity.

```zig
capy.Row(.{ .wrapping = true, .spacing = 5 }, .{
	capy.Button(.{ .label = "Button #0" }),
	capy.Button(.{ .label = "Button #1" }),
	capy.Button(.{ .label = "Button #2" }),
	capy.Button(.{ .label = "Button #3" }),
	// ...
})
```

Here's a row with `wrapping` set to `false`, aka old behaviour:
![container with wrapping=false](/img/wrapping-false-0.3.png)  
And here is it with `wrapping` set to `true`:  
![container with wrapping=true](/img/wrapping-true-0.3.png)  

Notice how with `wrapping` set to `false` (equivalent to the old behaviour) components take all the height of the Row, because the Row is only laying them out horizontally, so it gives them all the vertical space.  
However, with `wrapping` set to `true`, components may wrap over to bottom which means that Row is laying them out horizontally and vertically, so it gives components their preferred size instead.

Hence, in both pictures, the buttons have the same width.

## Optimized DataWrapper

DataWrapper is what is responsible of giving data binding, animations and other [neat things](https://capy-ui.org/docs/guides/data-binding) to Capy. It's usually used whenever a property is required. This means that it's often used through the entire codebase and can end up in components that might be instantiated hundreds of times. Under this, it's logical to try to reduce the size overhead it gives.  
Thus, the data structures of DataWrapper were optimized for size, this resulted in
the overhead being reduced, from 152 bytes down to 128 bytes.

On the other hand, the`dependOn` function was added to DataWrapper. It's meant for values that depend on other values, while avoiding having to manually setup tons of change listeners. This can be used for things like a 'Submit' button, which can dependOn all fields being valid. You can quickly see how it can be used in the [flight booker example](https://github.com/capy-ui/capy/blob/master/examples/7gui/flight-booker.zig)

Optional values can also now be animated using `animate(...)`

### win32 fixes
The native integration for High-DPI was added and is now functional. The only step remaining is to correctly
implement the actual pixel scaling. When it's done, there won't be any change necessary on the
application side as `Window.source_dpi` is already used well for that.

Among that, there were a lot of bug fixes.
- The background is now correctly cleared on resize ([c32e0e1](https://github.com/capy-ui/capy/commit/c32e0e16d62d0649deed63ba3b872e37c5c0f4b4))
- Improved performance and fixed flickering ([352a959](https://github.com/capy-ui/capy/commit/352a95974c4df0f109231100f292efd44b0bb435))
- You can now use `std.log` in Debug builds ([aed5e0f](https://github.com/capy-ui/capy/commit/aed5e0f28eb31bf37547707d8da999a4ebdb4b2f))
- Caption font is now used, this replaces win32's default GUI font that came from Windows 95 ([9bb59a1](https://github.com/capy-ui/capy/commit/9bb59a190089f693dba51e8c8e732f4d743fcbf1))

![image of a capy app on win32](/img/calculator-win32.png)

## First steps on Android
Recently, the first progress towards an Android backend were made.

The Android backend is something I couldn't have managed to do without the efforts the Zig community put
in [ZigAndroidTemplate](https://github.com/MasterQ32/ZigAndroidTemplate), so thanks to them.

Secondly, Android is absolutely not made for native code that creates native views.
But JNI truly can let you do anything Java can.

<br>
<img src="/img/capy-android-two-views.jpg" alt="We've got the TextView and the Button showing!" style="width: 15em;"></img>
<br>

Currently, it only supports TextField, Button, Canvas and Container.

For more information, see the [blog post](/blog/porting-capy-to-android) detailing the port.

## Baby steps on macOS
As always, for macOS, I'm aiming at being able to build your app from Windows/Linux/macOS to macOS.  
So far, the plan is to download the macOS SDK automatically in `build.zig`, which is something you can do
as long as you accept the [EULA](https://www.apple.com/legal/sla/docs/xcode.pdf). However this has not
been done yet.

Currently, what has been done is that, if you have a macOS SDK in the `macos-sdk` folder, you can build a basic non-functioning app. It doesn't work, but it calls the `NSWindow` APIs! We're onto a first step!

## A note about the WebAssembly backend
More functions were implemented on the WebAssembly, this quite notably allowed
to run the [OpenStreetMap viewer example](/zig-osm/) online, without any
platform-specific code.

![openstreetmap viewer made in capy running on web](/img/osm-viewer-gtk.png)

However, since Capy upgraded to the new Zig self-hosted compiler and it still hasn't yet reimplemented
async, the backend is currently unusable due to this compiler regression.

- Add viewport meta tag to run on mobile devices ([68dfda0](https://github.com/capy-ui/capy/commit/68dfda0eda529b915bc37d327320bab1af187224))


Lastly, an experimental HTTP module had been added ([03993dd](https://github.com/capy-ui/capy/commit/03993dd10e98d2d674708496ff2d9942f71666cd)) that used the Fetch API on WebAssembly.
On desktop, it used [zfetch](https://github.com/truemedian/zfetch) but when it was archived by its
creator, I had to switch to another library. Sadly no library was as simple to build as zfetch
(that is where a simple `zig build run` is enough to setup everything quick enough and on all major
platforms).  
I'm currently counting on Zig's efforts to implement a TLS library and an HTTP client in the standard library. I'll be able to switch once the changes brought in [#13980](https://github.com/ziglang/zig/pull/13980) are stabilized.

## Documentation

The documentation for Capy has switched from GitHub Wiki to a Docusaurus instance.
It's still editable by the public on the [capy-ui/documentation](https://github.com/capy-ui/documentation)
repository.
