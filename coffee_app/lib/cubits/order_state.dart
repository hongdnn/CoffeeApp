import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  OrderState get initialState => OrderInitial();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderProgress extends OrderState {}

class OrderSuccess extends OrderState {
   final int count;

   const OrderSuccess({@required this.count});
}

class OrderFailure extends OrderState {

  const OrderFailure();

}
