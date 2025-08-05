import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/registration_form_widget.dart';
import './widgets/social_registration_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 4.h),
                    _buildWelcomeSection(context),
                    SizedBox(height: 4.h),
                    RegistrationFormWidget(
                      onRegistrationSuccess: _handleRegistrationSuccess,
                    ),
                    SizedBox(height: 4.h),
                    const SocialRegistrationWidget(),
                    SizedBox(height: 3.h),
                    _buildLoginRedirect(context),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
            tooltip: 'Fechar',
          ),
          Expanded(
            child: Text(
              'Criar Conta',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 12.w), // Balance the close button
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Column(
      children: [
        _buildLogo(context),
        SizedBox(height: 3.h),
        Text(
          'Bem-vindo ao LinguaLearn',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 1.h),
        Text(
          'Crie sua conta e comece sua jornada de aprendizado de idiomas',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CustomIconWidget(
        iconName: 'school',
        color: AppTheme.lightTheme.colorScheme.onPrimary,
        size: 10.w,
      ),
    );
  }

  Widget _buildLoginRedirect(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Já tem uma conta? ',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text(
            'Fazer login',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  void _handleRegistrationSuccess() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/language-selection-screen',
      (route) => false,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
