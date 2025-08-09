import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_us_app/presentation/bloc/data_state.dart';

import 'data_event.dart';

class DataBloc extends Bloc<DataEvent, DataState>{
  DataBloc(): super (DataState(state: DataStatus.startService));
}