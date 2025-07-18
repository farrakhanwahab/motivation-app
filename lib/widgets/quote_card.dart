import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/rendering.dart';

class QuoteCard extends StatefulWidget {
  final String quote;
  final String author;

  const QuoteCard({
    super.key,
    required this.quote,
    required this.author,
  });

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  final GlobalKey _boundaryKey = GlobalKey();

  Future<void> _shareQuoteAsImage(BuildContext context) async {
    try {
      // Wait for the widget to be rendered
      await Future.delayed(const Duration(milliseconds: 100));
      RenderRepaintBoundary boundary = _boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      if (boundary.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to capture image.')),
        );
        return;
      }
      Uint8List pngBytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/quote.png').create();
      await file.writeAsBytes(pngBytes);
      await Share.shareXFiles([XFile(file.path)], text: 'Shared from Motivation AI');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.grey[900] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final authorColor = isDark ? Colors.white70 : Colors.grey[700];
    final shadowColor = isDark ? Colors.black.withOpacity(0.25) : Colors.black.withOpacity(0.08);
    return RepaintBoundary(
      key: _boundaryKey,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.format_quote, size: 36, color: isDark ? Colors.white24 : Colors.black26),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.quote,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 22,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  '- ${widget.author}',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                    color: authorColor,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: Icon(Icons.share, color: isDark ? Colors.white54 : Colors.black54),
                tooltip: 'Share',
                onPressed: () => _shareQuoteAsImage(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 