import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert'; // <-- Add for base64 decoding
import '../../models/testimonial.dart';
import '../../services/testimonial_dao.dart';

class ManageTestimonialsPage extends StatelessWidget {
  const ManageTestimonialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dao = TestimonialDao();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3D455B),
        title: const Text(
          "Manage Testimonials",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: dao.getPendingTestimonials(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text("No pending testimonials"));
          }

          final data = Map<String, dynamic>.from(
            snapshot.data!.snapshot.value as Map,
          );

          final testimonials = data.entries.map((e) {
            final value = Map<String, dynamic>.from(e.value as Map);
            return Testimonial(
              id: e.key,
              userName: value["name"] ?? "",
              message: value["testimonial"] ?? "",
              rating: 0, // not used anymore
              status: value["status"] ?? "pending",
              date: value["timestamp"] ?? "",
              image: value["image"], // <-- Fetch image
            );
          }).toList();

          return ListView.builder(
            itemCount: testimonials.length,
            itemBuilder: (context, index) {
              final t = testimonials[index];
              return Card(
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (t.image != null && t.image!.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.memory(
                                base64Decode(t.image!),
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (t.image != null && t.image!.isNotEmpty)
                            const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              t.userName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(t.message),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () => dao.approveTestimonial(t),
                            icon: const Icon(Icons.check, color: Colors.green),
                            label: const Text("Approve"),
                          ),
                          TextButton.icon(
                            onPressed: () => dao.rejectTestimonial(t.id),
                            icon: const Icon(Icons.close, color: Colors.red),
                            label: const Text("Reject"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
