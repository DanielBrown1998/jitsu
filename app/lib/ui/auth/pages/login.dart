import 'package:app/core/widgets/buttons/jitsu_button.dart';
import 'package:app/core/widgets/feedback/jitsu_snackbar.dart';
import 'package:app/core/widgets/forms/jitsu_text_field.dart';
import 'package:app/ui/admin_home/route/route.dart';
import 'package:app/ui/auth/logic/command.dart';
import 'package:app/ui/auth/logic/state.dart';
import 'package:app/ui/auth/logic/vm.dart';
import 'package:app/ui/auth/route/route.dart';
import 'package:app/ui/student_home/route/route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final AnimationController _controller;
  late final Animation<double> _headerOpacity;
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _formOpacity;
  late final Animation<Offset> _formSlide;
  late final Animation<double> _footerOpacity;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _headerOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.45, curve: Curves.easeOutCubic),
    );
    _headerSlide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0, 0.45, curve: Curves.easeOutCubic),
          ),
        );
    _formOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    );
    _formSlide = Tween<Offset>(begin: const Offset(0, 0.07), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
          ),
        );
    _footerOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 1, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = (value ?? '').trim();
    if (email.isEmpty) return 'Informe seu email';
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!regex.hasMatch(email)) return 'Email invalido';
    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Informe sua senha';
    if (password.length < 6) return 'Minimo de 6 caracteres';
    return null;
  }

  Future<void> _handleLogin(AuthVm vm) async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    await vm.loginCommand.execute(input: LoginInput(email, password));

    if (!mounted) return;
    if (vm.state.isLoggedIn) {
      final target = switch (vm.state.role) {
        UserRole.student => StudentHomeRoute.path,
        UserRole.admin || UserRole.professor => AdminHomeRoute.path,
      };
      context.go(target);
      return;
    }

    final message = vm.state.error ?? 'Nao foi possivel realizar o login';
    JitsuSnackBar.show(
      context,
      message: message,
      variant: JitsuSnackBarVariant.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVm>(
      builder: (context, vm, _) {
        return Container(
          color: const Color(0xFFFAFAFA),
          width: double.infinity,
          height: double.infinity,
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 390),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FadeTransition(
                        opacity: _headerOpacity,
                        child: SlideTransition(
                          position: _headerSlide,
                          child: Column(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF09090B),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x33000000),
                                      blurRadius: 24,
                                      offset: Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.shield_outlined,
                                  color: Colors.white,
                                  size: 34,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Bem-vindo de volta',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF18181B),
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Acesse sua conta para continuar',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: const Color(0xFF71717A),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      FadeTransition(
                        opacity: _formOpacity,
                        child: SlideTransition(
                          position: _formSlide,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                JitsuTextField(
                                  controller: _emailController,
                                  label: 'Email',
                                  hintText: 'ex: admin@jitsu.com',
                                  keyboardType: TextInputType.emailAddress,
                                  validator: _validateEmail,
                                  prefixIcon: const Icon(
                                    Icons.email_outlined,
                                    color: Color(0xFFA1A1AA),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                JitsuTextField(
                                  controller: _passwordController,
                                  label: 'Senha',
                                  hintText: '••••••••',
                                  obscureText: true,
                                  validator: _validatePassword,
                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                    color: Color(0xFFA1A1AA),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () =>
                                        context.go(Routes.recoverPassword.path),
                                    style: TextButton.styleFrom(
                                      foregroundColor: const Color(0xFF52525B),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 8,
                                      ),
                                      textStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    child: const Text('Esqueci a senha'),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: JitsuButton(
                                    onPressed: vm.state.isLoading
                                        ? () {}
                                        : () => _handleLogin(vm),
                                    label: 'Entrar',
                                    borderRadius: 12,
                                    isLoading: vm.state.isLoading,
                                    variant: JitsuButtonVariant.primary,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    icon: const Icon(
                                      Icons.chevron_right,
                                      size: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextButton(
                                  onPressed: () =>
                                      context.go(Routes.register.path),
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFF52525B),
                                    textStyle: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  child: const Text('Nao tenho conta'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      FadeTransition(
                        opacity: _footerOpacity,
                        child: Text(
                          'Versao 1.0.0 • JITSU App',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: const Color(0xFFA1A1AA),
                                fontSize: 12,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
