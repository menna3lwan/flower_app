import 'package:customer_app/features/commerce/ui/product_details/manager/cubit/product_details_intent.dart';
import 'package:customer_app/features/commerce/ui/product_details/manager/cubit/product_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../../core/base/operation_state.dart';
import '../../../../../../core/result/result.dart';
import '../../../../domain/entities/product_details_entity.dart';
import '../../../../domain/use_cases/get_product_by_id_use_case.dart';

@injectable
class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetProductByIdUseCase _getProductByIdUseCase;

  ProductDetailsCubit(this._getProductByIdUseCase)
      : super(const ProductDetailsState(operationState: OperationState()));

  Future<void> doIntent(ProductDetailsIntent intent) async {
    switch (intent) {
      case GetProductByIdIntent():
        await _getProductById(intent);
        break;
    }
  }

  Future<void> _getProductById(GetProductByIdIntent intent) async {
    emit(state.copyWith(operationState: state.operationState.loading()));

    final response = await _getProductByIdUseCase(intent.id);

    switch (response) {
      case Success<ProductDetailsEntity>():
        emit(
          state.copyWith(
            operationState: state.operationState.success(response.data),
          ),
        );
        break;
      case ResultFailure<ProductDetailsEntity>():
        emit(
          state.copyWith(
            operationState: state.operationState.failed(response.failure),
          ),
        );
        break;
    }
  }
}
