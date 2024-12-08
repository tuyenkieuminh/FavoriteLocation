import 'dart:io';

import 'package:favorite_places_new/models/place.dart';
import 'package:favorite_places_new/providers/favorite_places_provider.dart';
import 'package:favorite_places_new/widgets/image_input.dart';
import 'package:favorite_places_new/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewItemScreen extends ConsumerStatefulWidget {
  const NewItemScreen({super.key});

  @override
  ConsumerState<NewItemScreen> createState() => _NewItemScreenState();
}

class _NewItemScreenState extends ConsumerState<NewItemScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredTitle = '';
  bool? hasPicture;
  bool? hasLocation;
  File? _pickedPicture;
  PlaceLocation? _placeLocation;

  void _checkPicture() {
    if (_pickedPicture == null) {
      setState(() {
        hasPicture = false;
      });
    } else {
      setState(() {
        hasPicture = true;
      });
    }
  }

  void _savePlace() {
    if (_formKey.currentState!.validate() && _pickedPicture != null && _placeLocation != null) {
      _formKey.currentState!.save();

      ref.read(favoritePlacesNotifier.notifier).addNewPlace(
            Place(
              title: _enteredTitle,
              image: _pickedPicture!,
              location: _placeLocation!,
            ),
          );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Place'),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  validator: (value) {
                    
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 50) {
                      return 'Must be between 1 and 50 characters.';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _enteredTitle = newValue!;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                ImageInput(getPickedPicture: (pickedPicture) {
                  _pickedPicture = pickedPicture;
                  hasPicture = true;
                }),
                // if (hasPicture != null)
                //   if (hasPicture == false)
                //     Text(
                //       "Must pick a picture.",
                //       style: Theme.of(context).textTheme.bodySmall!.copyWith(
                //             color: Colors.red[200],
                //           ),
                //     ),
                const SizedBox(
                  height: 15,
                ),
                LocationInput(
                  getLocation: (placeLocation) {
                    _placeLocation = placeLocation;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _savePlace();
                      },
                      label: const Text('Add Place'),
                      icon: const Icon(Icons.add),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
