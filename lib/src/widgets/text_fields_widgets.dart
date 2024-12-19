import 'package:flutter/material.dart';

Widget buildTextFieldController({
  required String hintText,
  required IconData icon,
  required String? Function(String?) validator,
  required TextEditingController controller, // Added controller
}) {
  return TextFormField(
    controller: controller, // Bind the controller to the TextFormField
    decoration: InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(icon, color: Colors.white),
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
      filled: true,
      fillColor: Colors.red.withOpacity(0.2),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.white),
      ),
    ),
    validator: validator,
  );
}

Widget buildTextField({
  required String hintText,
  required IconData icon,
  required String? Function(String?) validator,
  required Function(String) onChanged,
}) {
  return TextFormField(
    decoration: InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(icon, color: Colors.white),
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
      filled: true,
      fillColor: Colors.red.withOpacity(0.2),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.white),
      ),
    ),
    validator: validator,
  );
}

Widget buildPasswordFieldController(
    bool isPasswordHidden,
    VoidCallback onPasswordToggle, {
      required TextEditingController controller, // Added controller
    }) {
  return TextFormField(
    controller: controller, // Bind the controller to the TextFormField
    obscureText: isPasswordHidden,
    decoration: InputDecoration(
      hintText: "Password",
      prefixIcon: Icon(Icons.lock, color: Colors.white),
      suffixIcon: IconButton(
        icon: Icon(
          isPasswordHidden ? Icons.visibility : Icons.visibility_off,
          color: Colors.white,
        ),
        onPressed: onPasswordToggle,
      ),
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
      filled: true,
      fillColor: Colors.red.withOpacity(0.2),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.white),
      ),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your password';
      }
      if (value.length < 6) {
        return 'Password must be at least 6 characters long';
      }
      return null;
    },
  );
}


Widget buildPasswordField(bool isPasswordHidden,
    VoidCallback onPasswordToggle,
    {required Function(String) onChanged}) {
  return TextFormField(
    obscureText: isPasswordHidden,
    decoration: InputDecoration(
      hintText: "Password",
      prefixIcon: Icon(Icons.lock, color: Colors.white),
      suffixIcon: IconButton(
        icon: Icon(
          isPasswordHidden ? Icons.visibility : Icons.visibility_off,
          color: Colors.white,
        ),
        onPressed: onPasswordToggle,
      ),
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
      filled: true,
      fillColor: Colors.red.withOpacity(0.2),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.white),
      ),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your password';
      }
      if (value.length < 6) {
        return 'Password must be at least 6 characters long';
      }
      return null;
    },
    onChanged: onChanged,
  );
}

Widget buildActionButton(BuildContext context, String text,
    {required VoidCallback onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    child: Text(text, style: TextStyle(color: Colors.white)),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.red,
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      textStyle: TextStyle(fontSize: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}

Widget buildOrDivider() {
  return Row(
    children: [
      Expanded(child: Divider(thickness: 1, color: Colors.grey)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text("OR", style: TextStyle(color: Colors.white)),
      ),
      Expanded(child: Divider(thickness: 1, color: Colors.grey)),
    ],
  );
}