# assets/illustrations

Decorative/branded graphics that aren't photography and aren't the app
mark — the two currently identified in the Figma design:

- `success_wave_bg.png` (or `.svg`) — the soft pink wave shape behind
  the checkmark on the order-confirmation / application-submitted
  screens.
- `delivery_car.png` (or `.svg`) — the car graphic on the Track order
  screen.

Both are registered in `lib/core/constants/app_assets.dart`
(`AppAssets.successWaveBackground`, `AppAssets.deliveryCarIllustration`)
ready to receive the real files; see that file's doc comment for why
they aren't exported yet.
