/// Domain Use Cases - Barrel file
library;

// Auth
export 'auth/login_with_email_usecase.dart';
export 'auth/logout_usecase.dart';
export 'auth/recover_password_usecase.dart';

// Aluno
export 'aluno/create_aluno_usecase.dart';
export 'aluno/get_aluno_profile_usecase.dart';
export 'aluno/get_aluno_history_usecase.dart';

// Presença & Aulas
export 'presenca/register_attendance_usecase.dart';
export 'presenca/get_turmas_usecase.dart';

// Graduação
export 'graduacao/check_graduation_eligibility_usecase.dart';
export 'graduacao/promote_aluno_usecase.dart';

// Relatórios
export 'relatorios/generate_turma_report_usecase.dart';
export 'relatorios/export_data_to_csv_usecase.dart';
