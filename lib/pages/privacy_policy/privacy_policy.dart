import 'package:flutter/material.dart';

class PrivacyPolicyComponent extends StatelessWidget {
  const PrivacyPolicyComponent({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text(
              "Politica de privacidad",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white),
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Text('''
Política de Privacidad para Smart Parking System

1. Información Recopilada
El Smart Parking System recopila información que los usuarios proporcionan directamente, como ubicación GPS, información del vehículo y detalles de la reserva.

2. Uso de la Información
La información recopilada se utiliza para proporcionar el servicio de estacionamiento y mejorar la experiencia del usuario. Esto incluye guiar a los usuarios a plazas de estacionamiento disponibles y brindar información relevante.

3. Compartir de Información
La información recopilada no se comparte con terceros sin el consentimiento del usuario, excepto cuando sea necesario para cumplir con la ley o proteger los derechos, propiedad o seguridad de Smart Parking Inc. y sus usuarios.

4. Seguridad de Datos
Se implementan medidas de seguridad técnicas y organizativas para proteger la información recopilada contra accesos no autorizados, pérdida o alteración. Sin embargo, no se garantiza la seguridad completa de los datos transmitidos a través de Internet.

5. Cookies y Tecnologías Similares
El Smart Parking System puede utilizar cookies y tecnologías similares para mejorar la funcionalidad y experiencia del usuario. Los usuarios pueden ajustar sus configuraciones de navegación para controlar el uso de cookies.

6. Cambios en la Política de Privacidad
Esta Política de Privacidad puede actualizarse ocasionalmente para reflejar cambios en las prácticas de recopilación y uso de información. Los usuarios serán notificados sobre cambios significativos.

7. Contacto
Para consultas relacionadas con la Política de Privacidad, puede contactarnos en privacy@smartparking.com.

8. Consentimiento
Al utilizar el Smart Parking System, usted acepta la recopilación y uso de su información según se describe en esta Política de Privacidad.
      '''),
        ));
  }
}
