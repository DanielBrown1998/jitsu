import 'package:app/core/widgets/buttons/jitsu_button.dart';
import 'package:app/core/widgets/feedback/jitsu_snackbar.dart';
import 'package:app/core/widgets/forms/jitsu_text_field.dart';
import 'package:app/ui/auth/logic/command.dart';
import 'package:app/ui/auth/logic/vm.dart';
import 'package:app/ui/auth/route/route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RecoverPasswordPage extends StatefulWidget {
  const RecoverPasswordPage({super.key});

  @override
  State<RecoverPasswordPage> createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final AnimationController _controller;
  late final Animation<double> _backOpacity;
  late final Animation<double> _contentOpacity;
  late final Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    _backOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.45, curve: Curves.easeOut),
    );
    _contentOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.15, 1, curve: Curves.easeOutCubic),
    );
    _contentSlide =
        Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.15, 1, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
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

  Future<void> _handleRecoverPassword(AuthVm vm) async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    await vm.recoverPasswordCommand.execute(input: RecoverPasswordInput(email));

    if (!mounted) return;

    if (vm.state.error == null) {
      JitsuSnackBar.show(
        context,
        message: 'Link de redefinicao enviado com sucesso.',
        variant: JitsuSnackBarVariant.success,
      );
      context.go(Routes.login.path);
      return;
    }

    JitsuSnackBar.show(
      context,
      message:
          vm.state.error ?? 'Nao foi possivel enviar o link de redefinicao.',
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
            child: Stack(
              children: [
                Positioned(
                  top: 8,
                  left: 12,
                  child: FadeTransition(
                    opacity: _backOpacity,
                    child: IconButton(
                      onPressed: () => context.go(Routes.login.path),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF71717A),
                        size: 24,
                      ),
                      splashRadius: 22,
                      tooltip: 'Voltar',
                    ),
                  ),
                ),
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 390),
                      child: FadeTransition(
                        opacity: _contentOpacity,
                        child: SlideTransition(
                          position: _contentSlide,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Recuperar Senha',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: const Color(0xFF18181B),
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Digite seu email para receber o link de redefinicao.',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: const Color(0xFF71717A),
                                        fontSize: 14,
                                      ),
                                ),
                                const SizedBox(height: 32),
                                JitsuTextField(
                                  controller: _emailController,
                                  label: 'Email',
                                  hintText: 'seu@email.com',
                                  keyboardType: TextInputType.emailAddress,
                                  validator: _validateEmail,
                                  prefixIcon: const Icon(
                                    Icons.email_outlined,
                                    color: Color(0xFFA1A1AA),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: JitsuButton(
                                    onPressed: vm.state.isLoading
                                        ? () {}
                                        : () => _handleRecoverPassword(vm),
                                    label: 'Enviar Link',
                                    isLoading: vm.state.isLoading,
                                    borderRadius: 12,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
