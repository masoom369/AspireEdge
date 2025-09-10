import 'package:flutter/material.dart';

class CareerBankScreen extends StatefulWidget {
  const CareerBankScreen({super.key});

  @override
  State<CareerBankScreen> createState() => _CareerBankScreenState();
}

class _CareerBankScreenState extends State<CareerBankScreen> {
  String selectedFilter = 'All Levels';
  final TextEditingController searchController = TextEditingController();

  final List<CareerPath> careerPaths = [
    CareerPath(
      title: 'Software Engineering',
      description: 'Become a skilled software developer with expertise in modern programming...',
      duration: '6-12 months',
      tags: ['Programming', 'Technology', 'Problem Solving'],
      isEnrolled: true,
      level: 'Beginner',
      image: 'assets/Images/gym.jpg',
    ),
    CareerPath(
      title: 'Data Science',
      description: 'Master data analysis, machine learning, and statistical modeling...',
      duration: '8-14 months',
      tags: ['Analytics', 'Machine Learning', 'Statistics'],
      isEnrolled: false,
      level: 'Intermediate',
      image: 'assets/Images/gym.jpg',
    ),
    CareerPath(
      title: 'UX/UI Design',
      description: 'Learn user experience design principles and create intuitive interfaces...',
      duration: '4-8 months',
      tags: ['Design', 'User Experience', 'Creativity'],
      isEnrolled: false,
      level: 'Beginner',
      image: 'assets/Images/gym.jpg',
    ),
    CareerPath(
      title: 'Digital Marketing',
      description: 'Master online marketing strategies, SEO, and social media management...',
      duration: '3-6 months',
      tags: ['Marketing', 'SEO', 'Social Media'],
      isEnrolled: false,
      level: 'Beginner',
      image: 'assets/Images/gym.jpg',
    ),
    CareerPath(
      title: 'Cybersecurity',
      description: 'Protect digital assets and learn ethical hacking techniques...',
      duration: '10-16 months',
      tags: ['Security', 'Networking', 'Ethics'],
      isEnrolled: false,
      level: 'Advanced',
      image: 'assets/Images/gym.jpg',
    ),
    CareerPath(
      title: 'Project Management',
      description: 'Lead teams and deliver projects successfully using modern methodologies...',
      duration: '5-9 months',
      tags: ['Leadership', 'Planning', 'Agile'],
      isEnrolled: false,
      level: 'Intermediate',
      image: 'assets/Images/gym.jpg',
    ),
  ];

  List<CareerPath> get filteredPaths {
    return careerPaths.where((path) {
      bool matchesFilter = selectedFilter == 'All Levels' || path.level == selectedFilter;
      bool matchesSearch = searchController.text.isEmpty ||
          path.title.toLowerCase().contains(searchController.text.toLowerCase()) ||
          path.tags.any((tag) => tag.toLowerCase().contains(searchController.text.toLowerCase()));
      return matchesFilter && matchesSearch;
    }).toList();
  }

  int get enrolledCount {
    return careerPaths.where((path) => path.isEnrolled).length;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Career Bank',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Discover curated career paths designed to help you succeed in today\'s dynamic job market. Each path includes comprehensive learning materials, practical projects, and industry insights.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                controller: searchController,
                onChanged: (value) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search career paths, skills, or industries...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedFilter,
                      icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                      items: ['All Levels', 'Beginner', 'Intermediate', 'Advanced']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedFilter = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  '$enrolledCount enrolled',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Showing ${filteredPaths.length} career paths',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 20),
LayoutBuilder(
  builder: (context, constraints) {
    int crossAxisCount = 1;
    if (constraints.maxWidth > 1200) {
      crossAxisCount = 3;
    } else if (constraints.maxWidth > 800) {
      crossAxisCount = 2;
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        // removed childAspectRatio
      ),
      itemCount: filteredPaths.length,
      itemBuilder: (context, index) {
        return IntrinsicHeight( // <-- ensures card height fits content
          child: CareerPathCard(
            careerPath: filteredPaths[index],
            onEnroll: () {
              setState(() {
                filteredPaths[index].isEnrolled = !filteredPaths[index].isEnrolled;
              });
            },
          ),
        );
      },
    );
  },
),
          ],
        ),
      ),
    );
  }
}

class CareerPath {
  final String title;
  final String description;
  final String duration;
  final List<String> tags;
  bool isEnrolled;
  final String level;
  final String image;

  CareerPath({
    required this.title,
    required this.description,
    required this.duration,
    required this.tags,
    required this.isEnrolled,
    required this.level,
    required this.image,
  });
}

class CareerPathCard extends StatelessWidget {
  final CareerPath careerPath;
  final VoidCallback onEnroll;

  const CareerPathCard({
    Key? key,
    required this.careerPath,
    required this.onEnroll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // keep column compact
        children: [
          // Image and Badge
          Stack(
            children: [
              Container(
                height: 240,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue[400]!,
                      Colors.purple[400]!,
                    ],
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(careerPath.image),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.work_outline,
                        size: 4,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
              ),
              if (careerPath.level == 'Beginner')
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFF25254B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Beginner',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16), // keep bottom padding small
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  careerPath.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                // Description
                Text(
                  careerPath.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12),
                // Duration
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey[500]),
                    SizedBox(width: 4),
                    Text(
                      careerPath.duration,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                // Tags
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: careerPath.tags.take(3).map((tag) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[700],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
                // Buttons row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Learn More',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onEnroll,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: careerPath.isEnrolled
                              ?Color(0xFF25254B)
                              : Color(0xFFFE0037),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          careerPath.isEnrolled ? 'Enrolled' : 'Enroll',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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

