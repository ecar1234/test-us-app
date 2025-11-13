

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_us_app/core/api_names.dart';
import 'package:test_us_app/data/data_sources/application_data/application_datasource.dart';
import 'package:test_us_app/data/data_sources/application_data/application_datasource_impl.dart';
import 'package:test_us_app/data/data_sources/post_data/base_post_datasource_impl.dart';
import 'package:test_us_app/data/data_sources/post_data/recruit_post_datasource.dart';
import 'package:test_us_app/data/data_sources/post_data/recruit_post_datasource_impl.dart';
import 'package:test_us_app/data/data_sources/review_data/review_data_source.dart';
import 'package:test_us_app/data/data_sources/review_data/review_data_source_impl.dart';
import 'package:test_us_app/data/data_sources/user_data/user_data_source.dart';
import 'package:test_us_app/data/data_sources/user_data/user_data_source_impl.dart';
import 'package:test_us_app/data/repositories/recruit_post_repository_impl.dart';
import 'package:test_us_app/domain/use_cases/base_post_usecase.dart';
import 'package:test_us_app/services/common_height_provider.dart';
import 'package:test_us_app/services/theme_provider.dart';

import 'core/net_driver.dart';
import 'data/data_sources/post_data/base_post_datasource.dart';
import 'data/data_sources/post_data/promotion_post_datasource.dart';
import 'data/data_sources/post_data/promotion_post_datasource_impl.dart';
import 'data/repositories/application_repository_impl.dart';
import 'data/repositories/base_post_repository_impl.dart';
import 'data/repositories/promotion_post_repository_impl.dart';
import 'data/repositories/review_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/application_repo.dart';
import 'domain/repositories/base_post_repository.dart';
import 'domain/repositories/image_repository.dart';
import 'domain/repositories/promotion_post_repository.dart';
import 'domain/repositories/recruit_post_repository.dart';
import 'domain/repositories/review_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/use_cases/application_usecase.dart';
import 'domain/use_cases/image_usecase.dart';
import 'domain/use_cases/promotion_post_usecase.dart';
import 'domain/use_cases/recruit_post_usecase.dart';
import 'domain/use_cases/review_usecase.dart';
import 'domain/use_cases/user_usecase.dart';

final getIt = GetIt.instance;
Future<void> serviceLocator() async {

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  //
  // await FirebaseMessaging.instance.requestPermission(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );


  final GoogleSignIn signIn = GoogleSignIn.instance;
  await signIn.initialize(serverClientId: '185199812075-7r7c3fin3ka58mdr7atqat89jce2lv1u.apps.googleusercontent.com');
  // await signIn.initialize();
  getIt.registerLazySingleton<GoogleSignIn>(() => signIn);

  getIt.registerLazySingleton<NetDriver>(() => NetDriver(Host.baseDevUrl));
  getIt.registerSingleton<ResponsiveHeightProvider>(ResponsiveHeightProvider());
  // getIt.registerSingleton<ThemeProvider>(ThemeProvider());

  // data
  getIt.registerLazySingleton<UserDataSource>(() => UserDataSourceImpl(getIt<NetDriver>()));
  getIt.registerLazySingleton<ApplicationDataSource>(() => ApplicationDataSourceImpl(getIt<NetDriver>()));
  getIt.registerLazySingleton<ReviewDataSource>(() => ReviewDataSourceImpl(getIt<NetDriver>()));
  // getIt.registerLazySingleton<ImageDataSource>(() => ImageDataSourceImpl(getIt<NetDriver>()));
  getIt.registerLazySingleton<BasePostDataSource>(() => BasePostDataSourceImpl(getIt<NetDriver>()));
  getIt.registerLazySingleton<RecruitPostDatasource>(() => RecruitPostDatasourceImpl(getIt<NetDriver>()));
  getIt.registerLazySingleton<PromotionPostDataSource>(() => PromotionPostDataSourceImpl(getIt<NetDriver>()));

  // domain
  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(getIt<UserDataSource>()));
  getIt.registerLazySingleton<ApplicationRepository>(() => ApplicationRepositoryImpl(getIt<ApplicationDataSource>()));
  getIt.registerLazySingleton<ReviewRepository>(() => ReviewRepositoryImpl(getIt<ReviewDataSource>()));
  // getIt.registerLazySingleton<ImageRepository>(() => ImageRepositoryImpl(getIt<ImageDataSource>()));
  getIt.registerLazySingleton<BasePostRepository>(() => BasePostRepositoryImpl(getIt<BasePostDataSource>()));
  getIt.registerLazySingleton<RecruitPostRepository>(() => RecruitPostRepositoryImpl(getIt<RecruitPostDatasource>()));
  getIt.registerLazySingleton<PromotionPostRepository>(() => PromotionPostRepositoryImpl(getIt<PromotionPostDataSource>()));

  // use case
  getIt.registerLazySingleton<UserUseCase>(() => UserUseCase(getIt<UserRepository>()));
  getIt.registerLazySingleton<ApplicationUseCase>(() => ApplicationUseCase(getIt<ApplicationRepository>()));
  getIt.registerLazySingleton<ReviewUseCase>(() => ReviewUseCase(getIt<ReviewRepository>()));
  getIt.registerLazySingleton<ImageUseCase>(() => ImageUseCase(getIt<ImageRepository>()));
  getIt.registerLazySingleton<BasePostUseCase>(() => BasePostUseCase(getIt<BasePostRepository>()));
  getIt.registerLazySingleton<RecruitPostUseCase>(() => RecruitPostUseCase(getIt<RecruitPostRepository>()));
  getIt.registerLazySingleton<PromotionPostUseCase>(() => PromotionPostUseCase(getIt<PromotionPostRepository>()));

  FlutterNativeSplash.remove();
}