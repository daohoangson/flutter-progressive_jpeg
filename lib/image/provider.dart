import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:image/image.dart';

import 'jpeg_data.dart';
import 'read_sos_exception.dart';

class MyImageProvider extends ImageProvider<String> {
  final String url;

  MyImageProvider(this.url);

  @override
  Future<String> obtainKey(ImageConfiguration configuration) async => url;

  @override
  ImageStreamCompleter loadImage(
    String key,
    ImageDecoderCallback decode,
  ) {
    debugPrint('Downloading $url...');
    final completer = Completer<Codec>();

    final ints = List<int>.empty(growable: true);
    final httpClient = HttpClient();
    httpClient.getUrl(Uri.parse(url)).then((request) async {
      final response = await request.close();

      response.listen(
        (newInts) {
          ints.addAll(newInts);
          final jpeg = MyJpegData();
          try {
            jpeg.read(Uint8List.fromList(ints));
          } on ReadSosException {
            response.detachSocket().then(
                  // destroy the socket to cancel the download
                  (socket) => socket.destroy(),
                );

            final image = jpeg.getImage();
            final encodedJpeg = encodeJpg(image);
            ImmutableBuffer.fromUint8List(encodedJpeg).then((buffer) async {
              decode(buffer).then(completer.complete);

              final values = response.headers['content-length'] ?? const [''];
              final contentLength = int.tryParse(values[0]);
              if (contentLength != null) {
                debugPrint('Downloaded ${ints.length} of $contentLength bytes');
              }
            });
          } catch (_) {
            // ignore
          }
        },
        onError: completer.completeError,
      );

      try {
        await completer.future;
      } finally {
        httpClient.close();
      }
    });

    return MultiFrameImageStreamCompleter(codec: completer.future, scale: 1.0);
  }
}
