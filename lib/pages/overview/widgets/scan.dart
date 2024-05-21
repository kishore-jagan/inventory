import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  @override
  _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  late CameraController _cameraController;
  late List<CameraDescription> cameras;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium);

    await _cameraController.initialize();

    if (!mounted) {
      return;
    }

    setState(() {
      _isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Scanner'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: CameraPreview(_cameraController),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // scanBarcode();
              },
              child: Text('Scan Barcode'),
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> scanBarcode() async {
  //   try {
  //     String barcodeScanResult = await BarcodeScanner.scan();
  //     // Handle the scanned barcode result
  //     print('Scanned Barcode: $barcodeScanResult');
  //   } on PlatformException catch (e) {
  //     if (e.code == BarcodeScanner.cameraAccessDenied) {
  //       print('Camera permission denied');
  //     } else {
  //       print('Error: $e');
  //     }
  //   } on FormatException {
  //     // User pressed the back button before scanning anything
  //     print('User pressed back button');
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }
}
