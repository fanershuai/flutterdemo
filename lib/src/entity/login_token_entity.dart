class LoginTokenEntity {
	int expiredAt;
	String token;

	LoginTokenEntity({this.expiredAt, this.token});

	LoginTokenEntity.fromJson(Map<String, dynamic> json) {
		expiredAt = json['expired_at'];
		token = json['token'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['expired_at'] = this.expiredAt;
		data['token'] = this.token;
		return data;
	}
}
