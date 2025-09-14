import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:aspire_edge/screens/admin/custom_appbar_admin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:aspire_edge/utils/image_picker.dart';
import '../../services/career_dao.dart';
import '../../models/career.dart';

class CareerManagementPage extends StatefulWidget {
  const CareerManagementPage({super.key});
  @override
  _CareerManagementPageState createState() => _CareerManagementPageState();
}

class CareerItem {
  final String key;
  final Career career;
  CareerItem({required this.key, required this.career});
}

class _CareerManagementPageState extends State<CareerManagementPage> {
  final CareerDao _careerDao = CareerDao();
  List<CareerItem> careers = [];
  bool _isLoading = true;
  StreamSubscription? _careersSubscription;

  @override
  void initState() {
    super.initState();
    _fetchCareers();
  }

  @override
  void dispose() {
    _careersSubscription?.cancel();
    super.dispose();
  }

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

  void _fetchCareers() async {
    setState(() => _isLoading = true);
    _careersSubscription?.cancel();

    _careersSubscription = _careerDao.getCareerList().onValue.listen(
      (event) {
        final snapshot = event.snapshot;
        if (snapshot.exists) {
          final data = _convertToMap(snapshot.value);
          final List<CareerItem> loaded = [];
          data.forEach((key, value) {
            try {
              loaded.add(CareerItem(key: key, career: Career.fromJson(value)));
            } catch (e) {
              debugPrint('Parse error career $key: $e');
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
      },
      onError: (err) {
        debugPrint('Firebase error: $err');
        setState(() => _isLoading = false);
      },
    );
  }

  void _openCareerPage({CareerItem? careerItem}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CareerFormPage(
          careerItem: careerItem,
          onSave: (newCareer) {
            if (careerItem == null) {
              _careerDao.saveCareer(newCareer);
            } else {
              _careerDao.updateCareer(careerItem.key, newCareer);
            }
          },
        ),
      ),
    );
  }

  void _deleteCareer(int index) {
    final key = careers[index].key;
    _careerDao.deleteCareer(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Career Management"),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openCareerPage(),
                icon: Icon(Icons.add, color: Colors.white),
                label: Text(
                  "Add Career",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3D455B),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : careers.isEmpty
                    ? Center(
                        child: Text(
                          'No careers found.',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: careers.length,
                        itemBuilder: (context, index) {
                          final careerItem = careers[index];
                          final career = careerItem.career;

                          Uint8List? imageBytes;
                          if (career.imageBase64.isNotEmpty) {
                            try {
                              final clean = career.imageBase64.contains(',')
                                  ? career.imageBase64.split(',').last
                                  : career.imageBase64;
                              imageBytes = base64Decode(clean);
                            } catch (e) {
                              debugPrint("Preview decode error: $e");
                            }
                          }

                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            elevation: 0,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
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
                                          child: Center(child: Text("Load Error")),
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
                                  const SizedBox(height: 12),
                                  Text(
                                    career.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Color(0xFF3D455B),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    career.description,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                  const SizedBox(height: 8),
                                  Text("Industry: ${career.industry}"), // 👈 NEW FIELD
                                  const SizedBox(height: 8),
                                  Text(
                                    "Skills: ${career.requiredSkills.join(", ")}",
                                  ),
                                  const SizedBox(height: 8),
                                  Text("Salary Range: ${career.salaryRange}"),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Degrees: ${career.educationPath.recommendedDegrees.join(", ")}",
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Certifications: ${career.educationPath.certifications.join(", ")}",
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.blueGrey,
                                        ),
                                        onPressed: () =>
                                            _openCareerPage(careerItem: careerItem),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.redAccent,
                                        ),
                                        onPressed: () => _deleteCareer(index),
                                      ),
                                    ],
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
    );
  }
}

class CareerFormPage extends StatefulWidget {
  final CareerItem? careerItem;
  final Function(Career) onSave;

  const CareerFormPage({super.key, this.careerItem, required this.onSave});

  @override
  State<CareerFormPage> createState() => _CareerFormPageState();
}

class _CareerFormPageState extends State<CareerFormPage> {
  late TextEditingController titleController;
  late TextEditingController descController;
  late TextEditingController skillsController;
  late TextEditingController salaryController;
  late TextEditingController degreesController;
  late TextEditingController certsController;
  late TextEditingController industryController; // 👈 NEW FIELD
  String currentImageBase64 = "";

  @override
  void initState() {
    super.initState();
    final career = widget.careerItem?.career;
    titleController = TextEditingController(text: career?.title ?? "");
    descController = TextEditingController(text: career?.description ?? "");
    skillsController =
        TextEditingController(text: career?.requiredSkills.join(", ") ?? "");
    salaryController = TextEditingController(text: career?.salaryRange ?? "");
    degreesController =
        TextEditingController(text: career?.educationPath.recommendedDegrees.join(", ") ?? "");
    certsController =
        TextEditingController(text: career?.educationPath.certifications.join(", ") ?? "");
    industryController = TextEditingController(text: career?.industry ?? ""); // 👈 prefill
    currentImageBase64 = career?.imageBase64 ?? "";
  }

  Widget _buildImagePreview(String base64String) {
    try {
      final clean = base64String.contains(',')
          ? base64String.split(',').last
          : base64String;
      final imageBytes = base64Decode(clean);
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(
          imageBytes,
          width: double.infinity,
          height: 150,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _errorImage(),
        ),
      );
    } catch (_) {
      return _errorImage();
    }
  }

  Widget _errorImage() => Container(
        height: 150,
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.broken_image, color: Colors.red, size: 40),
        ),
      );

  Widget _buildTextField(
    TextEditingController c,
    String label, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: c,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Career Management"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () async {
                final newImg = await ImagePickerUtils.pickImageBase64();
                if (newImg.isNotEmpty) {
                  setState(() => currentImageBase64 = newImg);
                }
              },
              child: currentImageBase64.isNotEmpty
                  ? _buildImagePreview(currentImageBase64)
                  : Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(Icons.image, color: Colors.grey, size: 40),
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            _buildTextField(titleController, "Title"),
            const SizedBox(height: 12),
            _buildTextField(descController, "Description", maxLines: 3),
            const SizedBox(height: 12),
            _buildTextField(
              industryController,
              "Industry", // 👈 NEW FIELD
            ),
            const SizedBox(height: 12),
            _buildTextField(
              skillsController,
              "Required Skills (comma separated)",
            ),
            const SizedBox(height: 12),
            _buildTextField(salaryController, "Salary Range"),
            const SizedBox(height: 12),
            _buildTextField(
              degreesController,
              "Recommended Degrees (comma separated)",
            ),
            const SizedBox(height: 12),
            _buildTextField(
              certsController,
              "Certifications (comma separated)",
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newCareer = Career(
                  title: titleController.text,
                  description: descController.text,
                  requiredSkills:
                      skillsController.text.split(",").map((e) => e.trim()).toList(),
                  salaryRange: salaryController.text,
                  educationPath: EducationPath(
                    recommendedDegrees: degreesController.text
                        .split(",")
                        .map((e) => e.trim())
                        .toList(),
                    certifications: certsController.text
                        .split(",")
                        .map((e) => e.trim())
                        .toList(),
                  ),
                  imageBase64: currentImageBase64,
                  industry: industryController.text, // 👈 NEW FIELD
                );
                widget.onSave(newCareer);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3D455B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
