import 'package:flutter/material.dart';
import '../widgets/available_rides.dart';

/// ---------------------------------------------------------------
/// saved_places_screen.dart
///
/// 1) Dashboard tile (the pink "Saved Places" card):
///      const SavedPlacesTile()
///    Tapping it opens SavedPlacesScreen automatically.
///
/// 2) Or open the screen from anywhere:
///      Navigator.push(context,
///        MaterialPageRoute(builder: (_) => const SavedPlacesScreen()));
/// ---------------------------------------------------------------

enum PlaceType { home, school, work, favorite }

extension PlaceTypeX on PlaceType {
  String get label {
    switch (this) {
      case PlaceType.home:
        return 'Home';
      case PlaceType.school:
        return 'School';
      case PlaceType.work:
        return 'Work';
      case PlaceType.favorite:
        return 'Favorite';
    }
  }

  Color get color {
    switch (this) {
      case PlaceType.home:
        return const Color(0xFFEF4444);
      case PlaceType.school:
        return const Color(0xFF4F36F5);
      case PlaceType.work:
        return const Color(0xFFF59E0B);
      case PlaceType.favorite:
        return const Color(0xFFEC4899);
    }
  }

  Color get bg {
    switch (this) {
      case PlaceType.home:
        return const Color(0xFFFEEEEE);
      case PlaceType.school:
        return const Color(0xFFEEF0FF);
      case PlaceType.work:
        return const Color(0xFFFFF4E5);
      case PlaceType.favorite:
        return const Color(0xFFFDEEF6);
    }
  }
}

class SavedPlace {
  final String id;
  final PlaceType type;
  final String name;
  final String address;

  const SavedPlace({
    required this.id,
    required this.type,
    required this.name,
    required this.address,
  });

  SavedPlace copyWith({PlaceType? type, String? name, String? address}) {
    return SavedPlace(
      id: id,
      type: type ?? this.type,
      name: name ?? this.name,
      address: address ?? this.address,
    );
  }
}

/// Sample data – replace with your Firebase / API data.
const List<SavedPlace> sampleSavedPlaces = [
  SavedPlace(
    id: '1',
    type: PlaceType.home,
    name: 'San Jose Village',
    address: 'San Jose Village, Lipa City',
  ),
  SavedPlace(
    id: '2',
    type: PlaceType.school,
    name: 'ShareTrip Campus',
    address: 'Main Campus, CMDI',
  ),
  SavedPlace(
    id: '3',
    type: PlaceType.favorite,
    name: 'Town Center',
    address: 'Lipa City Town Center',
  ),
];

// ======================= DASHBOARD TILE =======================

class SavedPlacesTile extends StatelessWidget {
  final VoidCallback? onTap;

  const SavedPlacesTile({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap ??
          () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SavedPlacesScreen(),
                ),
              ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFE9EA),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.location_on_outlined,
                  size: 24, color: Color(0xFFE11D48)),
            ),
            const SizedBox(height: 16),
            const Text(
              'Saved Places',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: RideColors.dark,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'Frequent destinations',
              style: TextStyle(fontSize: 13, color: RideColors.label),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================= SAVED PLACES SCREEN =======================

class SavedPlacesScreen extends StatefulWidget {
  final List<SavedPlace> places;

  const SavedPlacesScreen({super.key, this.places = sampleSavedPlaces});

  @override
  State<SavedPlacesScreen> createState() => _SavedPlacesScreenState();
}

class _SavedPlacesScreenState extends State<SavedPlacesScreen> {
  static const _bg = Color(0xFFF7F8FC);
  static const _indigo = Color(0xFF4F36F5);
  static const _red = Color(0xFFE11D48);

  late List<SavedPlace> _places;

  @override
  void initState() {
    super.initState();
    _places = List.of(widget.places);
  }

  // ---------------- ACTIONS ----------------
  Future<void> _addOrEdit([SavedPlace? existing]) async {
    final result = await showModalBottomSheet<SavedPlace>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => _PlaceFormSheet(existing: existing),
    );
    if (result == null) return;

    setState(() {
      if (existing == null) {
        _places.add(result);
      } else {
        final i = _places.indexWhere((p) => p.id == existing.id);
        if (i != -1) _places[i] = result;
      }
    });
    // TODO: save the place to Firebase / backend here.
  }

  Future<void> _delete(SavedPlace place) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete place?'),
        content: Text('Remove "${place.name}" from your saved places?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: _red)),
          ),
        ],
      ),
    );
    if (ok == true) {
      setState(() => _places.removeWhere((p) => p.id == place.id));
      // TODO: delete the place from Firebase / backend here.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          _header(context),
          Expanded(
            child: _places.isEmpty
                ? const Center(
                    child: Text(
                      'No saved places yet',
                      style: TextStyle(fontSize: 15, color: RideColors.grey),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    itemCount: _places.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (_, i) => _placeCard(_places[i]),
                  ),
          ),
        ],
      ),
    );
  }

  // ---------------- HEADER ----------------
  Widget _header(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
          16, MediaQuery.of(context).padding.top + 16, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.maybePop(context),
            customBorder: const CircleBorder(),
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Color(0xFFF1F2F5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back,
                  size: 20, color: RideColors.dark),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Saved Places',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: RideColors.dark,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Your frequently visited destinations',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: RideColors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () => _addOrEdit(),
            icon: const Icon(Icons.add, size: 16),
            label: const Text(
              'Add New Place',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _indigo,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- PLACE CARD ----------------
  Widget _placeCard(SavedPlace p) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: p.type.bg,
              borderRadius: BorderRadius.circular(14),
            ),
            child:
                Icon(Icons.location_on_outlined, size: 22, color: p.type.color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.type.label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: RideColors.grey,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  p.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: RideColors.dark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  p.address,
                  style: const TextStyle(fontSize: 13, color: RideColors.label),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => _addOrEdit(p),
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(4, 2, 4, 6),
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: _indigo,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => _delete(p),
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(4, 2, 0, 6),
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: _red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ======================= ADD / EDIT FORM =======================

class _PlaceFormSheet extends StatefulWidget {
  final SavedPlace? existing;

  const _PlaceFormSheet({this.existing});

  @override
  State<_PlaceFormSheet> createState() => _PlaceFormSheetState();
}

class _PlaceFormSheetState extends State<_PlaceFormSheet> {
  late final TextEditingController _name;
  late final TextEditingController _address;
  late PlaceType _type;
  String? _error;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.existing?.name ?? '');
    _address = TextEditingController(text: widget.existing?.address ?? '');
    _type = widget.existing?.type ?? PlaceType.favorite;
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    super.dispose();
  }

  void _save() {
    final name = _name.text.trim();
    final address = _address.text.trim();
    if (name.isEmpty || address.isEmpty) {
      setState(() => _error = 'Please fill in the name and address.');
      return;
    }
    Navigator.pop(
      context,
      SavedPlace(
        id: widget.existing?.id ??
            DateTime.now().microsecondsSinceEpoch.toString(),
        type: _type,
        name: name,
        address: address,
      ),
    );
  }

  InputDecoration _decoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: RideColors.grey),
        filled: true,
        fillColor: const Color(0xFFF6F7FB),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF4F36F5)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final editing = widget.existing != null;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 24, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                editing ? 'Edit Place' : 'Add New Place',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: RideColors.dark,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                decoration: _decoration('Place name (e.g. San Jose Village)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _address,
                textCapitalization: TextCapitalization.words,
                decoration: _decoration('Address'),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final t in PlaceType.values)
                    ChoiceChip(
                      label: Text(t.label),
                      selected: _type == t,
                      onSelected: (_) => setState(() => _type = t),
                      selectedColor: t.bg,
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: _type == t ? t.color : const Color(0xFFE5E7EB),
                      ),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: _type == t ? t.color : RideColors.dark,
                      ),
                    ),
                ],
              ),
              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(
                  _error!,
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xFFE11D48)),
                ),
              ],
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F36F5),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    editing ? 'Save Changes' : 'Save Place',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
