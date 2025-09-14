import 'dart:convert';
import 'package:aspire_edge/screens/admin/custom_appbar_admin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../models/testimonial.dart';
import '../../services/testimonial_dao.dart';

class ManageTestimonialsPage extends StatelessWidget {
  const ManageTestimonialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dao = TestimonialDao();

    return Scaffold(
      appBar: CustomAppBar(title: "Testimonial Management"),
      body: StreamBuilder<DatabaseEvent>(
        stream: dao.getPendingTestimonials(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text("No pending testimonials"));
          }

          final data =
              Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);

          final testimonials = data.entries.map((e) {
            final value = Map<String, dynamic>.from(e.value as Map);

            return Testimonial(
              id: e.key,
              userName: value["userName"] ?? "",
              message: value["message"] ?? "",
              rating: value["rating"] ?? 0,
              status: value["status"] ?? "pending",
              date: value["date"] ?? "",
              image: value["image"],
              tier: value["tier"], // ✅ added tier
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
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.userName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                if (t.tier != null && t.tier!.isNotEmpty)
                                  Text(
                                    t.tier!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
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

