import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_us_app/core/api_names.dart';
import 'package:test_us_app/data/data_sources/application_data/application_datasource.dart';
import 'package:test_us_app/data/data_sources/application_data/application_datasource_impl.dart';
import 'package:test_us_app/data/data_sources/message_data/message_data_source.dart';
import 'package:test_us_app/data/data_sources/message_data/message_data_source_impl.dart';
import 'package:test_us_app/data/data_sources/post_data/base_post_datasource_impl.dart';
import 'package:test_us_app/data/data_sources/post_data/recruit_post_datasource.dart';
import 'package:test_us_app/data/data_sources/post_data/recruit_post_datasource_impl.dart';
import 'package:test_us_app/data/data_sources/purchase_data/purchase_data_source.dart';
import 'package:test_us_app/data/data_sources/review_data/review_data_source.dart';
import 'package:test_us_app/data/data_sources/review_data/review_data_source_impl.dart';
import 'package:test_us_app/data/data_sources/user_data/user_data_source.dart';
import 'package:test_us_app/data/data_sources/user_data/user_data_source_impl.dart';
import 'package:test_us_app/data/repositories/message_repository_impl.dart';
import 'package:test_us_app/data/repositories/recruit_post_repository_impl.dart';
import 'package:test_us_app/domain/repositories/message_repository.dart';
import 'package:test_us_app/domain/repositories/purchase_repository.dart';
import 'package:test_us_app/domain/use_cases/base_post_usecase.dart';
import 'package:test_us_app/domain/use_cases/firebase_messaging_usecase.dart';
import 'package:test_us_app/presentation/provider/firebase_messaging_provider.dart';
import 'package:test_us_app/presentation/provider/socket_provider.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/services/auth/auth_service.dart';
import 'package:test_us_app/services/common_height_provider.dart';
import 'package:test_us_app/services/firebase/firebase_options.dart';
import 'package:test_us_app/services/revenue_cat_purchases/purchase_management.dart';
import 'package:test_us_app/services/socket/Isocket_io_client.dart';
import 'package:test_us_app/services/socket/socket_io_client.dart';

import 'core/net_driver.dart';
import 'data/data_sources/post_data/base_post_datasource.dart';
import 'data/data_sources/post_data/promotion_post_datasource.dart';
import 'data/data_sources/post_data/promotion_post_datasource_impl.dart';
import 'data/data_sources/purchase_data/purchase_data_source_impl.dart';
import 'data/data_sources/room_data/room_data_source.dart';
import 'data/data_sources/room_data/room_data_source_impl.dart';
import 'data/data_sources/room_member_data/room_member_data_source.dart';
import 'data/data_sources/room_member_data/room_member_data_source_impl.dart';
import 'data/repositories/application_repository_impl.dart';
import 'data/repositories/base_post_repository_impl.dart';
import 'data/repositories/promotion_post_repository_impl.dart';
import 'data/repositories/purchase_repository_impl.dart';
import 'data/repositories/review_repository_impl.dart';
import 'data/repositories/room_member_repository_impl.dart';
import 'data/repositories/room_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/application_repo.dart';
import 'domain/repositories/base_post_repository.dart';
import 'domain/repositories/image_repository.dart';
import 'domain/repositories/promotion_post_repository.dart';
import 'domain/repositories/recruit_post_repository.dart';
import 'domain/repositories/review_repository.dart';
import 'domain/repositories/room_member_repository.dart';
import 'domain/repositories/room_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/use_cases/application_usecase.dart';
import 'domain/use_cases/image_usecase.dart';
import 'domain/use_cases/message_usecase.dart';
import 'domain/use_cases/promotion_post_usecase.dart';
import 'domain/use_cases/purchase_usecase.dart';
import 'domain/use_cases/recruit_post_usecase.dart';
import 'domain/use_cases/review_usecase.dart';
import 'domain/use_cases/user_usecase.dart';

final getIt = GetIt.instance;

Future<void> serviceLocator(Future<void> Function(RemoteMessage message) firebaseMessagingBackgroundHandler) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  final GoogleSignIn signIn = GoogleSignIn.instance;
  await signIn.initialize();

  getIt.registerLazySingleton<GoogleSignIn>(() => signIn);
  String host = kDebugMode ? Host.baseDevUrl : Host.baseProdUrl;
  debugPrint('접속 URL : $host');
  getIt.registerLazySingleton<NetDriver>(() => NetDriver(host));
  getIt.registerSingleton<ResponsiveHeightProvider>(ResponsiveHeightProvider());
  // getIt.registerSingleton<ThemeProvider>(ThemeProvider());
  getIt.registerLazySingleton<ISocketClient>(() => SocketIOClientImpl());
  getIt.registerSingleton<AuthService>(AuthService());

  // data
  getIt.registerLazySingleton<UserDataSource>(() => UserDataSourceImpl(getIt<NetDriver>()));
  getIt.registerLazySingleton<ApplicationDataSource>(() => ApplicationDataSourceImpl(getIt<NetDriver>()));
  getIt.registerLazySingleton<ReviewDataSource>(() => ReviewDataSourceImpl(getIt<NetDriver>()));
  // getIt.registerLazySingleton<ImageDataSource>(() => ImageDataSourceImpl(getIt<NetDriver>()));
  getIt.registerLazySingleton<BasePostDataSource>(() => BasePostDataSourceImpl(getIt<NetDriver>()));
  getIt.registerLazySingleton<RecruitPostDatasource>(() => RecruitPostDatasourceImpl(getIt<NetDriver>()));
  getIt.registerLazySingleton<PromotionPostDataSource>(() => PromotionPostDataSourceImpl(getIt<NetDriver>()));
  getIt.registerLazySingleton<MessageDataSource>(() => MessageDataSourceImpl(getIt<NetDriver>()));
  getIt.registerLazySingleton<RoomDataSource>(() => RoomDataSourceImpl(getIt<NetDriver>()));
  getIt.registerLazySingleton<RoomMemberDataSource>(() => RoomMemberDataSourceImpl(getIt<NetDriver>()));
  getIt.registerLazySingleton<PurchaseDataSource>(() => PurchaseDataSourceImpl(getIt<NetDriver>()));

  // domain
  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(getIt<UserDataSource>()));
  getIt.registerLazySingleton<ApplicationRepository>(() => ApplicationRepositoryImpl(getIt<ApplicationDataSource>()));
  getIt.registerLazySingleton<ReviewRepository>(() => ReviewRepositoryImpl(getIt<ReviewDataSource>()));
  // getIt.registerLazySingleton<ImageRepository>(() => ImageRepositoryImpl(getIt<ImageDataSource>()));
  getIt.registerLazySingleton<BasePostRepository>(() => BasePostRepositoryImpl(getIt<BasePostDataSource>()));
  getIt.registerLazySingleton<RecruitPostRepository>(() => RecruitPostRepositoryImpl(getIt<RecruitPostDatasource>()));
  getIt.registerLazySingleton<PromotionPostRepository>(
      () => PromotionPostRepositoryImpl(getIt<PromotionPostDataSource>()));
  getIt.registerLazySingleton<MessageRepository>(() => MessageRepositoryImpl(getIt<MessageDataSource>()));
  getIt.registerLazySingleton<RoomRepository>(() => RoomRepositoryImpl(getIt<RoomDataSource>()));
  getIt.registerLazySingleton<RoomMemberRepository>(() => RoomMemberRepositoryImpl(getIt<RoomMemberDataSource>()));
  getIt.registerLazySingleton<PurchaseRepository>(() => PurchaseRepositoryImpl(getIt<PurchaseDataSource>()));


  // use case
  getIt.registerLazySingleton<UserUseCase>(() => UserUseCase(getIt<UserRepository>()));
  getIt.registerLazySingleton<ApplicationUseCase>(() => ApplicationUseCase(getIt<ApplicationRepository>()));
  getIt.registerLazySingleton<ReviewUseCase>(() => ReviewUseCase(getIt<ReviewRepository>()));
  getIt.registerLazySingleton<ImageUseCase>(() => ImageUseCase(getIt<ImageRepository>()));
  getIt.registerLazySingleton<BasePostUseCase>(() => BasePostUseCase(getIt<BasePostRepository>()));
  getIt.registerLazySingleton<RecruitPostUseCase>(() => RecruitPostUseCase(getIt<RecruitPostRepository>()));
  getIt.registerLazySingleton<PromotionPostUseCase>(() => PromotionPostUseCase(getIt<PromotionPostRepository>()));
  getIt.registerLazySingleton<FirebaseMessagingUseCase>(() => FirebaseMessagingUseCase());
  getIt.registerLazySingleton<MessageUseCase>(() => MessageUseCase(getIt<RoomRepository>(), getIt<MessageRepository>(), getIt<RoomMemberRepository>(), getIt<UserProvider>()));
  getIt.registerLazySingleton<PurchaseUseCase>(() => PurchaseUseCase(getIt<PurchaseRepository>()));

  //provider
  getIt.registerSingleton<FirebaseMessagingProvider>(FirebaseMessagingProvider(getIt<FirebaseMessagingUseCase>()));
  getIt.registerSingleton<UserProvider>(UserProvider(getIt<UserUseCase>()));
  getIt.registerSingleton<SocketProvider>(SocketProvider(getIt<ISocketClient>()));
  getIt.registerSingleton<PurchasesManagements>(PurchasesManagements());

}
