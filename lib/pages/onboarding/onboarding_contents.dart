class OnboardingContents {
  final String title;
  final String image;
  final String description;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.description,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    image: 'assets/images/onboarding/imagen_1.png',
    title: "¡Adiós a la búsqueda interminable de estacionamiento!",
    description:
        "Encuentra la mejor opción de estacionamiento en cuestión de segundos y evita tarifas exorbitantes.",
  ),
  OnboardingContents(
    image: 'assets/images/onboarding/imagen_2.png',
    title: "Facil Navegación",
    description:
        "Descubre las mejores opciones de estacionamiento en tu área y reserva con confianza.",
  ),
  OnboardingContents(
    image: 'assets/images/onboarding/imagen_3.png',
    title: "¡Reserve y Pague de una forma rapida y segura!",
    description:
        "Reservar un lugar de estacionamiento nunca fue más fácil y seguro, con opciones de pago en línea.",
  ),
];
