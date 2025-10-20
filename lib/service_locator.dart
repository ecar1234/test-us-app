

import 'package:get_it/get_it.dart';
import 'package:test_us_app/core/api_names.dart';
import 'package:test_us_app/data/data_sources/application_data/application_datasource.dart';
import 'package:test_us_app/data/data_sources/application_data/application_datasource_impl.dart';
import 'package:test_us_app/data/data_sources/post_data/post_datasource.dart';
import 'package:test_us_app/data/data_sources/post_data/post_datasource_impl.dart';
import 'package:test_us_app/data/data_sources/review_data/review_data_source.dart';
import 'package:test_us_app/data/data_sources/review_data/review_data_source_impl.dart';
import 'package:test_us_app/data/data_sources/user_data/user_data_source.dart';
import 'package:test_us_app/data/data_sources/user_data/user_data_source_impl.dart';
import 'package:test_us_app/data/repositories/post_repository_impl.dart';
import 'package:test_us_app/services/common_height_provider.dart';

import 'core/net_driver.dart';
import 'data/repositories/application_repository_impl.dart';
import 'data/repositories/review_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/application_repo.dart';
import 'domain/repositories/post_repository.dart';
import 'domain/repositories/review_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/use_cases/application_usecase.dart';
import 'domain/use_cases/post_usecase.dart';
import 'domain/use_cases/review_usecase.dart';
import 'domain/use_cases/user_usecase.dart';

final getIt = GetIt.instance;
Future<void> serviceLocator() async {

  getIt.registerLazySingleton<NetDriver>(() => NetDriver(Host.baseDevUrl));
  getIt.registerSingleton<ResponsiveHeightProvider>(ResponsiveHeightProvider());

  // data
  getIt.registerLazySingleton<UserDataSource>(() => UserDataSourceImpl(getIt<NetDriver>()));
  getIt.registerLazySingleton<PostDataSource>(() => PostDataSourceImpl(getIt<NetDriver>()));
  getIt.registerLazySingleton<ApplicationDataSource>(() => ApplicationDataSourceImpl(getIt<NetDriver>()));
  getIt.registerLazySingleton<ReviewDataSource>(() => ReviewDataSourceImpl(getIt<NetDriver>()));

  // domain
  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(getIt<UserDataSource>()));
  getIt.registerLazySingleton<PostRepository>(() => PostRepositoryImpl(getIt<PostDataSource>()));
  getIt.registerLazySingleton<ApplicationRepository>(() => ApplicationRepositoryImpl(getIt<ApplicationDataSource>()));
  getIt.registerLazySingleton<ReviewRepository>(() => ReviewRepositoryImpl(getIt<ReviewDataSource>()));

  // use case
  getIt.registerLazySingleton<UserUseCase>(() => UserUseCase(getIt<UserRepository>()));
  getIt.registerLazySingleton<PostUseCase>(() => PostUseCase(getIt<PostRepository>()));
  getIt.registerLazySingleton<ApplicationUseCase>(() => ApplicationUseCase(getIt<ApplicationRepository>()));
  getIt.registerLazySingleton<ReviewUseCase>(() => ReviewUseCase(getIt<ReviewRepository>()));


}