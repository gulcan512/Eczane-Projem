import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/medicine_provider.dart';
import '../models/medicine.dart';
import 'package:intl/intl.dart';
import 'medicine_detail_screen.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MedicineProvider>(context);
    final expiring = provider.expiringSoon;
    final lowStock = provider.lowStock;
    final allAlerts = [...expiring, ...lowStock].toSet().toList(); // Unique

    return Scaffold(
      appBar: AppBar(title: const Text('Acil Uyarılar ⚠️')),
      body: allAlerts.isEmpty 
      ? const Center(child: Text('Herhangi bir uyarı yok. Her şey yolunda! ✅', style: TextStyle(fontSize: 16)))
      : ListView.builder(
        itemCount: allAlerts.length,
        itemBuilder: (context, index) {
          final m = allAlerts[index];
          final isExpired = m.isExpiringSoon || m.isExpired;
          final isLowStock = m.stock < 10;
          
          return Card(
             color: Colors.red.shade50,
             margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
             child: ListTile(
               leading: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 30),
               title: Text(m.name, style: const TextStyle(fontWeight: FontWeight.bold)),
               subtitle: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   if (isExpired) Text('SKT Yaklaşıyor/Doldu: ${DateFormat('dd/MM/yyyy').format(m.expirationDate)}', style: const TextStyle(color: Colors.red)),
                   if (isLowStock) Text('Stok Kritik: ${m.stock} adet', style: const TextStyle(color: Colors.orange)),
                 ],
               ),
               onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => MedicineDetailScreen(medicine: m))
                  );
               },
             ),
          );
        },
      ),
    );
  }
}
