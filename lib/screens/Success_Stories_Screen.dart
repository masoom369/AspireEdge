import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:convert';
import '../../models/testimonial.dart';
import '../../services/testimonial_dao.dart';

class ApprovedTestimonialsPage extends StatefulWidget {
  const ApprovedTestimonialsPage({super.key});

  @override
  State<ApprovedTestimonialsPage> createState() =>
      _ApprovedTestimonialsPageState();
}

class _ApprovedTestimonialsPageState extends State<ApprovedTestimonialsPage> {
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
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        final List<Testimonial> loadedTestimonials = data.entries.map((e) {
          final value = Map<String, dynamic>.from(e.value as Map);
          return Testimonial(
            id: e.key,
            userName: value["name"] ?? "",
            message: value["testimonial"] ?? "",
            status: value["status"] ?? "approved",
            date: value["timestamp"] ?? "",
            image: value["image"],
            rating: 0,
          );
        }).toList();

        setState(() {
          testimonials = loadedTestimonials;
          if (currentIndex >= testimonials.length) {
            currentIndex = 0;
          }
        });
      } else {
        setState(() {
          testimonials = [];
          currentIndex = 0;
        });
      }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Approved Testimonials"),
        backgroundColor: const Color(0xFF8E2DE2),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: testimonials.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Testimonial Card
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
                              child: testimonials[currentIndex].image != null &&
                                      testimonials[currentIndex]
                                          .image!
                                          .isNotEmpty
                                  ? ClipOval(
                                      child: Image.memory(
                                        base64Decode(
                                            testimonials[currentIndex].image!),
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                        testimonials[currentIndex]
                                                .userName
                                                .isNotEmpty
                                            ? testimonials[currentIndex]
                                                .userName[0]
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
                              child: Text(
                                testimonials[currentIndex].userName,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2D3748),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          testimonials[currentIndex].message,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: const Color(0xFF2D3748),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Dots Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(testimonials.length, (index) {
                      return GestureDetector(
                        onTap: () => _goToIndex(index),
                        child: Container(
                          width: 12,
                          height: 12,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
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
      ),
    );
  }
}
