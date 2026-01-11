# Eczanem - İlaç Stok ve SKT Takip Sistemi

Bu proje, eczaneler ve ilaç depoları için geliştirilmiş mobil uyumlu (Android & Web) bir stok takip uygulamasıdır. Flutter ile geliştirilmiş olup, son kullanma tarihi (SKT) yönetimi, stok takibi ve barkod işlemleri üzerine odaklanmıştır.

## 🚀 Özellikler

- **Personel Girişi**: Güvenli giriş sistemi (Dummy Auth: `admin@eczanem.com` / `123456`).
- **Dashboard**: Hızlı erişim menüsü ve özet bilgiler.
- **İlaç Ekleme**:
  - API (Mock) üzerinden ilaç adı ile otomatik bilgi çekme.
  - Manuel stok ve SKT girişi.
  - Otomatik barkod oluşturma (Code128 / QR).
- **Stok Listesi**:
  - Tüm ilaçları listeleme.
  - İsim ile arama yapma.
  - **Filtreler**: SKT yaklaşanlar ve stoğu azalanlar.
- **Barkod Sistemi**:
  - Kamera ile barkod okuma (`mobile_scanner`).
  - İlaç detaylarına hızlı erişim.
  - Barkod görüntüleme ve yazdırma simülasyonu.
- **Uyarı Sistemi**: Son kullanma tarihi yaklaşan (30 gün) veya biten ilaçlar için otomatik uyarılar.

## 🛠️ Teknoloji Yığını

- **Framework**: Flutter (Dart)
- **State Management**: Provider
- **Local Database**: Hive (NoSQL)
- **UI Kit**: Material Design 3, Google Fonts (Outfit)
- **Barkod**: `qr_flutter` (Oluşturma), `mobile_scanner` (Okuma)

## 📂 Kurulum ve Çalıştırma

1. Projeyi klonlayın veya indirin.
2. Bağımlılıkları yükleyin:
   ```bash
   flutter pub get
   ```
3. Uygulamayı çalıştırın:
   ```bash
   flutter run
   ```

## 📱 Ekran Görüntüleri / Akış

1. **Giriş Ekranı**: E-posta ve şifre ile giriş.
2. **Ana Sayfa**: İlaç Ekle, Stok Listesi, Barkod Oku kısayolları.
3. **İlaç Ekle**: İlaç ismini yazıp API'den çekin, stoğu girin, tarihi seçin ve kaydedin.
4. **Stok Listesi**: Eklenen ilaçları yeşil (güvenli), turuncu (yaklaşan), kırmızı (geçmiş) renk kodları ile görün.

## ⚠️ Notlar
- API servisi şu an için "Mock" (sahte) veri döndürmektedir (`api_service.dart` içerisinde tanımlı).
- Veritabanı olarak Hive kullanıldığından veriler cihazda yerel olarak saklanır. Uygulamayı silerseniz veriler kaybolur.

---
**Geliştirici**: Antigravity (Google DeepMind)
