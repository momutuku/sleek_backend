import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({Key? key}) : super(key: key);

  @override
  _AddPropertyScreenState createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gpsLocationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _amenitiesController = TextEditingController();

  File? _mainImage;
  final List<File> _extraImages = [];

  Future<void> _pickImage(bool isMainImage) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isMainImage) {
          _mainImage = File(pickedFile.path);
        } else {
          _extraImages.add(File(pickedFile.path));
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
     
      final propertyData = {
        "name": _nameController.text,
        "gpslocation": _gpsLocationController.text,
        "description": _descriptionController.text,
        "cost": _costController.text,
        "location": _locationController.text,
        "amenities": _amenitiesController.text,
        "image": _mainImage != null ? _mainImage!.path : null,
        "extra_images": _extraImages.map((file) => file.path).toList(),
      };

     
      print(propertyData);

     
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Property")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Property Name"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Please enter a name" : null,
              ),

             
              TextFormField(
                controller: _gpsLocationController,
                decoration: const InputDecoration(labelText: "GPS Location"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Please enter GPS location" : null,
              ),

             
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Please enter a description" : null,
              ),

             
              TextFormField(
                controller: _costController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Cost"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Please enter the cost" : null,
              ),

             
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: "Location"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Please enter the location" : null,
              ),

             
              TextFormField(
                controller: _amenitiesController,
                decoration: const InputDecoration(labelText: "Amenities"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Please enter amenities" : null,
              ),

              const SizedBox(height: 16),

             
              Text("Main Image"),
              const SizedBox(height: 8),
              if (_mainImage != null)
                Image.file(_mainImage!, height: 150, fit: BoxFit.cover),
              TextButton.icon(
                onPressed: () => _pickImage(true),
                icon: const Icon(Icons.image),
                label: const Text("Pick Main Image"),
              ),

              const SizedBox(height: 16),

             
              Text("Extra Images"),
              const SizedBox(height: 8),
              if (_extraImages.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _extraImages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.file(
                          _extraImages[index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              TextButton.icon(
                onPressed: () => _pickImage(false),
                icon: const Icon(Icons.image),
                label: const Text("Pick Extra Images"),
              ),

              const SizedBox(height: 32),

             
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
