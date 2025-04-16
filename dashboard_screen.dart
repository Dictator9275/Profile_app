import 'package:flutter/material.dart';
import 'package:task_app/services/profile_service.dart';

class DashboardScreen extends StatelessWidget {
  final ProfileService _profileService = ProfileService();

  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profiles = _profileService.getAllProfiles();

    return Scaffold(
      appBar: AppBar(
        title: Text('Profiles Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
        ],
      ),
      body:
          profiles.isEmpty
              ? Center(
                child: Text(
                  'No profiles found. Tap + to add a new profile.',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : ListView.builder(
                itemCount: profiles.length,
                itemBuilder: (context, index) {
                  final profile = profiles[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            profile['imageUrl']?.isNotEmpty == true
                                ? NetworkImage(profile['imageUrl'])
                                : AssetImage('') as ImageProvider,
                        onBackgroundImageError: (_, __) {},
                        child:
                            profile['imageUrl']?.isNotEmpty == true
                                ? null
                                : Icon(Icons.person, size: 00),
                      ),
                      title: Text(profile['name'] ?? 'No Name'),
                      subtitle: Text(profile['job'] ?? 'No Job'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/home',
                                arguments: {'index': index, 'profile': profile},
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _showDeleteDialog(context, index);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/edit_profile',
                          arguments: {'profile': profile},
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text('Delete Profile'),
            content: Text('Are you sure you want to delete this profile?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _profileService.deleteProfile(index);
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Profile deleted')));

                  Navigator.pushReplacementNamed(context, '/dashboard');
                },
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
