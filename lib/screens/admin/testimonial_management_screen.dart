import 'package:flutter/material.dart';

class Testimonial {
  final String userName;
  final String message;
  final int rating; // 1–5 stars
  final DateTime date;

  Testimonial({
    required this.userName,
    required this.message,
    required this.rating,
    required this.date,
  });
}

class ManageTestimonialsPage extends StatefulWidget {
  const ManageTestimonialsPage({super.key});

  @override
  State<ManageTestimonialsPage> createState() => _ManageTestimonialsPageState();
}

class _ManageTestimonialsPageState extends State<ManageTestimonialsPage> {
  final List<Testimonial> testimonials = [
    Testimonial(
      userName: "Ali Khan",
      message: "This platform helped me a lot in my career growth.",
      rating: 5,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Testimonial(
      userName: "Sara Ahmed",
      message: "Clean UI and very professional experience.",
      rating: 4,
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  void _openTestimonialDialog({Testimonial? existing, int? index}) {
    final nameController = TextEditingController(text: existing?.userName ?? "");
    final messageController = TextEditingController(text: existing?.message ?? "");
    int selectedRating = existing?.rating ?? 5;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          existing == null ? "Add Testimonial" : "Edit Testimonial",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF3D455B),
          ),
        ),
        content: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "User Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: messageController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Message",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text("Rating:", style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(width: 8),
                    Row(
                      children: List.generate(5, (i) {
                        final filled = i < selectedRating;
                        return IconButton(
                          onPressed: () => setState(() => selectedRating = i + 1),
                          icon: Icon(
                            filled ? Icons.star : Icons.star_border,
                            color: const Color(0xFF3D455B),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text("Cancel", style: TextStyle(color: Colors.black54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3D455B),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              final newTestimonial = Testimonial(
                userName: nameController.text.isEmpty ? "Anonymous" : nameController.text,
                message: messageController.text.isEmpty ? "No message provided." : messageController.text,
                rating: selectedRating,
                date: DateTime.now(),
              );

              setState(() {
                if (existing == null) {
                  testimonials.add(newTestimonial);
                } else {
                  testimonials[index!] = newTestimonial;
                }
              });
              Navigator.pop(context);
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteTestimonial(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Delete Testimonial"),
        content: const Text("Are you sure you want to delete this testimonial?"),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() => testimonials.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard(Testimonial t, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t.userName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF3D455B),
                ),
              ),
              Text(
                "${t.date.day}/${t.date.month}/${t.date.year}",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Message
          Text(
            t.message,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 10),

          // Rating stars
          Row(
            children: List.generate(5, (i) {
              return Icon(
                i < t.rating ? Icons.star : Icons.star_border,
                color: const Color(0xFF3D455B),
                size: 18,
              );
            }),
          ),

          const SizedBox(height: 12),

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => _openTestimonialDialog(existing: t, index: index),
                icon: const Icon(Icons.edit, color: Colors.blue),
                label: const Text("Edit"),
              ),
              const SizedBox(width: 12),
              TextButton.icon(
                onPressed: () => _deleteTestimonial(index),
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text("Delete"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.rate_review_outlined, size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text("No testimonials yet", style: TextStyle(fontSize: 16, color: Colors.black54)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
       appBar: AppBar(
        backgroundColor:Color(0xFF3D455B)
 ,
        title: Text('Forgot Password',style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Add button on top
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openTestimonialDialog(),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text("Add Testimonial", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3D455B),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ),
          ),

          // Testimonials list
          Expanded(
            child: testimonials.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: testimonials.length,
                    itemBuilder: (context, index) =>
                        _buildTestimonialCard(testimonials[index], index),
                  ),
          ),
        ],
      ),
    );
  }
}
