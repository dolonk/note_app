import 'package:flutter/material.dart';
import 'package:note_app/features/auth/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/di/service_locator.dart';
import '../../../data_layer/domain/use_cases/auth_use_case.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Dashboard Screen")), body: Center(child: Column(
      children: [
        Text("Dashboard section"),
        ElevatedButton(onPressed: (){
          final AuthUseCase _authUseCase = sl<AuthUseCase>();
          _authUseCase.logout();
        }, child: Text("Log out"))
      ],
    )));
  }
}
