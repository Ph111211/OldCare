import 'package:flutter/material.dart';
import '../services/auth/auth_service.dart';
import '../viewmodels/auth.viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  AuthViewModel authViewModel = AuthViewModel(AuthService());
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _childPhoneController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _confimPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true; 
  bool _agreeToTerms = true; 
  // **ĐÃ SỬA:** Đặt mặc định là 'parent' (Bố mẹ) theo yêu cầu mới
  String _userType = 'parent'; 

  // Màu chủ đạo lấy từ hình ảnh (Xanh dương đậm)
  final Color _primaryColor = const Color(0xFF2563EB);
  final Color _backgroundColor = const Color(0xFFF8FAFC);
  final Color _borderColor = const Color(0xFFE2E8F0);

  // Widget cho tabs Con/Bố mẹ
  Widget _buildUserTypeTab(String type, String label) {
    bool isSelected = _userType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _userType = type;
          });
        },
        child: Container(
          // Logic màu sắc tab được chọn (Xanh đậm/Trắng)
          decoration: BoxDecoration(
            color: isSelected ? _primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: _primaryColor.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : _primaryColor, 
              ),
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
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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

  // Widget nút Social (Không thay đổi)
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

  // **Hàm xây dựng các trường form động**
  List<Widget> _buildFormFields() {
    List<Widget> fields = [];

    // 1. Họ và tên (Common)
    fields.add(_buildLabel('Họ và tên'));
    fields.add(const SizedBox(height: 8));
    fields.add(TextFormField(
      controller: _nameController,
      decoration: _inputDecoration(
        hint: 'Nguyễn Văn A',
        prefixIcon: Icons.person_outline,
      ),
      keyboardType: TextInputType.text,
    ));
    fields.add(const SizedBox(height: 20));


    if (_userType == 'child') {
      // Child form specific fields: Phone, Email
      fields.addAll([
        // 2. Input Số điện thoại
        _buildLabel('Số điện thoại'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _phoneController,
          decoration: _inputDecoration(
            hint: '0912 345 678',
            prefixIcon: Icons.phone_outlined,
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 20),

        // 3. Input Email
        _buildLabel('Email'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          decoration: _inputDecoration(
            hint: 'your.email@example.com',
            prefixIcon: Icons.email_outlined,
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
      ]);
    } else {
      // Parent form specific fields: Child Phone, Parent Phone (No Email)
      fields.addAll([
        // 2. Input Số điện thoại Con
        _buildLabel('Số điện thoại Con'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _childPhoneController,
          decoration: _inputDecoration(
            hint: '0912 345 678',
            prefixIcon: Icons.phone_outlined,
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 20),

        // 3. Input Số điện thoại Bố mẹ
        _buildLabel('Số điện thoại Bố mẹ'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _phoneController,
          decoration: _inputDecoration(
            hint: '0912 345 678',
            prefixIcon: Icons.phone_outlined,
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 20),
      ]);
    }
    
    // 4. Mật khẩu (Common)
    fields.add(_buildLabel('Mật khẩu'));
    fields.add(const SizedBox(height: 8));
    fields.add(TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: _inputDecoration(
        hint: 'Tối thiểu 8 ký tự',
        prefixIcon: Icons.lock_outline,
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
    ));
    fields.add(const SizedBox(height: 4));
    fields.add(Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        'Ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số',
        style: TextStyle(color: Colors.grey[500], fontSize: 11),
      ),
    ));
    fields.add(const SizedBox(height: 20));

    // 5. Xác nhận mật khẩu (Common)
    fields.add(_buildLabel('Xác nhận mật khẩu'));
    fields.add(const SizedBox(height: 8));
    fields.add(TextFormField(
      controller: _confimPasswordController,
      obscureText: _obscureConfirmPassword,
      decoration: _inputDecoration(
        hint: 'Nhập lại mật khẩu',
        prefixIcon: Icons.lock_outline,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
      ),
    ));
    fields.add(const SizedBox(height: 16));
    
    return fields;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- PHẦN BACK BUTTON ---
              GestureDetector(
                onTap: () { /* Xử lý chuyển về màn hình trước */ },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black87),
                    const SizedBox(width: 4),
                    const Text(
                      'Quay lại',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              Center(
                child: Column(
                  children: [
                    // --- LOGO ---
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
                    
                    // --- TIÊU ĐỀ ---
                    const Text(
                      'Tạo tài khoản mới',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bắt đầu chăm sóc người thân của bạn',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // --- USER TYPE TABS (CON / BỐ MẸ) ---
                    Container(
                      height: 50,
                      width: double.infinity,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _borderColor, 
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          _buildUserTypeTab('child', 'Con'),
                          _buildUserTypeTab('parent', 'Bố mẹ'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // --- PHẦN FORM ĐĂNG KÝ ---
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
                    ..._buildFormFields(), 
                    
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: _agreeToTerms,
                            activeColor: _primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            side: BorderSide(color: Colors.grey[400]!),
                            onChanged: (value) {
                              setState(() {
                                _agreeToTerms = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: RichText(
                              text: TextSpan(
                                text: 'Tôi đồng ý với ',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[800],
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Điều khoản dịch vụ',
                                    style: TextStyle(
                                      color: _primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const TextSpan(text: ' và '),
                                  TextSpan(
                                    text: 'Chính sách bảo mật',
                                    style: TextStyle(
                                      color: _primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          // [SỬA ĐOẠN NÀY]
                          onPressed: _agreeToTerms ? () {
                            // Kiểm tra loại tài khoản đang chọn
                            if (_userType == 'parent') {
                              // Nếu là Bố mẹ -> Chuyển sang trang Parent
                              authViewModel.registerParent(password: _passwordController.text, name: _nameController.text, phone: _phoneController.text, childPhone: _childPhoneController.text) ;
                            } else {
                              // Nếu là Con -> Xử lý chuyển sang trang của Con (hoặc về đăng nhập)
                              // Ví dụ: Navigator.pushNamed(context, '/settings');
                              authViewModel.registerChild(email:_emailController.text,name: _nameController.text,password: _passwordController.text,role:"child",phone:_phoneController.text);
                              print("Đăng ký tài khoản Con");
                            }
                          } : null,
                          
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
                                'Đăng ký',
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

                    Row(
                      children: [
                        Expanded(child: Divider(color: _borderColor)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'hoặc đăng ký với',
                            style: TextStyle(color: Colors.grey[500], fontSize: 13),
                          ),
                        ),
                        Expanded(child: Divider(color: _borderColor)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: _buildSocialButton(
                            text: 'Google',
                            iconAsset: 'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
                            isGoogle: true,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Đã có tài khoản? ',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/');
                    },
                    child: Text(
                      'Đăng nhập',
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
    );
  }
}