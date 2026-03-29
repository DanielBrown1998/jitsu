import 'package:flutter/material.dart';
import 'package:app/ui/auth/logic/command.dart';
import 'package:app/ui/auth/logic/vm.dart';
import 'package:provider/provider.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home do aluno'),
        actions: [
          IconButton(
            tooltip: 'Logout provisório',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final vm = context.read<AuthVm>();
              await vm.logoutCommand.execute(input: LogoutInput());

              if (!context.mounted) return;
              final error = vm.state.error;
              if (error != null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(error)));
              }
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('StudentHomePage - TODO: implementar tela'),
      ),
    );
  }
}
