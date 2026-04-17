// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:tithi_gadhi/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:tithi_gadhi/features/auth/presentation/cubit/auth_cubit.dart';
// import 'package:tithi_gadhi/features/auth/presentation/cubit/auth_state.dart';
// import '../../../../core/di/injection.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => getIt<AuthBloc>(),
//       child: Scaffold(
//         appBar: AppBar(title: const Text('Login')),
//         body: BlocConsumer<AuthBloc, AuthState>(
//           listener: (context, state) {
//             state.maybeWhen(
//               initial: () {},
//               loading: () {},
//               authenticated: () {
//                 context.go('/home'); // Ensure /home exists later
//               },
//               unauthenticated: () {},
//               error: (message) {
//                 ScaffoldMessenger.of(
//                   context,
//                 ).showSnackBar(SnackBar(content: Text(message)));
//               }, orElse: () {  },
//             );
//           },
//           builder: (context, state) {
//             final isLoading = state.maybeWhen(
//               loading: () => true,
//               orElse: () => false,
//             );

//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   TextField(
//                     controller: _emailController,
//                     decoration: const InputDecoration(labelText: 'Email'),
//                     keyboardType: TextInputType.emailAddress,
//                   ),
//                   const SizedBox(height: 16),
//                   TextField(
//                     controller: _passwordController,
//                     decoration: const InputDecoration(labelText: 'Password'),
//                     obscureText: true,
//                   ),
//                   const SizedBox(height: 32),
//                   if (isLoading)
//                     const CircularProgressIndicator()
//                   else
//                     ElevatedButton(
//                       onPressed: () {
//                         context.read<AuthBloc>().add(AuthEvent.googleLoginRequested());
//                       },
//                       child: const Text('Login'),
//                     ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
