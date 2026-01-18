import 'package:flutter/material.dart';
import '../main.dart'; // Imports AppColors from main.dart

class SortByBottomSheet extends StatefulWidget {
  final String currentSort;
  const SortByBottomSheet({super.key, required this.currentSort});

  @override
  State<SortByBottomSheet> createState() => _SortByBottomSheetState();
}

class _SortByBottomSheetState extends State<SortByBottomSheet> {
  late String _selectedSort;

  final List<String> _sortOptions = [
    "Recommended",
    "Price: Low to High",
    "Price: High to Low",
    "Star Rating: High to Low",
    "Guest Rating: High to Low",
    "Distance: Nearest First",
    "Most Popular",
  ];

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.currentSort;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Sort By",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          // Options List
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: _sortOptions.length,
              itemBuilder: (context, index) {
                final option = _sortOptions[index];
                return RadioListTile<String>(
                  title: Text(
                      option,
                      style: TextStyle(
                          fontWeight: option == _selectedSort ? FontWeight.bold : FontWeight.normal
                      )
                  ),
                  value: option,
                  groupValue: _selectedSort,
                  activeColor: AppColors.primaryBlue,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.trailing, // Radio on right
                  onChanged: (value) {
                    setState(() => _selectedSort = value!);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          // Apply Button
          ElevatedButton(
            onPressed: () => Navigator.pop(context, _selectedSort),
            child: const Text("APPLY"),
          ),
        ],
      ),
    );
  }
}