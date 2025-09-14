import 'package:aspire_edge/screens/entryPoint/components/custom_appbar.dart';
import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "About Us"),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildBackground(),
          const SizedBox(height: 20),
          _buildSolution(),
          const SizedBox(height: 20),
          _buildFeatures(),
          const SizedBox(height: 20),
          _buildMission(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          const Text(
            'Welcome to AspireEdge',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your Career Passport – Future Path Explorer',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF667EEA),
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Empowering students and professionals to navigate their career journeys with confidence and clarity.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.lightbulb, color: Color(0xFF667EEA), size: 20),
              SizedBox(width: 8),
              Text(
                'Our Background',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'In today\'s rapidly evolving world, many students and young professionals struggle with choosing the right career path. Lack of structured guidance often leads to confusion, dissatisfaction, and misaligned educational pursuits. Existing solutions are fragmented, outdated, or generic, failing to provide the personalized and interactive experience users need.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'There is a growing demand for an interactive, comprehensive, and user-friendly platform that simplifies career exploration, offering tailored recommendations, coaching tools, self-assessment modules, and inspirational content.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSolution() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.rocket_launch, color: Color(0xFF667EEA), size: 20),
              SizedBox(width: 8),
              Text(
                'Our Solution',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'AspireEdge is a cross-platform app designed to bridge the gap between ambition and awareness. It provides tier-wise career guidance for:',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
          const SizedBox(height: 12),
          _buildBulletPoint('School students (Grades 8–12)'),
          _buildBulletPoint('College students and graduates (Undergraduates/Postgraduates)'),
          _buildBulletPoint('Working professionals'),
          const SizedBox(height: 16),
          Text(
            'Our platform combines interactive tools like quizzes, resource hubs, and video libraries with coaching modules to deliver an engaging, end-to-end career exploration experience.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatures() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.star, color: Color(0xFF667EEA), size: 20),
              SizedBox(width: 8),
              Text(
                'What We Offer',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFeatureItem('Career Bank', 'Explore diverse career options with detailed information on skills, salary, and education paths.'),
          _buildFeatureItem('Interest Quiz', 'Take our interactive quiz to discover careers that match your interests and strengths.'),
          _buildFeatureItem('Coaching Tools', 'Access stream selectors, CV tips, and interview preparation modules.'),
          _buildFeatureItem('Resource Hub', 'Dive into blogs, videos, eBooks, and more to enhance your knowledge.'),
          _buildFeatureItem('Success Stories', 'Get inspired by real testimonials from students and professionals.'),
          _buildFeatureItem('Personalized Experience', 'Tier-based navigation tailored to your career stage.'),
        ],
      ),
    );
  }

  Widget _buildMission() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.flag, color: Color(0xFF667EEA), size: 20),
              SizedBox(width: 8),
              Text(
                'Our Mission',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'To empower individuals at every stage of their career journey by providing accessible, personalized, and comprehensive guidance. We believe that with the right tools and insights, everyone can make informed decisions that lead to fulfilling and successful careers.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Join us in shaping the future of career exploration. Your journey starts here.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Text('• ', style: TextStyle(fontSize: 16, color: Color(0xFF667EEA))),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
      ],
    );
  }
}

