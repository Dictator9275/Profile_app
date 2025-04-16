import 'package:flutter/material.dart';
import 'package:task_app/services/profile_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _profileService = ProfileService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _jobController = TextEditingController();
  final _imageUrlController = TextEditingController();

  int? _editingIndex;

  @override
  void initState() {
    super.initState();

    _imageUrlController.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      if (args != null && args['profile'] != null) {
        final profile = args['profile'];
        _editingIndex = args['index'];
        _nameController.text = profile['name'];
        _phoneController.text = profile['phone'];
        _jobController.text = profile['job'];
        _imageUrlController.text = profile['imageUrl'];
      } else {
        _imageUrlController.text = 'https://example.com/default_image.png';
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _jobController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    final urlController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Image URL'),
          content: TextField(
            controller: urlController,
            decoration: const InputDecoration(hintText: 'Image URL'),
            keyboardType: TextInputType.url,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _imageUrlController.text = urlController.text;
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;

    final profile = {
      'name': _nameController.text,
      'phone': _phoneController.text,
      'job': _jobController.text,
      'imageUrl': _imageUrlController.text,
    };

    if (_editingIndex != null) {
      _profileService.updateProfile(_editingIndex!, profile);
    } else {
      _profileService.addProfile(profile);
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profile saved successfully')));

    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editingIndex != null ? 'Edit Profile' : 'Add Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _updateImageUrl,
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey[300],
                  child: ClipOval(
                    child:
                        _imageUrlController.text.isNotEmpty
                            ? Image.network(
                              _imageUrlController.text,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                debugPrint('Image load error: $error');
                                return const Icon(
                                  Icons.broken_image,
                                  size: 60,
                                  color: Colors.grey,
                                );
                              },
                            )
                            : const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey,
                            ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter your name'
                            : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter your phone number'
                            : null,
              ),
              TextFormField(
                controller: _jobController,
                decoration: const InputDecoration(labelText: 'Current Job'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter your job'
                            : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
