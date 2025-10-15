import 'package:flutter/material.dart';
import 'package:voiceed/models/user.dart';
import 'package:voiceed/screens/dashboard_page.dart';
import 'package:voiceed/services/auth_service.dart';
import 'package:voiceed/services/voice_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  final _voiceService = VoiceService();
  UserRole _selectedRole = UserRole.student;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _voiceService.speak('Register page. Enter your details and select your role as student or admin.');
  }

  Future<void> _register() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showMessage('Please fill all fields');
      return;
    }

    setState(() => _isLoading = true);
    final user = await _authService.register(_nameController.text, _emailController.text, _passwordController.text, _selectedRole);
    setState(() => _isLoading = false);

    if (user != null && mounted) {
      await _voiceService.speak('Registration successful. Welcome ${user.name}');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardPage()));
    } else {
      _showMessage('Email already exists');
    }
  }

  void _showMessage(String message) {
    _voiceService.speak(message);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Register', style: theme.textTheme.titleLarge), centerTitle: true),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [theme.colorScheme.primary.withValues(alpha: 0.1), theme.colorScheme.surface],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_add, size: 80, color: theme.colorScheme.primary),
                  const SizedBox(height: 32),
                  Text('Create Account', style: theme.textTheme.headlineMedium?.copyWith(color: theme.colorScheme.primary)),
                  const SizedBox(height: 48),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                    ),
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                    ),
                    obscureText: true,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Select Role', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<UserRole>(
                                title: const Text('Student'),
                                value: UserRole.student,
                                groupValue: _selectedRole,
                                onChanged: (value) => setState(() => _selectedRole = value!),
                                activeColor: theme.colorScheme.primary,
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<UserRole>(
                                title: const Text('Admin'),
                                value: UserRole.admin,
                                groupValue: _selectedRole,
                                onChanged: (value) => setState(() => _selectedRole = value!),
                                activeColor: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text('Register', style: theme.textTheme.titleLarge?.copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
