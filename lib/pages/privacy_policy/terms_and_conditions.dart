import 'package:flutter/material.dart';

class TermsAndConditionsComponent extends StatelessWidget {
  const TermsAndConditionsComponent({
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
              "Terminos y condiciones",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white),
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Text('''
Términos y Condiciones para Smart Parking System

1. Aceptación de Términos
Al utilizar el Smart Parking System, usted acepta cumplir con estos términos y condiciones. Si no está de acuerdo con estos términos, no debe utilizar el servicio.

2. Uso del Servicio
El Smart Parking System proporciona información sobre plazas de estacionamiento disponibles y guía a los usuarios a ubicaciones de estacionamiento. Usted acepta que es su responsabilidad verificar la disponibilidad y condiciones de estacionamiento en el lugar.

3. Responsabilidad
El Smart Parking System no se hace responsable de daños o pérdidas de propiedad o vehículos mientras se utiliza el servicio. Los usuarios deben tomar precauciones y cumplir con las normativas de tráfico y estacionamiento locales.

4. Pago
Los cargos por estacionamiento se basan en las tarifas establecidas por los operadores de estacionamiento. El pago debe realizarse según las instrucciones proporcionadas en la aplicación.

5. Cancelación y Reembolsos
Las reservas pueden cancelarse según la política establecida por el operador de estacionamiento. Los reembolsos pueden aplicar según los términos y condiciones del operador.

6. Modificaciones
Los términos y condiciones pueden modificarse en cualquier momento sin previo aviso. Es responsabilidad del usuario revisarlos regularmente para mantenerse informado.

7. Derechos de Propiedad
Todos los derechos de propiedad intelectual relacionados con el Smart Parking System son propiedad de Smart Parking Inc. Los usuarios no tienen derecho a utilizar, copiar o modificar ninguna parte de la aplicación sin autorización.

8. Jurisdicción
Cualquier disputa relacionada con estos términos y condiciones estará sujeta a las leyes de [jurisdicción]. Las partes acuerdan someterse a la jurisdicción exclusiva de los tribunales de dicha jurisdicción.

9. Limitación de Responsabilidad
En la medida máxima permitida por la ley, Smart Parking Inc. no será responsable por ningún daño indirecto, consecuente, especial o punitivo relacionado con el uso del Smart Parking System.

10. Aceptación
Al utilizar el servicio, usted acepta cumplir con estos términos y condiciones. Si no está de acuerdo, le recomendamos que no utilice el Smart Parking System.
      '''),
        ));
  }
}
