
class Host {
  static const String baseDevUrl = 'http://dev.testusserver.site';
  static const String baseProdUrl = 'https://main.testusserver.site';
}

class AuthApi {
  static const String signup = '/api/v1/auth/register';
  static const String delete = '/api/v1/auth/delete';
  static const String login = '/api/v1/auth/login';
  static const String authLogin = '/api/v1/auth/authLogin';
  static const String authSignup = '/api/v1/auth/authSignup';
  static const String refreshToken = '/api/v1/auth/refreshToken';
  static const String autoLogin = '/api/v1/auth/autoLogin';
  static const String updatePassword = '/api/v1/auth/updatePassword';
  static const String changePassword = '/api/v1/auth/changePassword';
  static const String logout = '/api/v1/auth/logout';
  static const String findEmail = '/api/v1/auth/findEmail';
  static const String findPassword = '/api/v1/auth/findPassword';
  static const String verifyOtp = '/api/v1/auth/verifyOtp';
}

class UserApi {
  static const String update = '/api/v1/user/update';
  static const String getUserById = '/api/v1/user/getUserById';
  static const String getUsersByIds = '/api/v1/user/getUsersByIds';
  static const String getUserByEmail = '/api/v1/user/getUserByEmail';
  static const String getUserByNickname = '/api/v1/user/getUserByNickname';
  static const String getAllUsers = '/api/v1/user/getAllUsers';
  static const String isNicknameAvailable = '/api/v1/user/isNicknameAvailable';
  static const String isEmailAvailable = '/api/v1/user/isEmailAvailable';
  static const String isPasswordValid = '/api/v1/user/isPasswordValid';
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
  static const String searchPost = '/api/v1/post/searchPosts';
}

class RecruitPostApi {
  static const String createRecruitPost = '/api/v1/post/recruit/createRecruitPost';
  static const String update = '/api/v1/post/recruit/updateRecruitPost';
  static const String end = '/api/v1/post/recruit/endRecruitPost';
  static const String delete = '/api/v1/post/recruit/deleteRecruitPost';
  static const String getPostById = '/api/v1/post/recruit/getRecruitPostById';
  static const String getPostsByTitle = '/api/v1/post/recruit/getRecruitPostByTitle';
  static const String getPostsPagination = '/api/v1/post/recruit/getRecruitPostPagination';
  static const String getUserRecruitmentPosts = '/api/v1/post/recruit/getUserRecruitPosts';
  static const String getAppRecruitPosts = '/api/v1/post/recruit/getAppRecruitPosts';
  static const String getRecruitApplicationsByPostId = '/api/v1/post/recruit/getRecruitApplicationsByPostId';
}

class PromotionApi {
  static const String createPromotionPost = '/api/v1/post/promotion/createPromotionPost';
  static const String update = '/api/v1/post/promotion/updatePromotionPost';
  static const String delete = '/api/v1/post/promotion/deletePromotionPost';
  static const String getPostById = '/api/v1/post/promotion/getPromotionPostById';
  static const String getPostsByTitle = '/api/v1/post/promotion/getPromotionPostByTitle';
  static const String getPostsPagination = '/api/v1/post/promotion/getPromotionPostPagination';
  static const String getUserRecruitmentPosts = '/api/v1/post/promotion/getUserPromotionPosts';
}

class SideProjectApi { // /api/v1/side-project
  static const String upsertPost = '/api/v1/side-project/upsertSideProjectPost';
  static const String updatePost = '/api/v1/side-project/updateSideProjectPost';
  static const String getPostByPostId = '/api/v1/side-project/getSideProjectPostById';
  static const String getUserPostsByUserId = '/api/v1/side-project/getUserSideProjects';
  static const String getPostPagination = '/api/v1/side-project/getSideProjectPagination';
  static const String getPostAppUsers = '/api/v1/side-project/getSideProjectAppUsers';
}

class CoffeeChatApi { // /api/v1/coffee-chat

}

class ApplicationApi {
  static const String findByUserId = '/api/v1/application/findByUserId';
  static const String application = '/api/v1/application/apply'; // 테스터 신청
  static const String update = '/api/v1/application/update';
  static const String cancel = '/api/v1/application/cancelAppUser';// 테스터 신청 수정
  static const String acceptUser = '/api/v1/application/acceptUser';
  static const String rejectUser = '/api/v1/application/rejectUser';
  static const String getRecruitApplications = '/api/v1/application/getRecruitApplications';
  static const String getTesterReviewsByAppIds = '/api/v1/application/getTesterReviewsByAppIds';
}

class ReviewApi {
  static const String addUserReview = '/api/v1/review/addUserReview';
  static const String addRecruitReview = '/api/v1/review/addRecruitReview';
  static const String addPromotionReview = '/api/v1/review/addPromotionReview';
  static const String getUserReview = '/api/v1/review/getUserReview';
  static const String getReviewByPostId = '/api/v1/review/getReviewByPostId';
  static const String getReviewByUserId = '/api/v1/review/getReviewByUserId';
  static const String getReviewByTesters = '/api/v1/review/getReviewByTesters';
  static const String getReviewByNickname = '/api/v1/review/getReviewByNickname';
  static const String getReviewByPostReviewId = '/api/v1/review/getReviewByPostReviewId';
  static const String getReviewByUserReviewId = '/api/v1/review/getReviewByUserReviewId';
  static const String requestReviewInitData = '/api/v1/review/requestReviewInitData';
}

class MessageApi {
  static const String requestRoomList = '/api/v1/message/getRoomList';
  static const String requestRoomInfoById = '/api/v1/message/getRoomById';
  static const String requestMessageByRoomId = '/api/v1/message/getMessageByRoomId';
  static const String requestMessageByPostId = '/api/v1/message/getMessageByPostId';
  static const String resetUnreadCount = '/api/v1/message/resetUnreadCount';
  static const String deleteRoomMember = '/api/v1/message/deleteRoomMember';
}

class JobApi {
  static const String jobGetApplications = '/api/v1/jobState/jobApplicationsById';
  static const String jobGetInitPosts = '/api/v1/jobState/jobInitPosts';
  static const String jobGetUserPosts = '/api/v1/jobState/jobInitUserPosts';
}

class FirebaseApi {
  static const String createToken = '/api/v1/firebase/createToken';
  static const String updateToken = '/api/v1/firebase/updateToken';
  static const String deleteToken = '/api/v1/firebase/removeToken';
}

class PurchaseApi {
  static const String eventLog = '/api/v1/purchase/debug/eventLog';
  static const String errorLog = '/api/v1/purchase/debug/errorLog';
  static const String refresh = '/api/v1/purchase/refresh';
  static const String verifyPurchaseAOS = '/api/v1/purchase/purchaseAOS';
  static const String verifyPurchaseIOS = '/api/v1/purchase/purchaseIOS';
  static const String getPurchaseList = '/api/v1/purchase/subscribes';
}