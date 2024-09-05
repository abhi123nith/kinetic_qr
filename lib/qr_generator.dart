import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class QRCodeGeneratorScreen extends StatefulWidget {
  const QRCodeGeneratorScreen({super.key});

  @override
  _QRCodeGeneratorScreenState createState() => _QRCodeGeneratorScreenState();
}

class _QRCodeGeneratorScreenState extends State<QRCodeGeneratorScreen> {
  final TextEditingController _inputController = TextEditingController();
  final GlobalKey _globalKey = GlobalKey();
  String? qrData;

  // For saving QR code temporary and share it
  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(
          pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/qr_code.png';
      final file = File(filePath);

      await file.writeAsBytes(pngBytes);
      if (await file.exists()) {
        final fileSize = await file.length();
        print('File saved successfully. Size: $fileSize bytes');
      } else {
        print('Failed to save file.');
      }

      await Share.shareXFiles([XFile(file.path)], text: 'Here is my QR code!');
    } catch (e) {
      print('Error capturing and sharing PNG: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _inputController,
                decoration: const InputDecoration(
                  labelText: 'Enter data to generate QR code',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    qrData = _inputController.text;
                  });
                },
                child: const Text('Generate QR Code'),
              ),
              const SizedBox(height: 20),
              qrData != null
                  ? RepaintBoundary(
                      key: _globalKey,
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: CustomPaint(
                          painter: QrPainter(
                            data: qrData!,
                            version: QrVersions.auto,
                          ),
                        ),
                      ),
                    )
                  : Container(),
              const SizedBox(height: 20),
              qrData != null
                  ? ElevatedButton(
                      onPressed: () {
                        print('Attempting to capture and share QR code');
                        _captureAndSharePng();
                      },
                      child: const Text('Save & Share QR Code'),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
