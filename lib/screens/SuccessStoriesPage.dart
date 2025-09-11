import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async'; // Import for Timer

class SuccessStoriesPage extends StatefulWidget {
  const SuccessStoriesPage({super.key}); // Fix for super constructor

  @override
  State<SuccessStoriesPage> createState() => _SuccessStoriesPageState();
}

class _SuccessStoriesPageState extends State<SuccessStoriesPage> {
  final List<Map<String, dynamic>> testimonials = [
    {
      'name': 'Aisha Rahman',
      'image': 'https://via.placeholder.com/80/8E2DE2/FFFFFF?text=AR',
      'tier': 'Graduate',
      'story': 'I was unsure about my career path after college. AspireEdge helped me choose Computer Science. Now I work as a Software Engineer at a top tech company!',
    },
    {
      'name': 'Raj Patel',
      'image': 'https://via.placeholder.com/80/5B6CF1/FFFFFF?text=RP',
      'tier': 'Graduate',
      'story': 'Thanks to the interview prep module, I cracked my first job interview in just two weeks. I’m now working as a Data Analyst.',
    },
    {
      'name': 'Priya Singh',
      'image': 'https://via.placeholder.com/80/8E2DE2/FFFFFF?text=PS',
      'tier': 'Graduate',
      'story': 'I used the CV tips section to build a strong resume. Within a month, I landed a job in marketing. AspireEdge changed my life!',
    },
    {
      'name': 'Arjun Mehta',
      'image': 'https://via.placeholder.com/80/5B6CF1/FFFFFF?text=AM',
      'tier': 'Graduate',
      'story': 'The Career Bank helped me explore options beyond engineering. I chose Business Management and now run my own startup.',
    },
  ];

  int currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startAutoRotation();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startAutoRotation() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % testimonials.length;
      });
    });
  }

  void _goToIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF8E2DE2)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Success Stories',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D3748),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'Real Stories from Graduates',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'See how AspireEdge helped others find their dream careers.',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 30),

            // Testimonial Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF8E2DE2).withValues(alpha: 0.1), // Correct usage of withValues
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(testimonials[currentIndex]['image']),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              testimonials[currentIndex]['name'],
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                            SizedBox(height: 4),
                            Chip(
                              label: Text(
                                testimonials[currentIndex]['tier'],
                                style: GoogleFonts.poppins(fontSize: 12),
                              ),
                              backgroundColor: Color(0xFF8E2DE2).withValues(alpha: 0.1), // Correct usage of withValues
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    testimonials[currentIndex]['story'],
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Color(0xFF2D3748),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(testimonials.length, (index) {
                return GestureDetector(
                  onTap: () => _goToIndex(index),
                  child: Container(
                    width: 12,
                    height: 12,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: index == currentIndex ? Color(0xFF8E2DE2) : Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
