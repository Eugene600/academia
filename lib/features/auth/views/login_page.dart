import 'package:academia/features/features.dart';
import 'package:academia/utils/validator/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:sliver_tools/sliver_tools.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late AuthBloc authCubit = BlocProvider.of<AuthBloc>(context);
  final TextEditingController _admissionController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formState = GlobalKey<FormState>();
  bool _showPassword = true;

  @override
  void initState() {
    super.initState();
  }

  /// Validates the current sign in form
  /// Returns true if there are no errors otherwise
  /// it returns false to indicate an error
  bool validateForm() {
    return _formState.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              showCloseIcon: true,
              elevation: 12,
            ),
          );
          return;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Form(
          key: _formState,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                centerTitle: true,
                floating: true,
                snap: true,
                pinned: true,
                expandedHeight: 250,
                flexibleSpace: FlexibleSpaceBar(
                  background: const Image(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/school-of-athens.jpg"),
                  ),
                  centerTitle: true,
                  title: SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icons/academia.png",
                        ),
                        Text(
                          "Academia",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(12),
                sliver: SliverPinnedHeader(
                  child: Column(
                    spacing: 12,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Sign in",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Bootstrap.question_circle),
                          ),
                        ],
                      ),

                      const Text(
                        "Use your school admission number and school portal password to continue to Academia.",
                      ),

                      TextFormField(
                        controller: _admissionController,
                        textAlign: TextAlign.center,
                        maxLength: 7,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          AdmnoDashFormatter(),
                        ],
                        validator: (value) {
                          if (value?.length != 7) {
                            return "Please provide a valid admission number😡";
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUnfocus,
                        decoration: InputDecoration(
                          hintText: "Your school admission number",
                          label: const Text("Admission number"),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: _showPassword,
                        textAlign: TextAlign.center,
                        validator: (value) {
                          if ((value?.length ?? 0) < 3) {
                            return "Please provide a valid password 😡";
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              icon: Icon(_showPassword
                                  ? Bootstrap.eye
                                  : Bootstrap.eye_slash)),
                          hintText: "Your school portal password",
                          label: const Text("School Password"),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),

                      // Input buttons
                      BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                        if (state is AuthLoadingState) {
                          return Lottie.asset(
                            "assets/lotties/fetching.json",
                            height: 60,
                          );
                        }
                        return FilledButton.icon(
                          onPressed: () {
                            if (!_formState.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please ensure the form is filled appropriately",
                                  ),
                                ),
                              );
                              return;
                            }
                          },
                          label: const Text("Continue to Academia"),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(12),
                sliver: SliverFillRemaining(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text("Privacy and terms of service"),
                      ),
                      const SizedBox(height: 12)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
