<p align="center">
  <img src="assets/brand/branding.png" alt="Agora POS" width="400"/>
</p>

<h1 align="center">🍝 Agora POS</h1>

<p align="center">
  <strong>A free and open source Point of Sale system for Italian Food Festivals</strong>
</p>

<p align="center">
  <em>Built with ❤️ for Sagre, Fiere, and community food events across Italy</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-blue?style=for-the-badge" alt="Platform"/>
  <img src="https://img.shields.io/badge/Flutter-3.10+-02569B?style=for-the-badge&logo=flutter" alt="Flutter"/>
  <img src="https://img.shields.io/badge/License-AGPL--3.0-green?style=for-the-badge" alt="License"/>
</p>

<p align="center">
  <a href="#-features">Features</a> •
  <a href="#-screenshots">Screenshots</a> •
  <a href="#-quick-start">Quick Start</a> •
  <a href="#-tech-stack">Tech Stack</a> •
  <a href="#-project-structure">Structure</a> •
  <a href="#-contributing">Contributing</a>
</p>

---

## 🎯 What is Agora?

**Agora** is a modern, offline-first POS (Point of Sale) application designed specifically for Italian **Sagre** (food festivals), **Fiere** (fairs), and community events. Whether you're serving *porchetta*, *arrosticini*, *piadine*, or *vino locale*, Agora helps you manage orders, track inventory, and serve customers faster.

> 📍 **Why "Agora"?** — Named after the ancient Greek marketplace, Agora represents the heart of community gatherings where food, culture, and people come together.

---

## ✨ Features

### 📱 Point of Sale
- **Fast order entry** — Optimized touch interface for high-volume service
- **Product categories** — Organize items by course (Primi, Secondi, Dolci, Bevande)
- **Modifier groups** — Handle customizations (size, toppings, cooking preferences)
- **Quick checkout** — Complete transactions in seconds

### 📦 Inventory Management
- **Real-time stock tracking** — Know exactly what you have left
- **Low stock alerts** — Never run out of popular items mid-service
- **Batch adjustments** — Quickly update quantities after restocking

### 🧾 Order Management
- **Order history** — Complete transaction records
- **Order status tracking** — Pending, Completed, Voided
- **Line item details** — Track each product with modifiers
- **Notes & special requests** — Handle customer preferences

### 💰 Financial Tracking
- **Subtotals & grand totals** — Accurate calculations in cents
- **Tax calculation** — Configure for local regulations
- **Discount support** — Apply promotions and special offers

### 🌐 Multi-Platform
- **Android** — Tablets and phones
- **iOS** — iPads for elegant counter setup
- **Web** — Browser-based access for flexibility

### 🔒 Offline-First
- **Local SQLite database** — Works without internet
- **Sync when connected** — Never lose a sale
- **Fast & reliable** — No network latency

---

## 📸 Screenshots

<p align="center">
  <em>Screenshots coming soon — Stay tuned! 🎬</em>
</p>

<!-- Add your screenshots here
<p align="center">
  <img src="docs/screenshots/pos-screen.png" width="280"/>
  <img src="docs/screenshots/products-screen.png" width="280"/>
  <img src="docs/screenshots/orders-screen.png" width="280"/>
</p>
-->

---

## 🚀 Quick Start

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) 3.10.0 or higher
- [FVM](https://fvm.app/) (recommended for version management)
- Android Studio / Xcode for mobile development

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/agora.git
cd agora

# Install dependencies
flutter pub get

# Generate code (Freezed, Drift, AutoRoute, etc.)
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### Configuration

```bash
# Generate translations
flutter pub run slang

# Generate assets
flutter pub run flutter_gen

# Generate launcher icons
flutter pub run flutter_launcher_icons
```

---

## 🛠 Tech Stack

| Category | Technology |
|----------|------------|
| **Framework** | Flutter 3.10+ |
| **State Management** | BLoC + flutter_bloc |
| **Local Database** | Drift (SQLite) |
| **Navigation** | auto_route |
| **DI & Architecture** | Pine (Service Locator) |
| **Models** | Freezed + json_serializable |
| **Internationalization** | Slang |
| **HTTP Client** | Dio |
| **Logging** | Talker |

---

## 📁 Project Structure

```
lib/
├── auth/              # Authentication & session management
│   ├── cubits/        # Auth state management
│   ├── pages/         # Login, registration screens
│   └── repositories/  # Auth data layer
│
├── core/              # Shared utilities & foundation
│   ├── database/      # Drift database setup
│   ├── cubits/        # Global state (theme, locale)
│   ├── routes/        # AutoRoute configuration
│   ├── ui/            # Theme, design system
│   └── i18n/          # Translations
│
├── products/          # Product catalog management
│   ├── models/        # Product, Category, Modifier entities
│   └── services/      # Data access & repositories
│
├── orders/            # Order processing
│   ├── models/        # Order, OrderLineItem, SelectedModifiers
│   └── local/         # Local database operations
│
├── inventory/         # Stock management
│   └── services/      # Stock tracking & adjustments
│
├── discounts/         # Promotions & pricing rules
│   └── services/      # Discount calculations
│
├── pos/               # Point of Sale interface
│   └── pages/         # Main POS screen
│
├── settings/          # App configuration
│   ├── models/        # Settings entities
│   └── services/      # Preferences persistence
│
└── main.dart          # App entry point
```

---

## 🤝 Contributing

We welcome contributions from the community! Whether you're fixing bugs, adding features, or improving documentation, your help makes Agora better for everyone.

### How to Contribute

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Setup

```bash
# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format lib/
```

---

## 📋 Roadmap

- [ ] 🖨 Receipt printing (ESC/POS thermal printers)
- [ ] 📊 Sales analytics & reporting dashboard
- [ ] 👥 Multi-user support with roles (Cassiere, Admin)
- [ ] 🔄 Cloud sync with Supabase
- [ ] 📱 Kitchen display system (KDS) integration
- [ ] 💳 Payment integration (SumUp, Satispay)
- [ ] 🎫 Ticket/token system for Sagre

---

## 📄 License

Agora is released under the **[GNU Affero General Public License v3.0](LICENSE)** (AGPL-3.0).

This means you're free to:
- ✅ Use the software for any purpose
- ✅ Study and modify the source code
- ✅ Distribute copies
- ✅ Distribute your modifications

With the requirement that:
- 📝 You must disclose your source code if you run a modified version on a server

---

## 💬 Community & Support

- 🐛 **Bug Reports**: [Open an issue](https://github.com/yourusername/agora/issues)
- 💡 **Feature Requests**: [Start a discussion](https://github.com/yourusername/agora/discussions)
- 📧 **Contact**: your.email@example.com

---

<p align="center">
  <strong>Made in Italy 🇮🇹 for Italian Sagre everywhere</strong>
</p>

<p align="center">
  <sub>If Agora helped your event, consider giving us a ⭐ on GitHub!</sub>
</p>
