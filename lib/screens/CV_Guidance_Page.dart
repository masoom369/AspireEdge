import 'package:aspire_edge/screens/entryPoint/components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show File, Platform;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'dart:html' as html; // Only works for web

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
      'description':
          'Optimized for Applicant Tracking Systems with two-column layout.'
    },
  ];

  Future<void> _downloadTemplate(String assetPath, String fileName) async {
    try {
      // Load asset file as bytes
      ByteData data = await rootBundle.load(assetPath);
      List<int> bytes = data.buffer.asUint8List();

      if (kIsWeb) {
        // ✅ Web: trigger browser download
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..download = fileName
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        // ✅ Mobile/Desktop: save to temp dir and open
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/$fileName');
        await file.writeAsBytes(bytes);

        Uri uri = Uri.file(file.path);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Could not open the file")),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error downloading template: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "CV Guidance"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Build Your First Professional CV',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Learn how to create a clean, effective resume that stands out.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 30),

            // ======= TEMPLATE LIST =======
            const Text(
              'Downloadable Templates',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),
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
                            color:
                                const Color(0xFF8E2DE2).withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            template['name']!,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            template['description']!,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {
                              String fileName =
                                  template['file']!.split('/').last;
                              _downloadTemplate(template['file']!, fileName);
                            },
                            child: Row(
                              children: const [
                                Icon(Icons.file_download,
                                    color: Color(0xFF8E2DE2), size: 20),
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
                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
