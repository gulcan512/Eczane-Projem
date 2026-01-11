import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../models/medicine.dart';
import '../services/api_service.dart';
import '../providers/medicine_provider.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  // Controllers
  final _nameController = TextEditingController();
  final _activeIngredientController = TextEditingController();
  final _formController = TextEditingController();
  final _companyController = TextEditingController();
  final _stockController = TextEditingController();
  final _searchController = TextEditingController();

  DateTime? _selectedDate;
  bool _isSearching = false;

  void _searchFromApi() async {
    if (_searchController.text.isEmpty) return;

    setState(() => _isSearching = true);
    final result = await _apiService.fetchMedicineByName(_searchController.text);
    setState(() => _isSearching = false);

    if (result != null) {
      _nameController.text = result.name;
      _activeIngredientController.text = result.activeIngredient;
      _formController.text = result.form;
      _companyController.text = result.company;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('İlaç bilgileri getirildi ✅')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('İlaç bulunamadı ❌')),
      );
    }
  }

  void _saveMedicine() async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final newMedicine = Medicine(
        id: const Uuid().v4(),
        name: _nameController.text,
        activeIngredient: _activeIngredientController.text,
        form: _formController.text,
        company: _companyController.text,
        stock: int.parse(_stockController.text),
        expirationDate: _selectedDate!,
        barcode: const Uuid().v4().substring(0, 13).toUpperCase(), // Generating unique barcode
      );

      await Provider.of<MedicineProvider>(context, listen: false).addMedicine(newMedicine);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('İlaç başarıyla eklendi 🎉')),
        );
      }
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen son kullanma tarihi seçin 📅')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni İlaç Ekle')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search Section
              Card(
                color: const Color(0xFFF8BBD0), // Pink.shade50ish
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text('API Sorgulama', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                hintText: 'İlaç adı yazın...',
                                prefixIcon: Icon(Icons.search),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: _isSearching ? null : _searchFromApi,
                            child: _isSearching
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                : const Text('Getir'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              const Text('İlaç Bilgileri', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'İlaç Adı', border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? 'Zorunlu alan' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _activeIngredientController,
                decoration: const InputDecoration(labelText: 'Etken Madde', border: OutlineInputBorder()),
                 validator: (val) => val!.isEmpty ? 'Zorunlu alan' : null,
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _formController,
                      decoration: const InputDecoration(labelText: 'Form (Tablet, vb.)', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _companyController,
                      decoration: const InputDecoration(labelText: 'Firma', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              const Text('Stok & SKT', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _stockController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Stok Adedi', border: OutlineInputBorder()),
                       validator: (val) => val!.isEmpty ? 'Zorunlu alan' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(const Duration(days: 365)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 3650)),
                        );
                        if (date != null) {
                          setState(() => _selectedDate = date);
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Son Kullanma Tarihi',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          _selectedDate == null
                              ? 'Seçiniz'
                              : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              
              ElevatedButton.icon(
                onPressed: _saveMedicine,
                icon: const Icon(Icons.save),
                label: const Text('KAYDET'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF48FB1),
                  padding: const EdgeInsets.all(16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
