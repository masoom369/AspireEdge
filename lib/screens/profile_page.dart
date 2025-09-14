import 'package:aspire_edge/models/user.dart' as user_model;
import 'package:aspire_edge/screens/entryPoint/components/custom_appbar.dart';
import 'package:aspire_edge/services/user_dao.dart';
import 'package:aspire_edge/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  final UserDao _userDao = UserDao();

  int selectedTabIndex = 0;

  String fullName = "-";
  String email = "-";
  String password = "********";
  String tier = "-";

  String? editingField;
  final TextEditingController editingController = TextEditingController();

  bool isLoading = true;
  bool isSaving = false;
  String? error;


  final List<String> tierOptions = [
    "Student",
    "UnderGraduate",
    "PostGraduate",
    "Professional",
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (mounted) {
        setState(() => isLoading = false);
      }
      return;
    }

    try {
      final userProfile = await _userDao.getUserById(user.uid);
      if (mounted) {
        setState(() {
          if (userProfile != null) {
            fullName = userProfile.username;
            email = user.email ?? "-";
            tier = tierOptions.contains(userProfile.tier)
                ? userProfile.tier
                : "-";
          }
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = "Failed to load profile: $e";
          isLoading = false;
        });
      }
    }
  }


  Future<String?> _promptPassword(String action) async {
    final ctrl = TextEditingController();
    String? result;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Confirm $action',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: ctrl,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Current Password'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                result = ctrl.text;
                Navigator.of(context).pop();
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );

    return result;
  }


  Future<bool> _reauthenticate(String currentPassword) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) return false;

    final cred = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );

    try {
      await user.reauthenticateWithCredential(cred);
      return true;
    } catch (e) {
      if (mounted) {
        setState(() {
          error = "Current password is incorrect";
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error!)));
      }
      return false;
    }
  }

  void startEditing(String field, String currentValue) {
    if (!mounted) return;
    setState(() {
      editingField = field;
      editingController.text = field == "Password" ? "" : currentValue;
    });
  }

  Future<void> saveEditing(String field) async {
    final newValue = editingController.text.trim();
    if (newValue.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("$field cannot be empty")));
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      final currentUserProfile = await _userDao.getUserById(user.uid);
      if (currentUserProfile == null) {
        throw Exception("User profile not found");
      }

      if (!mounted) return;

      setState(() {
        isSaving = true;
        error = null;
      });

      switch (field) {
        case "Full Name":
          final updatedProfile = user_model.User(
            uuid: currentUserProfile.uuid,
            role: currentUserProfile.role,
            tier: currentUserProfile.tier,
            username: newValue,
          );


          _userDao.updateUser(user.uid, updatedProfile);


          await _authService.updateDisplayName(newValue);
          if (mounted) {
            setState(() => fullName = newValue);
          }
          break;

        case "Email":
          final currentPassword = await _promptPassword("Email Update");
          if (currentPassword == null || currentPassword.isEmpty) {
            if (mounted) setState(() => isSaving = false);
            return;
          }

          if (!await _reauthenticate(currentPassword)) {
            if (mounted) setState(() => isSaving = false);
            return;
          }

          await _authService.updateEmail(newValue);
          await _authService.sendEmailVerification();

          if (mounted) {
            setState(() => email = newValue);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Verification email sent to new address. Please verify to complete update.",
                ),
              ),
            );
          }
          break;

        case "Password":
          final currentPassword = await _promptPassword("Password Update");
          if (currentPassword == null || currentPassword.isEmpty) {
            if (mounted) setState(() => isSaving = false);
            return;
          }

          if (!await _reauthenticate(currentPassword)) {
            if (mounted) setState(() => isSaving = false);
            return;
          }

          await _authService.updatePassword(newValue);
          if (mounted) {
            setState(() => password = "********");
          }
          break;

        default:
          throw Exception("Unknown field: $field");
      }

      if (mounted) {
        setState(() {
          editingField = null;
          isSaving = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("$field updated successfully!")));
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = "Failed to update $field: $e";
        isSaving = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error!)));
    }
  }

  Future<void> _saveTier(String newTier) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      final currentUserProfile = await _userDao.getUserById(user.uid);
      if (currentUserProfile == null) throw Exception("User profile not found");

      if (!mounted) return;

      setState(() {
        isSaving = true;
        error = null;
      });

      final updatedProfile = user_model.User(
        uuid: currentUserProfile.uuid,
        role: currentUserProfile.role,
        tier: newTier,
        username: currentUserProfile.username,
      );

      _userDao.updateUser(user.uid, updatedProfile);

      if (mounted) {
        setState(() {
          tier = newTier;
          isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tier updated successfully!")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = "Failed to update tier: $e";
        isSaving = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error!)));
    }
  }

  Future<void> _sendEmailVerification() async {
    if (!mounted) return;

    setState(() {
      isSaving = true;
      error = null;
    });

    try {
      await _authService.sendEmailVerification();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Verification email sent")),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = "Failed to send verification: $e";
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error!)));
      }
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }


  Future<void> _sendPasswordResetEmail() async {
    if (!mounted) return;

    setState(() {
      isSaving = true;
      error = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        throw Exception("No user or email found");
      }

      await _authService.sendPasswordResetEmail(user.email!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password reset email sent. Check your inbox."),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = "Failed to send reset email: $e";
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error!)));
      }
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  Future<void> _deleteAccount() async {
    final password = await _promptPassword("Account Deletion");
    if (password == null || password.isEmpty) return;

    if (!mounted) return;

    setState(() {
      isSaving = true;
      error = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) throw Exception("No user found");

      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(cred);
      await _authService.deleteCurrentUser();

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/auth');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = "Failed to delete account: $e";
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error!)));
      }
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
         appBar: CustomAppBar(title: "Profile Screen"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFF667EEA),
                    child: Text(
                      fullName.isNotEmpty
                          ? fullName
                                .split(' ')
                                .map((name) => name.isNotEmpty ? name[0] : '')
                                .join('')
                                .substring(
                                  0,
                                  fullName.split(' ').length > 1 ? 2 : 1,
                                )
                          : "?",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    fullName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 16,
                          color: user?.emailVerified == true
                              ? const Color(0xFF9E9E9E)
                              : Colors.red,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (user != null && !user.emailVerified)
                        Tooltip(
                          message: "Email not verified",
                          child: const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 16,
                          ),
                        ),
                    ],
                  ),
                  if (user != null && !user.emailVerified)
                    TextButton(
                      onPressed: _sendEmailVerification,
                      child: const Text(
                        "Resend Verification Email",
                        style: TextStyle(color: Colors.blue, fontSize: 12),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Container(
                    height: 2,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x0D000000),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _buildTabItem('Profile', 0),
                  _buildTabItem('Skills', 1),
                  _buildTabItem('Progress', 2),
                  _buildTabItem('Achievements', 3),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (selectedTabIndex == 0)
              _infoCard("Account Information", [
                _editableRow("Full Name", fullName),
                _editableRow("Email", email),
                _editableRow("Password", password),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Center(
                    child: TextButton(
                      onPressed: isSaving ? null : _sendPasswordResetEmail,
                      child: const Text(
                        "Forgot Password? Click here to reset",
                        style: TextStyle(color: Colors.blue, fontSize: 14),
                      ),
                    ),
                  ),
                ),
                _dropdownRow("Tier", tier, tierOptions),
                _actionRow("Delete Account", Colors.red, _deleteAccount),
              ]),
            if (selectedTabIndex == 1)
              _infoCard("Skills", [
                _infoRow("Flutter", "Intermediate"),
                _infoRow("Dart", "Intermediate"),
                _infoRow("UI Design", "Beginner"),
              ]),
            if (selectedTabIndex == 2)
              _infoCard("Progress", [
                _progressRow("Flutter Course", 0.8),
                _progressRow("Dart Course", 0.65),
                _progressRow("UI Design", 0.3),
              ]),
            if (selectedTabIndex == 3)
              _infoCard("Achievements", [
                _infoRow("Top Student of 2023", "Award"),
                _infoRow("Completed Flutter Bootcamp", "Completed"),
              ]),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    final isSelected = selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF667EEA) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF757575),
            ),
          ),
        ),
      ),
    );
  }

  Widget _editableRow(String label, String value) {
    final isEditing = editingField == label;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: isEditing
                ? TextField(
                    controller: editingController,
                    autofocus: true,
                    obscureText: label == "Password",
                    decoration: InputDecoration(
                      labelText: label,
                      border: const OutlineInputBorder(),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF616161),
                        ),
                      ),
                      Text(
                        value.isEmpty ? "-" : value,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(width: 8),
          isEditing
              ? IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  onPressed: () => saveEditing(label),
                )
              : IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => startEditing(label, value),
                ),
        ],
      ),
    );
  }

  Widget _dropdownRow(String label, String value, List<String> options) {
    final safeValue = options.contains(value) ? value : options.first;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Color(0xFF616161)),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: safeValue,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
            items: options.map((option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: (newValue) {
              if (newValue != null && newValue != safeValue) {
                _saveTier(newValue);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _actionRow(String label, Color color, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: isSaving ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
          ),
          icon: const Icon(Icons.delete_forever),
          label: Text(label),
        ),
      ),
    );
  }

  Widget _progressRow(String label, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 16, color: Color(0xFF616161)),
              ),
              Text(
                "${(progress * 100).toInt()}%",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFE0E0E0),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF667EEA),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _infoCard(String title, List<Widget> children) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: const Color(0x0D000000),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    ),
  );
}

Widget _infoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Color(0xFF616161)),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}

