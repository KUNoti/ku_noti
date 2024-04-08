class FollowTagRequest {
  final String? tag;
  final String? token;
  const FollowTagRequest({this.tag, this.token});

  Map<String, dynamic> toJson() {
    return {
      'tag': tag,
      'user_token': token
    };
  }
}