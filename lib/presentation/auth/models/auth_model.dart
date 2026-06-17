class AuthModel {
  final String id;
  final String email;
  final String? name;
  final String? phone;
  final String? shopName;
  final String? shopLogo;
  final String? market;
  final String? subMarket;
  final String? country;
  final String? state;
  final String? address;
  final String? token;

  const AuthModel({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    this.shopName,
    this.shopLogo,
    this.market,
    this.subMarket,
    this.country,
    this.state,
    this.address,
    this.token,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString(),
      phone: json['phone']?.toString(),
      shopName: json['shop_name']?.toString(),
      shopLogo: json['shop_logo']?.toString(),
      market: json['market']?.toString(),
      subMarket: json['sub_market']?.toString(),
      country: json['country']?.toString(),
      state: json['state']?.toString(),
      address: json['address']?.toString(),
      token: json['token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'shop_name': shopName,
      'shop_logo': shopLogo,
      'market': market,
      'sub_market': subMarket,
      'country': country,
      'state': state,
      'address': address,
      'token': token,
    };
  }

  AuthModel copyWith({
    String? name,
    String? phone,
    String? shopName,
    String? shopLogo,
    String? address,
  }) {
    return AuthModel(
      id: id,
      email: email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      shopName: shopName ?? this.shopName,
      shopLogo: shopLogo ?? this.shopLogo,
      market: market,
      subMarket: subMarket,
      country: country,
      state: state,
      address: address ?? this.address,
      token: token,
    );
  }
}
