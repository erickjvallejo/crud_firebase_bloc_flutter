bool isNumeric(String value) {
  if (value.isEmpty) return false;

  final number = num.tryParse(value);

  return (number == null) ? false : true;
}
