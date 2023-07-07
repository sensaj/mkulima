import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mkulima/widgets/pop_up_dialogs.dart';
import 'package:url_launcher/url_launcher.dart';

class HelperServices {
  _getDayName({required int dayNum}) {
    String day = "Sun";
    switch (dayNum) {
      case 1:
        day = "Mon";
        break;
      case 2:
        day = "Tues";
        break;
      case 3:
        day = "Wed";
        break;
      case 4:
        day = "Thur";
        break;
      case 5:
        day = "Fri";
        break;
      case 6:
        day = "Sat";
        break;
      default:
        day = "Sun";
    }
    return day;
  }

  _getMonthName({required int monthNum}) {
    String month = "Dec";
    switch (monthNum) {
      case 1:
        month = "Jan";
        break;
      case 2:
        month = "Feb";
        break;
      case 3:
        month = "Mar";
        break;
      case 4:
        month = "Apr";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "June";
        break;
      case 7:
        month = "July";
        break;
      case 8:
        month = "Aug";
        break;
      case 9:
        month = "Sept";
        break;
      case 10:
        month = "Oct";
        break;
      case 11:
        month = "Nov";
        break;
      default:
        month = "Dec";
    }
    return month;
  }

  String beautifyDate(DateTime date) {
    return "${_getDayName(dayNum: date.weekday)}, ${date.day} ${_getMonthName(monthNum: date.month)} ${date.year} ${date.hour}:${date.minute}";
  }

  LatLng? locStrToLatLng({required position}) {
    try {
      if (position != null) {
        print(position);
        double lat = double.parse(position.split(",")[0]);
        double lng = double.parse(position.split(",")[1]);
        return LatLng(lat, lng);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  String locLatLngToStr({required LatLng position}) {
    return "${position.latitude}, ${position.longitude}";
  }

  Future<String> getLocationName({required LatLng location}) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(location.latitude, location.longitude);
      // print("$placemarks");
      return "${placemarks[0].name!}, ${placemarks[0].subAdministrativeArea!}";
    } catch (e) {
      return location.toString();
    }
  }

  makeOutAppCommunication(
      {required String media,
      required String comuItem,
      required BuildContext context}) async {
    Uri? url;
    switch (media) {
      case "call":
        url = Uri.parse("tel:$comuItem");
        break;
      case "sms":
        url = Uri.parse("sms:$comuItem");
        break;
      case "email":
        url = Uri.parse("mailto:$comuItem");
        break;
    }
    await canLaunchUrl(url!)
        ? launchUrl(url)
        : dialog.errorDialog(
            context: context, header: "ERROR", body: "failed to luach app");
  }
}

HelperServices helper = HelperServices();
