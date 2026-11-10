
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_us_app/domain/use_cases/side_project_usecase.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/side_project_bloc/side_project_event.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/side_project_bloc/side_project_state.dart';

class SideProjectBloc extends Bloc<SideProjectEvent, SideProjectState>{
  final SideProjectUseCase sideUseCase;
  SideProjectBloc(this.sideUseCase): super(SideProjectInitState());
}