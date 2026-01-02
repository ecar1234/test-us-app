import '../data/models/post/recruit_post_model.dart';
import '../data/models/user/user_model.dart';

class TypeConversionUtil {
  String userRoleToString(UserRole role) {
    switch (role) {
      case UserRole.programmer:
        return "programmer";
      case UserRole.planner:
        return "planner";
      case UserRole.marketer:
        return "marketer";
      case UserRole.designer:
        return "designer";
      case UserRole.publisher:
        return "publisher";
      case UserRole.analyst:
        return "analyst";
      case UserRole.operator:
        return "operator";
      case UserRole.pm:
        return "pm";
      case UserRole.qa:
        return "qa";
      case UserRole.cs:
        return "cs";
      case UserRole.manager:
        return "manager";
      case UserRole.user:
        return "user";
    }
  }

  String userTypeToString(UserType type) {
    switch (type) {
      case UserType.individuals:
        return "INDIVIDUALS";
      case UserType.companies:
        return "COMPANIES";
      case UserType.normal:
        return "NORMAL";
    }
  }

  UserRole toUserRole(String role) {
    switch (role) {
      case "프로그래머":
        return UserRole.programmer;
      case "기획자":
        return UserRole.planner;
      case "마케터":
        return UserRole.marketer;
      case "디자이너":
        return UserRole.designer;
      case "퍼블리셔":
        return UserRole.publisher;
      case "데이터 분석":
        return UserRole.analyst;
      case "서비스 운영":
        return UserRole.operator;
      case "PM":
        return UserRole.pm;
      case "QA":
        return UserRole.qa;
      case "CS":
        return UserRole.cs;
      default:
        return UserRole.programmer;
    }
  }

  UserType toUserType(String type) {
    switch (type) {
      case "1인 개발자":
        return UserType.individuals;
      case "기업":
        return UserType.companies;
      default:
        return UserType.individuals;
    }
  }

  String postCategoryToString(PostCategory category) {
    switch (category) {
      case PostCategory.game:
        return "게임";
      case PostCategory.travel:
        return "여행";
      case PostCategory.developerTool:
        return "개발 도구";
      case PostCategory.health:
        return "건강";
      case PostCategory.education:
        return "교육";
      case PostCategory.finance:
        return "금융";
      case PostCategory.weather:
        return "날씨";
      case PostCategory.news:
        return "뉴스";
      case PostCategory.books:
        return "도서";
      case PostCategory.life:
        return "생활";
      case PostCategory.business:
        return "사업";
      case PostCategory.photography:
        return "사진";
      case PostCategory.social:
        return "사회";
      case PostCategory.shopping:
        return "쇼핑";
      case PostCategory.entertainment:
        return "엔터테인먼트";
      case PostCategory.sports:
        return "스포츠";
      case PostCategory.utility:
        return "유틸리티";
      case PostCategory.food:
        return "음식";
      case PostCategory.music:
        return "음악";
      case PostCategory.medical:
        return "의료";
      case PostCategory.magazine:
        return "매거진";
      case PostCategory.etc:
        return "기타";
    }
  }
}
