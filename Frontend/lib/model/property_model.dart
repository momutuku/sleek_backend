class Property {
  final int id;
  final String name;
  final int ownerId;
  final String gpsLocation;
  final String description;
  final String amenities;
  final String? image;
  final double cost;
  final String location;
  final bool active;
  final List<PropertyImage> images;
  final Owner owner;

  Property({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.gpsLocation,
    required this.description,
    required this.amenities,
    this.image,
    required this.cost,
    required this.location,
    required this.active,
    required this.images,
    required this.owner,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      name: json['name'],
      ownerId: json['owner_id'],
      gpsLocation: json['gpslocation'],
      description: json['description'],
      amenities: json['amenities'],
      image: json['image'],
      cost: double.parse(json['cost']),
      location: json['location'],
      active: json['active'] == 1,
      images: (json['images'] as List)
          .map((imageJson) => PropertyImage.fromJson(imageJson))
          .toList(),
      owner: Owner.fromJson(json['owner']),
    );
  }
}

class PropertyImage {
  final int id;
  final String imageUrl;

  PropertyImage({required this.id, required this.imageUrl});

  factory PropertyImage.fromJson(Map<String, dynamic> json) {
    return PropertyImage(
      id: json['id'],
      imageUrl: json['image'],
    );
  }
}

class Owner {
  final int id;
  final String firstName;
  final String lastName;
  final String email;

  Owner({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
    );
  }
}
