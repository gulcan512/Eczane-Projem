import 'package:hive/hive.dart';
import '../models/medicine.dart';

class DatabaseHelper {
  static const String _boxName = 'medicinesBox';

  Future<Box> get _box async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    } else {
      return await Hive.openBox(_boxName);
    }
  }

  Future<void> addMedicine(Medicine medicine) async {
    final box = await _box;
    await box.put(medicine.id, medicine.toMap());
  }

  Future<List<Medicine>> getAllMedicines() async {
    final box = await _box;
    final List<Medicine> medicines = [];
    for (var key in box.keys) {
      final map = Map<String, dynamic>.from(box.get(key));
      medicines.add(Medicine.fromMap(map));
    }
    return medicines;
  }

  Future<void> updateMedicine(Medicine medicine) async {
    final box = await _box;
    await box.put(medicine.id, medicine.toMap());
  }

  Future<void> deleteMedicine(String id) async {
    final box = await _box;
    await box.delete(id);
  }
  
  Future<Medicine?> getMedicineByBarcode(String barcode) async {
     final medicines = await getAllMedicines();
     try {
       return medicines.firstWhere((m) => m.barcode == barcode);
     } catch (e) {
       return null;
     }
  }
}
