import 'package:flutter/material.dart';
import 'package:gemini_chat_bot/api_service.dart'; // Import the API service
import 'package:video_player/video_player.dart'; // Import the video player package
import 'about_pace.dart'; // Import the details screen
import 'package:audioplayers/audioplayers.dart'; // Import audio player package
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart'; // Import PDF view package
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart'; 
import 'package:gemini_chat_bot/favourites/presentation/favourites_screen.dart';
import 'package:gemini_chat_bot/video.dart';// Define your podcast assets

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  late Future<List<dynamic>> _data;
  final ApiService apiService = ApiService('http://192.168.1.21:3000'); // Update with your local server IP

  @override
  void initState() {
    super.initState();
    _fetchData(_selectedCategoryIndex);
  }

  void _fetchData(int index) {
    String category;
    switch (index) {
      case 0:
        category = 'videos';
        break;
      case 1:
        category = 'maps'; // Updated index for storymaps
        break;
      case 2:
        category = 'docs';
        break;
      case 3:
        category = 'images';
        break;
      case 4:
        category = 'brochures';
        break;
      case 5:
        category = 'news';
        break;
      default:
        category = 'videos';
    }
    setState(() {
      _data = apiService.fetchData(category); // Fetch data based on selected category
    });
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi, There 👋",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              "Let's explore PACE!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 45),

            // Category Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(6, (index) {
                  return GestureDetector(
                    child: _buildCategoryTab(
                      ["videos", "storymaps", "documents", "images", "brochures", "news"][index],
                      index,
                    ),
                    onTap: () {
                      setState(() {
                        _selectedCategoryIndex = index;
                        _fetchData(index); // Fetch data when category is tapped
                      });
                    },
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),

            // Display Data
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _data,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final dataList = snapshot.data!;
                    return PageView.builder(
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        return _buildContent(dataList[index]);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Method to build category tabs
  Widget _buildCategoryTab(String title, int index) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _selectedCategoryIndex == index ? Colors.black : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: _selectedCategoryIndex == index ? Colors.white : Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }


  // Method to build content based on type
  Widget _buildContent(dynamic item) {
    String url = item['url'] ?? '';
    String title = item['title'] ?? 'Untitled Video'; 
    String description = item['description'] ?? 'Untitled Video';
    List<dynamic> questions = item['questions'] ?? [];
     // Default title if not found
    print('Item URL: $url');

// Handle podcasts
// Inside your widget


    // Handle images
    if (url.contains('.png') || url.contains('.jpg')) {
      return Card(
        child: GestureDetector(
          onTap: () {
            // Optionally navigate to a detail view for the image
          },
          child: Image.network(url, fit: BoxFit.cover), // Display the image
        ),
      );
    }
if (url.contains('storymaps')) {
    return Card(
  elevation: 5, // Adds shadow for depth
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12), // Rounded corners
  ),
  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Spacing around the card
  child: InkWell(
    onTap: () {
      print('Opening Web Page: $url');
      // Navigate to WebView
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebViewScreen(url: url), // Opens WebView
        ),
      );
    },
    splashColor: Colors.blue.withOpacity(0.3), // Ripple effect on tap
    child: Padding(
      padding: EdgeInsets.all(12), // Internal padding
      child: Row(
        children: [
          // Icon for Story Maps
          Icon(
            Icons.map, // Use a map icon to represent Story Maps
            color: Colors.blueAccent, // Blue color for the icon
            size: 40,
          ),
          SizedBox(width: 15), // Space between icon and text
          
          // Expanded for flexible layout
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title displaying the link text
                Text(
                  'Open Web Page: $title',
                  style: TextStyle(
                    fontSize: 18, // Larger title text
                    fontWeight: FontWeight.w600, // Slightly bold
                    color: Colors.black87, // Dark color for visibility
                  ),
                ),
                SizedBox(height: 6), // Space between title and subtitle
                // Subtitle to guide interaction
                Text(
                  'Click to view the story map',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600], // Lighter subtitle color
                  ),
                ),
              ],
            ),
          ),
          // Action indicator icon
          Icon(
            Icons.open_in_new, // Suggests that a new view will open
            color: Colors.grey, // Grey color for action icon
            size: 22,
          ),
        ],
      ),
    ),
  ),
);

  }
    // Handle story maps and newsletters (PDFs)
    if (url.contains('Brochure') || url.contains('brochure') || url.contains('brochures')) {
      return Card(
  elevation: 5, // Adds a slight shadow for a raised look
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12), // Rounded corners for a modern feel
  ),
  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Adds spacing around the card
  child: InkWell(
    onTap: () {
      print('Opening PDF or Story Map: $url');
      // Navigate to PDF viewer
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(url: url), // Opens the PDF viewer
        ),
      );
    },
    splashColor: Colors.lightGreen.withOpacity(0.3), // Ripple effect on tap
    child: Padding(
      padding: EdgeInsets.all(12), // Adds internal padding for spacing
      child: Row(
        children: [
          // Icon representing a Brochure
          Icon(
            Icons.folder, // Use folder icon for Brochure
            color: Colors.greenAccent, // Green accent color for the icon
            size: 40,
          ),
          SizedBox(width: 15), // Space between icon and text
          
          // Expanded to fill remaining space
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title of the brochure
                Text(
                  item['title'] ?? 'Brochure',
                  style: TextStyle(
                    fontSize: 18, // Larger title text
                    fontWeight: FontWeight.w600, // Slightly bold
                    color: Colors.black87, // Dark color for better visibility
                  ),
                ),
                SizedBox(height: 6), // Space between title and subtitle
                // Subtitle for interaction hint
                Text(
                  'Click to view the brochure',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600], // Lighter color for the subtitle
                  ),
                ),
              ],
            ),
          ),
          // Action indicator icon
          Icon(
            Icons.open_in_new, // Suggests a new view will open
            color: Colors.grey, // Grey color for the action icon
            size: 22,
          ),
        ],
      ),
    ),
  ),
);

    }
     if (url.contains('Newsletter') ) {
      return Card(
  elevation: 5, // Adds a slight shadow for a raised look
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12), // Rounded corners
  ),
  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Adds spacing around the card
  child: InkWell(
    onTap: () {
      print('Opening PDF or Story Map: $url');
      // Navigate to PDF viewer
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(url: url), // Opens the PDF viewer
        ),
      );
    },
    splashColor: Colors.lightBlue.withOpacity(0.3), // Ripple effect when tapped
    child: Padding(
      padding: EdgeInsets.all(12), // Adds internal padding
      child: Row(
        children: [
          // Icon representing a Newsletter
          Icon(
            Icons.article, // Use article icon for Newsletter
            color: Colors.lightBlueAccent, // Light blue color for icon
            size: 40,
          ),
          SizedBox(width: 15), // Adds space between the icon and text
          
          // Expanded to make the text fill the remaining space
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title of the newsletter
                Text(
                  item['title'] ?? 'Newsletter',
                  style: TextStyle(
                    fontSize: 18, // Larger text for the title
                    fontWeight: FontWeight.w600, // Slightly bold
                    color: Colors.black87, // Dark text color for good contrast
                  ),
                ),
                SizedBox(height: 6), // Adds space between title and subtitle
                // Subtitle for interaction hint
                Text(
                  'Click to read the newsletter',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600], // Subtitle in a lighter color
                  ),
                ),
              ],
            ),
          ),
          // Icon to indicate interaction
          Icon(
            Icons.open_in_new, // Shows an icon that suggests a new view will open
            color: Colors.grey, // Grey color for the interaction icon
            size: 22,
          ),
        ],
      ),
    ),
  ),
);

    }
if (url.contains('docs') ) {
      return Card(
  elevation: 4, // Shadow effect for a raised card
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15), // Rounded corners
  ),
  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6), // Card padding
  child: InkWell(
    onTap: () {
      print('Opening PDF or Story Map: $url');
      // Open the PDF viewer
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(url: url), // Navigate to PDF viewer
        ),
      );
    },
    splashColor: Colors.blue.withAlpha(30), // Ripple effect on tap
    child: Padding(
      padding: EdgeInsets.all(10), // Internal padding for the card content
      child: Row(
        children: [
          // Icon representing a document (PDF or Story Map)
          Icon(
            Icons.picture_as_pdf, // Use document icon
            color: Colors.redAccent, // Icon color
            size: 40,
          ),
          SizedBox(width: 15), // Space between icon and text
          
          // Expanded ensures text takes up remaining space
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] ?? 'Document',
                  style: TextStyle(
                    fontSize: 18, // Larger text for title
                    fontWeight: FontWeight.bold, // Bold title
                    color: Colors.black87, // Darker text color
                  ),
                ),
                SizedBox(height: 5), // Space between title and subtitle
                Text(
                  'Click to view',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600], // Lighter subtitle color
                  ),
                ),
              ],
            ),
          ),
          // Optional icon to indicate navigation
          Icon(
            Icons.arrow_forward_ios, 
            color: Colors.grey, // Arrow color
            size: 18,
          ),
        ],
      ),
    ),
  ),
);

    }

    // Handle other types (like videos)
    return VideoPlayerWidget(
      videoUrl: url,
      title: title,
      description: description,
      questions: questions, // Pass the title to VideoPlayerWidget
      onTap: () {
        print('Navigating to Video: $url');
        // Navigate to the VideoPlayerScreen with the selected item
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(data: item), // Pass video data
          ),
        );
      },
    );
  }
}



class WebViewScreen extends StatefulWidget {
  final String url;

  WebViewScreen({required this.url});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late InAppWebViewController webViewController;
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web View'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              webViewController.reload();
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              webViewController.goBack();
            },
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onProgressChanged: (controller, progress) {
              setState(() {
                this.progress = progress / 100;
              });
            },
          ),
          progress < 1.0
              ? LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}


 // For sharing functionality

class PDFViewerScreen extends StatelessWidget {
  final String url;

  PDFViewerScreen({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              // TODO: Add PDF download functionality here
              print('Download button pressed');
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              
            },
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SfPdfViewer.network(
        url,
        onDocumentLoaded: (PdfDocumentLoadedDetails details) {
          print('PDF Loaded Successfully');
        },
        onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
          print('Failed to load PDF: ${details.error}');
        },
      ),
    );
  }
}



class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String description;
  final List<dynamic> questions;
  final VoidCallback? onTap;

  VideoPlayerWidget({
    required this.videoUrl,
    required this.title,
    required this.description,
    required this.questions,
    this.onTap,
  });

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  static List<Video> favorites = []; // List to store favorite video

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {}); // Refresh the widget when initialized
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when done
    super.dispose();
  }
void _addToFavorites() {
    final video = Video(
      title: widget.title,
      description: widget.description,
      videoUrl: widget.videoUrl,
    );
    favorites.add(video);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoritesPage(favorites: favorites), // Pass favorites to the page
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Make the entire widget scrollable
      child: GestureDetector(
        onTap: widget.onTap ?? () {}, // Use an empty function if onTap is null
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Space between title and video
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(15), // Rounded corners
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: _controller.value.isInitialized
                    ? VideoPlayer(_controller)
                    : Center(child: CircularProgressIndicator()),
              ),
            ),
            SizedBox(height: 10), // Space between video and suggestions

            // Title and favorites icon container
            Container(
              color: Colors.white, // Grey background for the title
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between title and icon
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.favorite_border), // Change to Icons.favorite for filled icon
                    color: Colors.grey[300],
                    
                    onPressed: _addToFavorites,
                    
                  ),
                ],
              ),
            ),

            SizedBox(height: 25),

            // Suggestion slider
            if (widget.questions.isNotEmpty) ...[
              Container(
                height: 80, // Increase height for text and suggestion slider
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text above the container
                    Container(
                      margin: const EdgeInsets.only(left: 8.0), // Optional: margin to slightly move it away from the edge
                      child: Text(
                        'Explore Our Recommendations', // Text displayed above the container
                        style: TextStyle(
                          fontSize: 18, // Size of the text
                          fontWeight: FontWeight.bold, // Weight of the text
                          color: Colors.black, // Color of the text
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Suggestion slider (PageView)
                    Expanded( // Use Expanded to allow the PageView to take the remaining height
                      child: PageView.builder(
                        itemCount: (widget.questions.length / 2).ceil(), // Calculate number of pages
                        itemBuilder: (context, pageIndex) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // First container with link
                              GestureDetector(
                                onTap: () async {
                                  const url = 'https://open.spotify.com/episode/30WlNImoOsn9aA1ILMg3PF?si=8a6b58813fbb4c9d&nd=1&dlsi=2867ea095bf64651';
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.42, // Width for the first container
                                  margin: EdgeInsets.symmetric(horizontal: 8.0), // Margin around each container
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200], // Background color for suggestion
                                    borderRadius: BorderRadius.circular(15), // Rounded corners
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Let\'s Explore Podcasts', // Text displayed in the container
                                      style: TextStyle(
                                        color: Colors.black, // Text color
                                        fontWeight: FontWeight.bold, // Text weight
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8), 
                              GestureDetector(
                                onTap: () async {
                                  const url = 'https://pace.oceansciences.org/docs/PACE_Newsletter_October-2022.pdf';
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.42, // Width for the second container
                                  margin: EdgeInsets.symmetric(horizontal: 8.0), // Margin around each container
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200], // Background color for suggestion
                                    borderRadius: BorderRadius.circular(15), // Rounded corners
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Popular News ', // Text displayed in the container
                                      style: TextStyle(
                                        color: Colors.black, // Text color
                                        fontWeight: FontWeight.bold, // Text weight
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              SizedBox(height: 8),  // Space between containers
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
