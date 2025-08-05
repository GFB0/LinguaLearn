import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegistrationFormWidget extends StatefulWidget {
  final VoidCallback? onRegistrationSuccess;

  const RegistrationFormWidget({
    super.key,
    this.onRegistrationSuccess,
  });

  @override
  State<RegistrationFormWidget> createState() => _RegistrationFormWidgetState();
}

class _RegistrationFormWidgetState extends State<RegistrationFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _acceptTerms = false;
  bool _isUnder18 = false;
  bool _showOptionalFields = false;

  // Validation states
  bool _isEmailValid = false;
  double _passwordStrength = 0.0;
  bool _passwordsMatch = false;

  @override
  void initState() {
    super.initState();
    _setupValidationListeners();
  }

  void _setupValidationListeners() {
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validatePasswordMatch);
  }

  void _validateEmail() {
    final email = _emailController.text;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    setState(() {
      _isEmailValid = emailRegex.hasMatch(email);
    });
  }

  void _validatePassword() {
    final password = _passwordController.text;
    double strength = 0.0;

    if (password.length >= 8) strength += 0.25;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.25;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.25;

    setState(() {
      _passwordStrength = strength;
    });

    _validatePasswordMatch();
  }

  void _validatePasswordMatch() {
    setState(() {
      _passwordsMatch =
          _passwordController.text == _confirmPasswordController.text &&
              _confirmPasswordController.text.isNotEmpty;
    });
  }

  bool get _isFormValid {
    return _formKey.currentState?.validate() == true &&
        _isEmailValid &&
        _passwordStrength >= 0.5 &&
        _passwordsMatch &&
        _acceptTerms;
  }

  Future<void> _handleRegistration() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate registration process
      await Future.delayed(const Duration(seconds: 2));

      // Show success animation
      if (mounted) {
        _showSuccessAnimation();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao criar conta. Tente novamente.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 80.w,
          height: 30.h,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'check',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 8.w,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Conta criada com sucesso!',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                'Redirecionando...',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop(); // Close dialog
        widget.onRegistrationSuccess?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildNameField(),
          SizedBox(height: 2.h),
          _buildEmailField(),
          SizedBox(height: 2.h),
          _buildPasswordField(),
          SizedBox(height: 1.h),
          _buildPasswordStrengthIndicator(),
          SizedBox(height: 2.h),
          _buildConfirmPasswordField(),
          SizedBox(height: 2.h),
          _buildOptionalFieldsToggle(),
          if (_showOptionalFields) ...[
            SizedBox(height: 2.h),
            _buildPhoneField(),
          ],
          SizedBox(height: 3.h),
          _buildAgeVerificationCheckbox(),
          SizedBox(height: 2.h),
          _buildTermsCheckbox(),
          SizedBox(height: 3.h),
          _buildRegistrationButton(),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Nome completo',
        hintText: 'Digite seu nome completo',
        prefixIcon: Padding(
          padding: EdgeInsets.all(3.w),
          child: CustomIconWidget(
            iconName: 'person_outline',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 5.w,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Nome é obrigatório';
        }
        if (value.trim().length < 2) {
          return 'Nome deve ter pelo menos 2 caracteres';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'E-mail',
        hintText: 'Digite seu e-mail',
        prefixIcon: Padding(
          padding: EdgeInsets.all(3.w),
          child: CustomIconWidget(
            iconName: 'email_outlined',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 5.w,
          ),
        ),
        suffixIcon: _emailController.text.isNotEmpty
            ? Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: _isEmailValid ? 'check_circle' : 'error',
                  color: _isEmailValid
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.error,
                  size: 5.w,
                ),
              )
            : null,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'E-mail é obrigatório';
        }
        if (!_isEmailValid) {
          return 'Digite um e-mail válido';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Senha',
        hintText: 'Digite sua senha',
        prefixIcon: Padding(
          padding: EdgeInsets.all(3.w),
          child: CustomIconWidget(
            iconName: 'lock_outline',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 5.w,
          ),
        ),
        suffixIcon: IconButton(
          icon: CustomIconWidget(
            iconName: _isPasswordVisible ? 'visibility_off' : 'visibility',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 5.w,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Senha é obrigatória';
        }
        if (value.length < 8) {
          return 'Senha deve ter pelo menos 8 caracteres';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Força da senha: ',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            Text(
              _getPasswordStrengthText(),
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: _getPasswordStrengthColor(),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        LinearProgressIndicator(
          value: _passwordStrength,
          backgroundColor:
              AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          valueColor:
              AlwaysStoppedAnimation<Color>(_getPasswordStrengthColor()),
        ),
      ],
    );
  }

  String _getPasswordStrengthText() {
    if (_passwordStrength == 0) return 'Muito fraca';
    if (_passwordStrength <= 0.25) return 'Fraca';
    if (_passwordStrength <= 0.5) return 'Regular';
    if (_passwordStrength <= 0.75) return 'Boa';
    return 'Muito forte';
  }

  Color _getPasswordStrengthColor() {
    if (_passwordStrength <= 0.25) return AppTheme.lightTheme.colorScheme.error;
    if (_passwordStrength <= 0.5) return const Color(0xFFF39C12);
    if (_passwordStrength <= 0.75) return const Color(0xFFF4A261);
    return AppTheme.lightTheme.colorScheme.primary;
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: !_isConfirmPasswordVisible,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'Confirmar senha',
        hintText: 'Digite sua senha novamente',
        prefixIcon: Padding(
          padding: EdgeInsets.all(3.w),
          child: CustomIconWidget(
            iconName: 'lock_outline',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 5.w,
          ),
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_confirmPasswordController.text.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: CustomIconWidget(
                  iconName: _passwordsMatch ? 'check_circle' : 'error',
                  color: _passwordsMatch
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.error,
                  size: 5.w,
                ),
              ),
            IconButton(
              icon: CustomIconWidget(
                iconName:
                    _isConfirmPasswordVisible ? 'visibility_off' : 'visibility',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
              onPressed: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
          ],
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Confirmação de senha é obrigatória';
        }
        if (!_passwordsMatch) {
          return 'Senhas não coincidem';
        }
        return null;
      },
    );
  }

  Widget _buildOptionalFieldsToggle() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showOptionalFields = !_showOptionalFields;
        });
      },
      child: Row(
        children: [
          CustomIconWidget(
            iconName: _showOptionalFields ? 'expand_less' : 'expand_more',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 5.w,
          ),
          SizedBox(width: 2.w),
          Text(
            'Campos opcionais',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'Telefone (opcional)',
        hintText: '(11) 99999-9999',
        prefixIcon: Padding(
          padding: EdgeInsets.all(3.w),
          child: CustomIconWidget(
            iconName: 'phone_outlined',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 5.w,
          ),
        ),
      ),
    );
  }

  Widget _buildAgeVerificationCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _isUnder18,
          onChanged: (value) {
            setState(() {
              _isUnder18 = value ?? false;
            });
          },
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isUnder18 = !_isUnder18;
              });
            },
            child: Padding(
              padding: EdgeInsets.only(top: 3.w),
              child: Text(
                'Tenho menos de 18 anos (requer consentimento dos pais)',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (value) {
            setState(() {
              _acceptTerms = value ?? false;
            });
          },
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _acceptTerms = !_acceptTerms;
              });
            },
            child: Padding(
              padding: EdgeInsets.only(top: 3.w),
              child: RichText(
                text: TextSpan(
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                  children: [
                    const TextSpan(text: 'Aceito os '),
                    TextSpan(
                      text: 'Termos de Serviço',
                      style: TextStyle(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: ' e a '),
                    TextSpan(
                      text: 'Política de Privacidade',
                      style: TextStyle(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationButton() {
    return ElevatedButton(
      onPressed: _isFormValid && !_isLoading ? _handleRegistration : null,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: _isLoading
          ? SizedBox(
              height: 5.w,
              width: 5.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightTheme.colorScheme.onPrimary,
                ),
              ),
            )
          : Text(
              'Criar Conta',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
