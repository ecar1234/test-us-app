
class Host {
  static const String baseDevUrl = 'http://192.168.45.100:3000';
  // static const String baseDevUrl = 'http://172.30.1.100:3000';
  // static const String baseDevUrl = 'http://testusserver.ddns.net:3000';
}

class AuthApi {
  static const String signup = '/api/v1/auth/register';
  static const String delete = '/api/v1/auth/delete';
  static const String login = '/api/v1/auth/login';
}

class UserApi {
  static const String update = '/api/v1/user/update';
  static const String getUserById = '/api/v1/user/getUserById';
  static const String getUserByEmail = '/api/v1/user/getUserByEmail';
  static const String getUserByNickname = '/api/v1/user/getUserByNickname';
  static const String updatePassword = '/api/v1/user/changePassword';
  static const String getAllUsers = '/api/v1/user/getAllUsers';
  static const String isNicknameAvailable = '/api/v1/user/isNicknameAvailable';
  static const String isEmailAvailable = '/api/v1/user/isEmailAvailable';
  static const String isPasswordValid = '/api/v1/user/isPasswordValid';
}

class PostApi {
  static const String create = '/api/v1/post/create';
  static const String update = '/api/v1/post/update';
  static const String delete = '/api/v1/post/delete';
  static const String getPostById = '/api/v1/post/getPostById';
  static const String getPostsByTitle = '/api/v1/post/getPostsByTitle';
  static const String getInitPosts = '/api/v1/post/getInitPosts';
  static const String getWebPosts = '/api/v1/post/getWebPostsPagination';
  static const String getMobilePosts = '/api/v1/post/getMobilePostsPagination';
}

class ApplicationApi {
  // static const String findByPostId = '/api/v1/application/findByPostId';
  // static const String findByUserId = '/api/v1/application/findByUserId';
  // static const String findByUserNickname = '/api/v1/application/findByUserNickname';
  // static const String findPostListByUserId = '/api/v1/application/findPostListByUserId';
  // static const String getAppUserListInPost = '/api/v1/application/getAllUserListInPost';
  static const String applications = '/api/v1/application/applications'; // 테스터 신청
  static const String update = '/api/v1/application/update'; // 테스터 신청 수정
  static const String acceptUser = '/api/v1/application/acceptUser';
  static const String rejectUser = '/api/v1/application/rejectUser';
  // static const String getAppPostList = '/api/v1/application/getAppPostList';
}

class ReviewApi {}

class MessageApi {}