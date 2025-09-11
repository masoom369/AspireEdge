import 'package:flutter/material.dart';

class Career {
  String title;
  String description;
  String period;
  List<String> tags;
  String imageUrl;

  Career({
    required this.title,
    required this.description,
    required this.period,
    required this.tags,
    required this.imageUrl,
  });
}

class CareerManagementPage extends StatefulWidget {
  @override
  _CareerManagementPageState createState() => _CareerManagementPageState();
}

class _CareerManagementPageState extends State<CareerManagementPage> {
  List<Career> careers = [
    Career(
      title: "Software Developer",
      description: "Learn core programming concepts, OOP, and frameworks.",
      period: "6 - 12 Months",
      tags: ["Programming", "Technology", "Software"],
      imageUrl: "assets/Images/gym.jpg",
    ),
  ];

  void _openCareerDialog({Career? career, int? index}) {
    final titleController = TextEditingController(text: career?.title ?? "");
    final descController = TextEditingController(text: career?.description ?? "");
    final periodController = TextEditingController(text: career?.period ?? "6 - 12 Months");
    final tagsController = TextEditingController(text: career?.tags.join(", ") ?? "");
    final imageController = TextEditingController(text: career?.imageUrl ?? "assets/Images/gym.jpg");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          career == null ? "Add Career" : "Edit Career",
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3D455B)),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(titleController, "Title"),
              SizedBox(height: 12),
              _buildTextField(descController, "Description", maxLines: 3),
              SizedBox(height: 12),
              _buildTextField(periodController, "Period (e.g. 6 - 12 months)"),
              SizedBox(height: 12),
              _buildTextField(tagsController, "Tags (comma separated)"),
              SizedBox(height: 12),
              _buildTextField(imageController, "Image Path (assets/...)"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.grey[700])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3D455B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              final newCareer = Career(
                title: titleController.text,
                description: descController.text,
                period: periodController.text,
                tags: tagsController.text.split(",").map((e) => e.trim()).toList(),
                imageUrl: imageController.text,
              );

              setState(() {
                if (career == null) {
                  careers.add(newCareer);
                } else {
                  careers[index!] = newCareer;
                }
              });
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _deleteCareer(int index) {
    setState(() {
      careers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Career Management", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF3D455B),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openCareerDialog(),
                icon: Icon(Icons.add, color: Colors.white),
                label: Text("Add Career", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3D455B),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: careers.length,
              itemBuilder: (context, index) {
                final career = careers[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.asset(
                          career.imageUrl,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                            Text(
                              "Period: ${career.period}",
                              style: TextStyle(fontSize: 14, color: Colors.black87),
                            ),
                            SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: career.tags
                                  .map((tag) => Container(
                                        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: Colors.grey.shade400),
                                          borderRadius: BorderRadius.circular(32),
                                        ),
                                        child: Text(
                                          tag,
                                          style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                                        ),
                                      ))
                                  .toList(),
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blueGrey),
                                  onPressed: () => _openCareerDialog(career: career, index: index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () => _deleteCareer(index),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
