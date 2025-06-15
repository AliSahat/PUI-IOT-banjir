// ignore_for_file: unused_local_variable, deprecated_member_use, sized_box_for_whitespace, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with TickerProviderStateMixin {
  final List<Map<String, dynamic>> newsData = [
    {
      "title": "Banjir Bandang Terjang Kota Semarang",
      "description": "Hujan deras selama 3 hari menyebabkan banjir bandang yang merusak rumah warga dan infrastruktur di Semarang.",
      "category": "Darurat",
      "time": "2 jam lalu",
      "severity": "high",
      "readTime": "3 menit baca",
      "image": "🌊"
    },
    {
      "title": "Ketinggian Air di Bekasi Mencapai 1,5 Meter",
      "description": "Badan Penanggulangan Bencana Daerah (BPBD) menyatakan status siaga banjir setelah sungai Cileungsi meluap.",
      "category": "Siaga",
      "time": "4 jam lalu",
      "severity": "high",
      "readTime": "2 menit baca",
      "image": "🚨"
    },
    {
      "title": "Evakuasi Massal di Tangerang Akibat Banjir",
      "description": "Ratusan warga dievakuasi ke tempat pengungsian setelah air naik dengan cepat di permukiman padat penduduk.",
      "category": "Evakuasi",
      "time": "6 jam lalu",
      "severity": "high",
      "readTime": "4 menit baca",
      "image": "🏠"
    },
    {
      "title": "Banjir di Surabaya Lumpuhkan Akses Jalan",
      "description": "Beberapa jalan protokol tidak bisa dilalui kendaraan akibat genangan air setinggi lutut orang dewasa.",
      "category": "Transportasi",
      "time": "8 jam lalu",
      "severity": "medium",
      "readTime": "3 menit baca",
      "image": "🚗"
    },
    {
      "title": "BMKG Prediksi Cuaca Ekstrem Pekan Ini",
      "description": "BMKG memperkirakan curah hujan tinggi berpotensi menyebabkan banjir di beberapa wilayah Jawa dan Sumatera.",
      "category": "Prakiraan",
      "time": "12 jam lalu",
      "severity": "medium",
      "readTime": "5 menit baca",
      "image": "🌤️"
    },
    {
      "title": "Warga Klaten Gotong Royong Hadapi Banjir",
      "description": "Komunitas lokal di Klaten bergotong royong membangun tanggul darurat untuk menahan luapan air sungai.",
      "category": "Komunitas",
      "time": "1 hari lalu",
      "severity": "low",
      "readTime": "3 menit baca",
      "image": "🤝"
    },
    {
      "title": "Sekolah Ditutup Sementara Karena Banjir",
      "description": "Dinas Pendidikan menetapkan kebijakan belajar daring setelah beberapa sekolah terendam banjir.",
      "category": "Pendidikan",
      "time": "1 hari lalu",
      "severity": "medium",
      "readTime": "2 menit baca",
      "image": "🏫"
    },
    {
      "title": "Kerugian Akibat Banjir Capai 10 Miliar",
      "description": "Banjir yang melanda 5 kecamatan menyebabkan kerugian material yang cukup besar menurut laporan resmi.",
      "category": "Ekonomi",
      "time": "2 hari lalu",
      "severity": "medium",
      "readTime": "4 menit baca",
      "image": "💰"
    },
    {
      "title": "Relawan Salurkan Bantuan untuk Korban Banjir",
      "description": "Bantuan makanan, selimut, dan obat-obatan mulai disalurkan ke wilayah terdampak banjir sejak kemarin malam.",
      "category": "Bantuan",
      "time": "2 hari lalu",
      "severity": "low",
      "readTime": "3 menit baca",
      "image": "❤️"
    },
    {
      "title": "Sungai Bengawan Solo Meluap, Warga Siaga",
      "description": "Luapan air dari hulu Bengawan Solo membuat warga sekitar bantaran sungai mulai mengevakuasi barang berharga.",
      "category": "Siaga",
      "time": "3 hari lalu",
      "severity": "medium",
      "readTime": "3 menit baca",
      "image": "🌊"
    },
  ];

  List<Map<String, dynamic>> filteredNewsData = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _selectedCategory = "Semua";
  final List<String> _categories = ["Semua", "Darurat", "Siaga", "Evakuasi", "Transportasi", "Prakiraan", "Komunitas", "Pendidikan", "Ekonomi", "Bantuan"];

  @override
  void initState() {
    super.initState();
    filteredNewsData = List.from(newsData);
    _searchController.addListener(_filterNews);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _filterNews() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredNewsData = newsData.where((news) {
        final title = news["title"]?.toLowerCase() ?? '';
        final description = news["description"]?.toLowerCase() ?? '';
        final category = news["category"]?.toLowerCase() ?? '';
        
        final matchesQuery = title.contains(query) || description.contains(query);
        final matchesCategory = _selectedCategory == "Semua" || news["category"] == _selectedCategory;
        
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _filterNews();
    });
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'high':
        return const Color(0xFFFF6B6B);
      case 'medium':
        return const Color(0xFFFFD93D);
      case 'low':
        return const Color(0xFF6BCF7F);
      default:
        return const Color(0xFF64B5F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: CustomScrollView(
        slivers: [
          // Modern App Bar dengan Glassmorphism
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFF0A0E27).withOpacity(0.8),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1E3A8A).withOpacity(0.8),
                    const Color(0xFF0A0E27).withOpacity(0.9),
                  ],
                ),
              ),
              child: FlexibleSpaceBar(
                title: _isSearching 
                    ? null
                    : const Text(
                        "Flood News",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        ),
                      ),
                centerTitle: false,
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  icon: Icon(
                    _isSearching ? Icons.close_rounded : Icons.search_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _isSearching = !_isSearching;
                      if (!_isSearching) {
                        _searchController.clear();
                        _selectedCategory = "Semua";
                        filteredNewsData = List.from(newsData);
                      }
                    });
                  },
                ),
              ),
            ],
          ),

          // Search Bar
          if (_isSearching)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1D3A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Cari berita banjir...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    prefixIcon: Icon(Icons.search_rounded, color: Colors.white.withOpacity(0.5)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(20),
                  ),
                  cursorColor: const Color(0xFF64B5F6),
                ),
              ),
            ),

          // Category Filter
          SliverToBoxAdapter(
            child: Container(
              height: 50,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category == _selectedCategory;
                  
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        _filterByCategory(category);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: isSelected 
                              ? const LinearGradient(
                                  colors: [Color(0xFF64B5F6), Color(0xFF1E88E5)],
                                )
                              : null,
                          color: isSelected ? null : const Color(0xFF1A1D3A),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: isSelected 
                                ? Colors.transparent 
                                : Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // News List
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (filteredNewsData.isEmpty) {
                  return Container(
                    height: 300,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Tidak ada berita ditemukan",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final news = filteredNewsData[index];
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF1A1D3A).withOpacity(0.8),
                          const Color(0xFF0F1419).withOpacity(0.9),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          print("Baca berita: ${news['title']}");
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header dengan kategori dan waktu
                              Row(
                                children: [
                                  // Icon Emoji
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: _getSeverityColor(news["severity"]).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(
                                        news["image"],
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: _getSeverityColor(news["severity"]),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                news["category"],
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              news["time"],
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(0.5),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          news["readTime"],
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.4),
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Title
                              Text(
                                news["title"] ?? "No Title",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  height: 1.3,
                                ),
                              ),
                              
                              const SizedBox(height: 12),
                              
                              // Description
                              Text(
                                news["description"] ?? "No description",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 15,
                                  height: 1.5,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Action Button
                              Container(
                                width: double.infinity,
                                height: 48,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      _getSeverityColor(news["severity"]),
                                      _getSeverityColor(news["severity"]).withOpacity(0.8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getSeverityColor(news["severity"]).withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      print("Baca selengkapnya: ${news['title']}");
                                    },
                                    child: const Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Baca Selengkapnya",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.arrow_forward_rounded,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: filteredNewsData.isEmpty ? 1 : filteredNewsData.length,
            ),
          ),
          
          // Bottom Spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }
}