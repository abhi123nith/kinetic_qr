import 'package:flutter/material.dart';
import 'package:kinetic_qr/qr_generator.dart';
import 'package:kinetic_qr/qr_scanner.dart';

void main() {
  runApp(const QRCodeScannerApp());
}

class QRCodeScannerApp extends StatelessWidget {
  const QRCodeScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Code Scanner & Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner & Generator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QRScannerScreen()),
                );
              },
              child: const Text('Scan QR Code'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QRCodeGeneratorScreen()),
                );
              },
              child: const Text('Generate QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}