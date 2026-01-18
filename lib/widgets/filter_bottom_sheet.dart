import 'package:flutter/material.dart';
import '../main.dart'; // Imports AppColors from main.dart

// A model to hold all the filter data
class FilterData {
  RangeValues priceRange;
  int? starRating;
  double? guestRating;
  String? hotelSource;
  List<String> propertyTypes;
  List<String> amenities;
  String? mealPlan;
  String? cancellationPolicy;
  List<String> specialFeatures;

  FilterData({
    this.priceRange = const RangeValues(100, 800),
    this.starRating,
    this.guestRating,
    this.hotelSource,
    this.propertyTypes = const [],
    this.amenities = const [],
    this.mealPlan,
    this.cancellationPolicy,
    this.specialFeatures = const [],
  });
}

class FilterBottomSheet extends StatefulWidget {
  final FilterData initialData;
  const FilterBottomSheet({super.key, required this.initialData});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late FilterData _data;

  @override
  void initState() {
    super.initState();
    // Create a copy of the initial data to work with
    _data = FilterData(
      priceRange: widget.initialData.priceRange,
      starRating: widget.initialData.starRating,
      guestRating: widget.initialData.guestRating,
      hotelSource: widget.initialData.hotelSource,
      propertyTypes: List.from(widget.initialData.propertyTypes),
      amenities: List.from(widget.initialData.amenities),
      mealPlan: widget.initialData.mealPlan,
      cancellationPolicy: widget.initialData.cancellationPolicy,
      specialFeatures: List.from(widget.initialData.specialFeatures),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.backgroundGrey,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header with Drag Handle and Close Button
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Filters",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildSectionTitle("Price Range (per night)"),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("RM ${_data.priceRange.start.round()}", style: const TextStyle(color: AppColors.textSecondary)),
                      Text("RM ${_data.priceRange.end.round()}", style: const TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                  RangeSlider(
                    values: _data.priceRange,
                    min: 0,
                    max: 1500,
                    divisions: 150,
                    activeColor: AppColors.primaryBlue,
                    inactiveColor: AppColors.inputBorder,
                    onChanged: (RangeValues values) {
                      setState(() {
                        _data.priceRange = values;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle("Star Rating"),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (index) {
                      int rating = index + 1;
                      bool isSelected = _data.starRating == rating;
                      return _buildRatingButton(
                        label: "$rating",
                        icon: Icons.star,
                        isSelected: isSelected,
                        onTap: () => setState(() => _data.starRating = isSelected ? null : rating),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle("Guest Rating"),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [3.0, 3.5, 4.0, 4.5].map((rating) {
                      bool isSelected = _data.guestRating == rating;
                      return _buildRatingButton(
                        label: "$rating+",
                        isSelected: isSelected,
                        onTap: () => setState(() => _data.guestRating = isSelected ? null : rating),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle("Hotel Source"),
                  _buildRadioList(["Partner Hotels", "Amadeus Hotels"], _data.hotelSource, (val) => setState(() => _data.hotelSource = val)),
                  const SizedBox(height: 24),

                  _buildSectionTitle("Property Type"),
                  _buildCheckboxList(["Hotels", "Apartments", "Villas", "Resorts", "Hostels", "Homestays"], _data.propertyTypes),
                  const SizedBox(height: 24),

                  _buildSectionTitle("Amenities"),
                  _buildCheckboxList(["Free WiFi", "Swimming Pool", "Gym/Fitness", "Restaurant", "Spa", "Free Parking"], _data.amenities),
                  const SizedBox(height: 24),

                  _buildSectionTitle("Meal Plans"),
                  _buildRadioList(["Breakfast Included", "Half Board", "Full Board", "All Inclusive"], _data.mealPlan, (val) => setState(() => _data.mealPlan = val)),
                  const SizedBox(height: 24),

                  _buildSectionTitle("Cancellation Policy"),
                  _buildRadioList(["Free Cancellation", "Non-refundable"], _data.cancellationPolicy, (val) => setState(() => _data.cancellationPolicy = val)),
                  const SizedBox(height: 24),

                  _buildSectionTitle("Special Features"),
                  _buildCheckboxList(["Beachfront", "Mountain View", "Business Center", "City View", "Family Friendly", "Wheelchair Access"], _data.specialFeatures),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Bottom Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _data = FilterData(); // Reset to default values
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppColors.inputBorder),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("RESET ALL", style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, _data),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("SHOW 145 RESULTS"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget _buildRatingButton({
    required String label,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.white,
          border: Border.all(color: isSelected ? AppColors.primaryBlue : AppColors.inputBorder),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.amber),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioList(List<String> options, String? groupValue, Function(String?) onChanged) {
    return Column(
      children: options.map((option) {
        return RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: groupValue,
          activeColor: AppColors.primaryBlue,
          contentPadding: EdgeInsets.zero,
          onChanged: onChanged,
        );
      }).toList(),
    );
  }

  Widget _buildCheckboxList(List<String> options, List<String> selectedList) {
    // Using a Wrap to create a two-column layout for checkboxes
    return Wrap(
      spacing: 16.0,
      runSpacing: 0.0,
      children: options.map((option) {
        return SizedBox(
          width: (MediaQuery.of(context).size.width - 76) / 2, // Calculate width for 2 columns
          child: CheckboxListTile(
            title: Text(option),
            value: selectedList.contains(option),
            activeColor: AppColors.primaryBlue,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  selectedList.add(option);
                } else {
                  selectedList.remove(option);
                }
              });
            },
          ),
        );
      }).toList(),
    );
  }
}