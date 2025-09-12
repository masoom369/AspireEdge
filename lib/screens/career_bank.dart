import 'package:flutter/material.dart';
import 'package:aspire_edge/services/career_dao.dart';
import 'package:aspire_edge/models/career.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';

class CareerBankPage extends StatefulWidget {
  @override
  _CareerBankPageState createState() => _CareerBankPageState();
}

class _CareerBankPageState extends State<CareerBankPage> {
  final CareerDao _careerDao = CareerDao();
  List<Career> careers = [];
  bool _isLoading = true;
  String searchQuery = '';
  String selectedIndustry = 'All';
  String selectedSort = 'Title';
  final TextEditingController searchController = TextEditingController();
  StreamSubscription? _careersStream;

  // 👇 COPY THESE TWO HELPER METHODS FROM CAREER MANAGEMENT PAGE
  Map<String, dynamic> _convertToMap(dynamic value) {
    if (value == null) return {};
    if (value is Map<dynamic, dynamic>) {
      final Map<String, dynamic> result = {};
      value.forEach((key, val) {
        result[key.toString()] = _convertValue(val);
      });
      return result;
    }
    return {};
  }

  dynamic _convertValue(dynamic value) {
    if (value == null) return null;
    if (value is Map<dynamic, dynamic>) {
      final Map<String, dynamic> result = {};
      value.forEach((key, val) {
        result[key.toString()] = _convertValue(val);
      });
      return result;
    }
    if (value is List) return value.map(_convertValue).toList();
    return value;
  }

  @override
  void initState() {
    super.initState();
    _fetchCareers();
  }

  void _fetchCareers() {
    setState(() => _isLoading = true);
    _careersStream = _careerDao.getCareerList().onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        // 👇 USE THE SAME SAFE CONVERSION AS IN CAREER MANAGEMENT PAGE
        final data = _convertToMap(snapshot.value); // ← This converts everything safely!
        final List<Career> loaded = [];

        data.forEach((key, value) {
          try {
            // Now `value` is guaranteed to be Map<String, dynamic>
            final career = Career.fromJson(value);
            loaded.add(career);
          } catch (e) {
            print('Parse error for career $key: $e');
          }
        });

        setState(() {
          careers = loaded;
          _isLoading = false;
        });
      } else {
        setState(() {
          careers = [];
          _isLoading = false;
        });
      }
    });
  }

  List<String> get industries {
    final allIndustries = careers.map((c) => c.industry).toSet().toList();
    allIndustries.sort();
    return ['All', ...allIndustries];
  }

  List<Career> get filteredCareers {
    List<Career> filtered = careers.where((career) {
      final matchesSearch =
          searchQuery.isEmpty ||
          career.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          career.industry.toLowerCase().contains(searchQuery.toLowerCase()) ||
          career.requiredSkills.any(
            (skill) => skill.toLowerCase().contains(searchQuery.toLowerCase()),
          );
      final matchesIndustry =
          selectedIndustry == 'All' || career.industry == selectedIndustry;
      return matchesSearch && matchesIndustry;
    }).toList();

    if (selectedSort == 'Title') {
      filtered.sort((a, b) => a.title.compareTo(b.title));
    } else if (selectedSort == 'Salary') {
      filtered.sort((a, b) => a.salaryRange.compareTo(b.salaryRange));
    }

    return filtered;
  }

  @override
  void dispose() {
    _careersStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.grey[700]),
        title: Text(
          'Career Bank',
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search by title, skills, or industry...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                DropdownButton<String>(
                  value: selectedSort,
                  items: ['Title', 'Salary'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSort = newValue!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 12),
            DropdownButton<String>(
              value: selectedIndustry,
              items: industries.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedIndustry = newValue!;
                });
              },
            ),
            SizedBox(height: 16),
            Text(
              'Showing ${filteredCareers.length} careers',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : filteredCareers.isEmpty
                      ? Center(child: Text('No careers found.'))
                      : ListView.builder(
                          itemCount: filteredCareers.length,
                          itemBuilder: (context, index) {
                            final career = filteredCareers[index];
                            Uint8List? imageBytes;
                            if (career.imageBase64.isNotEmpty) {
                              try {
                                final clean = career.imageBase64.contains(',')
                                    ? career.imageBase64.split(',').last
                                    : career.imageBase64;
                                imageBytes = base64Decode(clean);
                              } catch (e) {
                                print('Image decode error: $e');
                              }
                            }
                            return Container(
                              margin: EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (imageBytes != null)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.memory(
                                          imageBytes,
                                          width: double.infinity,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Container(
                                            height: 100,
                                            child: Center(
                                              child: Text('Load Error'),
                                            ),
                                          ),
                                        ),
                                      )
                                    else
                                      Container(
                                        width: double.infinity,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.image,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    SizedBox(height: 12),
                                    Text(
                                      career.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Color(0xFF3D455B),
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      career.description,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                    SizedBox(height: 8),
                                    Text('Industry: ${career.industry}'),
                                    SizedBox(height: 8),
                                    Text(
                                      'Skills: ${career.requiredSkills.join(", ")}',
                                    ),
                                    SizedBox(height: 8),
                                    Text('Salary Range: ${career.salaryRange}'),
                                    SizedBox(height: 8),
                                    Text(
                                      'Degrees: ${career.educationPath.recommendedDegrees.join(", ")}',
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Certifications: ${career.educationPath.certifications.join(", ")}',
                                    ),
                                  ],
                                ),
                              ),
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