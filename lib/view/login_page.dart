
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../services/auth_service.dart';
// import '../providers/theme_provider.dart';
// import 'schedule_page.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _authService = AuthService();

//   bool _isLoading = false;
//   bool _obscurePassword = true;
//   String? _errorMessage;
//   bool _rememberMe = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadSavedCredentials();
//   }

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   // Tải thông tin đăng nhập đã lưu (nếu có)
//   Future<void> _loadSavedCredentials() async {
//     // Có thể load username đã lưu từ SharedPreferences
//     final userInfo = await _authService.getUserInfo();
//     if (userInfo['username']?.isNotEmpty == true) {
//       setState(() {
//         _usernameController.text = userInfo['username']!;
//       });
//     }
//   }

//   // Xử lý đăng nhập
//   Future<void> _login() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//         _errorMessage = null;
//       });

//       try {
//         final result = await _authService.login(
//           _usernameController.text.trim(),
//           _passwordController.text,
//         );

//         if (result['success']) {
//           // In thông tin token để debug
//           await _authService.printTokenInfo();

//           // Đăng nhập thành công
//           if (mounted) {
//             // Hiển thị thông báo thành công
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Row(
//                   children: [
//                     Icon(Icons.check_circle, color: Colors.white),
//                     SizedBox(width: 8),
//                     Text('Đăng nhập thành công!'),
//                   ],
//                 ),
//                 backgroundColor: Colors.green,
//                 duration: Duration(seconds: 2),
//               ),
//             );

//             // Chuyển sang SchedulePage
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => SchedulePage()),
//             );
//           }
//         } else {
//           // Đăng nhập thất bại
//           setState(() {
//             _errorMessage = result['message'];
//           });
//         }
//       } catch (e) {
//         setState(() {
//           _errorMessage = 'Lỗi không xác định. Vui lòng thử lại';
//         });
//         print('Login exception: $e');
//       } finally {
//         if (mounted) {
//           setState(() {
//             _isLoading = false;
//           });
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);

//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: EdgeInsets.all(24),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   // Logo/Icon
//                   Container(
//                     padding: EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: Colors.blue.shade50,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       Icons.school_rounded,
//                       size: 80,
//                       color: Colors.blue,
//                     ),
//                   ),
//                   SizedBox(height: 32),

//                   // Title
//                   Text(
//                     'Lịch Học',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Đăng nhập để xem lịch học của bạn',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//                   ),
//                   SizedBox(height: 48),

//                   // Username Field
//                   TextFormField(
//                     controller: _usernameController,
//                     enabled: !_isLoading,
//                     decoration: InputDecoration(
//                       labelText: 'Tên đăng nhập',
//                       hintText: 'Nhập mã sinh viên hoặc email',
//                       prefixIcon: Icon(Icons.person_outline),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       filled: true,
//                       fillColor: themeProvider.isDarkMode
//                           ? Colors.grey[850]
//                           : Colors.grey[50],
//                     ),
//                     keyboardType: TextInputType.emailAddress,
//                     textInputAction: TextInputAction.next,
//                     validator: (value) {
//                       if (value == null || value.trim().isEmpty) {
//                         return 'Vui lòng nhập tên đăng nhập';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 16),

//                   // Password Field
//                   TextFormField(
//                     controller: _passwordController,
//                     enabled: !_isLoading,
//                     obscureText: _obscurePassword,
//                     decoration: InputDecoration(
//                       labelText: 'Mật khẩu',
//                       hintText: 'Nhập mật khẩu',
//                       prefixIcon: Icon(Icons.lock_outline),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _obscurePassword
//                               ? Icons.visibility_off_outlined
//                               : Icons.visibility_outlined,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _obscurePassword = !_obscurePassword;
//                           });
//                         },
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       filled: true,
//                       fillColor: themeProvider.isDarkMode
//                           ? Colors.grey[850]
//                           : Colors.grey[50],
//                     ),
//                     textInputAction: TextInputAction.done,
//                     onFieldSubmitted: (_) => _login(),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Vui lòng nhập mật khẩu';
//                       }
//                       if (value.length < 6) {
//                         return 'Mật khẩu phải có ít nhất 6 ký tự';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 12),

//                   // Remember Me & Forgot Password
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Checkbox(
//                             value: _rememberMe,
//                             onChanged: _isLoading
//                                 ? null
//                                 : (value) {
//                                     setState(() {
//                                       _rememberMe = value ?? false;
//                                     });
//                                   },
//                           ),
//                           Text('Ghi nhớ đăng nhập'),
//                         ],
//                       ),
//                       TextButton(
//                         onPressed: _isLoading
//                             ? null
//                             : () {
//                                 // TODO: Implement forgot password
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text(
//                                       'Vui lòng liên hệ phòng đào tạo để đặt lại mật khẩu',
//                                     ),
//                                   ),
//                                 );
//                               },
//                         child: Text('Quên mật khẩu?'),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 8),

//                   // Error Message
//                   if (_errorMessage != null)
//                     Container(
//                       margin: EdgeInsets.only(bottom: 16),
//                       padding: EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.red.shade50,
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: Colors.red.shade200),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.error_outline,
//                             color: Colors.red,
//                             size: 20,
//                           ),
//                           SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               _errorMessage!,
//                               style: TextStyle(
//                                 color: Colors.red.shade700,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.close, size: 18),
//                             padding: EdgeInsets.zero,
//                             constraints: BoxConstraints(),
//                             onPressed: () {
//                               setState(() {
//                                 _errorMessage = null;
//                               });
//                             },
//                           ),
//                         ],
//                       ),
//                     ),

//                   // Login Button
//                   ElevatedButton(
//                     onPressed: _isLoading ? null : _login,
//                     style: ElevatedButton.styleFrom(
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       elevation: 2,
//                     ),
//                     child: _isLoading
//                         ? SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 Colors.white,
//                               ),
//                             ),
//                           )
//                         : Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(Icons.login),
//                               SizedBox(width: 8),
//                               Text(
//                                 'Đăng nhập',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                   ),
//                   SizedBox(height: 16),

//                   // Divider
//                   Row(
//                     children: [
//                       Expanded(child: Divider()),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 16),
//                         child: Text(
//                           'HOẶC',
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                       Expanded(child: Divider()),
//                     ],
//                   ),
//                   SizedBox(height: 16),

//                   // Skip Login (Offline Mode)
//                   OutlinedButton.icon(
//                     onPressed: _isLoading
//                         ? null
//                         : () {
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => SchedulePage(),
//                               ),
//                             );
//                           },
//                     icon: Icon(Icons.offline_bolt),
//                     label: Text('Xem lịch offline'),
//                     style: OutlinedButton.styleFrom(
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 24),

//                   // Footer
//                   Text(
//                     'Bằng việc đăng nhập, bạn đồng ý với\nĐiều khoản sử dụng và Chính sách bảo mật',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'An Tâm Login UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto', // Sử dụng font mặc định hoặc thay thế bằng Google Fonts nếu muốn
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _rememberMe = false;

  // Màu chủ đạo lấy từ hình ảnh (Xanh dương đậm)
  final Color _primaryColor = const Color(0xFF2563EB);
  final Color _backgroundColor = const Color(0xFFF8FAFC);
  final Color _borderColor = const Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- PHẦN HEADER (LOGO) ---
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: _primaryColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'An Tâm',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Chăm sóc Cha Mẹ từ xa',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 32),

                // --- PHẦN CARD ĐĂNG NHẬP ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Đăng nhập',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Input Email
                      _buildLabel('Email'),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: _inputDecoration(
                          hint: 'your.email@example.com',
                          prefixIcon: Icons.email_outlined,
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),

                      // Input Mật khẩu
                      _buildLabel('Mật khẩu'),
                      const SizedBox(height: 8),
                      TextFormField(
                        obscureText: _obscurePassword,
                        decoration: _inputDecoration(
                          hint: '••••••••',
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Ghi nhớ & Quên mật khẩu
                      Row(
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: _rememberMe,
                              activeColor: _primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: BorderSide(color: Colors.grey[400]!),
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Ghi nhớ đăng nhập',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Quên mật khẩu?',
                              style: TextStyle(
                                color: _primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Nút Đăng nhập
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Đăng nhập',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Divider "hoặc"
                      Row(
                        children: [
                          Expanded(child: Divider(color: _borderColor)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'hoặc',
                              style: TextStyle(color: Colors.grey[500], fontSize: 13),
                            ),
                          ),
                          Expanded(child: Divider(color: _borderColor)),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Nút Social (Google & Facebook)
                      Row(
                        children: [
                          Expanded(
                            child: _buildSocialButton(
                              text: 'Google',
                              iconAsset: 'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
                              isGoogle: true, // Dùng để xử lý hiển thị ảnh mạng
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildSocialButton(
                              text: 'Facebook',
                              iconAsset: 'https://upload.wikimedia.org/wikipedia/commons/b/b8/2021_Facebook_icon.svg',
                              isGoogle: false,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Chưa có tài khoản? ',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Đăng ký ngay',
                        style: TextStyle(
                          color: _primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget hiển thị Label phía trên Input
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  // Cấu hình Style cho Input
  InputDecoration _inputDecoration({
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      prefixIcon: Icon(prefixIcon, color: Colors.grey[500], size: 20),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _primaryColor, width: 1.5),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  // Widget nút Social
  Widget _buildSocialButton({
    required String text,
    required String iconAsset,
    required bool isGoogle,
  }) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: _borderColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Vì đây là demo, ta dùng Icon thay thế nếu không tải được ảnh,
          // hoặc dùng Image.network đơn giản.
          // Trong dự án thật bạn nên dùng flutter_svg và file asset local.
          isGoogle
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: Image.network(
                     'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png',
                     errorBuilder: (context, error, stackTrace) => 
                        const Icon(Icons.g_mobiledata, color: Colors.red),
                  ),
                )
              : const Icon(Icons.facebook, color: Color(0xFF1877F2), size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}