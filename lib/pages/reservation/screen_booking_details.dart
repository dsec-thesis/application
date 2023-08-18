import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_parking_app/utils/tools.dart';

import '../../main.dart';
import 'create_reservation_animation.dart';

class BookParkingDetailsWidget extends StatefulWidget {
  final String title;
  final String parkingName;
  final String parkinglotId;
  final String? description;

  const BookParkingDetailsWidget({
    super.key,
    required this.title,
    required this.parkingName,
    required this.parkinglotId,
    this.description,
  });
  @override
  // ignore: library_private_types_in_public_api
  _BookParkingDetailsWidgetState createState() =>
      _BookParkingDetailsWidgetState();
}

class _BookParkingDetailsWidgetState extends State<BookParkingDetailsWidget> {
  bool isFreeReservation = false;
  final List<String> timeOptions = ['30m', '1h', '3h', '8h', '12h', '24h'];
  String selectedTime = '30m';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            "Detalles de la reserva",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InfoHeader(
                      imagePath: "assets/cochera.jpg",
                      name: widget.parkingName),
                ],
              ),
              SizedBox(
                height: SizeConfig.screenWidth * .1,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      "Dirección:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (widget.description != null) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          widget.description!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.screenWidth * .05,
              ),
              ReservationTypeSwitch(
                isFreeReservation: isFreeReservation,
                onChange: (value) {
                  setState(() {
                    isFreeReservation = value;
                  });
                },
              ),
              if (!isFreeReservation) ...[
                const SizedBox(height: 8),
                SliderExample(
                  timeOptions: timeOptions,
                  onChanged: (newValue) {
                    setState(() {
                      selectedTime = newValue;
                    });
                  },
                ),
              ],
              SizedBox(
                height: SizeConfig.screenWidth * .1,
              ),
              ButtonRow(
                onReservePressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: SizedBox(
                            width: SizeConfig.screenWidth * .7,
                            height: SizeConfig.screenHeight * .5,
                            child: AnimatedReservation(
                              parkinglotId: widget.parkinglotId,
                              description: widget.description,
                              duration: isFreeReservation == false
                                  ? selectedTime
                                  : null,
                              closeParentScreen: () {
                                Get.to(() => const MainComponent());
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}

class InfoHeader extends StatelessWidget {
  final String imagePath;
  final String name;

  const InfoHeader({super.key, required this.imagePath, required this.name});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: SizeConfig.screenWidth * .90,
            height: SizeConfig.screenHeight * .18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image:
                    AssetImage(imagePath), // Replace with your asset image path
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class ReservationTypeSwitch extends StatelessWidget {
  final bool isFreeReservation;
  final ValueChanged<bool> onChange;

  const ReservationTypeSwitch({
    super.key,
    required this.isFreeReservation,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Reserva Limitada"),
        Switch(
          value: isFreeReservation,
          onChanged: onChange,
        ),
        const Text("Reserva Libre"),
      ],
    );
  }
}

class TimeDropdown extends StatelessWidget {
  final String selectedTime;
  final ValueChanged<String?> onChanged;
  final List<String> timeOptions;

  const TimeDropdown({
    super.key,
    required this.selectedTime,
    required this.onChanged,
    required this.timeOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<String>(
        value: selectedTime,
        onChanged: onChanged,
        items: timeOptions.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}

class SliderExample extends StatefulWidget {
  final List<String> timeOptions;
  final ValueChanged<String> onChanged;

  const SliderExample(
      {super.key, required this.timeOptions, required this.onChanged});

  @override
  // ignore: library_private_types_in_public_api
  _SliderExampleState createState() => _SliderExampleState();
}

class _SliderExampleState extends State<SliderExample> {
  double _value = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: SizeConfig.screenWidth * .1,
        ),
        Text(
          'Tiempo de la reserva: ${widget.timeOptions[_value.toInt()]}',
          style: const TextStyle(fontSize: 18),
        ),
        SizedBox(
          height: SizeConfig.screenWidth * .1,
        ),
        Slider(
          value: _value,
          onChanged: (newValue) {
            setState(() {
              _value = newValue;
            });
            widget.onChanged(widget.timeOptions[_value.toInt()]);
          },
          min: 0,
          max: widget.timeOptions.length - 1.toDouble(),
          divisions: widget.timeOptions.length - 1,
          label: widget.timeOptions[_value.toInt()],
        ),
      ],
    );
  }
}

class ButtonRow extends StatelessWidget {
  final VoidCallback onReservePressed;

  const ButtonRow({
    super.key,
    required this.onReservePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: onReservePressed,
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(Size(
                  SizeConfig.screenWidth * .8, SizeConfig.screenHeight * .05)),
              backgroundColor: MaterialStateProperty.all<Color>(kButtonColor),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            child: const Text(
              "Reservar",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
