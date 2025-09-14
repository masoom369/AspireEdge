
import '../models/resource.dart';
import 'resource_dao.dart';

class ResourceRepository {
  final BlogDAO _blogDAO = BlogDAO();
  final EBookDAO _eBookDAO = EBookDAO();
  final VideoDAO _videoDAO = VideoDAO();
  final GalleryDAO _galleryDAO = GalleryDAO();


  Future<void> add(Resource resource) async {
    switch (resource.runtimeType) {
      case Blog:
        await _blogDAO.add(resource as Blog);
        break;
      case EBook:
        await _eBookDAO.add(resource as EBook);
        break;
      case Video:
        await _videoDAO.add(resource as Video);
        break;
      case Gallery:
        await _galleryDAO.add(resource as Gallery);
        break;
      default:
        throw ArgumentError('Unknown resource type: ${resource.runtimeType}');
    }
  }


  Future<List<Resource>> getAll() async {
    final blogs = await _blogDAO.getAll().then((list) => list.map((b) => b as Resource));
    final ebooks = await _eBookDAO.getAll().then((list) => list.map((e) => e as Resource));
    final videos = await _videoDAO.getAll().then((list) => list.map((v) => v as Resource));
    final galleries = await _galleryDAO.getAll().then((list) => list.map((g) => g as Resource));

    return [...blogs, ...ebooks, ...videos, ...galleries];
  }


  Future<List<Resource>> getByCategory(String category) async {
    final all = await getAll();

    final typeMap = {
      'Blog': 'Blog',
      'eBook': 'EBook',
      'Video': 'Video',
      'Gallery': 'Gallery',
    };
    final runtimeTypeName = typeMap[category] ?? category;
    return all.where((r) => r.runtimeType.toString().split('.').last == runtimeTypeName).toList();
  }


  Future<void> deleteByTitle(String title) async {
    final resource = await getById(title);
    if (resource == null) return;

    switch (resource.runtimeType) {
      case Blog:
        await _blogDAO.delete(title);
        break;
      case EBook:
        await _eBookDAO.delete(title);
        break;
      case Video:
        await _videoDAO.delete(title);
        break;
      case Gallery:
        await _galleryDAO.delete(title);
        break;
    }
  }


  Future<void> update(Resource resource) async {
    switch (resource.runtimeType) {
      case Blog:
        await _blogDAO.update(resource as Blog);
        break;
      case EBook:
        await _eBookDAO.update(resource as EBook);
        break;
      case Video:
        await _videoDAO.update(resource as Video);
        break;
      case Gallery:
        await _galleryDAO.update(resource as Gallery);
        break;
      default:
        throw ArgumentError('Unknown resource type: ${resource.runtimeType}');
    }
  }


  Future<Resource?> getById(String title) async {
    final all = await getAll();
    try {
      return all.firstWhere((r) => r.title == title);
    } catch (e) {
      return null;
    }
  }
}
