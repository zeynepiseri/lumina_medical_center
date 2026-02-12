import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/features/appointment/presentation/bloc/action/appointment_action_bloc.dart';
import 'package:lumina_medical_center/features/appointment/data/datasources/appointment_service.dart';
import 'package:lumina_medical_center/injection_container.dart';

class GlobalProviders extends StatelessWidget {
  final Widget child;

  const GlobalProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => sl<AppointmentActionBloc>())],
      child: child,
    );
  }
}
