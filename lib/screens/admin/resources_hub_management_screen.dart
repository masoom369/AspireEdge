import 'package:flutter/material.dart';

// ---------------- Data Model ----------------
class Resource {
  String title;
  String description;
  String category; // Blog, eBook, Video, Gallery
  String? link; // For video/ebook
  List<String>? images; // For gallery
  bool isBookmarked;

  Resource({
    required this.title,
    required this.description,
    required this.category,
    this.link,
    this.images,
    this.isBookmarked = false,
  });
}

// ---------------- Page ----------------
class ManageResourcesHubPage extends StatefulWidget {
  const ManageResourcesHubPage({super.key});

  @override
  State<ManageResourcesHubPage> createState() =>
      _ManageResourcesHubPageState();
}

class _ManageResourcesHubPageState extends State<ManageResourcesHubPage> {
  List<Resource> resources = [];
  String selectedTab = "Blog"; // active tab in main screen

  @override
  void initState() {
    super.initState();
    // ✅ Add demo data
    resources = [
      Resource(
          title: "How to Improve Focus",
          description: "A guide to staying productive and focused.",
          category: "Blog"),
      Resource(
          title: "Dart Programming eBook",
          description: "A beginner-friendly Dart eBook.",
          category: "eBook",
          link: "https://example.com/dart-ebook"),
      Resource(
          title: "Flutter Tutorial",
          description: "Learn Flutter step by step.",
          category: "Video",
          link: "https://youtube.com/flutter-tutorial"),
      Resource(
          title: "Vacation Memories",
          description: "Beautiful beach pictures.",
          category: "Gallery",
          images: ["beach.png", "sunset.png"]),
    ];
  }

  // ---------------- Add Resource Dialog ----------------
  void _openAddDialog() {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final linkController = TextEditingController();
    List<String> uploaded = [];

    showDialog(
      context: context,
      builder: (context) {
        return DefaultTabController(
          length: 4,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              "Add Resource",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            content: SizedBox(
              width: 400,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const TabBar(
                      labelColor: Colors.blueGrey,
                      indicatorColor: Colors.blueGrey,
                      tabs: [
                        Tab(text: "Blog"),
                        Tab(text: "eBook"),
                        Tab(text: "Video"),
                        Tab(text: "Gallery"),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 300,
                      child: TabBarView(
                        children: [
                          // Blog
                          _dialogFields(
                            titleController,
                            descController,
                            null,
                            null,
                          ),
                          // eBook
                          _dialogFields(
                            titleController,
                            descController,
                            linkController,
                            "eBook Link",
                          ),
                          // Video
                          _dialogFields(
                            titleController,
                            descController,
                            linkController,
                            "Video Link",
                          ),
                          // Gallery
                          StatefulBuilder(
                            builder: (context, setStateSB) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    _textField(titleController, "Title",
                                        isRequired: true),
                                    const SizedBox(height: 10),
                                    _textField(descController, "Description",
                                        maxLines: 3, isRequired: true),
                                    const SizedBox(height: 10),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        setStateSB(() {
                                          uploaded.add(
                                              "image_${uploaded.length + 1}.png");
                                        });
                                      },
                                      icon: const Icon(Icons.upload),
                                      label: const Text("Upload Images"),
                                    ),
                                    if (uploaded.isNotEmpty)
                                      Wrap(
                                        spacing: 8,
                                        children: uploaded
                                            .map((e) => Chip(label: Text(e)))
                                            .toList(),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final currentTab =
                      DefaultTabController.of(context)!.index;
                  String category =
                      ["Blog", "eBook", "Video", "Gallery"][currentTab];

                  // ✅ Validation
                  if (!formKey.currentState!.validate()) return;
                  if (category == "Gallery" && uploaded.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please upload at least 1 image")),
                    );
                    return;
                  }
                  if ((category == "eBook" || category == "Video") &&
                      linkController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Link is required")),
                    );
                    return;
                  }

                  setState(() {
                    resources.add(
                      Resource(
                        title: titleController.text,
                        description: descController.text,
                        category: category,
                        link: (category == "eBook" || category == "Video")
                            ? linkController.text
                            : null,
                        images: category == "Gallery" ? uploaded : null,
                      ),
                    );
                  });
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------- Dialog Fields ----------------
  static Widget _dialogFields(
    TextEditingController title,
    TextEditingController desc,
    TextEditingController? link,
    String? linkLabel,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _textField(title, "Title", isRequired: true),
          const SizedBox(height: 10),
          _textField(desc, "Description", maxLines: 3, isRequired: true),
          if (link != null) ...[
            const SizedBox(height: 10),
            _textField(link, linkLabel ?? "Link", isRequired: true),
          ],
        ],
      ),
    );
  }

  static Widget _textField(TextEditingController controller, String label,
      {int maxLines = 1, bool isRequired = false}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (v) {
        if (isRequired && (v == null || v.trim().isEmpty)) {
          return "$label is required";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  // ---------------- Resource Card ----------------
Widget _buildResourceCard(Resource r) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.grey.shade300), // Grey border
    ),
    elevation: 0, // No shadow
    color: Colors.white, // White background
    child: Padding(
      padding: const EdgeInsets.all(16.0), // Padding for clean spacing
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            r.title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18, // Larger title text for readability
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8), // Space between title and description
          
          // Description
          Text(
            r.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8), // Space between description and link/images

          // Link (if available)
          if (r.link != null)
            Text(
              "🔗 ${r.link}",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.blueGrey,
              ),
            ),

          // Images (if available)
          if (r.images != null && r.images!.isNotEmpty)
            Wrap(
              spacing: 6,
              children: r.images!
                  .map((img) => Chip(
                        label: Text(img),
                        backgroundColor: Colors.blueGrey.shade50,
                      ))
                  .toList(),
            ),
          const SizedBox(height: 8), // Space between images and category

          // Category chip
          Chip(
            label: Text(
              r.category,
              style: const TextStyle(fontSize: 12),
            ),
            backgroundColor: Colors.blueGrey.shade50,
          ),
        ],
      ),
    ),
  );
}

// ---------------- inside build ----------------
@override
Widget build(BuildContext context) {
  return Scaffold(
       appBar: AppBar(
        title: Text("Resource Hub Management", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF3D455B),
        centerTitle: true,
      ),
    body: Column(
      children: [
        // ✅ Add Resource button (full width + responsive)
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: double.infinity, // full width
            child: ElevatedButton.icon(
              onPressed: _openAddDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3D455B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Add Resource",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),

        // Custom tab buttons 2x2 grid
  Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Container(
    decoration: BoxDecoration(
      color: Colors.blueGrey.shade50, // ✅ change bg color here
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.all(12),
    child: GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // prevents scroll conflicts
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 3,
      
      children: [
        _tabButton("Blog"),
        _tabButton("eBook"),
        _tabButton("Video"),
        _tabButton("Gallery"),
      ],
    ),
  ),
),

        const SizedBox(height: 8),
        Expanded(child: _tabContent(selectedTab)),
      ],
    ),
  );
}


  // ---------------- Tab Buttons ----------------
  Widget _tabButton(String type) {
    final isActive = selectedTab == type;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Color(0xFF3D455B) : Colors.blueGrey.shade100,
        foregroundColor: isActive ? Colors.white : Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () => setState(() => selectedTab = type),
      child: Text(type),
    );
  }

  // ---------------- Tab Content ----------------
  Widget _tabContent(String type) {
    final filtered = resources.where((r) => r.category == type).toList();
    if (filtered.isEmpty) {
      return const Center(
        child:
            Text("No resources yet", style: TextStyle(color: Colors.grey)),
      );
    }
    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (_, i) => _buildResourceCard(filtered[i]),
    );
  }
}
