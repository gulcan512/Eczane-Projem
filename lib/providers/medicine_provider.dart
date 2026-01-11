import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../database/db_helper.dart';

class MedicineProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Medicine> _medicines = [];
  bool _isLoading = false;

  List<Medicine> get medicines => _medicines;
  bool get isLoading => _isLoading;

  Future<void> loadMedicines() async {
    _isLoading = true;
    notifyListeners();
    _medicines = await _dbHelper.getAllMedicines();
    _medicines.sort((a, b) => a.expirationDate.compareTo(b.expirationDate)); // Sort by expiry
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addMedicine(Medicine medicine) async {
    await _dbHelper.addMedicine(medicine);
    await loadMedicines();
  }

  Future<void> deleteMedicine(String id) async {
    await _dbHelper.deleteMedicine(id);
    await loadMedicines();
  }

  Future<void> updateMedicine(Medicine medicine) async {
    await _dbHelper.updateMedicine(medicine);
    await loadMedicines();
  }
  
  Medicine? findByBarcode(String barcode) {
    try {
      return _medicines.firstWhere((m) => m.barcode == barcode);
    } catch (e) {
      return null;
    }
  }
  
  List<Medicine> search(String query) {
    if (query.isEmpty) return _medicines;
    return _medicines.where((m) => m.name.toLowerCase().contains(query.toLowerCase())).toList();
  }

  // Filter for expiring soon or low stock
  List<Medicine> get expiringSoon {
    return _medicines.where((m) => m.isExpiringSoon).toList();
  }
  
   List<Medicine> get lowStock {
    return _medicines.where((m) => m.stock < 10).toList(); // threshold 10
  }
}
