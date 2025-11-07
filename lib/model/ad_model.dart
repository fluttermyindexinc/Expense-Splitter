class Ad {
  final String imageUrl;

  Ad({required this.imageUrl});

  factory Ad.fromJson(Map<String, dynamic> json) {
    // This factory constructor parses the JSON response from your API.
    return Ad(
      imageUrl: json['ads'],
    );
  }
}
