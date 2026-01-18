import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:intl/intl.dart';

// FIREBASE IMPORTS
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// CUSTOM WIDGETS & SCREENS IMPORTS
import 'widgets/location_picker.dart';
import 'widgets/date_picker.dart';
import 'widgets/guest_picker.dart';
import 'widgets/sort_bottom_sheet.dart';
import 'widgets/filter_bottom_sheet.dart';
import 'screens/hotel_details_screen.dart';

// ==============================
// 1. Constants & Theme Configuration
// ==============================

class AppColors {
  static const Color primaryBlue = Color(0xFF0D2E6B);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF828282);
  static const Color inputBorder = Color(0xFFE0E0E0);
  static const Color inputFill = Color(0xFFF8F9FA);
  static const Color successGreen = Color(0xFF27AE60);
  static const Color errorRed = Color(0xFFEB5757);

  static const Color backgroundGrey = Color(0xFFF5F5F5);
  static const Color cardShadow = Color(0x1F000000);
}

ThemeData buildAppTheme() {
  final base = ThemeData.light();
  return base.copyWith(
    primaryColor: AppColors.primaryBlue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      titleTextStyle: GoogleFonts.poppins(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).copyWith(
      headlineSmall: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: AppColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        color: AppColors.textSecondary,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        disabledBackgroundColor: AppColors.primaryBlue.withOpacity(0.5),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputFill,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
      ),
      hintStyle: GoogleFonts.poppins(color: AppColors.textSecondary),
    ),
  );
}

// ==============================
// 2. Main Entry Point & Routing
// ==============================

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        // PASTE YOUR ACTUAL KEYS HERE
        apiKey: "PASTE_YOUR_API_KEY_HERE",
        appId: "PASTE_YOUR_APP_ID_HERE",
        messagingSenderId: "PASTE_YOUR_SENDER_ID_HERE",
        projectId: "PASTE_YOUR_PROJECT_ID_HERE",
        storageBucket: "PASTE_YOUR_PROJECT_ID_HERE.appspot.com",
      ),
    );
  } catch (e) {
    print("Firebase init error (or already initialized): $e");
  }

  runApp(const BookNStayApp());
}

class BookNStayApp extends StatelessWidget {
  const BookNStayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookNStay',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/complete_profile': (context) => const CompleteProfileScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

// ==============================
// 3. Reusable Widgets
// ==============================

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData prefixIcon;
  final bool isPassword;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.isPassword = false,
    this.keyboardType,
    this.suffixIcon,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(prefixIcon, color: AppColors.textSecondary),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}

// ==============================
// 4. Auth & Onboarding Screens
// ==============================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(padding: const EdgeInsets.all(30), decoration: BoxDecoration(color: AppColors.primaryBlue.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.bed_rounded, size: 60, color: AppColors.primaryBlue)),
            const SizedBox(height: 24),
            Text('bookNStay', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 40),
            SizedBox(width: 100, child: ClipRRect(borderRadius: BorderRadius.circular(10), child: const LinearProgressIndicator(minHeight: 6, color: AppColors.primaryBlue, backgroundColor: AppColors.inputFill))),
          ],
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}
class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<Map<String, dynamic>> onboardingData = [
    {"image": Icons.lock_outline_rounded, "title": "Secure & Easy Booking", "desc": "Experience lightning-fast reservations."},
    {"image": Icons.map_outlined, "title": "Discover Amazing Hotels", "desc": "Explore thousands of hotels across the globe."},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(alignment: Alignment.topRight, child: TextButton(onPressed: () => Navigator.pushReplacementNamed(context, '/login'), child: const Text("Skip", style: TextStyle(color: AppColors.textSecondary)))),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(height: 250, decoration: BoxDecoration(color: AppColors.inputFill, borderRadius: BorderRadius.circular(20)), child: Center(child: Icon(onboardingData[index]['image'], size: 100, color: AppColors.primaryBlue))),
                      const SizedBox(height: 40),
                      Text(onboardingData[index]['title'], style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      Text(onboardingData[index]['desc'], textAlign: TextAlign.center),
                    ]),
                  );
                },
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(onboardingData.length, (index) => AnimatedContainer(duration: const Duration(milliseconds: 300), margin: const EdgeInsets.only(right: 8), height: 8, width: _currentPage == index ? 24 : 8, decoration: BoxDecoration(color: _currentPage == index ? AppColors.primaryBlue : AppColors.inputBorder, borderRadius: BorderRadius.circular(4))))),
            const SizedBox(height: 32),
            Padding(padding: const EdgeInsets.all(24.0), child: ElevatedButton(onPressed: () { if (_currentPage == onboardingData.length - 1) { Navigator.pushReplacementNamed(context, '/login'); } else { _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn); }}, child: Text(_currentPage == onboardingData.length - 1 ? "GET STARTED" : "NEXT"))),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim());
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? "Login Failed"), backgroundColor: AppColors.errorRed));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.eco_rounded, size: 60, color: AppColors.primaryBlue),
            const SizedBox(height: 24),
            Text("Welcome Back! 👋", style: Theme.of(context).textTheme.headlineSmall),
            const Text("Login to your account to continue"),
            const SizedBox(height: 40),
            CustomTextField(controller: _emailController, label: "Email Address", hint: "Enter your email", prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 24),
            CustomTextField(controller: _passwordController, label: "Password", hint: "Enter your password", prefixIcon: Icons.lock_outline, isPassword: !_isPasswordVisible, suffixIcon: IconButton(icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: AppColors.textSecondary), onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible))),
            Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () => Navigator.pushNamed(context, '/forgot_password'), child: const Text("Forgot Password?", style: TextStyle(color: AppColors.textSecondary)))),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _isLoading ? null : _login, child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text("LOGIN")),
            const SizedBox(height: 32),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Text("Don't have an account? "), GestureDetector(onTap: () => Navigator.pushNamed(context, '/register'), child: Text("Sign Up", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primaryBlue)))]),
          ],
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreedToTerms = false;
  bool _isLoading = false;
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasNumber = false;

  void _updatePasswordValidation(String password) {
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasNumber = password.contains(RegExp(r'[0-9]'));
    });
  }

  Future<void> _register() async {
    if (_passController.text != _confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text.trim(), password: _passController.text.trim());
      if (mounted) Navigator.pushReplacementNamed(context, '/complete_profile');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? "Registration Error"), backgroundColor: AppColors.errorRed));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildValidationTick(bool isValid, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(children: [Icon(isValid ? Icons.check_circle : Icons.radio_button_unchecked, color: isValid ? AppColors.successGreen : AppColors.textSecondary, size: 16), const SizedBox(width: 8), Text(text, style: TextStyle(color: isValid ? AppColors.textPrimary : AppColors.textSecondary, fontSize: 12))]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(controller: _emailController, label: "Email", hint: "Email Address", prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 20),
            Text("Password", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passController,
              obscureText: !_isPasswordVisible,
              onChanged: _updatePasswordValidation,
              decoration: InputDecoration(
                hintText: "Password",
                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
                suffixIcon: IconButton(icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: AppColors.textSecondary), onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible)),
              ),
            ),
            const SizedBox(height: 12),
            _buildValidationTick(_hasMinLength, "At least 8 characters"),
            _buildValidationTick(_hasUppercase, "One uppercase letter"),
            _buildValidationTick(_hasNumber, "One number"),
            const SizedBox(height: 20),
            CustomTextField(controller: _confirmPassController, label: "Confirm Password", hint: "Confirm Password", prefixIcon: Icons.lock_outline, isPassword: !_isConfirmPasswordVisible, suffixIcon: IconButton(icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off, color: AppColors.textSecondary), onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible))),
            const SizedBox(height: 24),
            Row(children: [Checkbox(value: _agreedToTerms, activeColor: AppColors.primaryBlue, onChanged: (value) => setState(() => _agreedToTerms = value!)), Expanded(child: RichText(text: TextSpan(style: TextStyle(color: AppColors.textSecondary, fontFamily: GoogleFonts.poppins().fontFamily), children: [const TextSpan(text: "I agree to the "), TextSpan(text: "Terms of Service", style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)), const TextSpan(text: " and "), TextSpan(text: "Privacy Policy", style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold))])))]),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: (_agreedToTerms && !_isLoading) ? _register : null, child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text("CREATE ACCOUNT")),
            const SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Text("Already have an account? "), GestureDetector(onTap: () => Navigator.pushNamed(context, '/login'), child: Text("Login", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primaryBlue)))]),
          ],
        ),
      ),
    );
  }
}

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});
  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}
class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  String _selectedCountryCode = "+60";

  Future<void> _saveProfile() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill in all fields")));
      return;
    }
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No user found. Please login again.");
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'fullName': _nameController.text.trim(),
        'email': user.email,
        'phoneNumber': "$_selectedCountryCode ${_phoneController.text.trim()}",
        'createdAt': FieldValue.serverTimestamp(),
      });
      await user.updateDisplayName(_nameController.text.trim());
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error saving profile: $e"), backgroundColor: AppColors.errorRed));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showCountryPicker() {
    showModalBottomSheet(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), builder: (context) { return DraggableScrollableSheet(initialChildSize: 0.5, minChildSize: 0.3, maxChildSize: 0.8, expand: false, builder: (_, controller) { return ListView(controller: controller, padding: const EdgeInsets.all(16), children: [const Padding(padding: EdgeInsets.only(bottom: 16), child: Text("Select Country", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))), ListTile(leading: const Text("🇺🇸", style: TextStyle(fontSize: 24)), title: const Text("United States"), trailing: const Text("+1"), onTap: () { setState(() => _selectedCountryCode = "+1"); Navigator.pop(context); }), ListTile(leading: const Text("🇲🇾", style: TextStyle(fontSize: 24)), title: const Text("Malaysia"), trailing: const Text("+60"), onTap: () { setState(() => _selectedCountryCode = "+60"); Navigator.pop(context); })]); }); });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(title: const Text("Complete Profile"), centerTitle: true, automaticallyImplyLeading: false),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Just a few more details to get you started.", style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 30),
              CustomTextField(controller: _nameController, label: "Full Name", hint: "Enter your full name", prefixIcon: Icons.person_outline),
              const SizedBox(height: 24),
              Text("Phone Number", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(children: [GestureDetector(onTap: _showCountryPicker, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16), decoration: BoxDecoration(color: AppColors.inputFill, border: Border.all(color: AppColors.inputBorder), borderRadius: BorderRadius.circular(12)), child: Row(children: [Text(_selectedCountryCode), const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary)]))), const SizedBox(width: 12), Expanded(child: TextFormField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(hintText: "123 456 789", prefixIcon: Icon(Icons.phone_outlined, color: AppColors.textSecondary))))]),
              const SizedBox(height: 40),
              ElevatedButton(onPressed: _isLoading ? null : _saveProfile, child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text("FINISH SETUP")),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}
class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) return;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Reset link sent! Check your email.")));
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error sending email.")));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop())),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.lock_reset_outlined, size: 80, color: AppColors.primaryBlue),
            const SizedBox(height: 24),
            Text("Reset Your Password", style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            const Text("Enter your email address and we'll send you instructions to reset your password.", textAlign: TextAlign.center),
            const SizedBox(height: 40),
            CustomTextField(controller: _emailController, label: "Email", hint: "example@email.com", prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _resetPassword, child: const Text("SEND RESET LINK")),
          ],
        ),
      ),
    );
  }
}

// ==============================
// 5. MAIN APP SCAFFOLD (Bottom Nav)
// ==============================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeTab(),
    const ExploreTab(),
    const Center(child: Text("Saved (Coming Soon)")),
    const Center(child: Text("Bookings (Coming Soon)")),
    const ProfileTab(), // UPDATED: Now points to ProfileTab
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.textSecondary,
        showUnselectedLabels: true,
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 10),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Saved"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: "Bookings"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}

// ==============================
// 6. TAB 1: HOME PAGE
// ==============================

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String? firstName;
  // STATE VARIABLES FOR SEARCH
  String _selectedLocation = "Select Location";
  DateTime? _startDate;
  DateTime? _endDate;

  List<GuestData> _guestDataList = [GuestData(adults: 2, children: 0)];

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _startDate = DateTime.now();
    _endDate = DateTime.now().add(const Duration(days: 1));
  }

  Future<void> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        setState(() => firstName = user.displayName!.split(" ")[0]);
      } else {
        try {
          final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
          if (doc.exists && mounted) {
            String fullName = doc.data()?['fullName'] ?? "Traveler";
            setState(() => firstName = fullName.split(" ")[0]);
          }
        } catch (e) {
          // Ignore
        }
      }
    }
  }

  // --- HELPERS FOR POP-UPS ---
  String _formatDateShort(DateTime? date) {
    if (date == null) return "Select Date";
    return DateFormat('MMM dd').format(date);
  }

  String _getGuestSummary() {
    int totalGuests = 0;
    for (var room in _guestDataList) {
      totalGuests += room.adults + room.children;
    }
    int totalRooms = _guestDataList.length;
    return "$totalGuests Guests, $totalRooms Room${totalRooms > 1 ? 's' : ''}";
  }

  Future<void> _openLocationPicker() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LocationPicker(),
    );
    if (result != null) {
      setState(() => _selectedLocation = result);
    }
  }

  Future<void> _openDatePicker() async {
    final result = await showModalBottomSheet<List<DateTime>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DatePicker(initialStartDate: _startDate, initialEndDate: _endDate),
    );
    if (result != null && result.length == 2) {
      setState(() {
        _startDate = result[0];
        _endDate = result[1];
      });
    }
  }

  Future<void> _openGuestPicker() async {
    final result = await showModalBottomSheet<List<GuestData>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GuestPicker(initialData: _guestDataList),
    );
    if (result != null) {
      setState(() => _guestDataList = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Current Location", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: AppColors.primaryBlue, size: 16),
                        const SizedBox(width: 4),
                        Text("Kuala Lumpur, MY", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        const Icon(Icons.keyboard_arrow_down, size: 16),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    // NOTIFICATION BUTTON
                    IconButton(
                      icon: const Icon(Icons.notifications_none),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen()));
                      },
                    ),
                    const CircleAvatar(backgroundColor: AppColors.inputBorder, child: Icon(Icons.person, color: Colors.white)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),

            // GREETING
            Text("Hi, ${firstName ?? 'Traveler'}! 👋", style: Theme.of(context).textTheme.headlineSmall),
            const Text("Where would you like to stay?", style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
            const SizedBox(height: 20),

            // SEARCH CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4))],
              ),
              child: Column(
                children: [
                  _buildSearchField(Icons.location_on_outlined, "Destination", _selectedLocation, onTap: _openLocationPicker),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildSearchField(Icons.calendar_today, "Check-in", _formatDateShort(_startDate), onTap: _openDatePicker)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildSearchField(Icons.calendar_today, "Check-out", _formatDateShort(_endDate), onTap: _openDatePicker)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildSearchField(Icons.people_outline, "Guests & Rooms", _getGuestSummary(), onTap: _openGuestPicker),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final bottomNav = context.findAncestorStateOfType<_HomeScreenState>();
                      bottomNav?.setState(() => bottomNav._currentIndex = 1);
                    },
                    child: const Text("SEARCH HOTELS"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // RECENT SEARCHES
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Recent Searches", style: Theme.of(context).textTheme.titleMedium),
                const Text("Clear", style: TextStyle(color: AppColors.primaryBlue, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildRecentChip("KL Sentral", "Dec 10-12"),
                  _buildRecentChip("Penang", "Jan 05-07"),
                  _buildRecentChip("Langkawi", "Feb 14-16"),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // POPULAR DESTINATIONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Popular Destinations", style: Theme.of(context).textTheme.titleMedium),
                const Text("See All", style: TextStyle(color: AppColors.primaryBlue, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildDestinationCard("Penang", "240+ Hotels", "https://images.unsplash.com/photo-1596422846543-75c6fc197f07?q=80&w=200&auto=format&fit=crop"),
                  _buildDestinationCard("Bali", "450+ Hotels", "https://images.unsplash.com/photo-1537996194471-e657df975ab4?q=80&w=200&auto=format&fit=crop"),
                  _buildDestinationCard("Bangkok", "320+ Hotels", "https://images.unsplash.com/photo-1508009603885-50cf7c579365?q=80&w=200&auto=format&fit=crop"),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // BANNER
            Container(
              width: double.infinity,
              height: 140,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF0D2E6B), Color(0xFF1A4595)]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                          child: const Text("LIMITED TIME", style: TextStyle(color: Colors.white, fontSize: 10)),
                        ),
                        const SizedBox(height: 8),
                        const Text("YEAR END\nSALE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, height: 1.1)),
                        const Text("Up to 50% Off", style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                  Container(
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: NetworkImage("https://images.unsplash.com/photo-1571896349842-6e53ce41e887?q=80&w=200"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(IconData icon, String label, String value, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.inputFill, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(icon, size: 16, color: AppColors.primaryBlue),
                const SizedBox(width: 8),
                Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14), overflow: TextOverflow.ellipsis)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRecentChip(String label, String dates) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.inputBorder)),
      child: Row(
        children: [
          const Icon(Icons.history, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              Text(dates, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationCard(String name, String count, String imgUrl) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 140,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: NetworkImage(imgUrl), fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.7)]),
        ),
        padding: const EdgeInsets.all(12),
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            Text(count, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// ==============================
// 7. TAB 2: EXPLORE PAGE
// ==============================

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  String _currentSort = "Recommended";
  FilterData _filterData = FilterData();

  void _showSortBottomSheet() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SortByBottomSheet(currentSort: _currentSort),
    );

    if (result != null) {
      setState(() {
        _currentSort = result;
      });
      print("Sorting by: $_currentSort");
    }
  }

  void _showFilterBottomSheet() async {
    final result = await showModalBottomSheet<FilterData>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(initialData: _filterData),
    );

    if (result != null) {
      setState(() {
        _filterData = result;
      });
      print("Filters applied: Price: ${_filterData.priceRange}, Stars: ${_filterData.starRating}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: Column(
          children: [
            const Text("Kuala Lumpur",
                style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
            Text("Dec 15-18 • 2 Adults, 1 Room", style: TextStyle(color: Colors.grey[600], fontSize: 10)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.map_outlined, color: AppColors.primaryBlue), onPressed: () {}),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search hotels...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: _showFilterBottomSheet,
                ),
                fillColor: AppColors.inputFill,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // FILTERS
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip("Sort", true, onTap: _showSortBottomSheet),
                          _buildFilterChip("Price", true),
                          _buildFilterChip("Stars", true),
                          _buildFilterChip("More", true),
                        ],
                      ),
                    )),
              ],
            ),
          ),

          // TOGGLE PARTNER
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: AppColors.inputFill, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]),
                          child: const Center(
                              child: Text("Partner Hotels",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryBlue))))),
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Center(
                              child: Text("All", style: TextStyle(fontSize: 12, color: AppColors.textSecondary))))),
                ],
              ),
            ),
          ),

          // HOTEL LIST
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text("245 hotels found", style: TextStyle(fontSize: 12, color: AppColors.textSecondary))),
                _buildHotelCard(
                    "Grand Hyatt Kuala Lumpur",
                    "City Centre, Kuala Lumpur • 0.5 km to center",
                    "RM 360",
                    "4.8",
                    "https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=600",
                    ["Free WiFi", "Pool", "Spa"],
                    isDiscounted: true),
                _buildHotelCard(
                  "EQ Kuala Lumpur",
                  "Golden Triangle, Kuala Lumpur",
                  "RM 520",
                  "4.5",
                  "https://images.unsplash.com/photo-1582719508461-905c673771fd?q=80&w=600",
                  ["Free WiFi", "Gym"],
                ),
                _buildHotelCard(
                    "Pavilion Hotel Kuala Lumpur",
                    "Bukit Bintang, Kuala Lumpur",
                    "RM 467",
                    "4.7",
                    "https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?q=80&w=600",
                    ["Pool", "Dining"],
                    isDiscounted: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool showDropdown, {VoidCallback? onTap}) {
    bool isActive = label == "Sort" && _currentSort != "Recommended";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.inputBorder),
          borderRadius: BorderRadius.circular(20),
          color: isActive ? AppColors.primaryBlue.withOpacity(0.1) : Colors.white,
        ),
        child: Row(
          children: [
            Text(isActive ? _currentSort : label,
                style: TextStyle(
                  fontSize: 12,
                  color: isActive ? AppColors.primaryBlue : AppColors.textPrimary,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                )),
            if (showDropdown) ...[
              const SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down,
                  size: 16, color: isActive ? AppColors.primaryBlue : AppColors.textSecondary)
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildHotelCard(String name, String loc, String price, String rating, String imgUrl, List<String> tags,
      {bool isDiscounted = false}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HotelDetailsScreen(
              hotelName: name,
              location: loc,
              price: price,
              rating: rating,
              imageUrl: imgUrl,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 4))]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(imgUrl, height: 180, width: double.infinity, fit: BoxFit.cover),
                ),
                Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                        child: const Icon(Icons.favorite_border, color: Colors.white, size: 20))),
                if (isDiscounted)
                  Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              color: AppColors.primaryBlue, borderRadius: BorderRadius.circular(4)),
                          child: const Text("PARTNER",
                              style:
                              TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)))),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              overflow: TextOverflow.ellipsis)),
                      Row(children: [
                        const Icon(Icons.star, color: AppColors.successGreen, size: 14),
                        Text(rating,
                            style:
                            const TextStyle(color: AppColors.successGreen, fontWeight: FontWeight.bold, fontSize: 12))
                      ]),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                          child: Text(loc,
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                              overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                      children: tags
                          .map((t) => Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              color: AppColors.inputFill, borderRadius: BorderRadius.circular(4)),
                          child: Text(t,
                              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary))))
                          .toList()),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (isDiscounted)
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                                color: AppColors.errorRed.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4)),
                            child: const Text("20% OFF",
                                style:
                                TextStyle(color: AppColors.errorRed, fontSize: 10, fontWeight: FontWeight.bold))),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: price,
                                style:
                                const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
                            const TextSpan(
                                text: " / night", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ==============================
// 8. TAB 5: PROFILE PAGE
// ==============================

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  User? _user;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() => _user = user);
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists && mounted) {
          setState(() => _userData = doc.data());
        }
      } catch (e) {
        print("Error fetching profile: $e");
      }
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error logging out: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4))],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.inputFill,
                    child: Text(
                      _userData?['fullName']?[0] ?? _user?.displayName?[0] ?? "U",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userData?['fullName'] ?? _user?.displayName ?? "User",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _user?.email ?? "",
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                        if (_userData?['phoneNumber'] != null)
                          Text(
                            _userData!['phoneNumber'],
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.edit_outlined, color: AppColors.primaryBlue), onPressed: () {}),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildProfileOption(Icons.person_outline, "Personal Information"),
            _buildProfileOption(Icons.payment_outlined, "Payment Methods"),
            _buildProfileOption(Icons.history, "Booking History"),
            _buildProfileOption(Icons.settings_outlined, "Settings"),
            _buildProfileOption(Icons.help_outline, "Help & Support"),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFEBEB),
                  foregroundColor: AppColors.errorRed,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.logout),
                label: const Text("LOGOUT"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.inputFill, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: AppColors.primaryBlue, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
        onTap: () {},
      ),
    );
  }
}

// ==============================
// 9. NOTIFICATION PAGE
// ==============================

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text("Notifications", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildSectionHeader("TODAY"),
                _buildNotificationItem(
                  icon: Icons.celebration,
                  iconColor: const Color(0xFF2F80ED),
                  bgColor: const Color(0xFFEBF2FF),
                  title: "Booking Confirmed",
                  desc: "You successfully booked The Grand Hotel for 3 nights. Check your email for details.",
                  time: "2m ago",
                  isUnread: true,
                ),
                _buildNotificationItem(
                  icon: Icons.local_fire_department,
                  iconColor: const Color(0xFFEB5757),
                  bgColor: const Color(0xFFFFEBEB),
                  title: "50% Flash Sale!",
                  desc: "Get 50% off on all bookings today! Offer ends at midnight.",
                  time: "1h ago",
                  isUnread: false,
                ),
                const SizedBox(height: 24),
                _buildSectionHeader("YESTERDAY"),
                _buildNotificationItem(
                  icon: Icons.schedule,
                  iconColor: const Color(0xFFF2994A),
                  bgColor: const Color(0xFFFFF5EB),
                  title: "Check-in Reminder",
                  desc: "Don't forget your check-in at Ocean View Resort is tomorrow at 2:00 PM.",
                  time: "1d ago",
                  isUnread: false,
                ),
                _buildNotificationItem(
                  icon: Icons.chat_bubble_outline,
                  iconColor: const Color(0xFF9B51E0),
                  bgColor: const Color(0xFFF4EBFF),
                  title: "New Message",
                  desc: "Concierge: \"Hello! We have prepared your room request.\"",
                  time: "1d ago",
                  isUnread: false,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.backgroundGrey,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                side: const BorderSide(color: AppColors.inputBorder),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                backgroundColor: Colors.transparent,
              ),
              child: const Text("Mark All as Read", style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String desc,
    required String time,
    required bool isUnread,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Row(
                      children: [
                        Text(time, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                        if (isUnread) ...[
                          const SizedBox(width: 8),
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primaryBlue, shape: BoxShape.circle)),
                        ]
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}