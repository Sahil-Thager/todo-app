enum SelectTime {
  tenMinutes('10Minutes'),
  oneHour('1Hour'),
  oneDay('1Day'),
  oneMinutes('1minute'),
  twoMinutes('2Minute'),
  threeMinutes('3Minutes');

  final String value;

  const SelectTime(this.value);
}

extension SelectTimeExtension on SelectTime {
  static const int _seconds = 60;
  int toSeconds() {
    switch (this) {
      case SelectTime.oneMinutes:
        return _seconds * 1;
      case SelectTime.twoMinutes:
        return _seconds * 2;
      case SelectTime.threeMinutes:
        return _seconds * 3;
      case SelectTime.tenMinutes:
        return _seconds * 10;
      case SelectTime.oneHour:
        return _seconds * 60;
      case SelectTime.oneDay:
        return (24 * 60) * _seconds;
    }
  }
}
