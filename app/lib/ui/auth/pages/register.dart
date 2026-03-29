import 'package:app/core/widgets/buttons/jitsu_button.dart';
import 'package:app/core/widgets/feedback/jitsu_snackbar.dart';
import 'package:app/core/widgets/forms/jitsu_text_field.dart';
import 'package:app/ui/auth/logic/command.dart';
import 'package:app/ui/auth/logic/vm.dart';
import 'package:app/ui/auth/route/route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final AnimationController _controller;
  late final Animation<double> _headerOpacity;
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _formOpacity;
  late final Animation<Offset> _formSlide;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
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
      curve: const Interval(0.2, 1, curve: Curves.easeOutCubic),
    );
    _formSlide = Tween<Offset>(begin: const Offset(0, 0.07), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.2, 1, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  String? _validatePasswordConfirmation(String? value) {
    if ((value ?? '').isEmpty) return 'Confirme sua senha';
    if (value != _passwordController.text) return 'As senhas nao conferem';
    return null;
  }

  Future<void> _handleRegister(AuthVm vm) async {
    if (!_formKey.currentState!.validate()) return;

    await vm.registerCommand.execute(
      input: RegisterInput(
        _emailController.text.trim(),
        _passwordController.text,
      ),
    );

    if (!mounted) return;

    if (vm.state.error == null) {
      JitsuSnackBar.show(
        context,
        message: 'Cadastro realizado com sucesso. Voce ja pode entrar.',
        variant: JitsuSnackBarVariant.success,
      );
      context.go(Routes.login.path);
      return;
    }

    JitsuSnackBar.show(
      context,
      message: vm.state.error ?? 'Nao foi possivel criar a conta.',
      variant: JitsuSnackBarVariant.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVm>(
      builder: (context, vm, _) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFFFAFAFA),
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
                                  Icons.person_add_alt_1_outlined,
                                  color: Colors.white,
                                  size: 34,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Criar conta',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF18181B),
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Preencha os dados para comecar',
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
                                  hintText: 'ex: voce@jitsu.com',
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
                                const SizedBox(height: 14),
                                JitsuTextField(
                                  controller: _confirmPasswordController,
                                  label: 'Confirmar senha',
                                  hintText: '••••••••',
                                  obscureText: true,
                                  validator: _validatePasswordConfirmation,
                                  prefixIcon: const Icon(
                                    Icons.verified_user_outlined,
                                    color: Color(0xFFA1A1AA),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: JitsuButton(
                                    onPressed: vm.state.isLoading
                                        ? () {}
                                        : () => _handleRegister(vm),
                                    label: 'Cadastrar',
                                    isLoading: vm.state.isLoading,
                                    borderRadius: 12,
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
                                      context.go(Routes.login.path),
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFF52525B),
                                    textStyle: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  child: const Text('Ja tenho conta'),
                                ),
                              ],
                            ),
                          ),
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
