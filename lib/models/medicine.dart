
// Actually, to avoid build_runner, I will implement the adapter in a separate file or right here.

class Medicine {
  final String id;
  final String name;
  final String activeIngredient;
  final String form;
  final String company;
  int stock;
  DateTime expirationDate;
  final String barcode;

  Medicine({
    required this.id,
    required this.name,
    required this.activeIngredient,
    required this.form,
    required this.company,
    required this.stock,
    required this.expirationDate,
    required this.barcode,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'activeIngredient': activeIngredient,
      'form': form,
      'company': company,
      'stock': stock,
      'expirationDate': expirationDate.toIso8601String(),
      'barcode': barcode,
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      name: map['name'],
      activeIngredient: map['activeIngredient'],
      form: map['form'],
      company: map['company'],
      stock: map['stock'],
      expirationDate: DateTime.parse(map['expirationDate']),
      barcode: map['barcode'],
    );
  }
  
  // Helper to check if expired
  bool get isExpired => DateTime.now().isAfter(expirationDate);
  
  // Helper to check if expiring soon (30 days)
  bool get isExpiringSoon {
    final difference = expirationDate.difference(DateTime.now()).inDays;
    return difference >= 0 && difference <= 30;
  }
}
