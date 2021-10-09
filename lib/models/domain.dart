class Domain {
  final String id;
  final String name;
  final String serviceId;
  final DateTime modifiedAt;

  Domain({
    required this.id,
    required this.name,
    required this.serviceId,
    required this.modifiedAt,
  });

  factory Domain.fromJson(Map<String, dynamic> json, {String? docID}) {
    return Domain(
      id: docID != null ? docID : json['id'],
      name: json['name'],
      serviceId: json['service_id'],
      modifiedAt: DateTime.parse(json['modifiedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    print('');
    return {
      'name': name,
      'service_id': serviceId,
      'modifiedAt': modifiedAt.toIso8601String(),
    };
  }
}
