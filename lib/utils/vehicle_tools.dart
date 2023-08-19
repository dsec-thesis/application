import 'dart:math';

class VehicleBrands {
  static final List<String> vehicleBrands = [
    'Toyota',
    'Ford',
    'Honda',
    'Chevrolet',
    'Volkswagen',
    'Nissan',
    'Mercedes-Benz',
    'BMW',
    'Audi',
    'Hyundai',
    'Kia',
    'Mazda',
    'Subaru',
    'Lexus',
    'Volvo',
    'Jeep',
    'Chrysler',
    'Buick',
    'Cadillac',
    'GMC',
    'Ram',
    'Dodge',
    'Land Rover',
    'Mitsubishi',
    'Porsche',
    'Ferrari',
    'Lamborghini',
    'Tesla',
    'Jaguar',
    'Mini',
    'Acura',
    'Infiniti',
    'Lincoln',
    'Alfa Romeo',
    'Bentley',
    'Rolls-Royce',
    'Fiat',
    'Maserati',
    'Smart',
    'Bugatti',
    'McLaren',
    'Maybach',
    'Lotus',
  ];

  static String getRandomVehicle() {
    final random = Random();
    return vehicleBrands[random.nextInt(vehicleBrands.length)];
  }

  static String generateLicensePlate() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';

    final random = Random();

    final letter1 = letters[random.nextInt(letters.length)];
    final letter2 = letters[random.nextInt(letters.length)];

    final number1 = numbers[random.nextInt(numbers.length)];
    final number2 = numbers[random.nextInt(numbers.length)];
    final number3 = numbers[random.nextInt(numbers.length)];

    final letter4 = letters[random.nextInt(letters.length)];
    final letter5 = letters[random.nextInt(letters.length)];

    return '$letter1$letter2 $number1$number2$number3 $letter4$letter5';
  }
}
