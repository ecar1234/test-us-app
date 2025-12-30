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
}
