---
title: "Making a map viewer from scratch"
date: 2022-08-31T14:09:52+02:00
draft: true
authors: ['Zen1th']
---

<br>

![Image of the map viewer](/img/osm-viewer-gtk.png)

Websites like [Google Maps](https://www.google.com/maps) and [OpenStreetMap](https://openstreetmap.org) are map renderers.

For rendering them on the web without downloading a precise multi-terabyte world map, there's two optimizations:
- Maps are pre-rendered on a server, so that instead of interacting with roads and building paths, a web client only needs to render the image its given.
- Maps are split into tiles, when you're looking at Spain, you don't need to also download images of Antartica. The way this work is that the map is divided in a set of squares.
- Tiles are split into zoom level, this is how map renderers do to only show 'United States' when looking at the USA zoomed out, but you can see the names of each places and roads  when zooming in on a city.

Now, there's one huge difference between how Google Maps work and how the OpenStreetMap website works:
- Google Maps uses vector tiles (think SVG), this allows for much more granular zooming, and making place names clickable, among some other features
- OpenStreetMap uses bitmap tiles (think PNG), which makes the web client easier to make and can achieve lower download size (which is important for speed)

## Starting up
To do this, I'm gonna use [Capy](https://capy-ui.org/)

We can scaffold how will the layout look in a file:
```zig
const capy = @import("capy");
pub usingnamespace capy.cross_platform;

// Custom 'MapViewer' component
const MapViewer_Impl = ...;

pub fn MapViewer(config: MapViewer_Impl.Config) MapViewer_Impl {
    var map_viewer = MapViewer_Impl.init(config);
	// TODO: handlers
	return map_viewer;
}

pub fn main() !void {
    try capy.backend.init();
    var window = try capy.Window.init();
    try window.set(
        capy.Column(.{}, .{
            capy.Row(.{}, .{
                capy.Expanded(
                    capy.TextField(.{})
                        .setName("location-input")
                ),
                capy.Button(.{ .label = "Go!", .onclick = onGo }),
            }),
            capy.Expanded(
                (try MapViewer(.{}))
                    .setName("map-viewer")
            ),
        }),
    );
    window.show();
	
    capy.runEventLoop();
}
```


The source code is available at [examples/osm-viewer.zig](https://github.com/capy-ui/capy/blob/master/examples/osm-viewer.zig).
