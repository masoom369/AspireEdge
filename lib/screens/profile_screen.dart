import 'package:flutter/material.dart';

// Profile Screen without Scaffold
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedTabIndex = 0; // 0 = Resume, 1 = Skills, 2 = Progress, 3 = Achievements

  // Profile data
  String firstName = "Jamie";
  String lastName = "Graduate";
  String email = "jamie.graduate@example.com";
  String phone = "-";
  String location = "-";
  String bio = "-";

  // Track which field is being edited
  String? editingField;
  TextEditingController editingController = TextEditingController();

  void startEditing(String field, String currentValue) {
    setState(() {
      editingField = field;
      editingController.text = currentValue;
    });
  }

  void saveEditing(String field) {
    setState(() {
      switch (field) {
        case "First Name":
          firstName = editingController.text;
          break;
        case "Last Name":
          lastName = editingController.text;
          break;
        case "Email":
          email = editingController.text;
          break;
        case "Phone Number":
          phone = editingController.text;
          break;
        case "Location":
          location = editingController.text;
          break;
        case "Bio":
          bio = editingController.text;
          break;
      }
      editingField = null; // exit edit mode
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$field updated successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Header
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFF667EEA),
                  child: Text(
                    "${firstName[0]}${lastName[0]}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "$firstName $lastName",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 2,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Tabs
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildTabItem('Resume', 0),
                _buildTabItem('Skills', 1),
                _buildTabItem('Progress', 2),
                _buildTabItem('Achievements', 3),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Show content depending on selected tab
          if (selectedTabIndex == 0)
            _infoCard("Personal Information", [
              _editableRow("First Name", firstName),
              _editableRow("Last Name", lastName),
              _editableRow("Email", email),
              _editableRow("Phone Number", phone),
              _editableRow("Location", location),
              _editableRow("Bio", bio),
            ]),
          if (selectedTabIndex == 1)
            _infoCard("Skills", [
              _infoRow("Flutter", "Intermediate"),
              _infoRow("Dart", "Intermediate"),
              _infoRow("UI Design", "Beginner"),
            ]),
          if (selectedTabIndex == 2)
            _infoCard("Progress", [
              _progressRow("Flutter Course", 0.8),
              _progressRow("Dart Course", 0.65),
              _progressRow("UI Design", 0.3),
            ]),
          if (selectedTabIndex == 3)
            _infoCard("Achievements", [
              _infoRow("Top Student of 2023", "🏆"),
              _infoRow("Completed Flutter Bootcamp", "✅"),
            ]),
        ],
      ),
    );
  }

  // 🔹 Reusable tab item
  Widget _buildTabItem(String title, int index) {
    bool isSelected = selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTabIndex = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF667EEA) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Editable Row
  Widget _editableRow(String label, String value) {
    bool isEditing = editingField == label;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: isEditing
                ? TextField(
                    controller: editingController,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: label,
                      border: OutlineInputBorder(),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                      Text(value.isEmpty ? "-" : value,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ],
                  ),
          ),
          SizedBox(width: 8),
          isEditing
              ? IconButton(
                  icon: Icon(Icons.check, color: Colors.green),
                  onPressed: () => saveEditing(label),
                )
              : IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => startEditing(label, value),
                ),
        ],
      ),
    );
  }

  // 🔹 Progress Row with Progress Bar
  Widget _progressRow(String label, double progress) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              Text("${(progress * 100).toInt()}%",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
          SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
            ),
          ),
        ],
      ),
    );
  }
}

//
// 🔹 Reusable helpers
//
Widget _infoCard(String title, List<Widget> children) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black)),
        SizedBox(height: 12),
        ...children,
      ],
    ),
  );
}

Widget _infoRow(String label, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ],
    ),
  );
}
