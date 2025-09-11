import 'package:firebase_database/firebase_database.dart';
import '../models/testimonial.dart';

class TestimonialDao {
  TestimonialDao();

  final _databaseRef = FirebaseDatabase.instance.ref("testimonials");

  void saveTestimonial(Testimonial testimonial) {
    _databaseRef.push().set(testimonial.toJson());
  }

  Query getTestimonialList() {
    return _databaseRef;
  }

  void deleteTestimonial(String key) {
    _databaseRef.child(key).remove();
  }

  void updateTestimonial(String key, Testimonial testimonial) {
    _databaseRef.child(key).update(testimonial.toJson());
  }
}