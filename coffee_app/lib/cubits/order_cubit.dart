import 'package:coffee_app/cubits/order_state.dart';
import 'package:coffee_app/repositories/order_repository.dart';
import 'package:cubit/cubit.dart';
import 'package:flutter/cupertino.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository orderRepo;

  OrderCubit({@required this.orderRepo})
      : assert(orderRepo != null),
        super(OrderInitial());

  void addToCart(int orderId, String productId, String productName, String size,
      int quantity, int unitPrice) async {
    emit(OrderProgress());
    if (orderId == -1) {
      var insertOrderResult = await orderRepo.insertOrder(quantity * unitPrice);
      if (insertOrderResult == -2) {
        await orderRepo.insertOrder(quantity * unitPrice).then((value) => {
              if (value != -1)
                {
                  insertDetail(insertOrderResult, productId, productName, size,
                      quantity, unitPrice)
                }
            });
      } else if (insertOrderResult != -1) {
        insertDetail(insertOrderResult, productId, productName, size, quantity,
            unitPrice);
      }
    } else {
      insertDetail(orderId, productId, productName, size, quantity, unitPrice);
    }
  }

  void insertDetail(int orderId, String productId, String productName,
      String size, int quantity, int unitPrice) async {
    var result = await orderRepo.insertOrderDetail(
        orderId, productId, productName, size, quantity, unitPrice);
    if (result == 200) {
      emit(OrderSuccess(count: 1));
    } else if (result == -2) {
      await orderRepo
          .insertOrderDetail(
              orderId, productId, productName, size, quantity, unitPrice)
          .then((value) => {
                if (value == 200)
                  {emit(OrderSuccess(count: 1))}
                else
                  {emit(OrderFailure())}
              });
    } else {
      emit(OrderFailure());
    }
  }

  void confirmOrder(String userId, int orderId, String couponId, int orderPrice) async {
    emit(OrderConfirmProgress());
    var result = await orderRepo.confirmCart(userId, orderId, couponId, orderPrice);
    if (result == 200) {
      emit(OrderConfirmSuccess());
    } else if (result == 401) {
      await orderRepo.confirmCart(userId, orderId, couponId, orderPrice).then((value) => {
            if (value == 200)
              {emit(OrderConfirmSuccess())}
            else
              {emit(OrderConfirmFailure())}
          });
    } else {
      emit(OrderConfirmFailure());
    }
  }
}
