import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/kappa_bloc.dart';
import '../bloc/kappa_state.dart';

class KappaUIListener<B extends KappaBloc<T>, T> extends StatelessWidget {
  final Widget child;
  final void Function(BuildContext context, T? data)? onSuccess;
  final void Function(BuildContext context, String message)? onError;

  const KappaUIListener({
    super.key,
    required this.child,
    this.onSuccess,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, KappaState<T>>(
      listener: (context, state) {
        if (state.status == KappaStatus.error) {
          final message = state.failure?.message ?? 'Lỗi không xác định';
          if (onError != null) {
            onError!(context, message);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message), backgroundColor: Colors.red),
            );
          }
        } else if (state.status == KappaStatus.success) {
          if (onSuccess != null) {
            onSuccess!(context, state.data);
          }
        }
      },
      child: child,
    );
  }
}
