import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class CaptchaImage extends StatefulWidget {
  final String captcha;

  const CaptchaImage({super.key, required this.captcha});

  @override
  State<CaptchaImage> createState() => _CaptchaImageState();
}

class _CaptchaImageState extends State<CaptchaImage> {
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _generateImage();
  }

  @override
  void didUpdateWidget(covariant CaptchaImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.captcha != widget.captcha) {
      _generateImage();
    }
  }

  void _generateImage() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, 150, 50));
    final painter = _CaptchaPainter(widget.captcha);
    painter.paint(canvas, const Size(150, 50));
    final picture = recorder.endRecording();
    final image = await picture.toImage(150, 50);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_image == null) {
      return const SizedBox(width: 150, height: 50);
    }
    return RawImage(image: _image, width: 150, height: 50);
  }
}

class _CaptchaPainter {
  final String captcha;
  final Random _random = Random();

  _CaptchaPainter(this.captcha);

  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = Colors.white);

    // Draw noise
    for (int i = 0; i < 12; i++) {
      paint.color = Colors.primaries[_random.nextInt(Colors.primaries.length)];
      paint.strokeWidth = 1 + _random.nextDouble();
      final start = Offset(_random.nextDouble() * size.width, _random.nextDouble() * size.height);
      final end = Offset(_random.nextDouble() * size.width, _random.nextDouble() * size.height);
      canvas.drawLine(start, end, paint);
    }

    // Draw characters
    for (int i = 0; i < captcha.length; i++) {
      final char = captcha[i];
      final dx = 10.0 + i * 25 + _random.nextDouble() * 4;
      final dy = 10.0 + _random.nextDouble() * 10;

      final builder = ui.ParagraphBuilder(ui.ParagraphStyle(fontSize: 30))
        ..pushStyle(ui.TextStyle(
          color: Colors.primaries[_random.nextInt(Colors.primaries.length)],
          fontWeight: FontWeight.bold,
        ))
        ..addText(char);

      final paragraph = builder.build();
      paragraph.layout(const ui.ParagraphConstraints(width: 40));

      final angle = (_random.nextDouble() * 0.4) - 0.2;
      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(angle);
      canvas.drawParagraph(paragraph, Offset.zero);
      canvas.restore();
    }
  }
}
