import 'package:firebase_database/firebase_database.dart';
import '../models/testimonial.dart';

class TestimonialDao {
  final DatabaseReference _testimonialsRef =
      FirebaseDatabase.instance.ref().child("testimonials"); // Pending
  final DatabaseReference _approvedRef =
      FirebaseDatabase.instance.ref().child("approved_testimonials"); // Approved

  /// Get all pending testimonials
  Stream<DatabaseEvent> getPendingTestimonials() {
    return _testimonialsRef.onValue;
  }

  /// Get all approved testimonials
  Stream<DatabaseEvent> getApprovedTestimonials() {
    return _approvedRef.onValue;
  }

  /// Approve testimonial (move from pending -> approved)
  Future<void> approveTestimonial(Testimonial t) async {
    await _approvedRef.child(t.id).set(t.toMap());
    await _testimonialsRef.child(t.id).remove();
  }

  /// Reject testimonial (delete only from pending list)
  Future<void> rejectTestimonial(String id) async {
    await _testimonialsRef.child(id).remove();
  }

  /// Add new testimonial (always added to pending first)
  Future<void> addTestimonial(Testimonial t) async {
    await _testimonialsRef.child(t.id).set(t.toMap());
  }

  /// Delete testimonial from approved (optional helper)
  Future<void> deleteApprovedTestimonial(String id) async {
    await _approvedRef.child(id).remove();
  }
}
