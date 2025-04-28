import 'package:flutter/material.dart';
import 'departments_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthtech_app/ai_track_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _plusZoomAnimation;
  late Animation<double> _fadeAnimation;
  bool _showTabs = false; // Controls tab visibility
  bool _isPressedTrack = false;
  bool _isPressedExpert = false;

  @override
  void initState() {
    super.initState();

    // Animation Controller (Runs for 2 seconds)
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    // Animation: "+" zooms in (scales up)
    _plusZoomAnimation = Tween<double>(begin: 1.0, end: 10.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Animation: Tabs fade in (0 to 1 opacity)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.6, 1.0, curve: Curves.easeIn)),
    );

    // Start Animation
    _controller.forward();

    // Show tabs after "+" animation completes
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _showTabs = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Dark Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.deepPurple.shade900, Colors.deepPurple.shade800],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Animated "+", which zooms in
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _plusZoomAnimation.value,
                child: Text(
                  "+", // The "+" symbol
                  style: GoogleFonts.montserrat(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 20, color: Colors.cyanAccent)],
                  ),
                ),
              );
            },
          ),

          // Logo (Shifted slightly up)
          Positioned(
            top: 50, // Adjusted from 80 to 50 to move it up
            child: Image.asset(
              "assets/images/logo.png",
              width: 400,
              height: 400,
            ),
          ),

          // Fade-in Tabs after "+" animation
          if (_showTabs)
            FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 350), // Adjusted for spacing

                  // Buttons Row inside a Scrollable View
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // AI Track Button with Press Effect
                          GestureDetector(
                            onTapDown: (_) => setState(() => _isPressedTrack = true), // Button pressed
                            onTapUp: (_) {
                              setState(() => _isPressedTrack = false); // Button released
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => AITrackScreen(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(opacity: animation, child: child);
                                  },
                                ),
                              );
                            },
                            onTapCancel: () => setState(() => _isPressedTrack = false), // Press canceled
                            child: AnimatedScale(
                              scale: _isPressedTrack ? 0.95 : 1.0, // Button shrinks slightly when pressed
                              duration: Duration(milliseconds: 100),
                              child: _buildNeonTab(
                                context,
                                text: "AI Assistance",
                                icon: Icons.health_and_safety,
                              ),
                            ),
                          ),

                          SizedBox(width: 15),

                          // Connect with an Expert Button with Press Effect
                          GestureDetector(
                            onTapDown: (_) => setState(() => _isPressedExpert = true),
                            onTapUp: (_) {
                              setState(() => _isPressedExpert = false);
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => DepartmentsScreen(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(opacity: animation, child: child);
                                  },
                                ),
                              );
                            },
                            onTapCancel: () => setState(() => _isPressedExpert = false),
                            child: AnimatedScale(
                              scale: _isPressedExpert ? 0.95 : 1.0,
                              duration: Duration(milliseconds: 100),
                              child: _buildNeonTab(
                                context,
                                text: "Expert Assistance",
                                icon: Icons.support_agent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Neon Tab Widget
  Widget _buildNeonTab(BuildContext context, {required String text, required IconData icon}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.width * 0.2,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.blueAccent, blurRadius: 20, spreadRadius: 2),
          BoxShadow(color: Colors.cyanAccent.withOpacity(0.3), blurRadius: 30, spreadRadius: 10),
        ],
        border: Border.all(color: Colors.blueAccent, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 22),
          SizedBox(height: 5),
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(blurRadius: 10, color: Colors.cyanAccent, offset: Offset(0, 0)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}