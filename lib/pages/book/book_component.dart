import 'package:flutter/material.dart';
import 'package:smart_parking_app/utils/tools.dart';

class BookInfoSheet extends StatelessWidget {
  final String title;
  final String image;
  final String parkingName;
  final String? description;

  const BookInfoSheet({
    Key? key,
    required this.title,
    required this.image,
    required this.parkingName,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      height: SizeConfig.screenHeight * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Encabezado "Details"
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, thickness: 1), // Línea divisoria
          const SizedBox(height: 8),
          // Imagen del estacionamiento
          if (image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                image,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 8),
          // Título del estacionamiento
          Text(
            parkingName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Mini descripción
          if (description != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                description!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
          ],
          // Botones Cancelar y Reservar
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancelar",
                    style: TextStyle(color: kButtonColor),
                  ),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(Size(130, 45)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(kButtonColorLight),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Lógica para reservar el estacionamiento
                  },
                  child: Text("Reservar"),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(Size(130, 45)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(kButtonColor),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
