import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// Important: Run build_runner after creating/modifying these:
// flutter pub run build_runner build --delete-conflicting-outputs

part 'models.g.dart'; // Hive will generate this file

@HiveType(typeId: 0)
class PersonNodeData extends HiveObject {
  // Extend HiveObject for easier updates
  @HiveField(0)
  String name;

  @HiveField(1)
  int iconCodePoint; // Store icon codepoint

  @HiveField(2)
  String? notes; // Add fields as needed

  // Store icon data using its code point
  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');

  PersonNodeData({required this.name, required IconData icon, this.notes})
    : iconCodePoint = icon.codePoint;
}

// Simplified structure for storing graph nodes in Hive
@HiveType(typeId: 1)
class StoredNode extends HiveObject {
  @HiveField(0)
  String uniqueId; // Internal ID for graphview

  @HiveField(1)
  String valueKeyString; // Store the ValueKey's string value

  StoredNode({required this.uniqueId, required this.valueKeyString});

  ValueKey get valueKey => ValueKey(valueKeyString);
}

// Simplified structure for storing graph edges in Hive
@HiveType(typeId: 2)
class StoredEdge extends HiveObject {
  @HiveField(0)
  String sourceNodeId; // Use StoredNode uniqueId

  @HiveField(1)
  String destinationNodeId; // Use StoredNode uniqueId

  StoredEdge({required this.sourceNodeId, required this.destinationNodeId});
}
