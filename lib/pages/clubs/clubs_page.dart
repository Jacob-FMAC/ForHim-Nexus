import 'package:flutter/material.dart';
import '../../config/constants.dart';

class ClubsPage extends StatelessWidget {
  const ClubsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clubs'),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: AppConstants.clubTypes.length,
        itemBuilder: (context, index) {
          return _buildClubCard(context, AppConstants.clubTypes[index]);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Create Club'),
      ),
    );
  }

  Widget _buildClubCard(BuildContext context, String clubType) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.groups, color: Colors.white),
        ),
        title: Text(clubType),
        subtitle: const Text('50 members — Level 5'),
        trailing: ElevatedButton(onPressed: () {}, child: const Text('Join')),
      ),
    );
  }
}
