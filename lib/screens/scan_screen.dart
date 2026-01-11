import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../providers/medicine_provider.dart';
import 'medicine_detail_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _isProcessing = false;
  MobileScannerController cameraController = MobileScannerController();

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final code = barcodes.first.rawValue;
    if (code == null) return;
    
    // Pause camera to prevent multiple scans
    cameraController.stop(); 
    
    _processBarcode(code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Camera Layer
          MobileScanner(
            controller: cameraController,
            onDetect: _onDetect,
            errorBuilder: (context, error, child) {
              return GestureDetector(
                onTap: () => _showManualEntryDialog(context),
                child: Container(
                  color: Colors.black87,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.touch_app, color: Colors.white, size: 60),
                        const SizedBox(height: 10),
                        const Text(
                          'Kamera kullanılamıyor.\nElle girmek için DOKUNUN.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          
          // 2. Scanner Overlay (Frame)
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFF48FB1), width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Icon(Icons.qr_code_scanner, color: Color(0xFFF8BBD0), size: 30),
              ),
            ),
          ),

          // 3. Back Button
          Positioned(
            top: 40,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.black45,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // 4. Manual Entry & Controls Panel
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Flash Button
                  IconButton(
                    icon: ValueListenableBuilder(
                      valueListenable: cameraController.torchState,
                      builder: (context, state, child) {
                         return Icon(
                           state == TorchState.on ? Icons.flash_on : Icons.flash_off, 
                           color: Colors.white
                         );
                      },
                    ),
                    onPressed: () => cameraController.toggleTorch(),
                  ),
                  
                  // Manual Input Button
                  ElevatedButton.icon(
                    onPressed: () => _showManualEntryDialog(context),
                    icon: const Icon(Icons.keyboard),
                    label: const Text('Elle Gir'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF48FB1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),

                  // Rotate Camera Button
                  IconButton(
                    icon: const Icon(Icons.cameraswitch, color: Colors.white),
                    onPressed: () => cameraController.switchCamera(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showManualEntryDialog(BuildContext context) {
    final controller = TextEditingController();
    // Pause camera when dialog opens
    cameraController.stop(); 
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Barkod Numarası Gir'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Örn: 869...',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.qr_code),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              cameraController.start(); // Resume camera on cancel
            },
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Navigator.pop(ctx);
                _processBarcode(controller.text);
              }
            },
            child: const Text('Sorgula'),
          ),
        ],
      ),
    );
  }

  void _processBarcode(String code) async {
    setState(() => _isProcessing = true);
    final provider = Provider.of<MedicineProvider>(context, listen: false);
    
    // Ensure data is loaded
    if (provider.medicines.isEmpty) {
      await provider.loadMedicines();
    }
    
    final medicine = provider.findByBarcode(code);

    if (mounted) {
       setState(() => _isProcessing = false);
      if (medicine != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MedicineDetailScreen(medicine: medicine)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            content: Text('Barkod bulunamadı: $code'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Tekrar',
              textColor: Colors.white,
              onPressed: () => cameraController.start(),
            ),
          ),
        );
         // Resume camera if not found
         cameraController.start();
      }
    }
  }
} // Close class correctly
