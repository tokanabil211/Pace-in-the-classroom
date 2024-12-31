import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:gemini_chat_bot/video.dart';
import 'package:gemini_chat_bot/navigation_bar/navigation_bar_screen.dart';
class FavoritesPage extends StatelessWidget {
  final List<Video> favorites; // Accept favorites in the constructor

  const FavoritesPage({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NavigationBarSection()),
            ); 
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Favorites",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 36),
            Image.asset('assets/images/favIcon.png', width: 22, height: 22),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // List of Favorite Items
            Expanded(
              child: ListView.builder(
                itemCount: favorites.length, // Use the length of favorites
                itemBuilder: (context, index) {
                  final video = favorites[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: FavoriteCard(video: video), // Pass the video to FavoriteCard
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteCard extends StatefulWidget {
  final Video video; // Accept the video in the constructor

  const FavoriteCard({super.key, required this.video});

  @override
  _FavoriteCardState createState() => _FavoriteCardState();
}

class _FavoriteCardState extends State<FavoriteCard> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the video player controller with the video URL
    _controller = VideoPlayerController.network(widget.video.videoUrl)
      ..initialize().then((_) {
        setState(() {}); // Update the UI when the video is initialized
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up the controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Video Player
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: _controller.value.isInitialized
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _controller.value.isPlaying ? _controller.pause() : _controller.play();
                      });
                    },
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : Center(child: CircularProgressIndicator()), // Show loading indicator
          ),
          // Favorite Icon
          Positioned(
            top: 10,
            right: 10,
            child: Icon(
              Icons.favorite,
              color: Colors.red,
              size: 28,
            ),
          ),
          // Text Information
          Positioned(
            bottom: 16,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.video.title, // Display the video title
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      widget.video.description, // Display the video description
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(width: 145),
                    Icon(Icons.access_time, color: Colors.white70, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '6:00', // Placeholder for video duration
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
