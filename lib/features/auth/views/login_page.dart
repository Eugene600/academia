import 'package:academia/features/features.dart';
import 'package:academia/utils/router/router.dart';
import 'package:academia/utils/validator/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool _newToAcademia = false;

  @override
  void initState() {
    super.initState();
  }

  /// Notify the user on agreeing to the terms of service and
  /// privacy policy
  Future<bool> showTermsDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Just a minute'),
              content: Text(
                'By using this app, you agree to our Terms of Service and Privacy Policy.',
              ),
              actions: <Widget>[
                FilledButton(
                  child: Text('Agree'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ).animate(delay: 500.ms).shake(),
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            ).animate().moveY(
                  begin: -3,
                  end: 0,
                  duration: 500.ms,
                  curve: Curves.easeInOutCubic,
                );
          },
        ) ??
        false;
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
        if (state is NewAuthUserDetailsFetched) {
          context.pushNamed(AcademiaRouter.register);
          return;
        }
        if (state is AuthenticatedState) {
          return GoRouter.of(context).clearStackAndNavigate("dashboard");
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Form(
          key: _formState,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: true,
                snap: true,
                expandedHeight: 250,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    "Welcome to Academia",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontFamily: GoogleFonts.lora().fontFamily,
                        ),
                  ).animate().moveY(
                      duration: 2000.ms,
                      begin: -10,
                      end: 0,
                      curve: Curves.easeInOut),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(12),
                sliver: SliverPinnedHeader(
                  child: Column(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Lottie.asset(
                            "assets/lotties/identity.json",
                            repeat: false,
                            height: 160,
                          ),

                          // Headline
                          Flexible(
                            child: Text(
                              "Lets find you and set up things just the way you like",
                              style: Theme.of(context).textTheme.titleLarge,
                            )
                                .animate()
                                .moveX(begin: -10, end: 3, duration: 500.ms),
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

                      // Card
                      Card(
                        elevation: 0,
                        child: CheckboxListTile(
                          title: Text("Im new to Academia"),
                          value: _newToAcademia,
                          onChanged: (val) {
                            setState(() {
                              _newToAcademia = val!;
                            });
                          },
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
                          onPressed: () async {
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

                            final agreed = await showTermsDialog(context);

                            if (!context.mounted) return;
                            if (!agreed) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "You must agree to the terms of service and privacy policy",
                                  ),
                                  showCloseIcon: true,
                                  elevation: 12,
                                ),
                              );
                              return;
                            }

                            if (!_newToAcademia) {
                              return context.read<AuthBloc>().add(
                                    AuthenticationRequested(
                                      admno: _admissionController.text,
                                      password: _passwordController.text,
                                    ),
                                  );
                            }

                            context
                                .read<AuthBloc>()
                                .add(RegistrationEventRequested(
                                  admno: _admissionController.text,
                                  password: _passwordController.text,
                                ));
                          },
                          label: const Text("Continue to Academia"),
                        ).animate().fadeIn(curve: Curves.easeOutBack);
                      }),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(12),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          final Uri url = Uri.parse(
                            'https://github.com/IamMuuo/academia/blob/dev/LICENSE',
                          );
                          if (!await launchUrl(url)) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Failed to launch privacy and terms url, we have saved this incident ans will resolve it"),
                              ),
                            );
                            throw ("Failed to launch url");
                          }
                        },
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
