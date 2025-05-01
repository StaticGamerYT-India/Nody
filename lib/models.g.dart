// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonNodeDataAdapter extends TypeAdapter<PersonNodeData> {
  @override
  final int typeId = 0;

  @override
  PersonNodeData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonNodeData(
      name: fields[0] as String,
      icon: IconData(
        fields[1] as int,
        fontFamily: 'MaterialIcons',
      ), // Corrected icon loading
      notes: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PersonNodeData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.iconCodePoint) // Write iconCodePoint
      ..writeByte(2)
      ..write(obj.notes);
  }
}
