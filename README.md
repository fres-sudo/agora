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
  <img src="https://img.shields.io/badge/Flutter-3.38+-02569B?style=for-the-badge&logo=flutter" alt="Flutter"/>
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

**Agora** is a modern, offline-first POS (Point of Sale) application designed specifically for Italian **Sagre** (food festivals), **Fiere** (fairs), and community events. Whether you're serving _porchetta_, _arrosticini_, _piadine_, or _vino locale_, Agora helps you manage orders, track inventory, and serve customers faster.

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

### 👥 Workforce Management

- **Employee accounts & PIN login** — Fast operator switching at the counter
- **Roles & permissions** — Cassiere, Admin, and custom roles
- **Clock-in / clock-out** — Track shifts per employee

### 🧾 Guided Onboarding

- **First-run setup wizard** — Business type and profile configuration
- **Capability-driven experience** — Nav and POS adapt to the business profile chosen

### 🖨 Receipt Printing

- **ESC/POS thermal printing** — Bluetooth/USB receipt printers

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

- [FVM](https://fvm.app/) (Required — manages the pinned Flutter SDK version, see `.fvmrc`)
- [Melos](https://melos.invertase.dev/) (`dart pub global activate melos`) — manages the monorepo workspace
- Android Studio / Xcode for mobile development

### Installation

```bash
# Clone the repository
git clone https://github.com/fres-sudo/agora.git
cd agora

# Bootstrap the monorepo (links all packages, runs pub get)
melos bootstrap

# Generate code (Freezed, Drift, AutoRoute, etc.) across all packages
melos run build

# Run the app
cd apps/agora && fvm flutter run
```

### Configuration

```bash
# Generate translations (per-package, uses Slang)
cd packages/i18n && fvm flutter pub run slang

# Generate assets
cd apps/agora && fvm flutter pub run flutter_gen

# Generate launcher icons
cd apps/agora && fvm flutter pub run flutter_launcher_icons
```

---

## 🛠 Tech Stack

| Category                 | Technology                        |
| ------------------------ | --------------------------------- |
| **Framework**            | Flutter 3.38+                     |
| **Monorepo tooling**     | Melos                             |
| **State Management**     | BLoC + flutter_bloc               |
| **Local Database**       | Drift (SQLite)                    |
| **Navigation**           | auto_route                        |
| **DI & Architecture**    | Pine (service locator) + Provider |
| **Models**               | Freezed + json_serializable       |
| **Internationalization** | Slang                             |
| **HTTP Client**          | Dio                               |
| **Logging**              | Talker                            |
| **Feature flags**        | package:feature_flags             |
| **Receipt printing**     | esc_pos_utils_plus (ESC/POS)      |

---

## 📁 Project Structure

Agora is a **Melos-managed Flutter monorepo** with three scopes:

```
agora/
├── apps/
│   └── agora/                 # Flutter entry point (no business logic)
│       └── lib/app/           # bootstrap, provider assembly, routing
│
├── features/                  # Domain-isolated feature packages
│   ├── auth/                  # Authentication & session management
│   ├── onboarding/             # First-run business setup wizard
│   ├── products/               # Product catalog management
│   ├── orders/                 # Order processing
│   ├── inventory/               # Stock management
│   ├── discounts/                # Promotions & pricing rules
│   ├── pos/                       # Point of Sale interface
│   ├── reports/                    # Sales analytics & reporting
│   ├── settings/                    # App configuration
│   └── workforce/                    # Employees, roles, PIN login, clock-in
│       └── lib/
│           ├── data/            # Drift DAOs, DTOs, repository impls
│           ├── domain/          # Freezed models, repository interfaces, mappers
│           └── presentation/    # Blocs, pages, widgets, route registration
│
└── packages/                  # Cross-cutting infrastructure (no business logic)
    ├── ui_kit/                 # Design system, shared widgets
    ├── theme/                  # AppTheme, ThemeCubit
    ├── database/                # AgoraDatabase (Drift), central schema
    ├── sync_engine/              # Offline-first sync primitives
    ├── printing/                  # Receipt building & ESC/POS thermal printing
    ├── feature_flags/              # Business type / capability flags
    ├── i18n/                        # Slang-generated translations
    ├── bloc/                         # flutter_bloc + freezed re-exports
    ├── result/                        # Result<T, E> pattern
    ├── errors/                         # AppException, RepositoryException
    ├── logger/                          # Talker wrapper
    ├── observer/                         # BlocObserver
    ├── remote_config/                     # Remote config abstraction
    ├── app_info/                           # App/package version info
    ├── config/                              # Environment/flavor config
    ├── launcher/                             # App launcher icon generation
    ├── utils/                                 # Extensions, constants
    └── design_lint/                            # Custom lint rules for the design system
```

Each feature package follows a strict `presentation → domain ← data` layering. See [CONTRIBUTING.md](CONTRIBUTING.md) and [docs/architecture/](docs/architecture/) for the full architectural spec, dependency rules, and the multi-app/backend roadmap.

---

## 🤝 Contributing

We welcome contributions from the community! Please read our [Contribution Guidelines](CONTRIBUTING.md) and [Code of Conduct](CODE_OF_CONDUCT.md) before getting started.

### Quick Commands

```bash
# Run tests across all packages
melos run test

# Analyze code across all packages
melos run lint

# Format code across all packages
melos run format

# Full CI quality gate (format + lint + design lint + test)
melos run ci
```

---

## 📋 Roadmap

- [x] 🖨 Receipt printing (ESC/POS thermal printers)
- [x] 👥 Multi-user support with roles (Cassiere, Admin) & PIN login
- [x] 🧭 Guided onboarding & business-profile setup
- [ ] 📊 Sales analytics & reporting dashboard
- [ ] 🔄 Cloud sync via the Agora backend (Hono + Bun + PostgreSQL)
- [ ] 📱 Kitchen display system (KDS) app
- [ ] 🧍 Self-order totem & customer mobile app
- [ ] 💳 Payment integration (SumUp, Satispay)
- [ ] 🎫 Ticket/token system for Sagre

See [docs/architecture/ECOSYSTEM.md](docs/architecture/ECOSYSTEM.md) for the full multi-app/backend build-phase plan.

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

- 🐛 **Bug Reports**: [Open an issue](https://github.com/fres-sudo/agora/issues)
- 💡 **Feature Requests**: [Start a discussion](https://github.com/fres-sudo/agora/discussions)
- 📧 **Contact**: me@fres.space

---

<p align="center">
  <strong>Made in Italy 🇮🇹 for Italian Sagre everywhere</strong>
</p>

<p align="center">
  <sub>If Agora helped your event, consider giving us a ⭐ on GitHub!</sub>
</p>
