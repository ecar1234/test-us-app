import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_us_app/data/models/package/recruit_post_applications_model.dart';
import 'package:test_us_app/domain/entities/image_entity.dart';
import 'package:test_us_app/domain/entities/promotion_post_entity.dart';
import 'package:test_us_app/domain/entities/recruit_post_entity.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';
import 'package:test_us_app/mata_data_setting.dart';
import 'package:test_us_app/permission_handler.dart';
import 'package:test_us_app/presentation/components/notifications_page.dart';

import '../pages/auth/find_password_page.dart';
import '../pages/auth/find_user_email_page.dart';
import '../pages/auth/find_user_info_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/signup_page.dart';
import '../pages/home/home_page.dart';
import '../pages/home/purchase/plan_page_view.dart';
import '../pages/home/purchase_page.dart';
import '../pages/home/search_page.dart';
import '../pages/home/setting_page.dart';
import '../pages/home/user_page.dart';
import '../pages/main_page.dart';
import '../pages/message/message_main_page.dart';
import '../pages/message/message_room.dart';
import '../pages/my_pages/application/my_applications_page.dart';
import '../pages/my_pages/promotion/my_promotion_page.dart';
import '../pages/my_pages/recruit/application_management_page.dart';
import '../pages/my_pages/recruit/my_recruitment_page.dart';
import '../pages/my_pages/reviews/application_post_review/add_service_review_page.dart';
import '../pages/my_pages/reviews/application_post_review/service_review_main_page.dart';
import '../pages/my_pages/reviews/review_page.dart';
import '../pages/my_pages/reviews/tester_review/add_tester_review_page.dart';
import '../pages/my_pages/reviews/tester_review/tester_review_main_page.dart';
import '../pages/my_pages/reviews/tester_review/tester_review_page.dart';
import '../pages/my_pages/reviews/user_review_page/check_post_review_page.dart';
import '../pages/my_pages/reviews/user_review_page/recruit_post_review_page.dart';
import '../pages/my_pages/reviews/user_review_page/user_review_main_page.dart';
import '../pages/my_pages/reviews/user_review_page/user_tester_review_page.dart';
import '../pages/my_pages/user_info/password_check_page.dart';
import '../pages/my_pages/user_info/password_update_page.dart';
import '../pages/my_pages/user_info/user_delete_page.dart';
import '../pages/my_pages/user_info/user_info_page.dart';
import '../pages/post/post_image_detail_page.dart';
import '../pages/post/post_main_page.dart';
import '../pages/post/promotion_post_pages/promotion_post_create_page.dart';
import '../pages/post/promotion_post_pages/promotion_post_detail_page.dart';
import '../pages/post/tester_post_pages/recruit_post_create_page.dart';
import '../pages/post/tester_post_pages/recruit_post_detail_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/', // 앱 시작 초기 경로 (스플래시 또는 메인)
    observers: [BotToastNavigatorObserver()],
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const PermissionHandler()
      ),
      GoRoute(
        path: '/meta_data_setting',
        name: 'meta_setting',
        builder: (context, state) => const MetaDataSetting()
      ),
      // ---------------------------------------------------------
      // 1. 인증 (Auth) 라우트
      // ---------------------------------------------------------
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(), // lib/presentation/pages/auth/login_page.dart
        routes: [
          GoRoute(
            path: 'signup',
            name: 'signup',
            builder: (context, state) => const SignupPage(), // lib/presentation/pages/auth/signup_page.dart
          ),
          GoRoute(
            path: 'find-info',
            name: 'find_info',
            builder: (context, state) => const FindUserInfoPage(),
          ),
          GoRoute(
            path: 'find-email',
            name: 'find_email',
            builder: (context, state) => const FindUserEmailPage(),
          ),
          GoRoute(
            path: 'find-password',
            name: 'find_password',
            builder: (context, state) => const FindPasswordPage(),
          ),
        ],
      ),

      // ---------------------------------------------------------
      // 2. 메인 및 홈 (Main & Home) 라우트
      // BottomNavigationBar를 사용하는 탭 구조라면 ShellRoute 사용을 권장합니다.
      // ---------------------------------------------------------
      GoRoute(
        path: '/main',
        name: 'main',
        builder: (context, state) => const MainPage(), // lib/presentation/pages/main_page.dart
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) {
          final onCallback = state.extra as Function(int);
          //TODO: 아래 조건부 추가 필요
          // ✅ 조건부 캐스팅 및 에러 핸들링
          // if (state.extra is! UserEntity) {
          //   // extra가 없거나 타입이 다를 경우의 폴백(Fallback) UI 또는 로직
          //   return const ErrorScreen(message: '사용자 정보가 전달되지 않았습니다.');
          // }
          return HomePage(onTap: onCallback);
        }, // lib/presentation/pages/home/home_page.dart
        routes: [
          GoRoute(
            path: 'notification',
            name: 'notification',
            builder: (context, state) => NotificationsPage()
          )
        ]
      ),
      GoRoute(
        path: '/setting',
        name: 'setting',
        builder: (context, state) => const SettingPage(),
      ),
      GoRoute(
        path: '/user',
        name: 'user',
        builder: (context, state) => const UserPage(),
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: '/purchase',
        name: 'purchase',
        builder: (context, state) => const PurchasePage(),
        routes: [
          GoRoute(
            path: 'plans',
            name: 'purchase_plans',
            builder: (context, state) {
              final onPlanChanged = state.extra as Function(int);
              return PlanPageView(onPlanChanged: onPlanChanged);
            }
          ),
        ],
      ),

      // ---------------------------------------------------------
      // 3. 포스트 (게시글) 관련 라우트
      // ---------------------------------------------------------
      GoRoute(
        path: '/post',
        name: 'post_main',
        builder: (context, state) {
          final type = state.uri.queryParameters['type']!;
          return PostMainPage(type: type,);
        },
        routes: [
          GoRoute(
            path: 'image-detail',
            name: 'post_image_detail',
            builder: (context, state) {
              final images = state.extra as List<ImageEntity>;
              return PostImageDetailPage(images: images);
            }
          ),
          // 테스터 모집 게시글
          GoRoute(
            path: 'recruit/create',
            name: 'recruit_create',
            builder: (context, state) => const RecruitPostCreatePage(),
          ),
          GoRoute(
            path: 'recruit/detail', // 동적 파라미터 :id 사용
            name: 'recruit_detail',
            builder: (context, state) {
              final postId = state.uri.queryParameters['postId'];
              final post = state.extra as RecruitPostEntity?;
              return RecruitPostDetailPage(postId: postId, post: post);
            },
          ),
          // 홍보 게시글
          GoRoute(
            path: 'promotion/create',
            name: 'promotion_create',
            builder: (context, state) => const PromotionPostCreatePage(),
          ),
          GoRoute(
            path: 'promotion/detail',
            name: 'promotion_detail',
            builder: (context, state) {
              final postId = state.uri.queryParameters['postId'];
              final post= state.extra as PromotionPostEntity?;
              return PromotionPostDetailPage(postId: postId, post: post,);
            },
          ),
        ],
      ),

      // ---------------------------------------------------------
      // 4. 메시지 (채팅) 관련 라우트
      // ---------------------------------------------------------
      GoRoute(
        path: '/message',
        name: 'message_main',
        builder: (context, state) => const MessageMainPage(),
        routes: [
          GoRoute(
            path: 'room/:roomId', // 채팅방 ID를 파라미터로 전달
            name: 'message_room',
            builder: (context, state) {
              final roomIdStr = state.pathParameters['roomId'];
              int? roomId = roomIdStr != null ? int.tryParse(roomIdStr) : null;
              final postId = state.uri.queryParameters['postId'];
              final targetUser = state.extra as User;
              return MessageRoom(targetUser: targetUser , roomId: roomId, postId: postId,);
            },
          ),
        ],
      ),

      // ---------------------------------------------------------
      // 5. 마이페이지 (My Pages) 관련 라우트
      // ---------------------------------------------------------
      GoRoute(
        path: '/mypage',
        name: 'mypage',
        builder: (context, state) {
          final user = state.extra as UserEntity;
          return UserInfoPage(user: user,);
        },// 기본 마이페이지 진입점
        routes: [
          // 내 게시글 관리
          GoRoute(
            path: 'promotion',
            name: 'my_promotion',
            builder: (context, state) => const MyPromotionPage(),
          ),
          GoRoute(
            path: 'recruit',
            name: 'my_recruit',
            builder: (context, state) => const MyRecruitmentPage(),
            routes: [
              GoRoute(
                path: 'applications',
                name: 'application_management',
                builder: (context, state) => const ApplicationManagementPage(),
              ),
            ],
          ),
          GoRoute(
            path: 'applications',
            name: 'my_applications',
            builder: (context, state) => const MyApplicationsPage(),
          ),

          // 회원 정보 관리
          GoRoute(
            path: 'password-check',
            name: 'password_check',
            builder: (context, state) => const PasswordCheckPage(),
          ),
          GoRoute(
            path: 'password-update/:email',
            name: 'password_update',
            builder: (context, state) {
              final email = state.pathParameters['email'];
              return PasswordUpdatePage(email: email,);
            }
          ),
          GoRoute(
            path: 'user-delete',
            name: 'user_delete',
            builder: (context, state) => const UserDeletePage(),
          ),

          // 리뷰 관리
          GoRoute(
            path: 'reviews',
            name: 'my_reviews',
            builder: (context, state) => const ReviewPage(),
            routes: [
              // 서비스(앱) 관련 리뷰
              GoRoute(
                path: 'service',
                name: 'service_review_main',
                builder: (context, state) => const ServiceReviewMainPage(),
              ),
              GoRoute(
                path: 'service/add',
                name: 'add_service_review',
                builder: (context, state) {
                  final post = state.extra as RecruitPostEntity;
                  return AddServiceReviewPage(post: post,);
                }
              ),
              // 유저 대상 리뷰
              GoRoute(
                path: 'user',
                name: 'user_review_main',
                builder: (context, state) => const UserReviewMainPage(),
              ),
              GoRoute(
                path: 'user/recruit-post',
                name: 'recruit_post_review',
                builder: (context, state) => const RecruitPostReviewPage(),
              ),
              GoRoute(
                path: 'user/tester',
                name: 'user_tester_review',
                builder: (context, state) => const UserTesterReviewPage(),
              ),
              GoRoute(
                path: 'user/check/:postId',
                name: 'check_post_review',
                builder: (context, state) {
                  final postId = state.pathParameters['postId']!;
                  return CheckPostReviewPage(postId: postId,);
                }
              ),
              // 테스터 대상 리뷰
              GoRoute(
                path: 'tester',
                name: 'tester_review_main',
                builder: (context, state) => const TesterReviewMainPage(),
              ),
              GoRoute(
                path: 'tester/detail/:postId',
                name: 'tester_review_detail',
                builder: (context, state) {
                  final postId = state.pathParameters['postId']!;
                  final apps = state.extra as List<int>;
                  return TesterReviewPage(applications: apps, postId: postId,);
                }
              ),
              GoRoute(
                path: 'tester/add/:appId',
                name: 'add_tester_review',
                builder: (context, state) {
                  final appId = int.parse(state.pathParameters['appId']!);
                  final tester = state.extra as User;
                  return AddTesterReviewPage(tester: tester, appId: appId,);
                }
              ),
            ],
          ),
        ],
      ),
    ],
  );
}