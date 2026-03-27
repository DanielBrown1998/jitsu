import "package:app/core/firebase/instance.dart";
import "package:app/domain/repositories/repositories.dart";
import "package:app/domain/usecases/usecases.dart";
import "package:app/infra/source/source.dart";
import "package:get_it/get_it.dart";

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  final firestore = FirebaseInstance.firestore;

  //Sources
  getIt.registerLazySingleton<AlunoSource>(
    () => AlunoSourceImpl(firestore: firestore),
  );
  getIt.registerLazySingleton<AulaSource>(
    () => AulaSourceImpl(firestore: firestore),
  );
  getIt.registerLazySingleton<AuthSource>(() => AuthSourceImpl());
  getIt.registerLazySingleton<HistoricoPresencaSource>(
    () => HistoricoPresencaSourceImpl(firestore: firestore),
  );
  getIt.registerLazySingleton<ReportSource>(
    () => ReportSourceImpl(firestore: firestore),
  );
  getIt.registerLazySingleton<TurmaSource>(
    () => TurmaSourceImpl(firestore: firestore),
  );

  //Repositories

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(source: getIt<AuthSource>()),
  );
  getIt.registerLazySingleton<AlunoRepository>(
    () => AlunoRepositoryImpl(source: getIt<AlunoSource>()),
  );
  getIt.registerLazySingleton<AulaRepository>(
    () => AulaRepositoryImpl(source: getIt<AulaSource>()),
  );
  getIt.registerLazySingleton<HistoricoPresencaRepository>(
    () => HistoricoPresencaRepositoryImpl(
      source: getIt<HistoricoPresencaSource>(),
    ),
  );
  getIt.registerLazySingleton<ReportRepository>(
    () => ReportRepositoryImpl(source: getIt<ReportSource>()),
  );
  getIt.registerLazySingleton<TurmaRepository>(
    () => TurmaRepositoryImpl(source: getIt<TurmaSource>()),
  );

  //UseCases

  getIt.registerLazySingleton<LoginWithEmailUseCase>(
    () => LoginWithEmailUseCaseImpl(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<LogoutUsecase>(
    () => LogoutUseCaseImpl(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<RecoverPasswordUseCase>(
    () => RecoverPasswordUseCaseImpl(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<GetAlunoHistoryUseCaseImpl>(
    () => GetAlunoHistoryUseCaseImpl(getIt<AlunoRepository>()),
  );
  getIt.registerLazySingleton<GetAlunoProfileUsecase>(
    () => GetAlunoProfileUseCaseImpl(getIt<AlunoRepository>()),
  );
  getIt.registerLazySingleton<CreateAlunoUsecase>(
    () => CreateAlunoUseCaseImpl(getIt<AlunoRepository>()),
  );
  getIt.registerLazySingleton<CheckGraduationEligibilityUsecase>(
    () => CheckGraduationEligibilityUseCaseImpl(getIt<AlunoRepository>()),
  );
  getIt.registerLazySingleton<PromoteAlunoUseCase>(
    () => PromoteAlunoUseCaseImpl(
      getIt<AlunoRepository>(),
      getIt<CheckGraduationEligibilityUsecase>(),
    ),
  );
  getIt.registerLazySingleton<GetTurmasUsecase>(
    () => GetTurmasUseCaseImpl(getIt<TurmaRepository>()),
  );
  getIt.registerLazySingleton<RegisterAttendanceUsecase>(
    () => RegisterAttendanceUseCaseImpl(
      getIt<AlunoRepository>(),
      getIt<AulaRepository>(),
      getIt<HistoricoPresencaRepository>(),
    ),
  );
  getIt.registerLazySingleton<ExportDataToCsvUseCase>(
    () => ExportDataToCsvUseCaseImpl(
      getIt<AlunoRepository>(),
      getIt<TurmaRepository>(),
      getIt<ReportRepository>(),
    ),
  );
  getIt.registerLazySingleton<GenerateTurmaReportUseCase>(
    () => GenerateTurmaReportUseCaseImpl(
      getIt<TurmaRepository>(),
      getIt<ReportRepository>(),
    ),
  );
}
