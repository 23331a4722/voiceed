import 'package:flutter/material.dart';
import 'package:voiceed/models/exam.dart';
import 'package:voiceed/screens/admin_panel.dart';
import 'package:voiceed/screens/exam_page.dart';
import 'package:voiceed/screens/landing_page.dart';
import 'package:voiceed/services/auth_service.dart';
import 'package:voiceed/services/exam_service.dart';
import 'package:voiceed/services/voice_service.dart';
import 'package:voiceed/theme.dart';
import 'package:voiceed/widgets/exam_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _authService = AuthService();
  final _examService = ExamService();
  final _voiceService = VoiceService();
  List<Exam> _exams = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _examService.initialize();
    final exams = await _examService.getAllExams();
    setState(() {
      _exams = exams;
      _isLoading = false;
    });
    
    final user = _authService.currentUser;
    await _voiceService.speak('Dashboard. Welcome ${user?.name}. ${_exams.length} exams available. Select an exam to begin.');
  }

  Future<void> _logout() async {
    await _authService.logout();
    await _voiceService.speak('Logged out successfully');
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LandingPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = _authService.currentUser;
    final isAdmin = _authService.isAdmin;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.surfaceSecondary,
      appBar: AppBar(
        title: const Text('VoiceEd Dashboard'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Container(
            margin: EdgeInsets.only(right: AppDimensions.spaceMD),
            child: IconButton(
              icon: Container(
                padding: EdgeInsets.all(AppDimensions.spaceSM),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: theme.colorScheme.error,
                  size: 20,
                ),
              ),
              onPressed: _logout,
              tooltip: 'Logout',
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width > 600 ? 48 : AppDimensions.spaceLG,
                  vertical: AppDimensions.spaceLG,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(AppDimensions.spaceLG),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.primary.withValues(alpha: 0.8),
                            theme.colorScheme.secondary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(alpha: 0.25),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Icon(
                              isAdmin ? Icons.admin_panel_settings_rounded : Icons.person_rounded,
                              size: 40,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          SizedBox(width: AppDimensions.spaceLG),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome Back!',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: AppDimensions.spaceSM),
                                Text(
                                  user?.name ?? '',
                                  style: theme.textTheme.headlineMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: AppDimensions.spaceSM),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppDimensions.spaceMD,
                                    vertical: AppDimensions.spaceSM,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
                                  ),
                                  child: Text(
                                    isAdmin ? 'Administrator' : 'Student',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: AppDimensions.spaceXL),
                    
                    // Stats Row (if applicable)
                    if (_exams.isNotEmpty) ...[
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              icon: Icons.quiz_rounded,
                              label: 'Available Exams',
                              value: '${_exams.length}',
                              color: theme.colorScheme.primary,
                              theme: theme,
                            ),
                          ),
                          SizedBox(width: AppDimensions.spaceMD),
                          Expanded(
                            child: _buildStatCard(
                              icon: Icons.access_time_rounded,
                              label: 'Total Duration',
                              value: '${_exams.fold(0, (sum, exam) => sum + exam.durationMinutes)} min',
                              color: theme.colorScheme.secondary,
                              theme: theme,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppDimensions.spaceXL),
                    ],
                    
                    // Section Header
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
                          ),
                        ),
                        SizedBox(width: AppDimensions.spaceMD),
                        Text(
                          'Available Exams',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.spaceLG),
                    
                    // Exams List
                    if (_exams.isEmpty)
                      _buildEmptyState(theme)
                    else
                      ..._exams.map((exam) => ExamCard(
                        exam: exam,
                        onTap: () {
                          _voiceService.stop();
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => ExamPage(exam: exam),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return SlideTransition(
                                  position: animation.drive(
                                    Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                                      .chain(CurveTween(curve: Curves.easeInOut)),
                                  ),
                                  child: child,
                                );
                              },
                              transitionDuration: const Duration(milliseconds: 300),
                            ),
                          );
                        },
                      )),
                  ],
                ),
              ),
            ),
      floatingActionButton: isAdmin
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: FloatingActionButton.extended(
                onPressed: () {
                  _voiceService.stop();
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const AdminPanel(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: animation.drive(
                            Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                              .chain(CurveTween(curve: Curves.easeInOut)),
                          ),
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  ).then((_) => _loadData());
                },
                icon: const Icon(Icons.admin_panel_settings_rounded),
                label: const Text('Admin Panel'),
                backgroundColor: theme.colorScheme.secondary,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
            )
          : null,
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required ThemeData theme,
  }) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spaceLG),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(
          color: color.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(AppDimensions.spaceMD),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(height: AppDimensions.spaceMD),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: AppDimensions.spaceSM),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.spaceXXL),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            ),
            child: Icon(
              Icons.quiz_outlined,
              size: 40,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: AppDimensions.spaceLG),
          Text(
            'No exams available',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppDimensions.spaceSM),
          Text(
            'Check back later or contact your administrator',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}