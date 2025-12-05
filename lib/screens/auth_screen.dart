/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../models/user_model.dart';
import 'profile_screen.dart';

const Color mainGreen = Color(0xFF0F4D37);

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  // Controllers
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  String role = 'User';

  final _formKey = GlobalKey<FormState>();

  void login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
            emailCtrl.text.trim(),
            passCtrl.text.trim(),
          );
    }
  }

  void signUp() {
    if (_formKey.currentState!.validate()) {
      final user = User(
        name: nameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        role: role,
        password: passCtrl.text.trim(),
      );
      context.read<AuthCubit>().signup(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoggedIn) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => ProfileScreen(user: state.user)),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      backgroundColor: mainGreen,
                      child: Icon(Icons.volunteer_activism,
                          color: Colors.white, size: 40),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Fiha Khir",
                      style: TextStyle(
                        color: mainGreen,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text("Join our community platform",
                        style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(height: 35),

                    // Tabs
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isLogin = true),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isLogin ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                alignment: Alignment.center,
                                child: Text("Login",
                                    style: TextStyle(
                                        color: mainGreen,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isLogin = false),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: !isLogin ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                alignment: Alignment.center,
                                child: Text("Sign Up",
                                    style: TextStyle(
                                        color: mainGreen,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 35),

                    // Form fields
                    if (!isLogin)
                      TextFormField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person_outline),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        validator: (value) =>
                            !isLogin && value!.isEmpty ? 'Please enter your name' : null,
                      ),
                    if (!isLogin) const SizedBox(height: 15),

                    TextFormField(
                      controller: emailCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),

                    if (!isLogin)
                      TextFormField(
                        controller: phoneCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          prefixIcon: Icon(Icons.phone),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        validator: (value) =>
                            !isLogin && value!.isEmpty ? 'Please enter your phone' : null,
                      ),
                    if (!isLogin) const SizedBox(height: 15),

                    TextFormField(
                      controller: passCtrl,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                   if (!isLogin) const SizedBox(height: 15),

                    if (!isLogin)
                      DropdownButton<String>(
                        value: role,
                        items: ['User', 'Organization']
                            .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            role = value!;
                          });
                        },
                      ),
                    const SizedBox(height: 25),

                    state is AuthLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainGreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: isLogin ? login : signUp,
                              child: Text(
                                isLogin ? 'Login' : 'Sign Up',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                    const SizedBox(height: 30),
                    Divider(thickness: 1, color: Colors.grey[300]),
                    const SizedBox(height: 10),
                    Text(
                      "Quick demo login as:",
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                    const SizedBox(height: 15),
                    demoButton("Citizen"),
                    const SizedBox(height: 10),
                    demoButton("Organization"),
                    const SizedBox(height: 10),
                    demoButton("Admin"),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget demoButton(String text) {
  return SizedBox(
    width: double.infinity,
    height: 45,
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: mainGreen, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: Colors.white, // make it white to match design
      ),
      onPressed: () {
        // You can add demo login logic here
      },
      child: Text(
        text,
        style: TextStyle(
          color: mainGreen,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    ),
  );
}}*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../models/user_model.dart';
import 'profile_screen.dart';
import 'RoleSelectionScreen.dart';

const Color mainGreen = Color(0xFF0F4D37);

class AuthScreen extends StatefulWidget {
  final String initialRole;
  const AuthScreen({super.key, this.initialRole = 'User'});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  late String role;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    role = widget.initialRole; // Preselect role
  }

  void login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
            emailCtrl.text.trim(),
            passCtrl.text.trim(),
          );
    }
  }

  void signUp() {
    if (_formKey.currentState!.validate()) {
      final user = User(
        name: nameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        role: role,
        password: passCtrl.text.trim(),
      );
      context.read<AuthCubit>().signup(user);
    }
  }

  void forgotPassword() {
    // Add your forgot password logic here
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Forgot Password"),
        content: const Text("Password reset feature coming soon."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to RoleSelectionScreen
          },
        ),
     
      ),
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoggedIn) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => ProfileScreen(user: state.user)),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Circular logo
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: mainGreen,
                      child: Icon(
                        Icons.volunteer_activism,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Fiha Khir",
                      style: TextStyle(
                        color: mainGreen,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Join our community platform",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 30),

                    // Login / Sign Up Tabs
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isLogin = true),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isLogin ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                alignment: Alignment.center,
                                child: Text("Login",
                                    style: TextStyle(
                                        color: mainGreen,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isLogin = false),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: !isLogin ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                alignment: Alignment.center,
                                child: Text("Sign Up",
                                    style: TextStyle(
                                        color: mainGreen,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Name field (Sign Up)
                    if (!isLogin)
                      TextFormField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person_outline),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        validator: (value) =>
                            !isLogin && value!.isEmpty ? 'Please enter your name' : null,
                      ),
                    if (!isLogin) const SizedBox(height: 15),

                    // Email field
                    TextFormField(
                      controller: emailCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),

                    // Phone field (Sign Up)
                   // Phone field (Sign Up)
if (!isLogin)
  TextFormField(
    controller: phoneCtrl,
    keyboardType: TextInputType.phone,
    decoration: const InputDecoration(
      labelText: 'Phone',
      prefixIcon: Icon(Icons.phone),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    validator: (value) {
      if (!isLogin) {
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        }
        if (!RegExp(r'^(05|06|07)[0-9]{8}$').hasMatch(value)) {
          return 'Enter a valid phone (Ex: 0551234567)';
        }
      }
      return null;
    },
  ),
if (!isLogin) const SizedBox(height: 15),

                    // Password field
                    TextFormField(
                      controller: passCtrl,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Forgot Password (only for login)
                    if (isLogin)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: forgotPassword,
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(color: mainGreen),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),

                    // Login/Sign Up button
                    state is AuthLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainGreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () {
                                if (isLogin) {
                                  login();
                                } else {
                                  signUp();
                                }
                              },
                              child: Text(
                                isLogin ? 'Login' : 'Sign Up',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
