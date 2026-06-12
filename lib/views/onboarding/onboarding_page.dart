import 'package:app_pengaduan/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:app_pengaduan/views/auth/login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Pantau Progres Laporan",
      "description": "Kirim pengaduan dan pantau status penanganannya secara real-time hingga selesai.",
      "image": "assets/images/foto_dummy_2.jpg",
      "tag": "PENGADUAN DIGITAL"
    },
    {
      "title": "Layanan Publik Terpadu",
      "description": "Akses berbagai layanan publik mulai dari informasi hingga pengaduan dalam satu aplikasi.",
      "image": "assets/images/foto_dummy_3.png",
      "tag": "LAYANAN TERPADU"
    },
    {
      "title": "Konsultasi Ahli",
      "description": "Konsultasikan masalah keluarga, psikologi, atau parenting langsung dengan ahlinya secara aman.",
      "image": "assets/images/konsultasi_psikolog.png",
      "tag": "KONSULTASI ONLINE"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  return OnboardingContent(
                    title: onboardingData[index]["title"]!,
                    description: onboardingData[index]["description"]!,
                    imageType: onboardingData[index]["image"]!,
                    tag: onboardingData[index]["tag"]!,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingData.length,
                      (index) => buildDot(index: index),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage == onboardingData.length - 1) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      }
                    },
                    child: Text(
                      _currentPage == onboardingData.length - 1 ? "Mulai Sekarang \u2192" : "Lanjut \u2192",
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_currentPage != onboardingData.length - 1)
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text("Lewati", style: TextStyle(color: AppTheme.textSecondary)),
                    )
                  else
                    const SizedBox(height: 48), // Spacer to keep layout stable
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? AppTheme.primary : const Color(0xFFD1D5DB),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    super.key,
    required this.title,
    required this.description,
    required this.imageType,
    required this.tag,
  });

  final String title, description, imageType, tag;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Mockup Graphic Area
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.primaryLight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.primaryLight.withOpacity(0.2)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    imageType,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.verified, color: AppTheme.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          tag,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
