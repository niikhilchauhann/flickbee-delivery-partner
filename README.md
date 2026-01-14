1️⃣ Store Selection

On login, the delivery partner:

Sees a list of available stores

Selects one store to work with

Orders assigned to the driver must be only from the selected store

2️⃣ Order Assignment Logic (Backend-Compatible)

Orders are sent to drivers based on:

Ascending distance from the store

Nearest available driver receives the request first

Driver can:

Accept or Reject an order

Once accepted:

Order is locked to that driver

⚠️ Backend logic is assumed — UI and state must be API compatible

3️⃣ Order Pickup & Delivery Flow

Driver workflow:

Accept order

Navigate to store

Pick up items

Start delivery

Navigate to user location

Deliver order

Return to store / go online again

4️⃣ Payment Handling

Support three payment modes:

Cash on Delivery

Online Payment

Prepaid

If order is prepaid:

Driver directly marks order as delivered

Otherwise:

Driver selects payment method and confirms payment received

5️⃣ Live Location Tracking

Driver’s live location is shared with the user:

Starts when order is picked up

Stops immediately after delivery

Location updates should be:

Continuous

Background-safe (architecture-ready)


📱 Screens to Build (UI First)

Login / Authentication Screen

Store Selection Screen

Driver Home (Online / Offline toggle)

Incoming Order Request Screen

Order Details Screen

Navigation / Delivery Tracking Screen

Payment Confirmation Screen

Order Completion Screen

Profile & Availability Screen

lib/
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_text_theme.dart
│   │   └── app_theme.dart
│   │
│   ├── extensions/
│   │   ├── spacing_extensions.dart   // 12.heightBox, .px(12), etc
│   │   └── widget_extensions.dart
│   │
│   ├── routing/
│   │   └── app_router.dart
│   │
│   ├── utils/
│   │   └── distance_calculator.dart
│   │
│   └── widgets/
│       ├── primary_button.dart
│       ├── status_chip.dart
│       └── loading_view.dart
│
├── features/
│   ├── auth/
│   │   ├── presentation/
│   │   │   ├── login_screen.dart
│   │   │   └── auth_controller.dart
│   │   ├── domain/
│   │   │   └── driver_entity.dart
│   │   └── data/
│   │       └── auth_repository.dart
│   │
│   ├── store/
│   │   ├── presentation/
│   │   │   ├── store_selection_screen.dart
│   │   │   └── store_controller.dart
│   │   ├── domain/
│   │   │   └── store_entity.dart
│   │   └── data/
│   │       └── store_repository.dart
│   │
│   ├── orders/
│   │   ├── presentation/
│   │   │   ├── driver_home_screen.dart
│   │   │   ├── incoming_order_screen.dart
│   │   │   ├── order_details_screen.dart
│   │   │   └── order_controller.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── order_entity.dart
│   │   │   ├── order_status.dart
│   │   │   └── payment_mode.dart
│   │   │
│   │   └── data/
│   │       └── order_repository.dart
│   │
│   ├── tracking/
│   │   ├── presentation/
│   │   │   ├── delivery_tracking_screen.dart
│   │   │   └── tracking_controller.dart
│   │   ├── domain/
│   │   │   └── location_entity.dart
│   │   └── data/
│   │       └── location_repository.dart
│   │
│   └── profile/
│       ├── presentation/
│       │   ├── profile_screen.dart
│       │   └── availability_controller.dart
│       └── domain/
│           └── availability_status.dart
│
├── shared/
│   ├── providers/
│   │   └── network_providers.dart
│   └── mocks/
│       └── fake_api.dart
│
└── main.dart
