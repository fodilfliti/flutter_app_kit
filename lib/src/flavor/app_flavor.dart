/// Build flavor. Pass `--dart-define=FLAVOR=dev|staging|prod`.
enum AppFlavor {
  dev,
  staging,
  prod;

  static const defineName = 'FLAVOR';

  static AppFlavor fromEnvironment() {
    const raw = String.fromEnvironment(defineName, defaultValue: 'dev');
    return parse(raw);
  }

  static AppFlavor parse(String raw) {
    return switch (raw.toLowerCase().trim()) {
      'prod' || 'production' => AppFlavor.prod,
      'staging' || 'stage' => AppFlavor.staging,
      _ => AppFlavor.dev,
    };
  }

  bool get isDev => this == AppFlavor.dev;
  bool get isStaging => this == AppFlavor.staging;
  bool get isProd => this == AppFlavor.prod;
}
