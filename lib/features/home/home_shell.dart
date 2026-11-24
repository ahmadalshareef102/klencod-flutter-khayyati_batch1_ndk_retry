import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../data/providers.dart';
import '../settings/settings_screen.dart';
import '../staff/staff_screen.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final pages = <_Tab>[
      const _Tab('الرئيسية', Icons.home_outlined, Icons.home, _HomePage()),
      if (session.isAdmin)
        const _Tab('العاملون', Icons.groups_outlined, Icons.groups, StaffScreen()),
      const _Tab('الإعدادات', Icons.settings_outlined, Icons.settings, SettingsScreen()),
    ];
    final i = _index.clamp(0, pages.length - 1);
    return Scaffold(
      appBar: AppBar(title: Text(pages[i].label)),
      body: pages[i].page,
      bottomNavigationBar: NavigationBar(
        selectedIndex: i,
        onDestinationSelected: (v) => setState(() => _index = v),
        destinations: [
          for (final t in pages)
            NavigationDestination(
                icon: Icon(t.icon), selectedIcon: Icon(t.selectedIcon), label: t.label),
        ],
      ),
    );
  }
}

class _Tab {
  const _Tab(this.label, this.icon, this.selectedIcon, this.page);
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget page;
}

class _HomePage extends ConsumerWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final shops = ref.watch(shopsProvider).valueOrNull ?? const [];
    final shop = ref.watch(currentShopProvider);
    final staff = ref.watch(staffProvider).valueOrNull ?? const [];
    final activeStaff = staff.where((u) => u.isActive).length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('أهلاً، ${session.user?.fullName ?? ''}',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        if (session.isAdmin && shops.length == 2)
          SegmentedButton<int>(
            showSelectedIcon: false,
            segments: [
              const ButtonSegment(value: 0, label: Text('الإجمالي')),
              for (final s in shops)
                ButtonSegment(
                    value: s.id,
                    label: Text(s.type == ShopTypes.men ? 'الرجالي' : 'العبايات')),
            ],
            selected: {session.shopId ?? 0},
            onSelectionChanged: (v) => ref
                .read(sessionProvider.notifier)
                .selectShop(v.first == 0 ? null : v.first),
          ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.storefront_outlined),
            title: Text(shop?.name ?? 'التقرير الموحد للمحلين'),
            subtitle: Text(shop == null
                ? 'اختر محلاً لعرض بياناته'
                : [shop.phone, shop.address]
                    .where((e) => e != null && e.isNotEmpty)
                    .join(' - ')
                    .ifEmpty('أضف الهاتف والعنوان من الإعدادات')),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.groups_outlined),
            title: const Text('العاملون النشطون'),
            trailing: Text('$activeStaff',
                style: Theme.of(context).textTheme.titleLarge),
          ),
        ),
      ],
    );
  }
}

extension on String {
  String ifEmpty(String other) => isEmpty ? other : this;
}
