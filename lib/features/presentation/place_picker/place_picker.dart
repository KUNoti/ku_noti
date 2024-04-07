import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:ku_noti/core/uuid.dart';

import 'entities/address_component.dart';
import 'entities/auto_complete_item.dart';
import 'entities/localization_item.dart';
import 'entities/location_result.dart';
import 'rich_suggestion.dart';
import 'search_input.dart';
import 'select_place_action.dart';


class PlacePicker extends StatefulWidget {
  final String apiKey;
  final LatLng? displayLocation;
  LocalizationItem? localizationItem;
  LatLng defaultLocation = const LatLng(13.8476, 100.5696);

  PlacePicker(this.apiKey,
      {super.key, this.displayLocation, this.localizationItem, LatLng? defaultLocation}) {
    localizationItem ??= LocalizationItem();
    if (defaultLocation != null) {
      this.defaultLocation = defaultLocation;
    }
  }

  @override
  State<PlacePicker> createState() => _PlacePickerState();
}

class _PlacePickerState extends State<PlacePicker> {
  final Completer<GoogleMapController> mapController = Completer();
  LatLng? _currentLocation;
  bool _loadMap = false;

  final Set<Marker> markers = {};

  LocationResult? locationResult;

  /// Overlay to display autocomplete suggestions
  OverlayEntry? overlayEntry;

  /// Session token required for autocomplete API call
  String sessionToken = Uuid().generateV4();

  GlobalKey appBarKey = GlobalKey();

  bool hasSearchTerm = false;

  String previousSearchTerm = '';

  void onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);
    moveToCurrentUserLocation();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.displayLocation == null) {
      _getCurrentLocation().then((value) {
        if (value != null) {
          setState(() {
            _currentLocation = value;
          });
        } else {
          //Navigator.of(context).pop(null);
          print("getting current location null");
        }
        setState(() {
          _loadMap = true;
        });
      }).catchError((e) {
        if (e is LocationServiceDisabledException) {
          Navigator.of(context).pop(null);
        } else {
          setState(() {
            _loadMap = true;
          });
        }
        print(e);
        //Navigator.of(context).pop(null);
      });
    } else {
      setState(() {
        markers.add(Marker(
          position: widget.displayLocation!,
          markerId: const MarkerId("selected-location"),
        ));
        _loadMap = true;
      });
    }
  }

  @override
  void dispose() {
    overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (Platform.isAndroid) {
          locationResult = null;
          _delayedPop();
          return Future.value(false);
        }  else  {
          return Future.value(true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          key: appBarKey,
          title: SearchInput(searchPlace),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: !_loadMap
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: widget.displayLocation ??
                      _currentLocation ??
                      widget.defaultLocation,
                  zoom: _currentLocation == null &&
                      widget.displayLocation == null
                      ? 5
                      : 15,
                ),
                minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                buildingsEnabled: false,
                onMapCreated: onMapCreated,
                onTap: (latLng) {
                  clearOverlay();
                  moveToLocation(latLng);
                },
                markers: markers,
              ),
            ),
            if (!hasSearchTerm)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SelectPlaceAction(getLocationName(), () {
                      if(Platform.isAndroid) {
                        _delayedPop();
                      } else {
                        Navigator.of(context).pop(locationResult);
                      }
                    }, widget.localizationItem!.tapToSelectLocation),
                    const Divider(height: 8),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Hides the autocomplete overlay
  void clearOverlay() {
    if (overlayEntry != null) {
      overlayEntry?.remove();
      overlayEntry = null;
    }
  }

  /// Begins the search process by displaying a "wait" overlay then
  /// proceeds to fetch the autocomplete list. The bottom "dialog"
  /// is hidden so as to give more room and better experience for the
  /// autocomplete list overlay.
  void searchPlace(String place) {
    // on keyboard dismissal, the search was being triggered again
    // this is to cap that.
    if (place == previousSearchTerm) {
      return;
    }

    previousSearchTerm = place;

    if (context == null) {
      return;
    }

    clearOverlay();

    setState(() {
      hasSearchTerm = place.isNotEmpty;
    });

    if (place.isEmpty) {
      return;
    }

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    final size = renderBox?.size;

    final RenderBox? appBarBox =
    appBarKey.currentContext?.findRenderObject() as RenderBox?;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: appBarBox?.size.height,
        width: size?.width,
        child: Material(
          elevation: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              children: <Widget>[
                const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 3)),
                const SizedBox(width: 24),
                Expanded(
                    child: Text(widget.localizationItem!.findingPlace,
                        style: const TextStyle(fontSize: 16)))
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)?.insert(overlayEntry!);
  }

  /// Fetches the place autocomplete list with the query [place].
  void autoCompleteSearch(String place) async {
    try {
      place = place.replaceAll(" ", "+");

      var endpoint =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?"
          "key=${widget.apiKey}&"
          "language=${widget.localizationItem!.languageCode}&"
          "input={$place}&sessiontoken=${this.sessionToken}";

      if (this.locationResult != null) {
        endpoint += "&location=${this.locationResult!.latLng?.latitude}," +
            "${this.locationResult!.latLng?.longitude}";
      }

      final response = await http.get(Uri.parse(endpoint));

      if (response.statusCode != 200) {
        throw Error();
      }

      final responseJson = jsonDecode(response.body);

      if (responseJson['predictions'] == null) {
        throw Error();
      }

      List<dynamic> predictions = responseJson['predictions'];

      List<RichSuggestion> suggestions = [];

      if (predictions.isEmpty) {
        AutoCompleteItem aci = AutoCompleteItem();
        aci.text = widget.localizationItem!.noResultsFound;
        aci.offset = 0;
        aci.length = 0;

        suggestions.add(RichSuggestion(aci, () {}));
      } else {
        for (dynamic t in predictions) {
          final aci = AutoCompleteItem()
            ..id = t['place_id']
            ..text = t['description']
            ..offset = t['matched_substrings'][0]['offset']
            ..length = t['matched_substrings'][0]['length'];

          suggestions.add(RichSuggestion(aci, () {
            FocusScope.of(context).requestFocus(FocusNode());
            decodeAndSelectPlace(aci.id!);
          }));
        }
      }

      displayAutoCompleteSuggestions(suggestions);
    } catch (e) {
      print(e);
    }
  }

  /// To navigate to the selected place from the autocomplete list to the map,
  /// the lat,lng is required. This method fetches the lat,lng of the place and
  /// proceeds to moving the map to that location.
  void decodeAndSelectPlace(String placeId) async {
    clearOverlay();

    try {
      final url = Uri.parse(
          "https://maps.googleapis.com/maps/api/place/details/json?key=${widget.apiKey}&language=${widget.localizationItem!.languageCode}&placeid=$placeId");

      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Error();
      }

      final responseJson = jsonDecode(response.body);

      if (responseJson['result'] == null) {
        throw Error();
      }

      final location = responseJson['result']['geometry']['location'];
      if (mapController.isCompleted) {
        moveToLocation(LatLng(location['lat'], location['lng']));
      }
    } catch (e) {
      print(e);
    }
  }

  /// Display autocomplete suggestions with the overlay.
  void displayAutoCompleteSuggestions(List<RichSuggestion> suggestions) {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    Size? size = renderBox?.size;

    final RenderBox? appBarBox =
    appBarKey.currentContext?.findRenderObject() as RenderBox?;

    clearOverlay();

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size?.width,
        top: appBarBox?.size.height,
        child: Material(elevation: 1, child: Column(children: suggestions)),
      ),
    );

    Overlay.of(context)?.insert(overlayEntry!);
  }

  String getLocationName() {
    if (locationResult == null) {
      return widget.localizationItem!.unnamedLocation;
    }

    return "${locationResult?.name}, ${locationResult?.locality}";
  }

  void setMarker(LatLng latLng) {
    // markers.clear();
    setState(() {
      markers.clear();
      markers.add(
          Marker(markerId: const MarkerId("selected-location"), position: latLng));
    });
  }

  void moveToLocation(LatLng latLng) {
    mapController.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(target: latLng, zoom: 15.0)),
      );
    });

    setMarker(latLng);

    reverseGeocodeLatLng(latLng);

  }

  void reverseGeocodeLatLng(LatLng latLng) async {
    try {
      final url = Uri.parse("https://maps.googleapis.com/maps/api/geocode/json?"
          "latlng=${latLng.latitude},${latLng.longitude}&"
          "language=${widget.localizationItem!.languageCode}&"
          "key=${widget.apiKey}");

      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Error();
      }

      final responseJson = jsonDecode(response.body);

      if (responseJson['results'] == null) {
        throw Error();
      }

      final result = responseJson['results'][0];

      setState(() {
        String name = "";
        String? locality,
            postalCode,
            country,
            administrativeAreaLevel1,
            administrativeAreaLevel2,
            city,
            subLocalityLevel1,
            subLocalityLevel2;
        bool isOnStreet = false;
        if (result['address_components'] is List<dynamic> &&
            result['address_components'].length != null &&
            result['address_components'].length > 0) {
          for (var i = 0; i < result['address_components'].length; i++) {
            var tmp = result['address_components'][i];
            var types = tmp["types"] as List<dynamic>;
            var shortName = tmp['short_name'];
            if (types == null) {
              continue;
            }
            if (i == 0) {
              // [street_number]
              name = shortName;
              isOnStreet = types.contains('street_number');
              // other index 0 types
              // [establishment, point_of_interest, subway_station, transit_station]
              // [premise]
              // [route]
            } else if (i == 1 && isOnStreet) {
              if (types.contains('route')) {
                name += ", $shortName";
              }
            } else {
              if (types.contains("sublocality_level_1")) {
                subLocalityLevel1 = shortName;
              } else if (types.contains("sublocality_level_2")) {
                subLocalityLevel2 = shortName;
              } else if (types.contains("locality")) {
                locality = shortName;
              } else if (types.contains("administrative_area_level_2")) {
                administrativeAreaLevel2 = shortName;
              } else if (types.contains("administrative_area_level_1")) {
                administrativeAreaLevel1 = shortName;
              } else if (types.contains("country")) {
                country = shortName;
              } else if (types.contains('postal_code')) {
                postalCode = shortName;
              }
            }
          }
        }
        locality = locality ?? administrativeAreaLevel1;
        city = locality;
        locationResult = LocationResult()
          ..name = name
          ..locality = locality
          ..latLng = latLng
          ..formattedAddress = result['formatted_address']
          ..placeId = result['place_id']
          ..postalCode = postalCode
          ..country = AddressComponent(name: country, shortName: country)
          ..administrativeAreaLevel1 = AddressComponent(
              name: administrativeAreaLevel1,
              shortName: administrativeAreaLevel1)
          ..administrativeAreaLevel2 = AddressComponent(
              name: administrativeAreaLevel2,
              shortName: administrativeAreaLevel2)
          ..city = AddressComponent(name: city, shortName: city)
          ..subLocalityLevel1 = AddressComponent(
              name: subLocalityLevel1, shortName: subLocalityLevel1)
          ..subLocalityLevel2 = AddressComponent(
              name: subLocalityLevel2, shortName: subLocalityLevel2);
      });
    } catch (e) {
      print(e);
    }
  }

  void moveToCurrentUserLocation() async {
    if (widget.displayLocation != null) {
      moveToLocation(widget.displayLocation!);
      return;
    }
    if (_currentLocation != null) {
      moveToLocation(_currentLocation!);
    } else {
      moveToLocation(widget.defaultLocation);
    }
  }

  Future<LatLng> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      bool? isOk = await _showLocationDisabledAlertDialog(context);
      if (isOk ?? false) {
        return Future.error(LocationServiceDisabledException());
      } else {
        return Future.error('Location Services is not enabled');
      }
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      //return widget.defaultLocation;
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    try {
      final locationData =
      await Geolocator.getCurrentPosition(timeLimit: const Duration(seconds: 30));
      LatLng target = LatLng(locationData.latitude, locationData.longitude);
      //moveToLocation(target);
      print('target:$target');
      return target;
    } on TimeoutException catch (e) {
      final locationData = await Geolocator.getLastKnownPosition();
      if (locationData != null) {
        return LatLng(locationData.latitude, locationData.longitude);
      } else {
        return widget.defaultLocation;
      }
    }
  }

  Future<dynamic> _showLocationDisabledAlertDialog(BuildContext context) {
    if (Platform.isIOS) {
      return showCupertinoDialog(
          context: context,
          builder: (BuildContext ctx) {
            return CupertinoAlertDialog(
              title: const Text("Location is disabled"),
              content: const Text(
                  "To use location, go to your Settings App > Privacy > Location Services."),
              actions: [
                CupertinoDialogAction(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                )
              ],
            );
          });
    } else {
      return showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return AlertDialog(
              title: const Text("Location is disabled"),
              content: const Text(
                  "The app needs to access your location. Please enable location service."),
              actions: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () async {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text("OK"),
                  onPressed: () async {
                    await Geolocator.openLocationSettings();
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          });
    }
  }

  // add delay to the map pop to avoid `Fatal Exception: java.lang.NullPointerException` error on Android
  Future<bool> _delayedPop() async {
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => WillPopScope(
          onWillPop: () async => false,
          child: const Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
        ),
        transitionDuration: Duration.zero,
        barrierDismissible: false,
        barrierColor: Colors.black45,
        opaque: false,
      ),
    );

    await Future.delayed(const Duration(milliseconds: 500));
    Navigator.of(context)
      ..pop()
      ..pop(locationResult);
    return Future.value(false);
  }
}
