import 'package:aspire_edge/screens/entryPoint/components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'dart:typed_data';

class CVGuidancePage extends StatefulWidget {
  const CVGuidancePage({Key? key}) : super(key: key);

  @override
  State<CVGuidancePage> createState() => _CVGuidancePageState();
}

class _CVGuidancePageState extends State<CVGuidancePage> {
  final List<Map<String, String>> cvTemplates = [
    {
      'file': 'assets/cvtemplates/215-professional-resume.docx',
      'name': 'Professional Resume Template',
      'description': 'Clean layout, modern design, perfect for entry-level roles.'
    },
    {
      'file': 'assets/cvtemplates/221-simple-resume-template.docx',
      'name': 'Simple Resume Template',
      'description': 'Minimalist design, easy to customize.'
    },
    {
      'file': 'assets/cvtemplates/259-job-resume-template.docx',
      'name': 'Job Resume Template',
      'description': 'Versatile template suitable for various job applications.'
    },
    {
      'file': 'assets/cvtemplates/260-cv-english-example.docx',
      'name': 'CV English Example',
      'description': 'Sample CV in English for reference.'
    },
    {
      'file': 'assets/cvtemplates/274-blank-resume-template.docx',
      'name': 'Blank Resume Template',
      'description': 'Blank template to start from scratch.'
    },
    {
      'file': 'assets/cvtemplates/343-resume-template-ats-two-columns.docx',
      'name': 'ATS Two Columns Resume Template',
      'description': 'Optimized for Applicant Tracking Systems with two-column layout.'
    },
  ];

  Future<void> _downloadTemplate(String assetPath, String fileName) async {
    try {
      // Load the asset as bytes
      ByteData data = await rootBundle.load(assetPath);
      List<int> bytes = data.buffer.asUint8List();

      // Get the temporary directory
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = '${tempDir.path}/$fileName';

      // Write the bytes to a file
      File file = File(tempPath);
      await file.writeAsBytes(bytes);

      // Open the file using url_launcher
      Uri uri = Uri.file(tempPath);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open the file')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading template: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: CustomAppBar(title: "CV Guidance"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'Build Your First Professional CV',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Learn how to create a clean, effective resume that stands out.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 30),


            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF8E2DE2),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF8E2DE2).withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '✅ Do’s',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            '• Use clear headings and bullet points\n• Include relevant skills and achievements\n• Keep it to 1 page\n• Use professional fonts like Arial or Calibri\n• Tailor your CV to the job you’re applying for',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF5B6CF1),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF5B6CF1).withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '❌ Don’ts',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            '• Avoid spelling and grammar errors\n• Don’t include photos unless required\n• Avoid personal details like age or religion\n• Don’t use overly creative formats\n• Never lie about experience',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 30),


            Text(
              'Downloadable Templates',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: 16),
            Column(
              children: cvTemplates.map((template) {
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF8E2DE2).withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            template['name']!,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            template['description']!,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {
                              String fileName = template['file']!.split('/').last;
                              _downloadTemplate(template['file']!, fileName);
                            },
                            child: Row(
                              children: [
                                Icon(Icons.file_download, color: Color(0xFF8E2DE2), size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Download',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    color: Color(0xFF8E2DE2),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                );
              }).toList(),
            ),

            SizedBox(height: 30),


            Text(
              'Watch Video Guide',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF8E2DE2).withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How to Write a Perfect Resume in 10 Minutes',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Step-by-step guide from experts. Covers formatting, content, and tips.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.play_circle_filled, color: Color(0xFF8E2DE2), size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Watch Now',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Color(0xFF8E2DE2),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
