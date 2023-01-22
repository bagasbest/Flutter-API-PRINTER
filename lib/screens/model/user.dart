class User {
  final String id;
  final String userName;
  final String email;
  final String phoneNumber;
  final String userDomain;
  final String windowsUserAccount;
  final bool active;
  final String passwordHash;
  final String securityStamp;
  final int site;
  final String code;
  final String siteName;
  final String name;
  final DateTime businessDate;
  final bool isOpen;

  User({
    required this.id,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.userDomain,
    required this.windowsUserAccount,
    required this.active,
    required this.passwordHash,
    required this.securityStamp,
    required this.site,
    required this.code,
    required this.siteName,
    required this.name,
    required this.businessDate,
    required this.isOpen,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['Id'],
      userName: json['UserName'],
      email: json['Email'],
      phoneNumber: json['PhoneNumber'],
      userDomain: json['UserDomain'],
      windowsUserAccount: json['WindowsUserAccount'],
      active: json['Active'],
      passwordHash: json['PasswordHash'],
      securityStamp: json['SecurityStamp'],
      site: json['Site'],
      code: json['Code'],
      siteName: json['SiteName'],
      name: json['Name'],
      businessDate: DateTime.parse(json['BusinessDate']),
      isOpen: json['isOpen'],
    );
  }
}
