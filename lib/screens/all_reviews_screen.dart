import 'package:flutter/material.dart';
import '../main.dart'; // Import for AppColors

class AllReviewsScreen extends StatelessWidget {
  const AllReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text("All Reviews", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.tune, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Overall Rating Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(text: "4.8", style: TextStyle(color: AppColors.primaryBlue, fontSize: 32, fontWeight: FontWeight.bold)),
                                      TextSpan(text: "/5.0", style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                                    ],
                                  ),
                                ),
                                const Text("Excellent", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const Text("Based on 2,456 reviews", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                              ],
                            ),
                            Row(children: List.generate(5, (index) => const Icon(Icons.star_outline, color: Colors.amber, size: 24))),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Detailed Bars
                        _buildCategoryBar("Cleanliness", 4.9),
                        _buildCategoryBar("Location", 4.5),
                        _buildCategoryBar("Service", 4.8),
                        _buildCategoryBar("Value", 4.7),
                        _buildCategoryBar("Facilities", 4.6),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 2. Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip("All (2456)", true),
                        _buildFilterChip("5 ★ (1890)", false),
                        _buildFilterChip("4 ★ (400)", false),
                        _buildFilterChip("3 ★ (100)", false),
                        _buildFilterChip("2 ★ (45)", false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3. Sort Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Showing 2,456 reviews", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      Row(
                        children: const [
                          Text("Sort: Most Recent", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          Icon(Icons.keyboard_arrow_down, size: 16),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 4. Reviews List
                  _buildReviewItem(
                    name: "Sarah Jenkins",
                    date: "Oct 24, 2023",
                    rating: "5.0",
                    tags: ["Solo Traveler", "3 Nights", "Ocean View"],
                    review: "The location was absolutely perfect, right next to the metro station and walking distance to main attractions. The staff went above and beyond!",
                    helpfulCount: 12,
                    hasResponse: true,
                  ),
                  _buildReviewItem(
                    name: "Michael Chen",
                    date: "Oct 10, 2023",
                    rating: "4.0",
                    tags: ["Business Trip", "King Suite"],
                    review: "Great amenities and fast Wi-Fi, which was crucial for my work. The room was spacious and clean. The only downside was noise from the street.",
                    helpfulCount: 4,
                  ),
                  _buildReviewItem(
                    name: "Emma Miller",
                    date: "Sep 05, 2023",
                    rating: "3.0",
                    tags: ["Family Trip", "Standard Room"],
                    review: "Average experience. The room was smaller than expected from the photos. Service was okay, but check-in took too long.",
                    helpfulCount: 0,
                  ),
                ],
              ),
            ),
          ),

          // Bottom Button
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Load More Reviews"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBar(String label, double score) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: score / 5.0,
                minHeight: 6,
                backgroundColor: AppColors.inputFill,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(score.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryBlue : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? AppColors.primaryBlue : AppColors.inputBorder),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildReviewItem({
    required String name,
    required String date,
    required String rating,
    required List<String> tags,
    required String review,
    required int helpfulCount,
    bool hasResponse = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(radius: 16, backgroundColor: AppColors.inputFill, child: Icon(Icons.person, color: AppColors.textSecondary, size: 20)),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text("Reviewed $date", style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.successGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Text(rating, style: const TextStyle(color: AppColors.successGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(width: 4),
                    const Icon(Icons.star, color: AppColors.successGreen, size: 12),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: tags.map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.inputFill, borderRadius: BorderRadius.circular(4)),
              child: Text(t, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
            )).toList(),
          ),
          const SizedBox(height: 12),
          Text(review, style: const TextStyle(height: 1.5, fontSize: 13, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.thumb_up_outlined, size: 16, color: AppColors.primaryBlue),
              const SizedBox(width: 6),
              Text("Helpful ($helpfulCount)", style: const TextStyle(color: AppColors.primaryBlue, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(width: 24),
              const Icon(Icons.flag_outlined, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              const Text("Report", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
          if (hasResponse) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                border: Border(left: BorderSide(color: AppColors.primaryBlue, width: 3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Response from Hotel", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryBlue)),
                  SizedBox(height: 4),
                  Text("\"Thank you Sarah! We are glad you enjoyed the convenience of our location and breakfast!\"", style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.textSecondary)),
                ],
              ),
            )
          ]
        ],
      ),
    );
  }
}