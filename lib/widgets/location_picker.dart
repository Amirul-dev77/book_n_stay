import 'package:flutter/material.dart';
import '../main.dart'; // Import for AppColors

class LocationPicker extends StatelessWidget {
  const LocationPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Select Location", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 20),
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: "Search location...",
              prefixIcon: const Icon(Icons.search),
              fillColor: AppColors.inputFill,
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 20),
          // Use Current Location Button
          ListTile(
            leading: const CircleAvatar(backgroundColor: AppColors.inputFill, child: Icon(Icons.my_location, color: AppColors.primaryBlue)),
            title: const Text("Use Current Location", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
            subtitle: const Text("Enable location access", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            onTap: () {
              // For now, just return a hardcoded location
              Navigator.pop(context, "Kuala Lumpur, MY");
            },
          ),
          const Divider(height: 30),
          const Text("ALL LOCATIONS", style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          // Location List
          Expanded(
            child: ListView(
              children: [
                _buildLocationTile(context, "Bali", "Indonesia"),
                _buildLocationTile(context, "Bangkok", "Thailand"),
                _buildLocationTile(context, "Kuala Lumpur", "Malaysia"),
                _buildLocationTile(context, "Seoul", "South Korea"),
                _buildLocationTile(context, "Singapore", "Singapore"),
                _buildLocationTile(context, "Tokyo", "Japan"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationTile(BuildContext context, String city, String country) {
    return ListTile(
      leading: const CircleAvatar(backgroundColor: AppColors.inputFill, child: Icon(Icons.location_on_outlined, color: AppColors.textSecondary)),
      title: Text(city, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(country, style: const TextStyle(color: AppColors.textSecondary)),
      onTap: () => Navigator.pop(context, "$city, $country"),
    );
  }
}