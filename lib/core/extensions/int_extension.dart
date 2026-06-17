extension IntToString on int {
  String toWord() {
    final numberWords = [
      'zero', 'one', 'two', 'three', 'four',
      'five', 'six', 'seven', 'eight', 'nine',
    ];
    if (this >= 0 && this <= 9) return numberWords[this];
    throw RangeError('Only integers between 0 and 9 are supported.');
  }
}
