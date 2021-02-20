// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CouponAdapter extends TypeAdapter<Coupon> {
  @override
  final int typeId = 0;

  @override
  Coupon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Coupon(
      couponId: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      image: fields[3] as String,
      sale: fields[4] as String,
      condition: fields[5] as int,
      status: fields[6] as int,
      startDate: fields[8] as String,
      createDate: fields[7] as String,
      expiryDate: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Coupon obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.couponId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.sale)
      ..writeByte(5)
      ..write(obj.condition)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.createDate)
      ..writeByte(8)
      ..write(obj.startDate)
      ..writeByte(9)
      ..write(obj.expiryDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CouponAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
