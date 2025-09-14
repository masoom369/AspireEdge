import 'package:aspire_edge/screens/entryPoint/components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:aspire_edge/models/resource.dart';
import 'package:aspire_edge/services/resource_repository_dao.dart';
import 'package:aspire_edge/services/bookmark_dao.dart';
import 'package:aspire_edge/services/auth_service.dart';
import 'package:aspire_edge/models/bookmark.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class ResourcesHubPage extends StatefulWidget {
  @override
  _ResourcesHubPageState createState() => _ResourcesHubPageState();
}

class _ResourcesHubPageState extends State<ResourcesHubPage> {
  final ResourceRepository _repository = ResourceRepository();
  final BookmarkDao _bookmarkDao = BookmarkDao();
  final AuthService _authService = AuthService();

  String selectedCategory = 'All';
  String searchQuery = '';
  Set<String> bookmarkedResourceIds = {}; // keep track of bookmarks

  List<String> categories = ['All', 'Blog', 'EBook', 'Video', 'Gallery'];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final user = _authService.currentUser;
    if (user != null) {
      final bookmarks = await _bookmarkDao.getBookmarksByUser(user.uid);
      setState(() {
        bookmarkedResourceIds = bookmarks.map((b) => b.resourceId).toSet();
      });
    }
  }

  Future<List<Resource>> get filteredResources async {
    List<Resource> allResources = await _repository.getAll();
    return allResources.where((resource) {
      final resourceType = resource.runtimeType.toString().split('.').last;
      final matchesCategory =
          selectedCategory == 'All' || resourceType == selectedCategory;
      final matchesSearch =
          resource.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          resource.description.toLowerCase().contains(
            searchQuery.toLowerCase(),
          );
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _toggleBookmark(Resource resource) async {
    final user = _authService.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to bookmark')),
      );
      return;
    }

    final resourceId = resource.title; // ✅ use resource object id
    if (bookmarkedResourceIds.contains(resourceId)) {

      await _bookmarkDao.removeBookmark(user.uid, resourceId);
      setState(() {
        bookmarkedResourceIds.remove(resourceId);
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Bookmark removed')));
    } else {

      final bookmark = Bookmark(uuid: user.uid, resourceId: resourceId);
      _bookmarkDao.saveBookmark(bookmark);
      setState(() {
        bookmarkedResourceIds.add(resourceId);
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Bookmark added')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: CustomAppBar(title: "Resources Hub"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [

              TextField(
                decoration: InputDecoration(
                  hintText: 'Search resources...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {
                  setState(() => searchQuery = value);
                },
              ),
              const SizedBox(height: 12),


              DropdownButtonFormField<String>(
                isExpanded: true,
                value: selectedCategory,
                items: categories
                    .map(
                      (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedCategory = value!);
                },
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),


              Expanded(
                child: FutureBuilder<List<Resource>>(
                  future: filteredResources,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final resources = snapshot.data ?? [];
                    if (resources.isEmpty) {
                      return const Center(child: Text('No resources found.'));
                    }

                    return ListView.builder(
                      itemCount: resources.length,
                      itemBuilder: (context, index) {
                        final resource = resources[index];
                        final isBookmarked = bookmarkedResourceIds.contains(
                          resource.title,
                        );

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        resource.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        isBookmarked
                                            ? Icons.bookmark
                                            : Icons.bookmark_border,
                                        color: isBookmarked
                                            ? Colors.blue
                                            : null,
                                      ),
                                      onPressed: () =>
                                          _toggleBookmark(resource),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  resource.description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                if (resource is EBook || resource is Video)
                                  TextButton(
                                    onPressed: () async {
                                      final url = resource is EBook
                                          ? resource.link
                                          : (resource as Video).link;
                                      if (await canLaunchUrl(Uri.parse(url))) {
                                        await launchUrl(Uri.parse(url));
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Could not launch $url',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(
                                      resource is EBook
                                          ? resource.link
                                          : (resource as Video).link,
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                if (resource is Gallery &&
                                    resource.images.isNotEmpty)
                                  Wrap(
                                    spacing: 6,
                                    children: resource.images
                                        .map(
                                          (img) => Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: DecorationImage(
                                                image: MemoryImage(
                                                  base64Decode(img),
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                const SizedBox(height: 6),
                                Text(
                                  'Category: ${resource.runtimeType.toString().split('.').last}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

