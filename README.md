# progressive_jpeg

This is a PoC to show how to download and display a progressive JPEG image in Flutter.

The idea is to download the image in chunks and display it as soon as possible.
The HTTP connection should be aborted at that point to save resources (cpu, memory, network). For real application, the chunks should be saved somewhere so the download can resume and display the full image.

This got started from https://twitter.com/mrpaint/status/1742790251612156211.
