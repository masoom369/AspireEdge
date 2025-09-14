import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aspire_edge/screens/entryPoint/components/custom_appbar.dart';

import '../../models/testimonial.dart';
import '../../services/testimonial_dao.dart';

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
      'description':
          'Discover careers by industry, skills, salary & education path.',
      'color': Color(0xFF8E2DE2),
      'icon': Icons.work,
      'route': '/career_bank',
    },
    {
      'title': 'Interest Quiz',
      'subtitle': 'Find your ideal career',
      'description': 'AI-powered quiz to match your interests and strengths.',
      'color': Color(0xFF5B6CF1),
      'icon': Icons.quiz,
      'route': '/quiz_management',
    },
    {
      'title': 'CV Tips',
      'subtitle': 'Build a winning resume',
      'description': 'Templates, do’s and don’ts, and expert advice.',
      'color': Color(0xFF8E2DE2),
      'icon': Icons.description,
      'route': '/cv_guidance',
    },
    {
      'title': 'Interview Prep',
      'subtitle': 'Ace your next interview',
      'description': 'Mock videos, common questions, body language tips.',
      'color': Color(0xFF5B6CF1),
      'icon': Icons.chat_bubble_outline,
      'route': '/interview_preparation',
    },
  ];

  final List<Map<String, dynamic>> recentContent = [
    {
      'title': 'How to Choose Your Stream?',
      'duration': 'Watch video - 15 mins',
      'color': Color(0xFF8E2DE2),
      'icon': Icons.play_circle_fill,
    },
    {
      'title': 'Top 5 Tech Careers in 2024',
      'duration': 'Read blog - 8 mins',
      'color': Color(0xFF5B6CF1),
      'icon': Icons.article,
    }
  ];


  final TestimonialDao _testimonialDao = TestimonialDao();
  List<Testimonial> testimonials = [];
  int currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadTestimonials();
    _startAutoRotation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _loadTestimonials() {
    _testimonialDao.getApprovedTestimonials().listen((event) {
      final value = event.snapshot.value;

      if (value == null) {
        setState(() {
          testimonials = [];
          currentIndex = 0;
        });
        return;
      }

      final List<Testimonial> loadedTestimonials = [];

      if (value is Map) {
        value.forEach((key, val) {
          final map = Map<String, dynamic>.from(val);
          loadedTestimonials.add(Testimonial(
            id: key,
            userName: map["userName"] ?? "",
            message: map["message"] ?? "",
            status: map["status"] ?? "approved",
            date: map["timestamp"] ?? "",
            image: map["image"],
            rating: map["rating"] ?? 0,
            tier: map["tier"] ?? "",
          ));
        });
      } else if (value is List) {
        for (int i = 0; i < value.length; i++) {
          final val = value[i];
          if (val != null) {
            final map = Map<String, dynamic>.from(val);
            loadedTestimonials.add(Testimonial(
              id: i.toString(),
              userName: map["userName"] ?? "",
              message: map["message"] ?? "",
              status: map["status"] ?? "approved",
              date: map["timestamp"] ?? "",
              image: map["image"],
              rating: map["rating"] ?? 0,
              tier: map["tier"] ?? "",
            ));
          }
        }
      }


      loadedTestimonials.sort((a, b) => b.date.compareTo(a.date));

      setState(() {
        testimonials = loadedTestimonials;
        if (currentIndex >= testimonials.length) {
          currentIndex = 0;
        }
      });
    });
  }

  void _startAutoRotation() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (testimonials.isNotEmpty) {
        setState(() {
          currentIndex = (currentIndex + 1) % testimonials.length;
        });
      }
    });
  }

  void _goToIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTestimonial =
        testimonials.isNotEmpty ? testimonials[currentIndex] : null;

    return Scaffold(
      appBar: const CustomAppBar(title: "AspireEdge"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),
            Text(
              'Your Future Starts Here',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Explore careers, take quizzes, and unlock your potential with personalized guidance.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: const Color(0xFF6B7280),
              ),
            ),


            const SizedBox(height: 30),
            Text(
              'Featured Tools',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: featuredModules.length,
              itemBuilder: (context, index) {
                final module = featuredModules[index];
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, module['route']),
                  child: Container(
                    decoration: BoxDecoration(
                      color: module['color'],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: module['color'].withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  module['title'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.white.withOpacity(0.15),
                                child: Icon(
                                  module['icon'],
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            module['subtitle'],
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.95),
                            ),
                          ),
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
                  ),
                );
              },
            ),


            const SizedBox(height: 30),
            Text(
              'Recent',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recentContent.length,
                itemBuilder: (context, index) {
                  final content = recentContent[index];
                  return Container(
                    width: 220,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          content['color'],
                          content['color'].withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: content['color'].withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: Icon(
                              content['icon'],
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            content['title'],
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            content['duration'],
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),


            const SizedBox(height: 30),
            Text(
              'Success Stories',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),
            if (currentTestimonial == null)
              const Center(child: CircularProgressIndicator())
            else
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8E2DE2).withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF8E2DE2),
                              ),
                              child: currentTestimonial.image != null &&
                                      currentTestimonial.image!.isNotEmpty
                                  ? ClipOval(
                                      child: Image.memory(
                                        base64Decode(
                                            currentTestimonial.image!),
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                        currentTestimonial.userName.isNotEmpty
                                            ? currentTestimonial.userName[0]
                                            : '',
                                        style: GoogleFonts.poppins(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentTestimonial.userName,
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF2D3748),
                                    ),
                                  ),
                                  if (currentTestimonial.tier != null &&
                                      currentTestimonial.tier!.isNotEmpty)
                                    Text(
                                      currentTestimonial.tier!,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  Text(
                                    currentTestimonial.date,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),


                        Text(
                          currentTestimonial.message,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: const Color(0xFF2D3748),
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 12),


                        if (currentTestimonial.rating > 0)
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < currentTestimonial.rating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 20,
                              );
                            }),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(testimonials.length, (index) {
                      return GestureDetector(
                        onTap: () => _goToIndex(index),
                        child: Container(
                          width: 12,
                          height: 12,
                          margin:
                              const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: index == currentIndex
                                ? const Color(0xFF8E2DE2)
                                : Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

