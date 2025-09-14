import 'package:firebase_database/firebase_database.dart';
import '../models/testimonial.dart';

class TestimonialDao {
  final DatabaseReference _testimonialsRef =
      FirebaseDatabase.instance.ref().child("testimonials"); // Pending
  final DatabaseReference _approvedRef =
      FirebaseDatabase.instance.ref().child("approved_testimonials"); // Approved


  Stream<DatabaseEvent> getPendingTestimonials() {
    return _testimonialsRef.onValue;
  }


  Stream<DatabaseEvent> getApprovedTestimonials() {
    return _approvedRef.onValue;
  }


  Future<void> approveTestimonial(Testimonial t) async {
    await _approvedRef.child(t.id).set(t.toMap());
    await _testimonialsRef.child(t.id).remove();
  }


  Future<void> rejectTestimonial(String id) async {
    await _testimonialsRef.child(id).remove();
  }


  Future<void> addTestimonial(Testimonial t) async {
    await _testimonialsRef.child(t.id).set(t.toMap());
  }


  Future<void> deleteApprovedTestimonial(String id) async {
    await _approvedRef.child(id).remove();
  }
}

