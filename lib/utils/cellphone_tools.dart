import 'dart:math';

class ArgentinePhoneNumbers {
  static final List<String> _prefixes = [
    '11',
    '22',
    '23',
    '24',
    '29',
    '30',
    '33',
    '34',
    '35',
    '37',
    '38',
    '42',
    '44',
    '47',
    '54',
    '55',
    '60',
    '66',
    '70',
    '72',
    '73',
    '74',
    '75',
    '76',
    '77',
    '80',
    '81',
    '85',
    '88',
    '89',
    '90',
    '91',
    '92',
    '93',
    '94',
    '95',
    '96',
    '97',
    '98',
    '99'
  ];

  static String getRandomPhoneNumber() {
    final random = Random();
    final selectedPrefix = _prefixes[random.nextInt(_prefixes.length)];
    final numberPart = random.nextInt(10000000).toString().padLeft(7, '0');
    return '+54 $selectedPrefix $numberPart';
  }
}
