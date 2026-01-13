class Property {
  final int? id;
  final String title;
  final String address;
  final double rentAmount;
  final int? ownerId;
  final String? ownerName;

  Property({
    this.id,
    required this.title,
    required this.address,
    required this.rentAmount,
    this.ownerId,
    this.ownerName,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      title: json['title'],
      address: json['address'],
      rentAmount: (json['rentAmount'] as num).toDouble(),
      ownerId: json['ownerId'],
      ownerName: json['ownerName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'address': address,
      'rentAmount': rentAmount,
    };
  }
}
