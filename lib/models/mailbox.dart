class Mailbox {
  final String id;
  final String name;
  final String password;
  final String domainId;
  final DateTime modifiedAt;
  final String description;

  Mailbox({
    required this.id,
    required this.name,
    required this.password,
    required this.domainId,
    required this.modifiedAt,
    required this.description,
  });

  factory Mailbox.fromJson(Map<String, dynamic> json, {String? docID}) {
    return Mailbox(
      id: docID != null ? docID : json['id'],
      name: json['name'],
      password: json['password'],
      domainId: json['domain_id'],
      modifiedAt: DateTime.parse(json['modifiedAt']),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'password': password,
      'domain_id': domainId,
      'modifiedAt': modifiedAt.toIso8601String(),
      'description': description,
    };
  }
}
