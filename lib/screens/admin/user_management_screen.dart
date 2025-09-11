import 'package:flutter/material.dart';

class User {
  String name;
  String email;
  String role;
  bool isActive;

  User({
    required this.name,
    required this.email,
    required this.role,
    this.isActive = true,
  });
}

// Reusable dialog for Add/Edit User
class UserDialog extends StatefulWidget {
  final User? user;
  final Function(User) onSubmit;

  const UserDialog({Key? key, this.user, required this.onSubmit})
      : super(key: key);

  @override
  _UserDialogState createState() => _UserDialogState();
}

class _UserDialogState extends State<UserDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late String _role;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _role = widget.user?.role ?? 'User';
    _isActive = widget.user?.isActive ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 400,
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.user == null ? "Add User" : "Edit User",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3D455B)),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Enter name" : null,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Enter email";
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                      return "Enter valid email";
                    return null;
                  },
                ),
                SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _role,
                  decoration: InputDecoration(
                      labelText: "Role",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                  items: ['Admin', 'Manager', 'User']
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _role = value);
                  },
                ),
                SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("Active"),
                  value: _isActive,
                  onChanged: (val) {
                    setState(() {
                      _isActive = val;
                    });
                  },
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel")),
                    SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.onSubmit(User(
                            name: _nameController.text,
                            email: _emailController.text,
                            role: _role,
                            isActive: _isActive,
                          ));
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3D455B),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(widget.user == null ? "Add" : "Update"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AdminUserManagementPage extends StatefulWidget {
  @override
  _AdminUserManagementPageState createState() =>
      _AdminUserManagementPageState();
}

class _AdminUserManagementPageState extends State<AdminUserManagementPage> {
  List<User> users = [
    User(name: "Alice Smith", email: "alice@example.com", role: "Admin"),
    User(name: "Bob Johnson", email: "bob@example.com", role: "User"),
    User(name: "Charlie Lee", email: "charlie@example.com", role: "Manager"),
  ];

  void _addOrEditUser({User? user, int? index}) {
    showDialog(
      context: context,
      builder: (_) => UserDialog(
        user: user,
        onSubmit: (newUser) {
          setState(() {
            if (user != null && index != null) {
              users[index] = newUser;
            } else {
              users.add(newUser);
            }
          });
        },
      ),
    );
  }

  void _deleteUser(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Delete User"),
        content: Text("Are you sure you want to delete this user?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() => users.removeAt(index));
              Navigator.pop(context);
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3D455B),
        title: Text('User Management', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _addOrEditUser(),
                icon: Icon(Icons.add),
                label: Text("Add User"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3D455B),
                  padding: EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 600) {
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (_, index) {
                        final user = users[index];
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            title: Text(
                              user.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3D455B)),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 4),
                                Text(user.email,
                                    style: TextStyle(color: Colors.grey[700])),
                                SizedBox(height: 2),
                                Text("Role: ${user.role}",
                                    style: TextStyle(color: Colors.grey[700])),
                                Text(
                                    "Active: ${user.isActive ? 'Yes' : 'No'}",
                                    style: TextStyle(color: Colors.grey[700])),
                              ],
                            ),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Color(0xFF3D455B)),
                                  onPressed: () =>
                                      _addOrEditUser(user: user, index: index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteUser(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor:
                            MaterialStateProperty.all(Colors.grey.shade100),
                        dataRowColor: MaterialStateProperty.all(Colors.white),
                        border: TableBorder(
                          horizontalInside: BorderSide(color: Colors.grey.shade300),
                          verticalInside: BorderSide(color: Colors.grey.shade300),
                        ),
                        columns: [
                          DataColumn(
                            label: Text("Name",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3D455B))),
                          ),
                          DataColumn(
                            label: Text("Email",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3D455B))),
                          ),
                          DataColumn(
                            label: Text("Role",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3D455B))),
                          ),
                          DataColumn(
                            label: Text("Active",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3D455B))),
                          ),
                          DataColumn(
                            label: Text("Actions",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3D455B))),
                          ),
                        ],
                        rows: users
                            .asMap()
                            .entries
                            .map(
                              (entry) => DataRow(cells: [
                                DataCell(Text(entry.value.name)),
                                DataCell(Text(entry.value.email)),
                                DataCell(Text(entry.value.role)),
                                DataCell(
                                    Text(entry.value.isActive ? 'Yes' : 'No')),
                                DataCell(Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit,
                                          color: Color(0xFF3D455B)),
                                      onPressed: () => _addOrEditUser(
                                          user: entry.value, index: entry.key),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _deleteUser(entry.key),
                                    ),
                                  ],
                                )),
                              ]),
                            )
                            .toList(),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
