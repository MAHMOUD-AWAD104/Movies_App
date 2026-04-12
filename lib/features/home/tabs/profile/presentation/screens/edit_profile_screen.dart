import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  String selectedAvatar = 'assets/images/avatar1.png';
  bool isLoading = false;

  final List<String> avatars = [
    'assets/images/avatar1.png',
    'assets/images/avatar2.png',
    'assets/images/avatar3.png',
    'assets/images/avatar4.png',
    'assets/images/avatar5.png',
    'assets/images/avatar6.png',
    'assets/images/avatar7.png',
    'assets/images/avatar8.png',
    'assets/images/avatar9.png',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    var ds = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user?.uid)
        .get();
    if (ds.exists) {
      setState(() {
        nameController.text = ds.get('username') ?? "";
        phoneController.text = ds.get('phone') ?? "";
        selectedAvatar = ds.get('avatar') ?? 'assets/images/avatar1.png';
      });
    }
  }

  //Firestore
  Future<void> _updateProfile() async {
    setState(() => isLoading = true);

    try {
      FirebaseFirestore.instance.collection('Users').doc(user!.uid).update({
        'username': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'avatar': selectedAvatar,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile Updated!")),
      );

      context.pop(); // 👈 يرجع فورًا
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );

      setState(() => isLoading = false);
    }
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF212121),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 400,
          child: Column(
            children: [
              const Text("Pick Avatar",
                  style: TextStyle(color: Color(0xFFFFBB3B), fontSize: 18)),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: avatars.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedAvatar = avatars[index]);
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: selectedAvatar == avatars[index]
                                  ? const Color(0xFFFFBB3B)
                                  : Colors.transparent,
                              width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(avatars[index]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121312),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFFBB3B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Edit Profile",
            style: TextStyle(color: Color(0xFFFFBB3B))),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _showAvatarPicker,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(selectedAvatar),
                ),
              ),
              const SizedBox(height: 40),
              _buildTextField(Icons.person, "Name", nameController),
              const SizedBox(height: 15),
              _buildTextField(Icons.phone, "Phone", phoneController),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () async {
                    if (user?.email != null) {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: user!.email!);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Reset link sent to your email")));
                    }
                  },
                  child: const Text("Reset Password",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              // const Spacer(),
              _buildActionButton("Delete Account", const Color(0xFFE82626),
                  Colors.white, () async {}),
              const SizedBox(height: 12),
              isLoading
                  ? const CircularProgressIndicator(color: Color(0xFFFFBB3B))
                  : _buildActionButton("Update Data", const Color(0xFFFFBB3B),
                      Colors.black, _updateProfile),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      IconData icon, String label, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFF282A28),
          borderRadius: BorderRadius.circular(12)),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white70),
          hintText: label,
          hintStyle: const TextStyle(color: Colors.white54),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildActionButton(
      String text, Color bgColor, Color textColor, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(text,
            style: TextStyle(
                color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}
