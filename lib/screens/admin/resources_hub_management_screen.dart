import 'dart:convert';
import 'package:aspire_edge/models/resource.dart';
import 'package:aspire_edge/screens/admin/custom_appbar_admin.dart';
import 'package:aspire_edge/services/resource_repository_dao.dart';
import 'package:aspire_edge/utils/image_picker.dart';
import 'package:flutter/material.dart';
// ---------------- Main Page ----------------
class ManageResourcesHubPage extends StatefulWidget {
  const ManageResourcesHubPage({super.key});

  @override
  State<ManageResourcesHubPage> createState() => _ManageResourcesHubPageState();
}

class _ManageResourcesHubPageState extends State<ManageResourcesHubPage> {
  final ResourceRepository _repository = ResourceRepository();
  String selectedTab = "Blog";

  @override
  void initState() {
    super.initState();
  }

  // ---------------- Add Resource Dialog ----------------
  void _openAddDialog() {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final linkController = TextEditingController();
    final uploadedImages = <String>[];

   
showDialog(
  context: context,
  builder: (context) {
    return DefaultTabController(
      length: 4,
      child: Builder(
        builder: (ctx) => AlertDialog(
          content: SizedBox(
            width: 400,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TabBar(
                    tabs: const [
                      Tab(text: "Blog"),
                      Tab(text: "eBook"),
                      Tab(text: "Video"),
                      Tab(text: "Gallery"),
                    ],
                  ),
                  SizedBox(
                    height: 300,
                    child: TabBarView(
                      children: [
                        _dialogFields(titleController, descController, null, null),
                        _dialogFields(titleController, descController, linkController, "eBook Link"),
                        _dialogFields(titleController, descController, linkController, "Video Link"),
                            Column(
                              children: [
                                _dialogFields(titleController, descController, null, null),
                                const SizedBox(height: 10),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    // Use the custom ImagePickerUtils to pick images and convert to base64
                                    final base64Image = await ImagePickerUtils.pickImageBase64();
                                    if (base64Image.isNotEmpty) {
                                      uploadedImages.add(base64Image);
                                      setState(() {});
                                    }
                                  },
                                  icon: const Icon(Icons.upload_file),
                                  label: const Text("Upload Images"),
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 6,
                                  children: uploadedImages
                                      .map((img) => Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              image: DecorationImage(
                                                image: MemoryImage(base64Decode(img)),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ],
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
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final currentTab = DefaultTabController.of(ctx)!.index;
                final category = ["Blog", "eBook", "Video", "Gallery"][currentTab];
                if (formKey.currentState!.validate()) {
                  if (category == "Blog") {
                    await _repository.add(Blog(
                      title: titleController.text,
                      description: descController.text,
                    ));
                  } else if (category == "eBook") {
                    await _repository.add(EBook(
                      title: titleController.text,
                      description: descController.text,
                      link: linkController.text,
                    ));
                  } else if (category == "Video") {
                    await _repository.add(Video(
                      title: titleController.text,
                      description: descController.text,
                      link: linkController.text,
                    ));
                  } else if (category == "Gallery") {
                    await _repository.add(Gallery(
                      title: titleController.text,
                      description: descController.text,
                      images: uploadedImages,
                    ));
                  }
                  Navigator.pop(ctx);
                  setState(() {});
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  },
);

  }

  // ---------------- Edit Resource Dialog ----------------
  void _openEditDialog(Resource resource) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: resource.title);
    final descController = TextEditingController(text: resource.description);
    final linkController = TextEditingController(
      text: resource is EBook ? resource.link : (resource is Video ? resource.link : ''),
    );
    final uploadedImages = resource is Gallery ? List<String>.from(resource.images) : <String>[];

    final initialTabIndex = resource.runtimeType.toString().split('.').last == "Blog" ? 0 :
                           resource.runtimeType.toString().split('.').last == "eBook" ? 1 :
                           resource.runtimeType.toString().split('.').last == "Video" ? 2 : 3;

    showDialog(
      context: context,
      builder: (context) {
        return DefaultTabController(
          length: 4,
          initialIndex: initialTabIndex,
          child: Builder(
            builder: (ctx) => AlertDialog(
              title: const Text("Edit Resource"),
              content: SizedBox(
                width: 400,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TabBar(
                        tabs: const [
                          Tab(text: "Blog"),
                          Tab(text: "eBook"),
                          Tab(text: "Video"),
                          Tab(text: "Gallery"),
                        ],
                      ),
                      SizedBox(
                        height: 300,
                        child: TabBarView(
                          children: [
                            _dialogFields(titleController, descController, null, null),
                            _dialogFields(titleController, descController, linkController, "eBook Link"),
                            _dialogFields(titleController, descController, linkController, "Video Link"),
                            Column(
                              children: [
                                _dialogFields(titleController, descController, null, null),
                                const SizedBox(height: 10),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    // Use the custom ImagePickerUtils to pick images and convert to base64
                                    final base64Image = await ImagePickerUtils.pickImageBase64();
                                    if (base64Image.isNotEmpty) {
                                      uploadedImages.add(base64Image);
                                      setState(() {});
                                    }
                                  },
                                  icon: const Icon(Icons.upload_file),
                                  label: const Text("Upload Images"),
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 6,
                                  children: uploadedImages
                                      .map((img) => Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              image: DecorationImage(
                                                image: MemoryImage(base64Decode(img)),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ],
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
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final currentTab = DefaultTabController.of(ctx)!.index;
                    final category = ["Blog", "eBook", "Video", "Gallery"][currentTab];
                    if (formKey.currentState!.validate()) {
                      Resource updatedResource;
                      if (category == "Blog") {
                        updatedResource = Blog(
                          title: titleController.text,
                          description: descController.text,
                        );
                      } else if (category == "eBook") {
                        updatedResource = EBook(
                          title: titleController.text,
                          description: descController.text,
                          link: linkController.text,
                        );
                      } else if (category == "Video") {
                        updatedResource = Video(
                          title: titleController.text,
                          description: descController.text,
                          link: linkController.text,
                        );
                      } else {
                        updatedResource = Gallery(
                          title: titleController.text,
                          description: descController.text,
                          images: uploadedImages,
                        );
                      }
                      await _repository.update(updatedResource);
                      Navigator.pop(ctx);
                      setState(() {});
                    }
                  },
                  child: const Text("Update"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------- Confirm Delete Dialog ----------------
  void _confirmDelete(Resource resource) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Resource"),
        content: Text("Are you sure you want to delete '${resource.title}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await _repository.deleteByTitle(resource.title);
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
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
        side: BorderSide(color: Colors.grey.shade300),
      ),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    r.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _openEditDialog(r),
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(r),
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            Text(
              r.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),

            if (r is EBook)
              Text(
                "${(r as EBook).link}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.blueGrey,
                ),
              ),
            if (r is Video)
              Text(
                "${(r as Video).link}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.blueGrey,
                ),
              ),

            if (r is Gallery && r.images.isNotEmpty)
              Wrap(
                spacing: 6,
                children: r.images
                    .map((img) => Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: MemoryImage(base64Decode(img)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            const SizedBox(height: 8),

            Chip(
              label: Text(
                r.runtimeType.toString().split('.').last,
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blueGrey.shade50,
            ),
          ],
        ),
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

  // ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title:"Resources Hub Management"),
      body: Column(
        children: [
          // Add Resource Button
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity,
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

          // Tab Grid (2x2)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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

          // Dynamic Content
          Expanded(
            child: FutureBuilder<List<Resource>>(
              future: _repository.getByCategory(selectedTab),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final resources = snapshot.data ?? [];
                if (resources.isEmpty) {
                  return const Center(
                    child: Text("No resources yet", style: TextStyle(color: Colors.grey)),
                  );
                }

                return ListView.builder(
                  itemCount: resources.length,
                  itemBuilder: (_, i) => _buildResourceCard(resources[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}