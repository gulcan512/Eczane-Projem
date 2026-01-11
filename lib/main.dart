import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

// Services & Providers
import 'services/auth_service.dart';
import 'providers/medicine_provider.dart';

// Screens
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_medicine_screen.dart';
import 'screens/stock_list_screen.dart';
import 'screens/scan_screen.dart';
import 'screens/alerts_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => MedicineProvider()),
      ],
      child: const EczanemApp(),
    ),
  );
}

class EczanemApp extends StatelessWidget {
  const EczanemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eczanem Stok & SKT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.pink, // Fallback
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFC0CB), // Toz Pembe (Powder Pink)
          primary: const Color(0xFFF48FB1), // Darker pink for better visibility
          secondary: const Color(0xFFF8BBD0),
        ),
        textTheme: GoogleFonts.outfitTextTheme(Theme.of(context).textTheme),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Color(0xFFF48FB1),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/add_medicine': (context) => const AddMedicineScreen(),
        '/stock_list': (context) => const StockListScreen(),
        '/scan': (context) => const ScanScreen(),
        '/alerts': (context) => const AlertsScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text("Sayfa Bulunamadı"))));
      },
    );
  }
}
