import 'package:astro_prompt/Utility/permissionHandlerScreen.dart';
import 'package:astro_prompt/Utility/snackBarHelper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class CurrencyService {
  Future<bool> requestPermission(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    print('Permission: $permission');
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      return true;
    }

    bool allow = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.white.withValues(alpha: 0.5),
          builder: (context) => PermissionHandlerScreen(),
        ) ??
        false;
    if (!allow) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.white.withValues(alpha: 0.5),
        builder: (context) => MandatoryPermissionScreen(),
      );
      return false;
    }

    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.deniedForever) {
      showErrorSnackBar(context, "Permission permanently denied. Please enable it in settings.");
      await Geolocator.openAppSettings();
      return false;
    }

    if (permission == LocationPermission.denied) {
      showErrorSnackBar(context, 'Permission Denied');
      await showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.white.withValues(alpha: 0.5),
        builder: (context) => MandatoryPermissionScreen(),
      );
      return false;
    }
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  Future<String?> getUserCountry(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled");
      return null;
    }

    final hasPermission = await requestPermission(context);
    if (!hasPermission) {
      print("Location permission not granted");
      return null;
    }

    try {
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
      );

      Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
      if (kDebugMode) {
        print("Got position: ${position.latitude}, ${position.longitude}");
      }

      List<Placemark> placeMarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      return placeMarks.isNotEmpty ? placeMarks.first.isoCountryCode : null;
    } catch (e) {
      if (kDebugMode) {
        print("Error getting location: $e");
      }
      return null;
    }
  }

//Determine Currency
  Future<String?> getCurrency(BuildContext context) async {
    String? countryCode = await getUserCountry(context);
    print('CountryCOde: $countryCode');
    if (countryCode == null) return null;

    return countryCode == 'IN' ? 'INR' : 'USD';
  }
}
