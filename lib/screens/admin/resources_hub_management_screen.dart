import 'package:flutter/material.dart';

// Data Model
class Resource {
  String title;
  String description;
  String category; // Blog, eBook, Video
  String tier; // Student, Graduate, Professional
  bool isBookmarked;

  Resource({
    required this.title,
    required this.description,
    required this.category,
    required this.tier,
    this.isBookmarked = false,
  });
}

class ManageResourcesHubPage extends StatefulWidget {
  const ManageResourcesHubPage({super.key});

  @override
  State<ManageResourcesHubPage> createState() =>
      _ManageResourcesHubPageState();
}

class _ManageResourcesHubPageState extends State<ManageResourcesHubPage> {
  List<Resource> resources = [
    Resource(
      title: "How to Write an Impressive CV",
      description: "Step-by-step guide for students and graduates.",
      category: "Blog",
      tier: "Student",
    ),
    Resource(
      title: "Career Planning eBook",
      description: "Comprehensive guide for career transitions.",
      category: "eBook",
      tier: "Professional",
    ),
    Resource(
      title: "Interview Tips Video",
      description: "Expert video on mastering interviews.",
      category: "Video",
      tier: "Graduate",
    ),
  ];

  final List<String> categories = ["Blog", "eBook", "Video"];
  final List<String> tiers = ["Student", "Graduate", "Professional"];

  // Add or Edit Resource
  void _openResourceDialog({Resource? resource, int? index}) {
    final titleController = TextEditingController(text: resource?.title ?? "");
    final descController =
        TextEditingController(text: resource?.description ?? "");
    String selectedCategory = resource?.category ?? categories.first;
    String selectedTier = resource?.tier ?? tiers.first;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          resource == null ? "Add Resource" : "Edit Resource",
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Color(0xFF3D455B)),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categories
                    .map((c) =>
                        DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => setState(() => selectedCategory = val!),
                decoration: InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedTier,
                items: tiers
                    .map((t) =>
                        DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) => setState(() => selectedTier = val!),
                decoration: InputDecoration(
                  labelText: "User Tier",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text("Cancel",
                style: TextStyle(color: Colors.black54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3D455B),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              final newRes = Resource(
                title: titleController.text,
                description: descController.text,
                category: selectedCategory,
                tier: selectedTier,
              );
              setState(() {
                if (resource == null) {
                  resources.add(newRes);
                } else {
                  resources[index!] = newRes;
                }
              });
              Navigator.pop(context);
            },
            child:
                const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Delete Resource
  void _deleteResource(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Delete Resource"),
        content: const Text(
            "Are you sure you want to delete this resource?"),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() => resources.removeAt(index));
              Navigator.pop(context);
            },
            child:
                const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCard(Resource r, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Category
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                r.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF3D455B),
                ),
              ),
              Text(
                r.category,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Description
          Text(
            r.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey.shade800),
          ),
          const SizedBox(height: 6),
          Text("Tier: ${r.tier}",
              style: const TextStyle(color: Colors.black87, fontSize: 13)),
          const SizedBox(height: 10),
          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blueGrey),
                onPressed: () =>
                    _openResourceDialog(resource: r, index: index),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () => _deleteResource(index),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.folder_open, size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text("No resources available",
              style: TextStyle(fontSize: 16, color: Colors.black54)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
          appBar: AppBar(
        title: Text("Manage Feedback", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF3D455B),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Add Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openResourceDialog(),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text("Add Resource",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3D455B),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ),
          ),

          // Resource List
          Expanded(
            child: resources.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: resources.length,
                    itemBuilder: (_, index) =>
                        _buildResourceCard(resources[index], index),
                  ),
          ),
        ],
      ),
    );
  }
}
