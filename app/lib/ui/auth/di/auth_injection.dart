import 'package:app/domain/usecases/usecases.dart';
import 'package:app/ui/auth/logic/vm.dart';
import 'package:get_it/get_it.dart';

void initializeAuthFeature(GetIt getIt) {
  getIt.registerLazySingleton<AuthVm>(
    () => AuthVm(
      watchAuthStateUseCase: getIt<WatchAuthStateUseCase>(),
      loginWithEmailUseCase: getIt<LoginWithEmailUseCase>(),
      logoutUseCase: getIt<LogoutUsecase>(),
      recoverPasswordUseCase: getIt<RecoverPasswordUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
      getUserRoleUsecase: getIt<GetUserRoleUsecase>(),
      createStudentProfileUsecase: getIt<CreateStudentProfileUsecase>(),
      getAlunoProfileUsecase: getIt<GetAlunoProfileUsecase>(),
      getProfessorProfileUsecase: getIt<GetProfessorProfileUsecase>(),
    ),
  );
}
