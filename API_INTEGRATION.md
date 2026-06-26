# API Integration

The app now talks to the ShopOwner Django backend (the `api` app in
`shopowner_app`) instead of using mock data.

## Layout

```
lib/core/network/
  api_config.dart      # base URL (override with --dart-define=API_BASE_URL=...)
  api_client.dart      # Dio singleton + token interceptor + error → message
lib/data/models/       # ProductModel, OrderModel, DashboardModel
lib/data/repositories/ # auth / product / order / dashboard repositories
lib/presentation/.../cubit/
  auth_cubit.dart      # HydratedCubit — persists token + shop across restarts
  products_cubit.dart, orders_cubit.dart, dashboard_cubit.dart
```

- Auth token is stored in memory (`TokenStore`) for the Dio interceptor and
  persisted via `hydrated_bloc`, so a signed-in user stays signed in.
- `HomePage.initState` loads dashboard, products and orders once authenticated.
  Each list also supports pull-to-refresh.

## Running it

1. Start the backend (from `shopowner_app`):
   ```bash
   ./venv/bin/python manage.py runserver 0.0.0.0:8000
   ./venv/bin/python manage.py seed_demo   # demo@shop.com / password123
   ```
2. Run the app, pointing it at the backend for your target:

   | Target                | Command |
   |-----------------------|---------|
   | iOS sim / desktop/web | `flutter run` (default `http://127.0.0.1:8000/api`) |
   | Android emulator      | `flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000/api` |
   | Physical device       | `flutter run --dart-define=API_BASE_URL=http://<your-LAN-ip>:8000/api` |

   Only the `android/` platform is currently set up. To run on Chrome/desktop,
   add the platform first: `flutter create --platforms=web .`

3. Sign in with `demo@shop.com` / `password123`, or create a new shop account.
