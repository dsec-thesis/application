import 'package:flutter/material.dart';

class FaqsComponent extends StatelessWidget {
  const FaqsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'FAQs - Smart Parking System',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FaqItem(
              question: '¿Cómo funciona el Smart Parking System?',
              answer:
                  'El Smart Parking System utiliza sensores y tecnología de geolocalización para rastrear la disponibilidad de plazas de estacionamiento en tiempo real. Los usuarios pueden acceder a la información a través de la aplicación móvil y ser guiados a plazas disponibles.',
            ),
            FaqItem(
              question: '¿Cómo puedo reservar una plaza de estacionamiento?',
              answer:
                  'La reserva de plazas de estacionamiento se realiza a través de la aplicación móvil. Simplemente seleccione la ubicación deseada, el horario y el tipo de vehículo. Luego, puede pagar la tarifa correspondiente y recibir la confirmación de su reserva.',
            ),
            FaqItem(
              question: '¿Cuál es la política de cancelación?',
              answer:
                  'La política de cancelación varía según el operador de estacionamiento. En general, las reservas canceladas con suficiente antelación pueden estar sujetas a reembolsos parciales o completos. Lea los términos y condiciones para conocer los detalles específicos.',
            ),
            FaqItem(
              question: '¿Qué medidas de seguridad se implementan?',
              answer:
                  'La seguridad de nuestros usuarios es una prioridad. Utilizamos medidas de seguridad técnicas y organizativas para proteger los datos recopilados y garantizar transacciones seguras. Sin embargo, recomendamos a los usuarios seguir las precauciones normales al estacionar sus vehículos.',
            ),
          ],
        ),
      ),
    );
  }
}

class FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  const FaqItem({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title:
          Text(question, style: const TextStyle(fontWeight: FontWeight.bold)),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(answer),
        ),
      ],
    );
  }
}
