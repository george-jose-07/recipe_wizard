// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeModelAdapter extends TypeAdapter<RecipeModel> {
  @override
  final int typeId = 0;

  @override
  RecipeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeModel(
      title: fields[0] as String,
      ingredients: (fields[1] as List).cast<String>(),
      instructions: (fields[2] as List).cast<String>(),
      fav: fields[4] as bool,
      description: fields[5] as String,
      allergens: (fields[6] as List).cast<String>(),
      servings: fields[7] as String,
      id: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.ingredients)
      ..writeByte(2)
      ..write(obj.instructions)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.fav)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.allergens)
      ..writeByte(7)
      ..write(obj.servings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
