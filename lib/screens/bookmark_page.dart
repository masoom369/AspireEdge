import 'package:aspire_edge/screens/entryPoint/components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:aspire_edge/services/bookmark_dao.dart';
import 'package:aspire_edge/services/auth_service.dart';
import 'package:aspire_edge/services/resource_repository_dao.dart';
import 'package:aspire_edge/models/bookmark.dart';


class Resource {
  final String title;
  final String description;
  final String category; // Blog, eBook, Video, Gallery
  bool isBookmarked;

  Resource({
    required this.title,
    required this.description,
    required this.category,
    this.isBookmarked = false,
  });
}

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  String selectedCategory = 'All';
  String searchQuery = '';

  final BookmarkDao _bookmarkDao = BookmarkDao();
  final AuthService _authService = AuthService();
  final ResourceRepository _resourceRepository = ResourceRepository();

  List<String> categories = ['All', 'Blog', 'eBook', 'Video', 'Gallery'];
  List<Resource> bookmarkedResources = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final user = _authService.currentUser;
    if (user != null) {
      final bookmarks = await _bookmarkDao.getBookmarksByUser(user.uid);
      final allResources = await _resourceRepository.getAll();
      final bookmarkedIds = bookmarks.map((b) => b.resourceId).toSet();
      setState(() {
        bookmarkedResources = allResources
            .where((r) => bookmarkedIds.contains(r.title))
            .map((r) => Resource(
                  title: r.title,
                  description: r.description,
                  category: r.runtimeType.toString().split('.').last,
                  isBookmarked: true,
                ))
            .toList();
      });
    }
  }

  List<Resource> get filteredBookmarks {
    return bookmarkedResources.where((r) {
      final matchesCategory =
          selectedCategory == 'All' || r.category == selectedCategory;
      final matchesSearch = r.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          r.description.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case "Blog":
        return Icons.article_outlined;
      case "eBook":
        return Icons.menu_book_outlined;
      case "Video":
        return Icons.play_circle_outline;
      case "Gallery":
        return Icons.photo_library_outlined;
      default:
        return Icons.bookmark_border;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case "Blog":
        return Colors.blueAccent;
      case "eBook":
        return Colors.deepPurple;
      case "Video":
        return Colors.redAccent;
      case "Gallery":
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  Future<void> _toggleBookmark(Resource resource) async {
    final user = _authService.currentUser;
    if (user == null) return;
    if (resource.isBookmarked) {
      await _bookmarkDao.removeBookmark(user.uid, resource.title);
      setState(() {
        bookmarkedResources.removeWhere((r) => r.title == resource.title);
      });
    } else {
      final bookmark = Bookmark(uuid: user.uid, resourceId: resource.title);
      _bookmarkDao.saveBookmark(bookmark);
      setState(() {
        resource.isBookmarked = true;
        bookmarkedResources.add(resource);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const gradientColors = [Color(0xFF764BA2), Color(0xFF667EEA)];

    return Scaffold(
      appBar: CustomAppBar(title: "Bookmark"),
      body: SafeArea(
        child: Column(
          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Your Saved Resources",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Access your saved blogs, eBooks, videos, and galleries.",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search bookmarks...',
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF764BA2)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF764BA2), width: 1.5),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() => searchQuery = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: selectedCategory,
                          items: categories
                              .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                              .toList(),
                          onChanged: (value) {
                            setState(() => selectedCategory = value!);
                          },
                          decoration: InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),


            Expanded(
              child: filteredBookmarks.isEmpty
                  ? const Center(child: Text('No bookmarks found.'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: filteredBookmarks.length,
                      itemBuilder: (context, index) {
                        final resource = filteredBookmarks[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: _getCategoryColor(resource.category).withOpacity(0.15),
                                child: Icon(
                                  _getCategoryIcon(resource.category),
                                  color: _getCategoryColor(resource.category),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      resource.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Color(0xFF25254B),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      resource.description,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Category: ${resource.category}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  resource.isBookmarked
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: resource.isBookmarked
                                      ? gradientColors.first
                                      : Colors.grey,
                                ),
                                onPressed: () => _toggleBookmark(resource),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

