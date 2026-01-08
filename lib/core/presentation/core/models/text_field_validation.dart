enum ValidationStatusType {
  normal,
  valid,
  invalid;

  bool get isNormal => this == ValidationStatusType.normal;

  bool get isValid => this == ValidationStatusType.valid;

  bool get isInvalid => this == ValidationStatusType.invalid;
}

class TextFieldValidation {
    String text;
    ValidationStatusType validationStatusType;

  TextFieldValidation(this.text, this.validationStatusType);
}
