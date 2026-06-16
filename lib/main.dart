import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:navbar/widgets/background_blob.dart';
import 'package:navbar/widgets/liquid_nav.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  void toggleTheme() => setState(() => isDark = !isDark);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.ibmPlexSansArabicTextTheme()),
      home: Scaffold(
        body: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              color: isDark ? Colors.black : const Color(0xFFE5E5EA),
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              top: -100,
              left: -100,
              child: BackgroundBlob(
                size: 400,
                color: isDark
                    ? const Color(0xFFBF5AF2)
                    : const Color(0xFFFF2A5F),
                opacity: isDark ? 0.5 : 0.7,
              ),
            ),
            Positioned(
              bottom: -100,
              right: -100,
              child: BackgroundBlob(
                size: 380,
                color: isDark
                    ? const Color(0xFF0A84FF)
                    : const Color(0xFF007AFF),
                opacity: isDark ? 0.5 : 0.7,
              ),
            ),
            Positioned(
              top: 200,
              left: 150,
              child: BackgroundBlob(
                size: 300,
                color: isDark
                    ? const Color(0xFFFF375F)
                    : const Color(0xFFFF9500),
                opacity: isDark ? 0.5 : 0.7,
              ),
            ),
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: LiquidNav(
                      isDark: isDark,
                      onToggleTheme: toggleTheme,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
