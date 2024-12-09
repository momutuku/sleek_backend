import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sleek/model/property_model.dart';

class EditPropertyScreen extends StatefulWidget {
  final Property property;

  const EditPropertyScreen({Key? key, required this.property}) : super(key: key);

  @override
  _EditPropertyScreenState createState() => _EditPropertyScreenState();
}

class _EditPropertyScreenState extends State<EditPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _gpsLocationController;
  late TextEditingController _descriptionController;
  late TextEditingController _costController;
  late TextEditingController _locationController;
  late TextEditingController _amenitiesController;

  File? _mainImage;
  final List<File> _extraImages = [];

  @override
  void initState() {
    super.initState();

   
    _nameController = TextEditingController(text: widget.property.name);
    _gpsLocationController =
        TextEditingController(text: widget.property.gpsLocation);
    _descriptionController =
        TextEditingController(text: widget.property.description);
    _costController =
        TextEditingController(text: widget.property.cost.toString());
    _locationController = TextEditingController(text: widget.property.location);
    _amenitiesController =
        TextEditingController(text: widget.property.amenities);

   
    if (widget.property.image != null) {
      _mainImage = File(widget.property.image!);
    }
    _extraImages.addAll(widget.property.images
        .map((image) => File(image.imageUrl))
        .toList(growable: true));
  }

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
     
      final updatedProperty = Property(
        id: widget.property.id,
        ownerId: widget.property.ownerId,
        name: _nameController.text,
        gpsLocation: _gpsLocationController.text,
        description: _descriptionController.text,
        cost: double.parse(_costController.text),
        location: _locationController.text,
        amenities: _amenitiesController.text,
        image: _mainImage?.path,
        images: _extraImages
            .map((file) => PropertyImage(id: 0, imageUrl: file.path))
            .toList(),
        owner: widget.property.owner, active: true,
      );

      print("Updated Property: $updatedProperty");

     
      Navigator.pop(context, updatedProperty);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Property")),
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
                validator: (value) => value == null || value.isEmpty
                    ? "Please enter a name"
                    : null,
              ),

             
              TextFormField(
                controller: _gpsLocationController,
                decoration: const InputDecoration(labelText: "GPS Location"),
                validator: (value) => value == null || value.isEmpty
                    ? "Please enter GPS location"
                    : null,
              ),

             
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                validator: (value) => value == null || value.isEmpty
                    ? "Please enter a description"
                    : null,
              ),

             
              TextFormField(
                controller: _costController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Cost"),
                validator: (value) => value == null || value.isEmpty
                    ? "Please enter the cost"
                    : null,
              ),

             
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: "Location"),
                validator: (value) => value == null || value.isEmpty
                    ? "Please enter the location"
                    : null,
              ),

             
              TextFormField(
                controller: _amenitiesController,
                decoration: const InputDecoration(labelText: "Amenities"),
                validator: (value) => value == null || value.isEmpty
                    ? "Please enter amenities"
                    : null,
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
                        child: Stack(
                          children: [
                            Image.file(
                              _extraImages[index],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _extraImages.removeAt(index);
                                  });
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
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
                  child: const Text("Save Changes"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
