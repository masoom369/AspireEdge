// dao/resource_dao.dart

import 'package:firebase_database/firebase_database.dart';
import '../models/resource.dart';

abstract class ResourceDAO<T extends Resource> {
  Future<List<T>> getAll();
  Future<void> add(T item);
  Future<void> update(T item);
  Future<void> delete(String title);
  Future<T?> findById(String title);
}

class BlogDAO implements ResourceDAO<Blog> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('resources/blogs');

  @override
  Future<List<Blog>> getAll() async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      return data.entries.map((entry) => Blog.fromMap(Map<String, dynamic>.from(entry.value))).toList();
    }
    return [];
  }

  @override
  Future<void> add(Blog item) async {
    final key = _dbRef.push().key;
    if (key != null) {
      await _dbRef.child(key).set(item.toMap());
    }
  }

  @override
  Future<void> update(Blog item) async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      final entry = data.entries.firstWhere(
        (entry) => Map<String, dynamic>.from(entry.value)['title'] == item.title,
        orElse: () => MapEntry('', {}),
      );
      if (entry.key.isNotEmpty) {
        await _dbRef.child(entry.key).set(item.toMap());
      }
    }
  }

  @override
  Future<void> delete(String title) async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      final entry = data.entries.firstWhere(
        (entry) => Map<String, dynamic>.from(entry.value)['title'] == title,
        orElse: () => MapEntry('', {}),
      );
      if (entry.key.isNotEmpty) {
        await _dbRef.child(entry.key).remove();
      }
    }
  }

  @override
  Future<Blog?> findById(String title) async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      final entry = data.entries.firstWhere(
        (entry) => Map<String, dynamic>.from(entry.value)['title'] == title,
        orElse: () => MapEntry('', {}),
      );
      if (entry.key.isNotEmpty) {
        return Blog.fromMap(Map<String, dynamic>.from(entry.value));
      }
    }
    return null;
  }
}

class EBookDAO implements ResourceDAO<EBook> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('resources/ebooks');

  @override
  Future<List<EBook>> getAll() async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      return data.entries.map((entry) => EBook.fromMap(Map<String, dynamic>.from(entry.value))).toList();
    }
    return [];
  }

  @override
  Future<void> add(EBook item) async {
    final key = _dbRef.push().key;
    if (key != null) {
      await _dbRef.child(key).set(item.toMap());
    }
  }

  @override
  Future<void> update(EBook item) async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      for (final entry in data.entries) {
        final itemData = Map<String, dynamic>.from(entry.value);
        if (itemData['title'] == item.title) {
          await _dbRef.child(entry.key).set(item.toMap());
          break;
        }
      }
    }
  }

  @override
  Future<void> delete(String title) async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      for (final entry in data.entries) {
        final itemData = Map<String, dynamic>.from(entry.value);
        if (itemData['title'] == title) {
          await _dbRef.child(entry.key).remove();
          break;
        }
      }
    }
  }

  @override
  Future<EBook?> findById(String title) async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      for (final entry in data.entries) {
        final itemData = Map<String, dynamic>.from(entry.value);
        if (itemData['title'] == title) {
          return EBook.fromMap(itemData);
        }
      }
    }
    return null;
  }
}

class VideoDAO implements ResourceDAO<Video> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('resources/videos');

  @override
  Future<List<Video>> getAll() async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      return data.entries.map((entry) => Video.fromMap(Map<String, dynamic>.from(entry.value))).toList();
    }
    return [];
  }

  @override
  Future<void> add(Video item) async {
    final key = _dbRef.push().key;
    if (key != null) {
      await _dbRef.child(key).set(item.toMap());
    }
  }

  @override
  Future<void> update(Video item) async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      for (final entry in data.entries) {
        final itemData = Map<String, dynamic>.from(entry.value);
        if (itemData['title'] == item.title) {
          await _dbRef.child(entry.key).set(item.toMap());
          break;
        }
      }
    }
  }

  @override
  Future<void> delete(String title) async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      for (final entry in data.entries) {
        final itemData = Map<String, dynamic>.from(entry.value);
        if (itemData['title'] == title) {
          await _dbRef.child(entry.key).remove();
          break;
        }
      }
    }
  }

  @override
  Future<Video?> findById(String title) async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      for (final entry in data.entries) {
        final itemData = Map<String, dynamic>.from(entry.value);
        if (itemData['title'] == title) {
          return Video.fromMap(itemData);
        }
      }
    }
    return null;
  }
}

class GalleryDAO implements ResourceDAO<Gallery> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('resources/galleries');

  @override
  Future<List<Gallery>> getAll() async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      return data.entries.map((entry) => Gallery.fromMap(Map<String, dynamic>.from(entry.value))).toList();
    }
    return [];
  }

  @override
  Future<void> add(Gallery item) async {
    final key = _dbRef.push().key;
    if (key != null) {
      await _dbRef.child(key).set(item.toMap());
    }
  }

  @override
  Future<void> update(Gallery item) async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      final entry = data.entries.firstWhere(
        (entry) => Map<String, dynamic>.from(entry.value)['title'] == item.title,
        orElse: () => MapEntry('', {}),
      );
      if (entry.key.isNotEmpty) {
        await _dbRef.child(entry.key).set(item.toMap());
      }
    }
  }

  @override
  Future<void> delete(String title) async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      final entry = data.entries.firstWhere(
        (entry) => Map<String, dynamic>.from(entry.value)['title'] == title,
        orElse: () => MapEntry('', {}),
      );
      if (entry.key.isNotEmpty) {
        await _dbRef.child(entry.key).remove();
      }
    }
  }

  @override
  Future<Gallery?> findById(String title) async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      final entry = data.entries.firstWhere(
        (entry) => Map<String, dynamic>.from(entry.value)['title'] == title,
        orElse: () => MapEntry('', {}),
      );
      if (entry.key.isNotEmpty) {
        return Gallery.fromMap(Map<String, dynamic>.from(entry.value));
      }
    }
    return null;
  }
}
