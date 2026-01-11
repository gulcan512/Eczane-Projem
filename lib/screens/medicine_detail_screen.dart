import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/medicine.dart';
import '../providers/medicine_provider.dart';

class MedicineDetailScreen extends StatelessWidget {
  final Medicine medicine;

  const MedicineDetailScreen({super.key, required this.medicine});

  void _showBarcodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(medicine.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              QrImageView(
                data: medicine.barcode,
                version: QrVersions.auto,
                size: 200.0,
              ),
              const SizedBox(height: 10),
              Text(medicine.barcode, style: const TextStyle(letterSpacing: 2)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.print),
                label: const Text('Yazdır'),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Yazıcıya gönderildi (Simülasyon) 🖨️')),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _deleteMedicine(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Silme Onayı'),
        content: Text('${medicine.name} ilacını silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
          TextButton(
            onPressed: () {
               Provider.of<MedicineProvider>(context, listen: false).deleteMedicine(medicine.id);
               Navigator.pop(ctx); // Close dialog
               Navigator.pop(context); // Go back to list
               ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(content: Text('İlaç silindi 🗑️')),
               );
            },
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final expiryColor = medicine.isExpired ? Colors.red : (medicine.isExpiringSoon ? Colors.orange : Colors.green);

    return Scaffold(
      appBar: AppBar(title: Text(medicine.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.medication, size: 60, color: theme.primaryColor),
                    const SizedBox(height: 10),
                    Text(medicine.name, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    Text(medicine.activeIngredient, style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey)),
                    const SizedBox(height: 20),
                    _DetailRow(label: 'Barkod', value: medicine.barcode),
                    _DetailRow(label: 'Firma', value: medicine.company),
                    _DetailRow(label: 'Form', value: medicine.form),
                    _DetailRow(label: 'Stok', value: '${medicine.stock} Adet'),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Son Kullanma Tarihi:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Chip(
                          label: Text(DateFormat('dd/MM/yyyy').format(medicine.expirationDate)),
                          backgroundColor: expiryColor.withOpacity(0.2),
                          labelStyle: TextStyle(color: expiryColor, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _showBarcodeDialog(context),
              icon: const Icon(Icons.qr_code),
              label: const Text('Barkodu Göster / Yazdır'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _deleteMedicine(context),
              icon: const Icon(Icons.delete),
              label: const Text('İlacı Sil'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
