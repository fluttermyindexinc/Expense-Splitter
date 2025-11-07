class AppSettings {
  final String contact;
  final String privacy;
  final String terms;
  final String playStore;
  final String about;
  final String blogs;

  AppSettings({
    required this.contact,
    required this.privacy,
    required this.terms,
    required this.playStore,
        required this.about,
    required this.blogs,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) { 
    return AppSettings(
      contact: json["contact"],
      privacy: json["privacy"],
      terms: json["terms"],
      playStore: json["play_store"],
      about: json["about"],
      blogs: json["blogs"],
    );
  }
}
