// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:smart_parking_app/utils/tools.dart';

import '../../controllers/reservation_controller.dart';

const riveFile = 'assets/RiveAssets/check.riv';

class CancelReservationAnimated extends StatefulWidget {
  final String bookingId;

  const CancelReservationAnimated({
    super.key,
    required this.bookingId,
  });
  @override
  _CancelReservationAnimated createState() => _CancelReservationAnimated();
}

class _CancelReservationAnimated extends State<CancelReservationAnimated> {
  Artboard? _artboard;
  late RiveAnimationController _animationController;
  bool _isSuccess = false;
  bool _isLoading = true;
  final ReservationController _reservationController = Get.find();

  @override
  void initState() {
    super.initState();
    _cancellReservation();
    _loadRiveFile();
  }

  Future<void> _cancellReservation() async {
    var response =
        await _reservationController.deleteReservation(widget.bookingId);
    setState(
      () {
        _isLoading = false;
        _isSuccess = response;
        if (_isSuccess) {
          _onSucess();
        } else {
          _onFailed();
        }
      },
    );
  }

  void _loadRiveFile() async {
    final bytes = await rootBundle.load(riveFile);
    RiveFile rFile = RiveFile.import(bytes);

    setState(() => _artboard = rFile.mainArtboard
      ..addController(
        _animationController = SimpleAnimation('Loading'),
      ));
  }

  void _onSucess() {
    _artboard!.artboard.removeController(_animationController);
    _artboard!.addController(SimpleAnimation('Filling_circle'));
    _artboard!.addController(SimpleAnimation('Check'));
  }

  void _onFailed() {
    _artboard!.artboard.removeController(_animationController);
    _artboard!.addController(SimpleAnimation('Err'));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_artboard != null)
            SizedBox(
              width: 200,
              height: 200,
              child: Rive(
                artboard: _artboard!,
              ),
            ),
          Text(
            textAlign: TextAlign.center,
            _isLoading
                ? 'Cargando...'
                : (_isSuccess
                    ? 'Reserva cancelada exitosamente'
                    : 'Ocurrió un problema al cancela la reserva'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _isLoading
                  ? Colors.grey
                  : (_isSuccess ? Colors.green : Colors.red),
            ),
          ),
          SizedBox(
            height: SizeConfig.screenWidth * .05,
          ),
          if (!_isLoading)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    _isSuccess ? Colors.green : Colors.red),
              ),
              child: const Text(
                'Cerrar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
