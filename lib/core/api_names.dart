
class Host {
  // static const String baseDevUrl = 'http://192.168.45.100:3000';
  // static const String baseDevUrl = 'http://172.30.1.100:3000';
  // static const String baseDevUrl = 'http://testusserver.ddns.net:3000';
  static const String baseDevUrl = 'http://dev.testusserver.xyz';
}

class AuthApi {
  static const String signup = '/api/v1/auth/register';
  static const String delete = '/api/v1/auth/delete';
  static const String login = '/api/v1/auth/login';
  static const String authLogin = '/api/v1/auth/authLogin';
  static const String authSignup = '/api/v1/auth/authSignup';
}

class UserApi {
  static const String update = '/api/v1/user/update';
  static const String getUserById = '/api/v1/user/getUserById';
  static const String getUsersByIds = '/api/v1/user/getUsersByIds';
  static const String getUserByEmail = '/api/v1/user/getUserByEmail';
  static const String getUserByNickname = '/api/v1/user/getUserByNickname';
  static const String updatePassword = '/api/v1/user/changePassword';
  static const String getAllUsers = '/api/v1/user/getAllUsers';
  static const String isNicknameAvailable = '/api/v1/user/isNicknameAvailable';
  static const String isEmailAvailable = '/api/v1/user/isEmailAvailable';
  static const String isPasswordValid = '/api/v1/user/isPasswordValid';
  // static const String updateUserInfo = '/api/v1/user/updateUserInfo';
  static const String updateUserInfoWithImg = '/api/v1/user/updateUserInfoWithImg';
}

class ImageApi {
  static const String registerPostImg = '/api/v1/images/uploads';
  static const String updatePostImg = '/api/v1/images/update';
  static const String deletePostImg = '/api/v1/images/delete';
}

class PostApi {
  static const String getInitPosts = '/api/v1/post/getInitPosts';
  static const String getUserInitData = '/api/v1/post/getUserInitPosts';
}

class RecruitPostApi {
  static const String createRecruitPost = '/api/v1/post/createRecruitPost';
  static const String update = '/api/v1/post/updateRecruitPost';
  static const String delete = '/api/v1/post/deleteRecruitPost';
  static const String getPostById = '/api/v1/post/getRecruitPostById';
  static const String getPostsByTitle = '/api/v1/post/getRecruitPostByTitle';
  static const String getPostsPagination = '/api/v1/post/getRecruitPostPagination';
  static const String getUserRecruitmentPosts = '/api/v1/post/getUserRecruitPosts';
  static const String getAppRecruitPosts = '/api/v1/post/getAppRecruitPosts';
}

class PromotionApi {
  static const String createPromotionPost = '/api/v1/post/createPromotionPost';
  static const String update = '/api/v1/post/updatePromotionPost';
  static const String delete = '/api/v1/post/deletePromotionPost';
  static const String getPostById = '/api/v1/post/getPromotionPostById';
  static const String getPostsByTitle = '/api/v1/post/getPromotionPostByTitle';
  static const String getPostsPagination = '/api/v1/post/getPromotionPostPagination';
  static const String getUserRecruitmentPosts = '/api/v1/post/getUserPromotionPosts';
}

class ApplicationApi {
  // static const String findByPostId = '/api/v1/application/findByPostId';
  static const String findByUserId = '/api/v1/application/findByUserId';
  // static const String findByUserNickname = '/api/v1/application/findByUserNickname';
  // static const String findPostListByUserId = '/api/v1/application/findPostListByUserId';
  // static const String getAppUserListInPost = '/api/v1/application/getAllUserListInPost';
  static const String application = '/api/v1/application/apply'; // 테스터 신청
  static const String update = '/api/v1/application/update';
  static const String cancel = '/api/v1/application/cancelAppUser';// 테스터 신청 수정
  static const String acceptUser = '/api/v1/application/acceptUser';
  static const String rejectUser = '/api/v1/application/rejectUser';
  // static const String getAppPostList = '/api/v1/application/getAppPostList';
}

class ReviewApi {
  static const String create = '/api/v1/review/create';
  static const String update = '/api/v1/review/update';
  static const String delete = '/api/v1/review/delete';
  static const String getReviewsById = '/api/v1/review/getReviewsById';
  static const String gatUsersReviewAverage = '/api/v1/review/getUserReviewAverage';
}

class MessageApi {}

class JobApi {
  static const String jobGetApplications = '/api/v1/jobState/jobApplicationsById';
  static const String jobGetInitPosts = '/api/v1/jobState/jobInitPosts';
  static const String jobGetUserPosts = '/api/v1/jobState/jobInitUserPosts';
}