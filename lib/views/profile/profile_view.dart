
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/routes/app_router.dart';
import '../../viewmodels/auth_vm.dart';
import '../../viewmodels/book_vm.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = await ref.read(authProvider.notifier).getProfile();

    if (!mounted) return;

    setState(() {
      _loading = false;
      _error = user == null
          ? ref.read(authProvider).error ?? 'Gagal mengambil profil'
          : null;
    });
  }

  Future<void> _logout() async {
    await ref.read(authProvider.notifier).logout();
    ref.read(bookProvider.notifier).reset();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (_) => false,
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';

    final local = date.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');

    return '$day-$month-${local.year}';
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
      ),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : _error != null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error!),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () {
                          setState(() {
                            _loading = true;
                            _error = null;
                          });
                          _loadProfile();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba lagi'),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 45,
                                child: Text(
                                  user!.name.isEmpty
                                      ? '?'
                                      : user.name[0].toUpperCase(),
                                  style: const TextStyle(fontSize: 32),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                user.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall,
                              ),
                              const SizedBox(height: 24),
                              ListTile(
                                leading: const Icon(Icons.person),
                                title: const Text('Nama'),
                                subtitle: Text(user.name),
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(Icons.email),
                                title: const Text('Email'),
                                subtitle: Text(user.email),
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(Icons.calendar_today),
                                title: const Text('Tanggal Bergabung'),
                                subtitle: Text(
                                  _formatDate(user.createdAt),
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  onPressed: _logout,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  icon: const Icon(Icons.logout),
                                  label: const Text('Logout'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
