import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialRegistrationWidget extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onFacebookPressed;
  final VoidCallback? onApplePressed;

  const SocialRegistrationWidget({
    super.key,
    this.onGooglePressed,
    this.onFacebookPressed,
    this.onApplePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDivider(context),
        SizedBox(height: 3.h),
        _buildSocialButtons(context),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.5),
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'ou continue com',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.5),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButtons(BuildContext context) {
    return Column(
      children: [
        _buildGoogleButton(context),
        SizedBox(height: 2.h),
        _buildFacebookButton(context),
        if (Theme.of(context).platform == TargetPlatform.iOS) ...[
          SizedBox(height: 2.h),
          _buildAppleButton(context),
        ],
      ],
    );
  }

  Widget _buildGoogleButton(BuildContext context) {
    return OutlinedButton(
      onPressed:
          onGooglePressed ?? () => _handleSocialRegistration(context, 'Google'),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 3.5.h),
        side: BorderSide(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.5),
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageWidget(
            imageUrl:
                'https://developers.google.com/identity/images/g-logo.png',
            width: 5.w,
            height: 5.w,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 3.w),
          Text(
            'Continuar com Google',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacebookButton(BuildContext context) {
    return OutlinedButton(
      onPressed: onFacebookPressed ??
          () => _handleSocialRegistration(context, 'Facebook'),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 3.5.h),
        side: BorderSide(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.5),
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 5.w,
            height: 5.w,
            decoration: const BoxDecoration(
              color: Color(0xFF1877F2),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'facebook',
              color: Colors.white,
              size: 3.w,
            ),
          ),
          SizedBox(width: 3.w),
          Text(
            'Continuar com Facebook',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppleButton(BuildContext context) {
    return OutlinedButton(
      onPressed:
          onApplePressed ?? () => _handleSocialRegistration(context, 'Apple'),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 3.5.h),
        side: BorderSide(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.5),
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'apple',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Text(
            'Continuar com Apple',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _handleSocialRegistration(BuildContext context, String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Registro com $provider em desenvolvimento'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
