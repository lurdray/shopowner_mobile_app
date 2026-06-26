/// Base URL for the ShopOwner Django backend (the `api` app, served under /api/).
///
/// Defaults to the live server. Override at run time for local development, e.g.:
///   flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000/api      # iOS sim / desktop / web
///   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000/api       # Android emulator
///   flutter run --dart-define=API_BASE_URL=http://<your-LAN-ip>:8000/api  # physical device
const String kApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://shopowner.app/api',
);
