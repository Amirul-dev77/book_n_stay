import 'package:flutter/material.dart';
import '../main.dart'; // Import for AppColors

// A simple model to hold guest data for a single room
class GuestData {
  int adults;
  int children;
  GuestData({this.adults = 2, this.children = 0});
}

class GuestPicker extends StatefulWidget {
  final List<GuestData> initialData;
  const GuestPicker({super.key, required this.initialData});

  @override
  State<GuestPicker> createState() => _GuestPickerState();
}

class _GuestPickerState extends State<GuestPicker> {
  late List<GuestData> _roomsData;

  @override
  void initState() {
    super.initState();
    _roomsData = widget.initialData.map((data) => GuestData(
      adults: data.adults,
      children: data.children,
    )).toList();
  }

  int _getTotalGuests() {
    return _roomsData.fold(0, (sum, room) => sum + room.adults + room.children);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Guests & Rooms", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 20),
          // Scrollable List of Rooms
          Expanded(
            child: ListView.builder(
              itemCount: _roomsData.length,
              itemBuilder: (context, index) {
                return _buildRoomSection(index);
              },
            ),
          ),
          const SizedBox(height: 16),

          // "Add Another Room" Button - FIXED WIDTH
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _roomsData.add(GuestData(adults: 1, children: 0));
              });
            },
            style: OutlinedButton.styleFrom(
              // THIS LINE MAKES IT WIDER (Full Width)
              minimumSize: const Size(double.infinity, 50),
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: AppColors.primaryBlue),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryBlue),
            label: const Text("ADD ANOTHER ROOM", style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
          ),

          const SizedBox(height: 16),
          // Summary and Apply Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Selection Summary", style: TextStyle(color: AppColors.textSecondary)),
              Text("Total: ${_getTotalGuests()} Guests, ${_roomsData.length} Room${_roomsData.length > 1 ? 's' : ''}", style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, _roomsData),
            child: const Text("APPLY"),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomSection(int index) {
    final room = _roomsData[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border.all(color: AppColors.inputBorder), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Room ${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              if (index > 0)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.errorRed),
                  onPressed: () {
                    setState(() {
                      _roomsData.removeAt(index);
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),
          _buildCounterRow("Adults", "Ages 18+", room.adults, (val) => setState(() => room.adults = val), minVal: 1),
          const Divider(height: 32),
          _buildCounterRow("Children", "Ages 0-17", room.children, (val) => setState(() => room.children = val)),

          if (room.children > 0) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Age of child 1", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.inputBorder)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("5 years old"),
                        const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text("Required for best pricing.", style: TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildCounterRow(String label, String subtitle, int value, Function(int) onChanged, {int minVal = 0}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            if (subtitle.isNotEmpty) Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
        Row(
          children: [
            _buildCircularButton(Icons.remove, () {
              if (value > minVal) onChanged(value - 1);
            }),
            SizedBox(width: 30, child: Center(child: Text("$value", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))),
            _buildCircularButton(Icons.add, () {
              onChanged(value + 1);
            }),
          ],
        )
      ],
    );
  }

  Widget _buildCircularButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.inputBorder)),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 18, color: AppColors.primaryBlue),
        onPressed: onPressed,
      ),
    );
  }
}