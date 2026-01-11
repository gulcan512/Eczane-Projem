import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/medicine_provider.dart';
import '../models/medicine.dart';
import 'medicine_detail_screen.dart'; // Will create this next

class StockListScreen extends StatefulWidget {
  const StockListScreen({super.key});

  @override
  State<StockListScreen> createState() => _StockListScreenState();
}

class _StockListScreenState extends State<StockListScreen> {
  String _searchQuery = '';
  bool _showExpiredOnly = false;
  bool _showLowStockOnly = false;

  @override
  void initState() {
    super.initState();
    // Refresh list on enter
    Future.microtask(() => 
      Provider.of<MedicineProvider>(context, listen: false).loadMedicines()
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MedicineProvider>(context);
    
    // Filtering logic
    List<Medicine> filteredList = provider.medicines.where((m) {
      final matchesSearch = m.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesExpired = _showExpiredOnly ? m.isExpiringSoon || m.isExpired : true;
      final matchesStock = _showLowStockOnly ? m.stock < 10 : true;
      
      return matchesSearch && matchesExpired && matchesStock;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stok Listesi'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'İlaç Ara...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('SKT Yaklaşanlar'),
                  selected: _showExpiredOnly,
                  onSelected: (val) => setState(() => _showExpiredOnly = val),
                  checkmarkColor: Colors.white,
                  selectedColor: Colors.red.shade200,
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Stok Az'),
                  selected: _showLowStockOnly,
                  onSelected: (val) => setState(() => _showLowStockOnly = val),
                  checkmarkColor: Colors.white,
                  selectedColor: Colors.orange.shade200,
                ),
              ],
            ),
          ),
          
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredList.isEmpty
                    ? const Center(child: Text('Kayıt bulunamadı.'))
                    : ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final medicine = filteredList[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: medicine.isExpired ? Colors.red : (medicine.isExpiringSoon ? Colors.orange : Colors.green),
                                child: Icon(
                                  medicine.isExpired ? Icons.warning : Icons.check,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(medicine.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Stok: ${medicine.stock} | ${medicine.form}"),
                                  Text("SKT: ${DateFormat('dd/MM/yyyy').format(medicine.expirationDate)}"),
                                ],
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () {
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) => MedicineDetailScreen(medicine: medicine))
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
