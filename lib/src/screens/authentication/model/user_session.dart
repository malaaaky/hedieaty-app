class UserSession {
  static int? currentUserId;
  static String? currentUserEmail; // Optionally store the email for easier identification
  static String? currentUserName; // Optionally store the name of the user

  /// Set the current user's details
  static void setCurrentUser({
    required int id,
    String? email,
    String? name,
  }) {
    currentUserId = id;
    currentUserEmail = email;
    currentUserName = name;
  }

  /// Clear user session when logging out
  static void clearSession() {
    currentUserId = null;
    currentUserEmail = null;
    currentUserName = null;
  }
}
