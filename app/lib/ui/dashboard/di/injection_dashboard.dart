import 'package:get_it/get_it.dart';
import 'package:app/domain/usecases/presenca/get_turmas_usecase.dart';
import 'package:app/ui/dashboard/logic/vm.dart';

void initializeDashboardFeature(GetIt getIt) {
  getIt.registerLazySingleton<DashboardVm>(
    () => DashboardVm(getTurmasUsecase: getIt<GetTurmasUsecase>()),
  );
}
