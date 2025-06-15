// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KontakDarurat extends StatefulWidget {
  const KontakDarurat({Key? key}) : super(key: key);

  @override
  State<KontakDarurat> createState() => _KontakDaruratState();
}

class _KontakDaruratState extends State<KontakDarurat>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _slideController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F0F23),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Modern App Bar
              _buildModernAppBar(),
              
              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Emergency Alert Card
                      _buildEmergencyAlert(),
                      
                      const SizedBox(height: 24),
                      
                      // Emergency Button (Main CTA)
                      _buildEmergencyButton(),
                      
                      const SizedBox(height: 20),
                      
                      // Contact Grid
                      _buildContactGrid(),
                      
                      const SizedBox(height: 24),
                      
                      // Evacuation Info
                      SlideTransition(
                        position: _slideAnimation,
                        child: _buildEvacuationCard(),
                      ),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Hapus Back Button
          // const SizedBox(width: 0), // Tidak perlu pengganti

          // Title with gradient
          Expanded(
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.white, Color(0xFFFF6B6B)],
              ).createShader(bounds),
              child: const Text(
                'Kontak Darurat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          // Emergency indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'SIAGA',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyAlert() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.red.withOpacity(0.15),
            Colors.orange.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.emergency_rounded,
                  color: Colors.red,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Situasi Darurat',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Segera hubungi kontak darurat di bawah ini jika terjadi bencana atau situasi emergency',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyButton() {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.heavyImpact();
          _showEmergencyDialog();
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              const Icon(
                Icons.phone_in_talk_rounded,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(height: 8),
              const Text(
                'HUBUNGI 112',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              Text(
                'Emergency Hotline',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildContactCard(
                'BPBD Yogya',
                '(0274) 555-0123',
                Icons.shield_rounded,
                const Color(0xFF667EEA),
                0,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildContactCard(
                'Pemadam',
                '(0274) 555-0456',
                Icons.local_fire_department_rounded,
                const Color(0xFFFF6B6B),
                100,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildContactCard(
                'Polisi',
                '110',
                Icons.local_police_rounded,
                const Color(0xFF4ECDC4),
                200,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildContactCard(
                'Share Lokasi',
                'Kirim koordinat',
                Icons.share_location_rounded,
                const Color(0xFF45B7D1),
                300,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    int delay,
  ) {
    return SlideTransition(
      position: _slideAnimation,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          _showContactDialog(title, subtitle);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.15),
                color.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEvacuationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF96DEDA).withOpacity(0.15),
            const Color(0xFF50C9C3).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF96DEDA).withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF96DEDA).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF96DEDA).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.place_rounded,
                  color: Color(0xFF96DEDA),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Lokasi Evakuasi Terdekat',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Balai Desa Sleman',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.directions_walk_rounded,
                      color: Color(0xFF96DEDA),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '800m dari lokasi Anda',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickAction(
                        'Rute',
                        Icons.directions_rounded,
                        const Color(0xFF96DEDA),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildQuickAction(
                        'Telepon',
                        Icons.phone_rounded,
                        const Color(0xFF50C9C3),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(String label, IconData icon, Color color) {
    return GestureDetector(
      onTap: () => HapticFeedback.lightImpact(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.phone, color: Colors.red),
            ),
            const SizedBox(width: 12),
            const Text(
              'Hubungi 112?',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: const Text(
          'Anda akan menghubungi layanan darurat nasional.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Add phone call functionality here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Hubungi'),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(String title, String contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Hubungi $title?',
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          contact,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Add contact functionality here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4ECDC4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Hubungi'),
          ),
        ],
      ),
    );
  }
}