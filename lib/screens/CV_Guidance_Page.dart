import 'package:aspire_edge/screens/entryPoint/components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;


class CVGuidancePage extends StatefulWidget {
  const CVGuidancePage({Key? key}) : super(key: key);

  @override
  State<CVGuidancePage> createState() => _CVGuidancePageState();
}

class _CVGuidancePageState extends State<CVGuidancePage> {
  final List<Map<String, String>> cvTemplates = [
    {
      'file': 'cvtemplates/215-professional-resume.docx',
      'name': 'Professional Resume Template',
      'description': 'Clean layout, modern design, perfect for entry-level roles.'
    },
    {
      'file': 'cvtemplates/221-simple-resume-template.docx',
      'name': 'Simple Resume Template',
      'description': 'Minimalist design, easy to customize.'
    },
    {
      'file': 'cvtemplates/259-job-resume-template.docx',
      'name': 'Job Resume Template',
      'description': 'Versatile template suitable for various job applications.'
    },
    {
      'file': 'cvtemplates/260-cv-english-example.docx',
      'name': 'CV English Example',
      'description': 'Sample CV in English for reference.'
    },
    {
      'file': 'cvtemplates/274-blank-resume-template.docx',
      'name': 'Blank Resume Template',
      'description': 'Blank template to start from scratch.'
    },
    {
      'file': 'cvtemplates/343-resume-template-ats-two-columns.docx',
      'name': 'ATS Two Columns Resume Template',
      'description': 'Optimized for Applicant Tracking Systems with two-column layout.'
    },
  ];

  Future<void> _downloadTemplate(String assetPath, String fileName) async {
    try {
      // Load the asset as bytes
      ByteData data = await rootBundle.load(assetPath);
      Uint8List bytes = data.buffer.asUint8List();

      if (kIsWeb) {
        // ✅ Web download logic
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..download = fileName
          ..click();
        html.Url.revokeObjectUrl(url);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Downloaded: $fileName")),
        );
      } else {
        // ✅ Mobile/Desktop logic
        Directory dir = await getApplicationDocumentsDirectory();
        String filePath = '${dir.path}/$fileName';

        File file = File(filePath);
        await file.writeAsBytes(bytes, flush: true);

        final result = await OpenFilex.open(filePath);

        if (result.type != ResultType.done) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Saved but could not open: ${result.message}")),
          );
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Downloaded and opened: $fileName")),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
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

            // ✅ Do's & Don'ts
            Row(
              children: [
                Expanded(
                  child: _buildTipCard(
                    title: "Dos",
                    color: const Color(0xFF8E2DE2),
                    tips:
                        "• Use clear headings and bullet points\n• Include relevant skills and achievements\n• Keep it to 1 page\n• Use professional fonts like Arial or Calibri\n• Tailor your CV to the job you’re applying for",
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTipCard(
                    title: "Donts",
                    color: const Color(0xFF5B6CF1),
                    tips:
                        "• Avoid spelling and grammar errors\n• Don’t include photos unless required\n• Avoid personal details like age or religion\n• Don’t use overly creative formats\n• Never lie about experience",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "Downloadable Templates",
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
                return _buildTemplateCard(
                  name: template['name']!,
                  description: template['description']!,
                  assetPath: template['file']!,
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            const Text(
              "Watch Video Guide",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),
            _buildVideoCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard({
    required String title,
    required Color color,
    required String tips,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
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
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            tips,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard({
    required String name,
    required String description,
    required String assetPath,
  }) {
    final String fileName = assetPath.split('/').last;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8E2DE2).withOpacity(0.1),
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
            name,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _downloadTemplate(assetPath, fileName),
            child: Row(
              children: const [
                Icon(Icons.file_download, color: Color(0xFF8E2DE2), size: 20),
                SizedBox(width: 8),
                Text(
                  "Download",
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
    );
  }

  Widget _buildVideoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8E2DE2).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "How to Write a Perfect Resume in 10 Minutes",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Step-by-step guide from experts. Covers formatting, content, and tips.",
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
                "Watch Now",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8E2DE2),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
