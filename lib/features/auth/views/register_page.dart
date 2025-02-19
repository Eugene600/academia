import 'package:academia/utils/validator/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:sliver_tools/sliver_tools.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _admissionController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formState = GlobalKey<FormState>();
  bool _showPassword = true;
  int _activeCurrentStep = 0;
  bool accepted = false;
  // are required to complete the form
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
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
            padding: EdgeInsets.all(12),
            sliver: MultiSliver(
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
                      ).animate().moveX(begin: -10, end: 3, duration: 500.ms),
                    ),
                  ],
                ),

                Text("Please fill in the following form,"),

                SizedBox(height: 22),
                // Form
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

                SizedBox(height: 22),
                Expanded(
                  child: FilledButton(
                    onPressed: () {},
                    child: Text("Register with Academia"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
