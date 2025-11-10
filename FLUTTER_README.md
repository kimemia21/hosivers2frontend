# Hospital Management System - Flutter Application

A production-ready Flutter application for managing hospital records, built to work seamlessly on both web and mobile platforms.

## 📱 Overview

This Flutter application provides a comprehensive interface for the Hospital Records Management System backend. It features role-based access control, real-time data management, and a responsive design that adapts to different screen sizes.

## ✨ Features

- **Authentication & Authorization**
  - Secure login with JWT tokens
  - Role-based access (Admin, Doctor, Pharmacist, Receptionist)
  - Automatic token management and refresh

- **Dashboard**
  - Quick statistics overview
  - Total patients, doctors, inventory items, and prescriptions
  - Low stock and expiring items alerts
  - Navigation to different modules

- **Patient Management**
  - View all patients with pagination
  - Search patients by name, phone, or email
  - View patient medical records
  - Create, update, and delete patients (role-based)

- **Doctor Management**
  - List all doctors with specializations
  - View doctor profiles and departments
  - Manage doctor information (admin only)

- **Inventory Management**
  - Track medications and supplies
  - Filter by low stock and expiring items
  - Batch and expiry date tracking
  - Real-time inventory updates

- **Prescription Management**
  - Create and view prescriptions
  - Filter by status (active, completed, cancelled)
  - Link prescriptions to patients and doctors
  - Automatic inventory deduction

- **Responsive Design**
  - Mobile-first approach
  - Adaptive layouts for tablet and desktop
  - Consistent UI across all platforms

## 🏗️ Architecture

### Folder Structure

```
lib/
├── main.dart                 # Application entry point
├── core/                     # Core utilities and configuration
│   ├── config.dart          # App configuration
│   ├── constants.dart       # Application constants
│   ├── exceptions.dart      # Custom exception classes
│   └── utils.dart           # Utility functions
├── theme/                   # Theme configuration
│   ├── app_theme.dart       # Light and dark themes
│   ├── colors.dart          # Color palette
│   └── text_styles.dart     # Typography styles
├── comms/                   # API communication layer
│   ├── api_client.dart      # Global HTTP client (Dio)
│   ├── api_endpoints.dart   # API endpoint constants
│   └── services/            # Service classes for each resource
│       ├── auth_service.dart
│       ├── patient_service.dart
│       ├── doctor_service.dart
│       ├── department_service.dart
│       ├── inventory_service.dart
│       ├── prescription_service.dart
│       └── audit_service.dart
├── models/                  # Data models
│   ├── user_model.dart
│   ├── patient_model.dart
│   ├── doctor_model.dart
│   ├── department_model.dart
│   ├── inventory_model.dart
│   ├── prescription_model.dart
│   ├── audit_log_model.dart
│   └── api_response.dart
├── state/                   # State management (Riverpod)
│   ├── auth_provider.dart
│   ├── patient_provider.dart
│   ├── doctor_provider.dart
│   ├── department_provider.dart
│   ├── inventory_provider.dart
│   ├── prescription_provider.dart
│   ├── dashboard_provider.dart
│   └── theme_provider.dart
├── screens/                 # UI screens
│   ├── auth/
│   │   └── login_screen.dart
│   ├── dashboard/
│   │   └── dashboard_screen.dart
│   ├── patients/
│   │   └── patients_screen.dart
│   ├── doctors/
│   │   └── doctors_screen.dart
│   ├── inventory/
│   │   └── inventory_screen.dart
│   └── prescriptions/
│       └── prescriptions_screen.dart
└── widgets/                 # Reusable widgets
    ├── app_button.dart
    ├── app_text_field.dart
    ├── dashboard_card.dart
    ├── loading_indicator.dart
    ├── error_view.dart
    ├── empty_view.dart
    └── responsive_layout.dart
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK (included with Flutter)
- An IDE (VS Code, Android Studio, or IntelliJ IDEA)
- Node.js backend running (see backend documentation)

### Installation

1. **Clone the repository** (if not already done)
   ```bash
   cd hospital_management_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate model files**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Configure API base URL**
   
   Edit `lib/core/constants.dart` to set your backend URL:
   ```dart
   static const String apiBaseUrl = String.fromEnvironment(
     'API_BASE_URL',
     defaultValue: 'http://localhost:4000/api/v1',
   );
   ```
   
   Or pass it as an environment variable when running:
   ```bash
   flutter run --dart-define=API_BASE_URL=http://your-api-url.com/api/v1
   ```

### Running the Application

#### Web
```bash
flutter run -d chrome
```

#### Mobile (Android/iOS)
```bash
# Android
flutter run -d android

# iOS (macOS only)
flutter run -d ios
```

#### All platforms
```bash
flutter run
```

### Building for Production

#### Web
```bash
flutter build web --release
```
Output will be in `build/web/`

#### Android APK
```bash
flutter build apk --release
```

#### Android App Bundle
```bash
flutter build appbundle --release
```

#### iOS (macOS only)
```bash
flutter build ios --release
```

## 🔐 Authentication

The app uses JWT token-based authentication. Upon login, the token is securely stored using `flutter_secure_storage` and automatically attached to all API requests.

### Default Test Credentials

- **Admin**: alice@hospital.com / Admin@123
- **Doctor**: john.smith@hospital.com / Doctor@123
- **Pharmacist**: sarah.johnson@hospital.com / Pharmacist@123

## 🎨 Theming

The app supports both light and dark themes. Users can toggle between themes (feature can be added to UI).

### Customization

Edit theme files in `lib/theme/`:
- `colors.dart` - Color palette
- `text_styles.dart` - Typography
- `app_theme.dart` - Complete theme configuration

## 📡 State Management

The application uses **Riverpod** for state management, providing:

- **Reactive UI updates**: Widgets automatically rebuild when data changes
- **Provider-based architecture**: Clean separation of business logic and UI
- **Efficient caching**: Reduces unnecessary API calls
- **Type-safe**: Compile-time safety for state access

### Key Providers

- `currentUserProvider` - Current authenticated user
- `patientsProvider` - Patients list with pagination
- `doctorsProvider` - Doctors list
- `inventoryProvider` - Inventory with filters
- `prescriptionsProvider` - Prescriptions with filters
- `dashboardStatsProvider` - Dashboard statistics

## 🌐 API Communication

The `ApiClient` class (using Dio) handles all HTTP communication:

### Features

- **Automatic token attachment**: JWT tokens added to all requests
- **Global error handling**: Converts HTTP errors to app-specific exceptions
- **Retry logic**: Configurable retry on network failures
- **Request/response logging**: Debug mode logging
- **Timeout handling**: Configurable timeouts

### Adding New Endpoints

1. Add endpoint constant in `lib/comms/api_endpoints.dart`
2. Create service class in `lib/comms/services/`
3. Create provider in `lib/state/`
4. Use in UI screens

## 📱 Responsive Design

The app uses adaptive layouts:

- **Mobile** (<600px): Single column, bottom navigation
- **Tablet** (600-1200px): Two columns, side navigation
- **Desktop** (>1200px): Multi-column grid, persistent navigation

Use the `ResponsiveLayout` widget for adaptive UI:

```dart
ResponsiveLayout(
  mobile: MobileView(),
  tablet: TabletView(),
  desktop: DesktopView(),
)
```

## 🧪 Testing

### Run Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

### Integration Tests
```bash
flutter test integration_test/
```

## 🚀 Performance Optimization

### Implemented Optimizations

1. **Const Constructors**: Used throughout for better performance
2. **Pagination**: All list views use pagination to reduce data load
3. **Caching**: Providers cache data to minimize API calls
4. **Lazy Loading**: Data loaded only when needed
5. **Image Optimization**: (When images are added, use cached network images)

### Best Practices

- Keep build methods pure and fast
- Avoid rebuilding entire widget trees
- Use `const` constructors wherever possible
- Implement proper `dispose()` methods
- Use `ListView.builder` for long lists

## 🔒 Security

### Implemented Security Features

1. **Secure Token Storage**: Uses `flutter_secure_storage`
2. **HTTPS Only**: Production builds enforce HTTPS
3. **Input Validation**: All forms validate input
4. **Role-based Access**: UI adapts to user permissions
5. **Auto-logout**: Session expiry handling

### Security Checklist for Production

- [ ] Enable HTTPS/SSL
- [ ] Implement certificate pinning
- [ ] Obfuscate code for release builds
- [ ] Enable R8/ProGuard for Android
- [ ] Use environment variables for sensitive data
- [ ] Implement biometric authentication (optional)

## 📦 Dependencies

### Core Dependencies

```yaml
flutter_riverpod: ^2.4.9      # State management
dio: ^5.4.0                    # HTTP client
shared_preferences: ^2.2.2    # Local storage
flutter_secure_storage: ^9.0.0 # Secure storage
json_annotation: ^4.8.1        # JSON serialization
intl: ^0.19.0                  # Internationalization
logger: ^2.0.2+1               # Logging
```

### UI Dependencies

```yaml
fl_chart: ^0.66.0              # Charts and graphs
google_fonts: ^6.1.0           # Custom fonts
shimmer: ^3.0.0                # Loading shimmer effect
```

### Dev Dependencies

```yaml
build_runner: ^2.4.7           # Code generation
json_serializable: ^6.7.1      # JSON serialization
flutter_lints: ^5.0.0          # Linting rules
```

## 🛠️ Development

### Code Generation

When you modify model files:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Watch mode (auto-regenerate on changes):

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Adding New Models

1. Create model class with `@JsonSerializable()` annotation
2. Add fields with proper annotations
3. Run code generation
4. Create service class
5. Create provider
6. Use in UI

### Linting

```bash
flutter analyze
```

### Format Code

```bash
flutter format lib/
```

## 🐛 Troubleshooting

### Common Issues

**Issue**: Build runner fails
```bash
# Solution: Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

**Issue**: API connection fails
```bash
# Solution: Check API base URL in constants.dart
# Ensure backend is running
# Check CORS settings on backend
```

**Issue**: iOS build fails
```bash
# Solution: Update CocoaPods
cd ios
pod install
cd ..
```

**Issue**: Web CORS errors
```bash
# Solution: Run with web-renderer=html
flutter run -d chrome --web-renderer html
```

## 📈 Future Enhancements

### Planned Features

- [ ] Offline mode with local database
- [ ] Push notifications
- [ ] Biometric authentication
- [ ] File upload for patient documents
- [ ] Advanced reporting and analytics
- [ ] Export data to PDF/Excel
- [ ] Multi-language support
- [ ] Real-time updates using WebSockets
- [ ] Advanced search and filters
- [ ] Appointment scheduling

### Contributing

To add new features:

1. Create a new branch
2. Follow the existing architecture
3. Add tests for new features
4. Update documentation
5. Submit pull request

## 📄 License

MIT License

## 🆘 Support

For issues or questions:

- Check the documentation
- Review the backend API documentation
- Create an issue in the repository
- Check logs for error messages

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Dio Documentation](https://pub.dev/packages/dio)
- [Material Design Guidelines](https://material.io/design)

## 🔄 Version History

**v1.0.0** - Initial Release
- Authentication and authorization
- Patient management
- Doctor management
- Inventory management
- Prescription management
- Dashboard with statistics
- Responsive design for web and mobile

---

**Built with ❤️ using Flutter**
