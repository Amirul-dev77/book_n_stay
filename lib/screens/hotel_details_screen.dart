import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart'; // Import for AppColors and theme
import 'all_reviews_screen.dart'; // Import the All Reviews Screen

class HotelDetailsScreen extends StatelessWidget {
  final String hotelName;
  final String location;
  final String price;
  final String rating;
  final String imageUrl;

  const HotelDetailsScreen({
    super.key,
    required this.hotelName,
    required this.location,
    required this.price,
    required this.rating,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: CustomScrollView(
        slivers: [
          // 1. App Bar with Image
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), shape: BoxShape.circle),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), shape: BoxShape.circle),
                child: IconButton(icon: const Icon(Icons.share_outlined, color: Colors.black), onPressed: () {}),
              ),
              const SizedBox(width: 8),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), shape: BoxShape.circle),
                child: IconButton(icon: const Icon(Icons.favorite_border, color: Colors.black), onPressed: () {}),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. Page Content
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(hotelName, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(location, style: const TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.successGreen, size: 18),
                      const SizedBox(width: 4),
                      Text(rating, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 4),
                      const Text("(1,240 reviews)", style: TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Booking Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("DATES", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                            SizedBox(height: 4),
                            Text("Oct 12 → Oct 16", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("GUESTS", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                            SizedBox(height: 4),
                            Text("2 Adults, 1 Room", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined, color: AppColors.primaryBlue))
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Overview
                  _buildSectionTitle("Overview"),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: AppColors.textSecondary, height: 1.5, fontFamily: GoogleFonts.poppins().fontFamily),
                      children: const [
                        TextSpan(text: "Experience luxury in the heart of Manhattan. Steps away from Grand Central Terminal, this iconic hotel offers sophisticated rooms, world-class dining, and breathtaking city views... "),
                        TextSpan(text: "Read more", style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Amenities
                  _buildSectionTitle("Amenities"),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildAmenityIcon(Icons.wifi, "Free Wifi"),
                      _buildAmenityIcon(Icons.pool, "Pool"),
                      _buildAmenityIcon(Icons.restaurant, "Restaurant"),
                      _buildAmenityIcon(Icons.fitness_center, "Gym"),
                      _buildAmenityIcon(Icons.spa, "Spa"),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Room Types
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle("Room Types"),
                      TextButton(onPressed: () {}, child: const Text("See All")),
                    ],
                  ),
                  _buildRoomCard("Deluxe King Room", "1 King Bed • 350 sqft • City View", "240", imageUrl),
                  const SizedBox(height: 16),
                  _buildRoomCard("Double Room", "2 Queen Beds • 400 sqft", "280", "https://images.unsplash.com/photo-1566665797739-1674de7a421a?q=80&w=600"),
                  const SizedBox(height: 24),

                  // Location
                  _buildSectionTitle("Location"),
                  const SizedBox(height: 16),
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: NetworkImage("https://i.imgur.com/7Q6Z24X.png"), // Replace with actual map image/widget
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.location_on, color: AppColors.primaryBlue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ============================================================
                  // UPDATED REVIEWS SECTION (Clickable + Visible Border)
                  // ============================================================
                  _buildSectionTitle("Reviews"),
                  const SizedBox(height: 16),
                  Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                    child: InkWell(
                      onTap: () {
                        // Navigate to All Reviews Screen
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AllReviewsScreen())
                        );
                      },
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.inputFill, // Light grey background
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.inputBorder, width: 1.5), // Visible border
                        ),
                        child: Row(
                          children: [
                            // Left Side: Summary
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "4.8",
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 48, height: 1),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.amber, size: 18)),
                                ),
                                const SizedBox(height: 8),
                                const Text("1,240 reviews", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                              ],
                            ),
                            const SizedBox(width: 24),
                            // Right Side: Detailed Breakdown
                            Expanded(
                              child: Column(
                                children: [
                                  _buildRatingBar(5, 0.85),
                                  _buildRatingBar(4, 0.10),
                                  _buildRatingBar(3, 0.03),
                                  _buildRatingBar(2, 0.01),
                                  _buildRatingBar(1, 0.01),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Policies
                  _buildPolicyTile("House Rules"),
                  _buildPolicyTile("Cancellation Policy"),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.inputBorder)),
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: "RM $price", style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 20)),
                      const TextSpan(text: " / night", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Text("Oct 12 - 16", style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("SELECT ROOM"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper for Rating Bars
  Widget _buildRatingBar(int star, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text("$star", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textPrimary)),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: AppColors.inputBorder,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
                minHeight: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18));
  }

  Widget _buildAmenityIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.inputFill, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: AppColors.primaryBlue),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildRoomCard(String title, String subtitle, String price, String imgUrl) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.inputBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(imgUrl, width: 80, height: 80, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: "RM $price", style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                      const TextSpan(text: " / night", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(60, 36),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("VIEW"),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyTile(String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}