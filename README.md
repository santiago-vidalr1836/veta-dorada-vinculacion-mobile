# veta_dorada_vinculacion_mobile

Aplicacion movil para poder realizar tareas de verificacion

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Environment Configuration

The application expects several compile‑time environment variables for Azure
AD authentication. Provide them when running or building the app using
`--dart-define`:

| Variable | Description |
|----------|-------------|
| `CLIENT_ID` | Azure application (client) identifier. |
| `TENANT_ID` | Azure AD tenant identifier. |
| `DEFAULT_SCOPES` | Space- or comma-separated list of scopes, e.g. `User.Read`. |

Example:

```bash
flutter run \
  --dart-define=CLIENT_ID=your_client_id \
  --dart-define=TENANT_ID=your_tenant_id \
  --dart-define=DEFAULT_SCOPES="User.Read"
```

## Run on Android Emulator

List available emulators with `flutter devices` or `flutter emulators` to find
their identifiers.

Launch the app on a specific emulator, supplying the same compile-time
environment variables:

```bash
flutter run -d emulator-5554 \
  --dart-define=CLIENT_ID=your_client_id \
  --dart-define=TENANT_ID=your_tenant_id \
  --dart-define=DEFAULT_SCOPES="User.Read"
```

These `--dart-define` parameters are required when running on the emulator as
well.
