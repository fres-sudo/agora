enum Flavor { dev, staging, prod }

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Agora Dev';
      case Flavor.staging:
        return 'Agora Staging';
      case Flavor.prod:
        return 'Agora POS';
    }
  }
}
