# 🚀 Quick Start Guide - Hospital Management System

Get up and running in 5 minutes!

## Prerequisites Check

```bash
# Check Flutter
flutter --version
# Should show Flutter 3.9.2 or higher

# Check Node.js (for backend)
node --version
# Should show v18 or higher

# Check if backend is running
curl http://localhost:4000/api/v1/health
# Should return: {"status":"success","message":"Server is running"}
```

## 1️⃣ Start the Backend (If Not Running)

```bash
cd /Users/kimemiathuku/Desktop/gnnovation/hosi/backend/backend

# Install dependencies (first time only)
npm install

# Run migrations (first time only)
npm run migrate:latest

# Seed database with test data (first time only)
npm run seed:run

# Start server
npm start
```

Backend will run at: `http://localhost:4000`

## 2️⃣ Start the Flutter App

```bash
cd /Users/kimemiathuku/Desktop/gnnovation/hosi/app

# Install dependencies (first time only)
flutter pub get

# Generate model files (first time only)
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app - WEB
flutter run -d chrome

# OR run on mobile (if device/emulator connected)
flutter run
```

## 3️⃣ Login to the App

Use these test credentials:

**Admin (Full Access):**
- Email: `alice@hospital.com`
- Password: `Admin@123`

**Doctor:**
- Email: `john.smith@hospital.com`
- Password: `Doctor@123`

**Pharmacist:**
- Email: `sarah.johnson@hospital.com`
- Password: `Pharmacist@123`

## 4️⃣ Explore the Features

### Dashboard
- View statistics for patients, doctors, inventory, and prescriptions
- Click on any card to navigate to that module
- See alerts for low stock and expiring items

### Patients Module
- View list of all patients
- Search by name, phone, or email
- Click on a patient to view details (coming soon)

### Doctors Module
- View all doctors with specializations
- See department assignments

### Inventory Module
- View all medications and supplies
- Filter by "Low Stock" or "Expiring Soon"
- See expiry dates and batch numbers

### Prescriptions Module
- View all prescriptions
- Filter by status (Active, Completed, Cancelled)
- See patient and doctor information

## 🔧 Configuration

### Change API URL

Edit `lib/core/constants.dart`:

```dart
static const String apiBaseUrl = 'http://localhost:4000/api/v1';
```

Or use environment variable:

```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://your-api-url/api/v1
```

### Enable Dark Mode

In the app, you can toggle themes (feature can be added to UI, or modify `lib/state/theme_provider.dart`)

## 🐛 Troubleshooting

### Backend Not Accessible

```bash
# Check if backend is running
curl http://localhost:4000/api/v1/health

# If not, start it
cd /Users/kimemiathuku/Desktop/gnnovation/hosi/backend/backend
npm start
```

### Flutter Build Errors

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### CORS Errors on Web

The backend already has CORS enabled. If you still see errors:

```bash
# Run Flutter with specific renderer
flutter run -d chrome --web-renderer html
```

### Can't Login

Make sure:
1. Backend is running at `http://localhost:4000`
2. Database has been seeded with test users
3. You're using correct credentials (see above)

## 📱 Build for Production

### Web
```bash
flutter build web --release
# Output in: build/web/
```

### Android
```bash
flutter build apk --release
# Output in: build/app/outputs/flutter-apk/app-release.apk
```

### iOS (macOS only)
```bash
flutter build ios --release
```

## 📚 Documentation

- **API Documentation**: `API_DOCUMENTATION.md`
- **Flutter Guide**: `FLUTTER_README.md`
- **Project Summary**: `PROJECT_SUMMARY.md`

## 🎯 Next Steps

1. ✅ Login and explore the dashboard
2. ✅ Navigate through different modules
3. ✅ Test search and filter features
4. 🔄 Customize theme colors in `lib/theme/colors.dart`
5. 🔄 Add new features following the existing architecture
6. 🔄 Deploy to production

## 🆘 Need Help?

Check these files in order:
1. This file (QUICKSTART.md) - Quick setup
2. FLUTTER_README.md - Detailed Flutter guide
3. API_DOCUMENTATION.md - Complete API reference
4. PROJECT_SUMMARY.md - Overall project overview

## ✨ You're Ready!

The app is now running. Enjoy exploring the Hospital Management System! 🏥

---

**Quick Reference Commands:**

```bash
# Backend
cd /Users/kimemiathuku/Desktop/gnnovation/hosi/backend/backend && npm start

# Flutter Web
cd /Users/kimemiathuku/Desktop/gnnovation/hosi/app && flutter run -d chrome

# Flutter Mobile
cd /Users/kimemiathuku/Desktop/gnnovation/hosi/app && flutter run

# Rebuild Models
cd /Users/kimemiathuku/Desktop/gnnovation/hosi/app && flutter pub run build_runner build --delete-conflicting-outputs

# Run Tests
cd /Users/kimemiathuku/Desktop/gnnovation/hosi/app && flutter test
```
