class Video {
  final String title;
  final String description;
  final String videoUrl;
  

  Video({
    required this.title,
    required this.description,
    required this.videoUrl,
  });
}
List<Video> favorites = []; // List to store favorite video