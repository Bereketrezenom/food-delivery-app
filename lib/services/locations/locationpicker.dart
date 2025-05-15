// services/locations/locationpicker.dart
import 'package:auth_demo/services/locations/locationservies.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({Key? key}) : super(key: key);

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final LocationService _locationService = LocationService();
  GoogleMapController? _mapController;
  Position? _currentPosition;
  String? _currentAddress;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      setState(() => _isLoading = true);
      final position = await _locationService.getCurrentLocation();
      final address =
          await _locationService.getAddressFromCoordinates(position);

      setState(() {
        _currentPosition = position;
        _currentAddress = address;
        _isLoading = false;
      });

      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 15,
          ),
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Delivery Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        _currentPosition?.latitude ?? 0,
                        _currentPosition?.longitude ?? 0,
                      ),
                      zoom: 15,
                    ),
                    onMapCreated: (controller) => _mapController = controller,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        _currentAddress ?? 'Loading address...',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_currentAddress != null) {
                              await _locationService
                                  .saveDeliveryAddress(_currentAddress!);
                              if (mounted) {
                                Navigator.pop(context, _currentAddress);
                              }
                            }
                          },
                          child: const Text('Confirm Location'),
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

class LocationPickerMap extends StatefulWidget {
  const LocationPickerMap({Key? key}) : super(key: key);

  @override
  State<LocationPickerMap> createState() => _LocationPickerMapState();
}

class _LocationPickerMapState extends State<LocationPickerMap> {
  final LocationService _locationService = LocationService();
  final TextEditingController _addressController = TextEditingController();
  GoogleMapController? _mapController;
  LatLng? _pickedLocation;
  String? _pickedAddress;
  bool _loading = true;
  String? _errorMessage;
  int _retryCount = 0;
  static const _maxRetries = 3;
  bool _isApproximate = true;
  bool _isEditing = false;
  bool _isSearching = false;

  // Default location (can be any city center)
  static const LatLng _defaultLocation =
      LatLng(51.5074, -0.1278); // London coordinates

  @override
  void initState() {
    super.initState();
    _pickedLocation = _defaultLocation; // Set default location
    _determinePosition();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _determinePosition() async {
    if (_retryCount >= _maxRetries) {
      setState(() {
        _loading = false;
        _errorMessage =
            'Failed to get location after $_maxRetries attempts. Please check your location settings.';
      });
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final position = await _locationService.getApproximateLocation();
      setState(() {
        _pickedLocation = LatLng(position.latitude, position.longitude);
        _loading = false;
      });
      _getAddress(_pickedLocation!);

      // Animate camera to the new position
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _pickedLocation!,
            zoom: 16,
          ),
        ),
      );

      // Then try to get more precise location in the background
      if (_isApproximate) {
        _getPreciseLocation();
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _errorMessage = 'Error getting location: ${e.toString()}';
        _retryCount++;
      });
    }
  }

  Future<void> _getPreciseLocation() async {
    try {
      final position = await _locationService.getCurrentLocation();
      if (mounted) {
        setState(() {
          _pickedLocation = LatLng(position.latitude, position.longitude);
          _isApproximate = false;
        });
        _getAddress(_pickedLocation!);

        // Animate camera to new position
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _pickedLocation!,
              zoom: 16,
            ),
          ),
        );
      }
    } catch (e) {
      // Ignore errors for precise location as we already have approximate
      print('Error getting precise location: $e');
    }
  }

  Future<void> _getAddress(LatLng latLng) async {
    try {
      final address = await _locationService.getAddressFromCoordinates(
        Position(
          latitude: latLng.latitude,
          longitude: latLng.longitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        ),
      );
      if (mounted) {
        setState(() {
          _pickedAddress = address;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error getting address: ${e.toString()}';
        });
      }
    }
  }

  void _onMapTap(LatLng latLng) {
    setState(() {
      _pickedLocation = latLng;
      _pickedAddress = null;
      _errorMessage = null;
      _isApproximate = false;
    });
    _getAddress(latLng);
  }

  Future<void> _searchLocation(String address) async {
    if (address.isEmpty) return;

    setState(() {
      _isSearching = true;
      _errorMessage = null;
    });

    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final location = locations.first;
        final newLatLng = LatLng(location.latitude, location.longitude);

        // Fetch the formatted address
        final formattedAddress =
            await _locationService.getAddressFromCoordinates(
          Position(
            latitude: location.latitude,
            longitude: location.longitude,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0,
            altitudeAccuracy: 0,
            headingAccuracy: 0,
          ),
        );

        print('Geocoded to: \\${newLatLng.latitude}, \\${newLatLng.longitude}');

        setState(() {
          _pickedLocation = newLatLng;
          _pickedAddress = formattedAddress;
          _addressController.text = formattedAddress; // Update text field
          _isApproximate = false;
          _isSearching = false;
        });

        // Animate camera to the new location
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: newLatLng,
              zoom: 16,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isSearching = false;
        _errorMessage =
            'Could not find location. Please try a different address.';
      });
    }
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _addressController.text = _pickedAddress ?? '';
    });
  }

  void _saveEditedAddress() {
    final newAddress = _addressController.text.trim();
    if (newAddress.isNotEmpty) {
      _searchLocation(newAddress);
    }
    setState(() {
      _isEditing = false;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Delivery Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _determinePosition,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Always show the map, even when loading
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _pickedLocation ?? _defaultLocation,
              zoom: 16,
            ),
            mapType: MapType.normal,
            onMapCreated: (controller) {
              _mapController = controller;
              // If we have a picked location, animate to it
              if (_pickedLocation != null) {
                controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: _pickedLocation!,
                      zoom: 16,
                    ),
                  ),
                );
              }
            },
            onTap: _onMapTap,
            markers: _pickedLocation == null
                ? {}
                : {
                    Marker(
                      markerId: const MarkerId('picked'),
                      position: _pickedLocation!,
                    ),
                  },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            mapToolbarEnabled: true,
            compassEnabled: true,
          ),
          if (_loading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Getting your location...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          if (_errorMessage != null)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Card(
                  margin: const EdgeInsets.all(20),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _determinePosition,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (_pickedAddress != null)
            Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Selected Location:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          if (_isApproximate)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Approximate',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (_isEditing)
                        Column(
                          children: [
                            TextField(
                              controller: _addressController,
                              decoration: InputDecoration(
                                hintText: 'Enter delivery address',
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                suffixIcon: _isSearching
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : IconButton(
                                        icon: const Icon(Icons.search),
                                        onPressed: () => _searchLocation(
                                            _addressController.text),
                                      ),
                              ),
                              maxLines: 2,
                              onSubmitted: (value) => _searchLocation(value),
                            ),
                          ],
                        )
                      else
                        InkWell(
                          onTap: _startEditing,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _pickedAddress!,
                                    style: const TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                const Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: (_isEditing &&
                          _addressController.text.trim().isEmpty) ||
                      (!_isEditing &&
                          (_pickedAddress == null ||
                              _pickedAddress!.trim().isEmpty))
                  ? null
                  : () async {
                      String addressToSave;
                      if (_isEditing &&
                          _addressController.text.trim().isNotEmpty) {
                        addressToSave = _addressController.text.trim();
                        try {
                          List<Location> locations =
                              await locationFromAddress(addressToSave);
                          if (locations.isNotEmpty) {
                            final location = locations.first;
                            final newLatLng =
                                LatLng(location.latitude, location.longitude);
                            setState(() {
                              _pickedLocation = newLatLng;
                              _pickedAddress = addressToSave;
                              _isApproximate = false;
                            });
                            _mapController?.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target: newLatLng,
                                  zoom: 16,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Could not find location. Please try a different address.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Error finding location: \\${e.toString()}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                      } else {
                        addressToSave = _pickedAddress!;
                      }
                      await _locationService.saveDeliveryAddress(addressToSave);
                      if (mounted) {
                        Navigator.pop(context, addressToSave);
                      }
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Confirm Location'),
            ),
          ),
        ],
      ),
    );
  }
}
