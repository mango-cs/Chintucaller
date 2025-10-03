import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class DemoCredentialsWidget extends StatelessWidget {
  const DemoCredentialsWidget({super.key});

  final List<Map<String, String>> _demoCredentials = const [
    {
      'role': 'Admin',
      'email': 'admin@aiassistant.com',
      'password': 'admin123',
    },
    {
      'role': 'User',
      'email': 'rajesh@example.com',
      'password': 'password123',
    },
    {
      'role': 'User',
      'email': 'priya@example.com',
      'password': 'password123',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.only(top: 2.h),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.blue[700],
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Demo Credentials',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'For testing purposes, you can use these demo accounts:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.blue[600],
                ),
          ),
          SizedBox(height: 2.h),

          // Demo Credentials List
          ...(_demoCredentials.map((credential) => _buildCredentialItem(
                context,
                credential['role']!,
                credential['email']!,
                credential['password']!,
              ))),
        ],
      ),
    );
  }

  Widget _buildCredentialItem(
    BuildContext context,
    String role,
    String email,
    String password,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            role,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[800],
                ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email: $email',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[700],
                          ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Password: $password',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[700],
                          ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _copyCredentials(context, email, password),
                icon: Icon(
                  Icons.copy,
                  color: Colors.blue[600],
                  size: 5.w,
                ),
                tooltip: 'Copy credentials',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _copyCredentials(BuildContext context, String email, String password) {
    final credentialText = 'Email: $email\nPassword: $password';
    Clipboard.setData(ClipboardData(text: credentialText));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Credentials copied to clipboard'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
