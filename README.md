# Onboarding App

iOS onboarding application with multi-step questionnaire and subscription paywall integration.

![iOS](https://img.shields.io/badge/iOS-16.0+-black?logo=apple)
![Swift](https://img.shields.io/badge/Swift-5.9+-orange?logo=swift)

## 📱 Features

- ✅ Multi-step onboarding questionnaire
- ✅ Dynamic question loading from API
- ✅ Smooth animations between steps
- ✅ Subscription paywall with 7-day free trial
- ✅ StoreKit 2 integration
- ✅ Custom UI components
- ✅ Loading states and error handling
- ✅ Programmatic UI (no Storyboards)

## 🛠️ Tech Stack

- **Language:** Swift 5.9+
- **Minimum iOS:** 16.0+
- **Architecture:** MVVM + Coordinator
- **Reactive:** RxSwift 6.7+
- **Layout:** SnapKit (Programmatic UI)
- **Networking:** async/await
- **IAP:** StoreKit 2

### Key Principles
- **Separation of Concerns:** Clear boundaries between UI, business logic, and navigation
- **Reactive Programming:** RxSwift for data binding and event handling
- **Coordinator Pattern:** Decoupled navigation logic

### Testing In-App Purchases

The project includes a StoreKit Configuration File for local testing:
- No App Store Connect setup required
- Test purchases without real money
- Accelerated subscription renewal for testing

## 🔄 Data Flow

### Onboarding Flow
```
1. User opens app
   ↓
2. OnboardingViewController loads
   ↓
3. ViewModel fetches questions (API)
   ↓
4. User answers questions
   ↓
5. Navigate to Paywall
```

### Subscription Flow
```
1. PaywallViewController loads
   ↓
2. Load products from StoreKit
   ↓
3. User taps "Start Now"
   ↓
4. Purchase flow (7-day free trial)
   ↓
5. Complete onboarding
```

## 🤝 Contributing

This is a test task project and is not open for contributions.

## 📄 License

This project is created as a test task and is for demonstration purposes only.

## 👤 Author

**[Yaroslav Homziak]**
- Email: ywgk0102@gmail.com
- LinkedIn: [Yaroslav Homziak](https://www.linkedin.com/in/yaroslav-homziak/)
- GitHub: [@iOSYahoCode](https://github.com/iOSYahoCode)