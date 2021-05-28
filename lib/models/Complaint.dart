import 'package:flutter_with_maps/models/user.dart';

class Complaint {
  String heading, complaint, status, createdOn, updatedOn;
  User user;

  Complaint(this.heading, this.complaint, this.status, this.createdOn,
      this.updatedOn, this.user);

  factory Complaint.fromJson(dynamic json) {
    if (json != null) {
      return Complaint(
          json['heading'] as String,
          json['complaint'] as String,
          json['status'] as String,
          json['created_on'] as String,
          json['updated_on'] as String,
          User.fromJson(json['user_id']));
    } else {
      return Complaint(null, null, null, null, null, null);
    }
  }
}
