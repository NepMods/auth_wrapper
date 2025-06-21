# auth_wrapper

`auth_wrapper` is a lightweight and customizable Flutter package to manage public and protected routes with async authentication checks. Ideal for apps where login state must be verified before loading protected content.

---

## ✨ Features

- ✅ Easy route-based auth protection
- 🔐 Supports both public and protected pages
- 🔄 Async authentication check with loading handler hooks
- 🧩 Integrates directly into your `MaterialApp`
- 🧱 Static and builder-based route support

---

## 🚀 Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  auth_wrapper:
    git:
      url: https://github.com/nepmods/auth_wrapper.git
```

Or, if published:

```yaml
dependencies:
  auth_wrapper: ^1.0.0
```

---

## 🧩 Usage

### 1. Define your routes

```dart
final publicPages = [
  AuthRoute.static('/login', const LoginPage()),
];

final protectedPages = [
  AuthRoute.static('/home', const HomePage()),
];
```

> Alternatively, use `AuthRoute.builder` for dynamic pages with arguments.

---

### 2. Wrap your app with `UseAuth`

```dart
UseAuth(
  publicPages: publicPages,
  protectedPages: protectedPages,
  noAuth: '/login',             // fallback if not authenticated
  success: '/home',             // first route after login
  checkFunc: () async {
    // Your auth logic here
    return await AuthService.isLoggedIn();
  },
  showLoading: () => showDialog(...),
  hideLoading: () => Navigator.pop(context),
  app: MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'My App',
    home: const SplashScreen(),
  ),
)
```

---

### 3. Protect individual widgets

You can also use `AuthWrapper` directly:

```dart
AuthWrapper(
  checkFunc: () async => await AuthService.isLoggedIn(),
  fallbackRoute: '/login',
  showLoading: () => showDialog(...),
  hideLoading: () => Navigator.pop(context),
  child: MyProtectedWidget(),
)
```

---

## 📦 AuthRoute Options

| Constructor       | Description                                     |
|-------------------|-------------------------------------------------|
| `AuthRoute.static`| Pass a static widget for the route              |
| `AuthRoute.builder`| Provide a builder for dynamic routes with args |

---

## 📄 Example

See the [example/](example/) directory for a complete app setup.

---

## 📜 License

[MIT](LICENSE)

---

## 🤝 Contributing

Pull requests are welcome! If you find a bug or want a feature, feel free to open an issue.

---

## 📬 Contact

Made with ❤️ by [NepMods](https://github.com/nepmods)
