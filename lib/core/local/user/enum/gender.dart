enum Gender {
  male,
  female,
  unknown,
  legal,
  public;
}

extension GenderExtension on Gender {
    static Gender getGenderByName(String name) {
    switch (name) {
      case 'MALE':
        return Gender.male;
      case 'FEMALE':
        return Gender.female;
      case 'LEGAL':
        return Gender.legal;
      case 'PUBLIC':
        return Gender.public;
      case 'UNKNOWN':
        return Gender.unknown;

      default:
        return Gender.male;
    }
  }
  static int getGenderNumByName(Gender name) {
    switch (name) {
      case Gender.male:
        return 0;
      case Gender.female:
        return 1;

      default:
        return 0;
    }
  }
}
