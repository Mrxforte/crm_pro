import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { admin, brigadier, viewer }

class AppUser {
  String uid;
  String email;
  String? name;
  UserRole role;
  String? assignedProjectId; // For brigadiers only
  DateTime createdAt;
  DateTime updatedAt;

  AppUser({
    required this.uid,
    required this.email,
    this.name,
    required this.role,
    this.assignedProjectId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: doc.id,
      email: data['email'] ?? '',
      name: data['name'],
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == data['role'],
        orElse: () => UserRole.viewer,
      ),
      assignedProjectId: data['assignedProjectId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'role': role.toString().split('.').last,
      'assignedProjectId': assignedProjectId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  bool get isAdmin => role == UserRole.admin;
  bool get isBrigadier => role == UserRole.brigadier;
  bool get isViewer => role == UserRole.viewer;

  bool canManageTools(String? projectId) {
    if (isAdmin) return true;
    if (isBrigadier) {
      return assignedProjectId != null &&
          (projectId == null || projectId == assignedProjectId);
    }
    return false;
  }

  bool canManageProject(String projectId) {
    if (isAdmin) return true;
    if (isBrigadier) {
      return assignedProjectId == projectId;
    }
    return false;
  }
}
