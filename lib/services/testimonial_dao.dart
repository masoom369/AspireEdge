import 'package:firebase_database/firebase_database.dart';
import '../models/testimonial.dart';

class TestimonialDao {
  final DatabaseReference _testimonialsRef =
      FirebaseDatabase.instance.ref().child("testimonials");
  final DatabaseReference _approvedRef =
      FirebaseDatabase.instance.ref().child("approved_testimonials");

  /// Get pending testimonials
  Stream<DatabaseEvent> getPendingTestimonials() {
    return _testimonialsRef.onValue;
  }

  /// Approve testimonial (move to approved list)
  Future<void> approveTestimonial(Testimonial t) async {
    await _approvedRef.child(t.id).set(t.toMap());
    await _testimonialsRef.child(t.id).remove();
  }

  /// Reject testimonial (delete only from pending)
  Future<void> rejectTestimonial(String id) async {
    await _testimonialsRef.child(id).remove();
  }

  /// Add new testimonial (pending by default)
  Future<void> addTestimonial(Testimonial t) async {
    await _testimonialsRef.child(t.id).set(t.toMap());
  }
}
