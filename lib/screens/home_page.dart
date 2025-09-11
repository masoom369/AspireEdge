import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> featuredModules = [
    {
      'title': 'Career Bank',
      'subtitle': 'Explore 100+ career paths',
      'description': 'Discover careers by industry, skills, salary & education path.',
      'color': Color(0xFF8E2DE2),
      'icon': Icons.work,
    },
    {
      'title': 'Interest Quiz',
      'subtitle': 'Find your ideal career',
      'description': 'AI-powered quiz to match your interests and strengths.',
      'color': Color(0xFF5B6CF1),
      'icon': Icons.quiz,
    },
    {
      'title': 'CV Tips',
      'subtitle': 'Build a winning resume',
      'description': 'Templates, do’s and don’ts, and expert advice.',
      'color': Color(0xFF8E2DE2),
      'icon': Icons.description,
    },
    {
      'title': 'Interview Prep',
      'subtitle': 'Ace your next interview',
      'description': 'Mock videos, common questions, body language tips.',
      'color': Color(0xFF5B6CF1),
      'icon': Icons.chat_bubble_outline,
    },
  ];

  final List<Map<String, dynamic>> recentContent = [
    {
      'title': 'How to Choose Your Stream?',
      'duration': 'Watch video - 15 mins',
      'color': Color(0xFF8E2DE2),
    },
    {
      'title': 'Top 5 Tech Careers in 2024',
      'duration': 'Read blog - 8 mins',
      'color': Color(0xFF5B6CF1),
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Color(0xFF8E2DE2)),
          onPressed: () {},
        ),
        title: Text(
          'AspireEdge',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF8E2DE2),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Color(0xFF8E2DE2)),
            onPressed: () {},
          ),
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage('https://via.placeholder.com/100/8E2DE2/FFFFFF?text=U'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            SizedBox(height: 20),
            Text(
              'Your Future Starts Here',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Explore careers, take quizzes, and unlock your potential with personalized guidance.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 30),

            // Featured Modules Grid
            Text(
              'Featured Tools',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: featuredModules.length,
              itemBuilder: (context, index) {
                final module = featuredModules[index];
                return Container(
                  decoration: BoxDecoration(
                    color: module['color'],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: module['color'].withOpacity(0.2),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              module['title'],
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              child: Icon(
                                module['icon'],
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          module['subtitle'],
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          module['description'],
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 30),

            // Recent Content
            Text(
              'Recent',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: 16),
            Column(
              children: recentContent.map((content) {
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: content['color'],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: content['color'].withOpacity(0.2),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                content['title'],
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                content['duration'],
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
