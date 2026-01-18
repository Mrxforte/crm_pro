import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../models/tool.dart';
import '../providers/auth_provider.dart';

class ToolProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Tool> _tools = [];

  List<Tool> get tools => _tools;

  Future<List<Tool>> fetchTools({String? projectId}) async {
    try {
      Query query = _firestore.collection('tools');

      // Filter by project if specified (for brigadiers)
      if (projectId != null) {
        query = query.where('currentProjectId', isEqualTo: projectId);
      }

      final querySnapshot = await query.get();
      _tools = querySnapshot.docs
          .map((doc) => Tool.fromFirestore(doc))
          .toList();
      notifyListeners();
      return _tools;
    } catch (e) {
      print('Error fetching tools: $e');
      return [];
    }
  }

  Future<bool> canAddTool(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Future.value(authProvider.user?.canManageTools(null) ?? false);
  }

  Future<String?> addTool(Tool tool, BuildContext context) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;

      if (user == null || !user.canManageTools(tool.currentProjectId)) {
        return 'Permission denied';
      }

      // Add creator info
      final toolData = tool.toFirestore();
      toolData['createdBy'] = user.uid;
      toolData['createdByName'] = user.name ?? user.email;

      await _firestore.collection('tools').doc(tool.id).set(toolData);

      // Add initial location history
      final historyEntry = {
        'location': tool.currentLocation,
        'projectId': tool.currentProjectId,
        'date': Timestamp.fromDate(DateTime.now()),
        'notes': 'Tool created',
        'changedBy': user.uid,
        'changedByName': user.name ?? user.email,
      };

      await _firestore.collection('tools').doc(tool.id).update({
        'locationHistory': FieldValue.arrayUnion([historyEntry]),
      });

      _tools.add(tool);
      notifyListeners();
      return null;
    } catch (e) {
      print('Error adding tool: $e');
      return 'Failed to add tool';
    }
  }

  Future<String?> updateTool(Tool tool, BuildContext context) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;

      if (user == null || !user.canManageTools(tool.currentProjectId)) {
        return 'Permission denied';
      }

      tool.updatedAt = DateTime.now();
      await _firestore
          .collection('tools')
          .doc(tool.id)
          .update(tool.toFirestore());

      final index = _tools.indexWhere((t) => t.id == tool.id);
      if (index != -1) {
        _tools[index] = tool;
        notifyListeners();
      }
      return null;
    } catch (e) {
      print('Error updating tool: $e');
      return 'Failed to update tool';
    }
  }

  Future<String?> deleteTool(String toolId, BuildContext context) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;

      if (user == null || !user.isAdmin) {
        return 'Only admin can delete tools';
      }

      await _firestore.collection('tools').doc(toolId).delete();
      _tools.removeWhere((tool) => tool.id == toolId);
      notifyListeners();
      return null;
    } catch (e) {
      print('Error deleting tool: $e');
      return 'Failed to delete tool';
    }
  }

  Future<String?> transferTool({
    required String toolId,
    required String newProjectId,
    required String newLocation,
    String? notes,
    required BuildContext context,
  }) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;

      if (user == null) {
        return 'Authentication required';
      }

      // Get the tool
      final toolDoc = await _firestore.collection('tools').doc(toolId).get();
      if (!toolDoc.exists) {
        return 'Tool not found';
      }

      final tool = Tool.fromFirestore(toolDoc);

      // Check permissions
      if (!user.canManageTools(tool.currentProjectId) ||
          !user.canManageTools(newProjectId)) {
        return 'Permission denied for transfer';
      }

      // For brigadier: check if tool is in assigned project
      if (user.isBrigadier) {
        if (tool.currentProjectId != user.assignedProjectId) {
          return 'You can only transfer tools from your assigned project';
        }
      }

      final historyEntry = {
        'location': newLocation,
        'projectId': newProjectId,
        'date': Timestamp.fromDate(DateTime.now()),
        'notes': notes ?? 'Tool transferred',
        'changedBy': user.uid,
        'changedByName': user.name ?? user.email,
      };

      // Update tool
      await _firestore.collection('tools').doc(toolId).update({
        'currentLocation': newLocation,
        'currentProjectId': newProjectId,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
        'locationHistory': FieldValue.arrayUnion([historyEntry]),
      });

      // Update tool in local list
      tool.currentLocation = newLocation;
      tool.currentProjectId = newProjectId;
      tool.locationHistory.add(LocationHistory.fromMap(historyEntry));

      final index = _tools.indexWhere((t) => t.id == toolId);
      if (index != -1) {
        _tools[index] = tool;
        notifyListeners();
      }

      return null;
    } catch (e) {
      print('Error transferring tool: $e');
      return 'Transfer failed: $e';
    }
  }
}
