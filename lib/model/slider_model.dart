class SliderResponse {
  final int status;
  final List<String> sliders;

  SliderResponse({required this.status, required this.sliders});

  factory SliderResponse.fromJson(Map<String, dynamic> json) {
    // The 'sliders' key contains a list of strings (the image URLs).
    return SliderResponse(
      status: json['status'],
      sliders: List<String>.from(json['sliders']),
    );
  }
}
