// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CitySearchScreen extends StatefulWidget {
  const CitySearchScreen({super.key});

  @override
  State<CitySearchScreen> createState() => _CitySearchScreenState();
}

class _CitySearchScreenState extends State<CitySearchScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  final List<CityItem> allCities = [
    CityItem(name: "Cari lokasi", isSpecial: true, icon: Icons.location_on),
    CityItem(name: "Tangerang"),
    CityItem(name: "Jakarta"),
    CityItem(name: "Denpasar", isHighlighted: true),
    CityItem(name: "Yogyakarta", isHighlighted: true),
    CityItem(name: "Bandung"),
    CityItem(name: "Surabaya"),
    CityItem(name: "Balikpapan"),
    CityItem(name: "Mataram"),
    CityItem(name: "Kupang"),
    CityItem(name: "Jambi"),
    CityItem(name: "Medan"),
    CityItem(name: "Pekanbaru"),
    CityItem(name: "Palu"),
    CityItem(name: "Manado"),
    CityItem(name: "Padang"),
    CityItem(name: "Makasar"),
    CityItem(name: "Pontianak"),
    CityItem(name: "Banjarmasin"),
    CityItem(name: "Lampung"),
    CityItem(name: "Palembang"),
    CityItem(name: "Batam"),
  ];

  List<CityItem> filteredCities = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    filteredCities = allCities;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();

    // Auto focus search bar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _filterCities(String query) {
    setState(() {
      isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        filteredCities = allCities;
      } else {
        filteredCities =
            allCities
                .where(
                  (city) =>
                      city.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      }
    });
  }

  void _selectCity(CityItem city) async {
    if (city.isSpecial) {
      // Deteksi lokasi saat ini
      String? currentCity;
      // TODO: Implementasi deteksi lokasi, contoh sederhana:
      // currentCity = await getCurrentCityName(); // Fungsi ini perlu Anda buat
      // Untuk demo, misal hasilnya "Lokasi Saya"
      currentCity = "Lokasi Saya";
      Navigator.pop(context, currentCity);
    } else {
      Navigator.pop(context, city.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchSection(),
            Expanded(child: _buildCityGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.grey[700],
                  size: 20,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF3B82F6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: const Text(
                "Batal",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          onChanged: _filterCities,
          decoration: InputDecoration(
            hintText: "Cari kota...",
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Colors.grey[500],
              size: 22,
            ),
            suffixIcon:
                _searchController.text.isNotEmpty
                    ? GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        _filterCities('');
                      },
                      child: Icon(
                        Icons.clear_rounded,
                        color: Colors.grey[500],
                        size: 20,
                      ),
                    )
                    : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildCityGrid() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isSearching) ...[
              Text(
                "Kota populer",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
            ],
            Expanded(
              child:
                  filteredCities.isEmpty
                      ? _buildEmptyState()
                      : _buildCityChips(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityChips() {
    return SingleChildScrollView(
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children:
            filteredCities.asMap().entries.map((entry) {
              int index = entry.key;
              CityItem city = entry.value;

              return AnimatedContainer(
                duration: Duration(milliseconds: 200 + (index * 50)),
                curve: Curves.easeOutCubic,
                child: _buildCityChip(city),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildCityChip(CityItem city) {
    Color backgroundColor;
    Color textColor;
    Color borderColor;

    if (city.isSpecial) {
      backgroundColor = const Color(0xFF3B82F6);
      textColor = Colors.white;
      borderColor = const Color(0xFF3B82F6);
    } else if (city.isHighlighted) {
      backgroundColor = const Color(0xFFEBF8FF);
      textColor = const Color(0xFF3B82F6);
      borderColor = const Color(0xFF3B82F6);
    } else {
      backgroundColor = Colors.grey[100]!;
      textColor = Colors.grey[700]!;
      borderColor = Colors.grey[300]!;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _selectCity(city),
        borderRadius: BorderRadius.circular(25),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: borderColor, width: 1),
            boxShadow:
                city.isSpecial
                    ? [
                      BoxShadow(
                        color: const Color(0xFF3B82F6).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                    : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (city.icon != null) ...[
                Icon(city.icon, color: textColor, size: 18),
                const SizedBox(width: 6),
              ],
              Text(
                city.name,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight:
                      city.isSpecial ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 40,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Kota tidak ditemukan",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Coba kata kunci lain",
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

class CityItem {
  final String name;
  final bool isSpecial;
  final bool isHighlighted;
  final IconData? icon;

  CityItem({
    required this.name,
    this.isSpecial = false,
    this.isHighlighted = false,
    this.icon,
  });
}
