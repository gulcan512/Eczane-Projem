import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class MedicineApiInfo {
  final String name;
  final String activeIngredient;
  final String form;
  final String company;

  MedicineApiInfo({
    required this.name,
    required this.activeIngredient,
    required this.form,
    required this.company,
  });
}

class ApiService {
  // Mock Database for Turkish Medicines (Priority)
  final List<MedicineApiInfo> _mockMedicines = [
    MedicineApiInfo(name: "Parol", activeIngredient: "Parasetamol", form: "Tablet", company: "Atabay"),
    MedicineApiInfo(name: "Majezik", activeIngredient: "Flurbiprofen", form: "Tablet", company: "Sanovel"),
    MedicineApiInfo(name: "Aspirin", activeIngredient: "Asetilsalisilik Asit", form: "Tablet", company: "Bayer"),
    MedicineApiInfo(name: "Calpol", activeIngredient: "Parasetamol", form: "Şurup", company: "GSK"),
    MedicineApiInfo(name: "Augmentin", activeIngredient: "Amoksisilin", form: "Tablet", company: "GSK"),
    MedicineApiInfo(name: "Dolorex", activeIngredient: "Diklofenak Potasyum", form: "Draje", company: "Abdi İbrahim"),
    MedicineApiInfo(name: "Arveles", activeIngredient: "Deksketoprofen", form: "Tablet", company: "Menarini"),
    MedicineApiInfo(name: "Apranax", activeIngredient: "Naproksen Sodyum", form: "Tablet", company: "Abdi İbrahim"),
    MedicineApiInfo(name: "Tylolhot", activeIngredient: "Parasetamol", form: "Toz", company: "Nobel"),
  ];

  Future<MedicineApiInfo?> fetchMedicineByName(String name) async {
    final normalizedQuery = name.toLowerCase().trim();
    
    // 1. Try Mock Data First (Turkish)
    try {
      return _mockMedicines.firstWhere(
        (m) => m.name.toLowerCase().contains(normalizedQuery),
      );
    } catch (e) {
      // Not found in mock, continue to API
    }

    // 2. Try OpenFDA API (Global/English)
    try {
      final url = Uri.parse('https://api.fda.gov/drug/label.json?search=openfda.brand_name:"$normalizedQuery"&limit=1');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          final result = data['results'][0]['openfda'];
          
          String form = "Tablet/Other";
          if (result['dosage_form'] != null) {
            form = (result['dosage_form'] as List).first.toString();
          }

          String company = "Unknown";
          if (result['manufacturer_name'] != null) {
            company = (result['manufacturer_name'] as List).first.toString();
          }
          
          String ingredient = "Unknown";
          if (result['substance_name'] != null) {
            ingredient = (result['substance_name'] as List).take(2).join(", ");
          } else if (result['generic_name'] != null) {
             ingredient = (result['generic_name'] as List).first.toString();
          }

          String brandName = name;
           if (result['brand_name'] != null) {
            brandName = (result['brand_name'] as List).first.toString();
          }

          return MedicineApiInfo(
            name: brandName,
            activeIngredient: ingredient,
            form: form,
            company: company,
          );
        }
      }
    } catch (e) {
      debugPrint("API Error: $e");
      return null;
    }
    
    return null;
  }

  // Search logic for dropdowns if needed later
  Future<List<MedicineApiInfo>> searchMedicines(String query) async {
     await Future.delayed(const Duration(milliseconds: 300));
     final normalizedQuery = query.toLowerCase().trim();
     return _mockMedicines.where((m) => m.name.toLowerCase().contains(normalizedQuery)).toList();
  }
}
