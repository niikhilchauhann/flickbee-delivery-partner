class AccountSettingItem {
  final String icon;
  final String title;
  final String subtitle;

  const AccountSettingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class AppSettingState {
  final bool locationSharing;
  final String navigationApp;
  final String language;

  const AppSettingState({
    required this.locationSharing,
    required this.navigationApp,
    required this.language,
  });

  AppSettingState copyWith({
    bool? locationSharing,
    String? navigationApp,
    String? language,
  }) {
    return AppSettingState(
      locationSharing: locationSharing ?? this.locationSharing,
      navigationApp: navigationApp ?? this.navigationApp,
      language: language ?? this.language,
    );
  }
}

class AvailabilitySlot {
  final String label;
  final bool enabled;

  const AvailabilitySlot(this.label, this.enabled);

  AvailabilitySlot copy(bool value) => AvailabilitySlot(label, value);
}

class DayAvailability {
  final String day;
  final List<AvailabilitySlot> slots;

  const DayAvailability(this.day, this.slots);
}

class DocumentItem {
  final String icon;
  final String title;
  final String status;
  final String expiry;
  final bool isVerified;

  const DocumentItem({
    required this.icon,
    required this.title,
    required this.status,
    required this.expiry,
    required this.isVerified,
  });
}
