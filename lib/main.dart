import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carousel Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CarouselDemo(),
    );
  }
}

class CarouselDemo extends StatelessWidget {
  const CarouselDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Carousel Examples')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Basic PageView Carousel', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 10),
            BasicCarousel(),
            SizedBox(height: 30),


            Text('Carousel with Indicators', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 10),
            CarouselWithIndicators(),
          ],
        ),
      ),
    );
  }
}

// 1. Basic Carousel using PageView with Local Images
class BasicCarousel extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/images/AppBreweryWallpaper.png',
    'assets/images/AppBreweryWallpaper 3.png',
    'assets/images/AppBreweryWallpaper 6.png',
    'assets/images/AppBreweryWallpaper 7.jpg',
    'assets/images/AppBreweryWallpaper.png',
  ];

  // image titles
  final List<String> imageTitles = [
    'First Image',
    'Second Image', 
    'Third Image',
    'Fourth Image',
    'Fifth Image',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: PageView.builder(
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // The local image
                  Image.asset(
                    imagePaths[index],
                    fit: BoxFit.cover,
                    // Error handling for missing images
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                              SizedBox(height: 8),
                              Text(
                                'Image not found',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  // overlay with title
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(),
                          ],
                        ),
                      ),
                      child: Text(
                        imageTitles[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// 2. Carousel with Dot Indicators
class CarouselWithIndicators extends StatefulWidget {
  @override
  _CarouselWithIndicatorsState createState() => _CarouselWithIndicatorsState();
}

class _CarouselWithIndicatorsState extends State<CarouselWithIndicators> {
  PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<CarouselItem> items = [
    CarouselItem(
      title: 'Welcome',
      description: 'This is the first slide',
      color: Colors.blue,
    ),
    CarouselItem(
      title: 'Features',
      description: 'Discover amazing features',
      color: Colors.green,
    ),
    CarouselItem(
      title: 'Get Started',
      description: 'Ready to begin your journey',
      color: Colors.orange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 250,
          child: PageView.builder(
            controller: _pageController,
            itemCount: items.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: items[index].color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      items[index].title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      items[index].description,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16),
        // Dot Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  entry.key,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                width: 12,
                height: 12,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == entry.key
                      ? Colors.blue
                      : Colors.grey.shade400,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

// Custom Carousel Widget (Reusable)
class CustomCarousel extends StatefulWidget {
  final List<Widget> children;
  final double height;
  final Duration autoPlayDuration;
  final bool autoPlay;
  final bool showIndicators;
  final Color indicatorColor;
  final Color activeIndicatorColor;

  const CustomCarousel({
    Key? key,
    required this.children,
    this.height = 200,
    this.autoPlayDuration = const Duration(seconds: 4),
    this.autoPlay = false,
    this.showIndicators = true,
    this.indicatorColor = Colors.grey,
    this.activeIndicatorColor = Colors.blue,
  }) : super(key: key);

  @override
  _CustomCarouselState createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  PageController _controller = PageController();
  int _currentIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: widget.height,
          child: PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: widget.children,
          ),
        ),
        if (widget.showIndicators) ...[
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.children.asMap().entries.map((entry) {
              return Container(
                width: 8,
                height: 8,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == entry.key
                      ? widget.activeIndicatorColor
                      : widget.indicatorColor,
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

// Helper class for carousel items
class CarouselItem {
  final String title;
  final String description;
  final Color color;

  CarouselItem({
    required this.title,
    required this.description,
    required this.color,
  });
}
