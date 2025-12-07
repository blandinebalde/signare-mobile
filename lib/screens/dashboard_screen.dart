import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import '../models/user_model.dart';
import '../services/vente_service.dart';
import '../services/finance_service.dart';
import '../services/order_service.dart';
import '../services/delivery_service.dart';
import '../services/task_service.dart';
import '../services/income_service.dart';
import '../services/dashboard_service.dart';
import '../services/notification_service.dart';
import '../utils/navigation_helper.dart';
import '../utils/responsive_helper.dart';
import 'products_screen.dart';
import 'orders_screen.dart';
import 'tasks_screen.dart';
import 'deliveries_screen.dart';
import 'invoices_screen.dart';
import 'profile_screen.dart';
import 'livreur/livreur_home_screen.dart';
import 'notifications_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  List<NavigationItem> _navigationItems = [];
  List<Widget> _screens = [];
  String? _lastUserId; // Pour détecter les changements d'utilisateur

  @override
  void initState() {
    super.initState();
    debugPrint('🔵 DEBUG DashboardScreen: initState appelé');
    // Ne pas initialiser ici car l'utilisateur pourrait ne pas être chargé
    // L'initialisation se fera dans le build avec Consumer
  }
  
  @override
  void dispose() {
    debugPrint('🔵 DEBUG DashboardScreen: dispose appelé');
    _navigationItems.clear();
    _screens.clear();
    _lastUserId = null;
    super.dispose();
  }

  void _initializeNavigation(User? user) {
    final userRole = user?.role;
    debugPrint('🔵 DEBUG DashboardScreen: Initialisation navigation pour rôle: $userRole');
    
    _navigationItems = NavigationHelper.getNavigationItems(userRole);
    
    // Créer les écrans correspondants
    _screens = _navigationItems.map((item) {
      switch (item.route) {
        case '/dashboard':
          return const HomeTab();
        case '/products':
          return const ProductsScreen();
        case '/orders':
          return const OrdersScreen();
        case '/tasks':
          return const TasksScreen();
        case '/deliveries':
          return const DeliveriesScreen();
        case '/livreur-home':
          return const LivreurHomeScreen();
        case '/invoices':
          return const InvoicesScreen();
        case '/profile':
          return const ProfileScreen();
        default:
          return const HomeTab();
      }
    }).toList();
    
    // S'assurer qu'on a au moins un écran
    if (_screens.isEmpty) {
      _screens.add(const HomeTab());
      _navigationItems.add(NavigationItem(
        icon: Icons.dashboard,
        label: 'Accueil',
        route: '/dashboard',
      ));
    }
    
    debugPrint('🔵 DEBUG DashboardScreen: ${_navigationItems.length} éléments de navigation créés');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final currentUserId = authProvider.currentUser?.id?.toString() ?? '';
        
        // Si l'utilisateur a changé, réinitialiser la navigation
        if (currentUserId.isNotEmpty && currentUserId != _lastUserId) {
          debugPrint('🔵 DEBUG DashboardScreen: Utilisateur changé - Réinitialisation de la navigation');
          _lastUserId = currentUserId;
          _navigationItems.clear();
          _screens.clear();
          _selectedIndex = 0;
        }
        
        // Si l'utilisateur n'est pas chargé, afficher un loader
        if (authProvider.currentUser == null) {
          debugPrint('🔵 DEBUG DashboardScreen: Utilisateur non chargé - Affichage du loader');
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        // Initialiser la navigation si nécessaire
        if (_navigationItems.isEmpty) {
          debugPrint('🔵 DEBUG DashboardScreen: Initialisation de la navigation');
          _initializeNavigation(authProvider.currentUser);
        }
        
        final notificationService = NotificationService();
        final unreadCount = notificationService.unreadCount;
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Gestion Stock'),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          unreadCount > 99 ? '99+' : unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          body: _screens.isNotEmpty && _selectedIndex < _screens.length
              ? _screens[_selectedIndex]
              : const Center(child: CircularProgressIndicator()),
          bottomNavigationBar: _navigationItems.length > 1
              ? BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _selectedIndex.clamp(0, _navigationItems.length - 1),
                  onTap: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  items: _navigationItems.map((item) {
                    return BottomNavigationBarItem(
                      icon: Icon(item.icon),
                      label: item.label,
                    );
                  }).toList(),
                )
              : null,
        );
      },
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final VenteService _venteService = VenteService();
  final FinanceService _financeService = FinanceService();
  final OrderService _orderService = OrderService();
  final DeliveryService _deliveryService = DeliveryService();
  final TaskService _taskService = TaskService();
  final IncomeService _incomeService = IncomeService();
  final DashboardService _dashboardService = DashboardService();
  
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser;
      _userRole = user?.role;
      
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      await productProvider.loadEntrepotProducts();
      
      final products = productProvider.entrepotProducts;
      final totalProducts = products.length;
      final lowStock = products.where((p) => p.isLowStock).length;
      
      // Charger les stats selon le rôle
      switch (_userRole?.toUpperCase()) {
        case NavigationHelper.superAdmin:
        case NavigationHelper.admin:
          await _loadAdminDashboard(totalProducts, lowStock);
          break;
        case NavigationHelper.gestionnaire:
        case NavigationHelper.responsable:
          await _loadManagerDashboard(totalProducts, lowStock);
          break;
        case NavigationHelper.comptable:
          await _loadAccountantDashboard();
          break;
        case NavigationHelper.caissier:
          await _loadCashierDashboard(totalProducts);
          break;
        case NavigationHelper.facturier:
          await _loadInvoicerDashboard();
          break;
        case NavigationHelper.livreur:
          await _loadDeliveryDashboard();
          break;
        default:
          setState(() {
            _stats = {
              'products': totalProducts,
              'lowStock': lowStock,
            };
            _isLoading = false;
          });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // Dashboard pour SUPERADMIN/ADMIN - Vue globale complète
  Future<void> _loadAdminDashboard(int totalProducts, int lowStock) async {
    try {
      final salesStats = await _venteService.getSalesStatistics();
      final financeSummary = await _financeService.getFinanceDashboardSummary();
      
      // Charger commandes et livraisons
      final orders = await _orderService.getAllOrders();
      final deliveries = await _deliveryService.getAllDeliveries();
      final tasks = await _taskService.getTasks(size: 10);
      
      setState(() {
        _stats = {
          'products': totalProducts,
          'lowStock': lowStock,
          'sales': salesStats['totalSales'] ?? 0,
          'revenue': salesStats['totalRevenue'] ?? 0.0,
          'orders': orders.length,
          'pendingOrders': orders.where((o) => o.status == 'PENDING').length,
          'deliveries': deliveries.length,
          'pendingDeliveries': deliveries.where((d) => d.status == 'PENDING').length,
          'tasks': tasks.length,
          'pendingTasks': tasks.where((t) => t.status == 'PENDING').length,
          'finance': financeSummary,
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _stats = {
          'products': totalProducts,
          'lowStock': lowStock,
        };
        _isLoading = false;
      });
    }
  }

  // Dashboard pour GESTIONNAIRE/RESPONSABLE - Vue opérationnelle
  Future<void> _loadManagerDashboard(int totalProducts, int lowStock) async {
    try {
      final orders = await _orderService.getAllOrders();
      final deliveries = await _deliveryService.getAllDeliveries();
      final tasks = await _taskService.getTasks(size: 10);
      
      setState(() {
        _stats = {
          'products': totalProducts,
          'lowStock': lowStock,
          'orders': orders.length,
          'pendingOrders': orders.where((o) => o.status == 'PENDING').length,
          'deliveries': deliveries.length,
          'pendingDeliveries': deliveries.where((d) => d.status == 'PENDING').length,
          'tasks': tasks.length,
          'pendingTasks': tasks.where((t) => t.status == 'PENDING').length,
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _stats = {
          'products': totalProducts,
          'lowStock': lowStock,
        };
        _isLoading = false;
      });
    }
  }

  // Dashboard pour COMPTABLE - Vue financière
  Future<void> _loadAccountantDashboard() async {
    try {
      final invoices = await _incomeService.getInvoices();
      final weeklyInvoices = await _incomeService.getWeeklyInvoices();
      final financeSummary = await _financeService.getFinanceDashboardSummary();
      
      final totalInvoices = invoices.length;
      final paidInvoices = invoices.where((i) => i.isPaid == true).length;
      final unpaidInvoices = totalInvoices - paidInvoices;
      final weeklyAmount = weeklyInvoices.fold<double>(0.0, (sum, inv) => sum + inv.amount);
      
      setState(() {
        _stats = {
          'totalInvoices': totalInvoices,
          'paidInvoices': paidInvoices,
          'unpaidInvoices': unpaidInvoices,
          'weeklyInvoices': weeklyInvoices.length,
          'weeklyAmount': weeklyAmount,
          'finance': financeSummary,
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _stats = {};
        _isLoading = false;
      });
    }
  }

  // Dashboard pour CAISSIER - Vue ventes
  Future<void> _loadCashierDashboard(int totalProducts) async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      final salesStats = await _venteService.getSalesStatistics(
        startDate: today.toIso8601String().split('T')[0],
        endDate: today.toIso8601String().split('T')[0],
      );
      
      final todaySales = await _venteService.getVentes(
        startDate: today.toIso8601String().split('T')[0],
        endDate: today.toIso8601String().split('T')[0],
      );
      
      setState(() {
        _stats = {
          'products': totalProducts,
          'todaySales': salesStats['totalSales'] ?? todaySales.length,
          'todayRevenue': salesStats['totalRevenue'] ?? todaySales.fold<double>(0.0, (sum, v) => sum + (v.montant ?? 0.0)),
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _stats = {
          'products': totalProducts,
        };
        _isLoading = false;
      });
    }
  }

  // Dashboard pour FACTURIER - Vue facturation
  Future<void> _loadInvoicerDashboard() async {
    try {
      final weeklyInvoices = await _incomeService.getWeeklyInvoices();
      final orders = await _orderService.getAllOrders();
      
      // Commandes non facturées
      final unpaidOrders = orders.where((o) => o.status != 'CANCELLED').toList();
      final weeklyAmount = weeklyInvoices.fold<double>(0.0, (sum, inv) => sum + inv.amount);
      
      setState(() {
        _stats = {
          'weeklyInvoices': weeklyInvoices.length,
          'weeklyAmount': weeklyAmount,
          'unpaidOrders': unpaidOrders.length,
          'pendingInvoices': weeklyInvoices.where((i) => i.isPaid != true).length,
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _stats = {};
        _isLoading = false;
      });
    }
  }

  // Dashboard pour LIVREUR - Vue livraisons
  Future<void> _loadDeliveryDashboard() async {
    try {
      // Use the new dashboard endpoint
      final dashboardData = await _dashboardService.getLivreurDashboard();
      
      final stats = dashboardData['stats'] as Map<String, dynamic>? ?? {};
      
      setState(() {
        _stats = {
          'todayDeliveries': stats['todayDeliveries'] ?? 0,
          'completedDeliveries': stats['completedDeliveries'] ?? 0,
          'pendingDeliveries': stats['pendingDeliveries'] ?? 0,
          'totalDistance': stats['totalDistance'] ?? 0.0,
          'averageDeliveryTime': stats['averageDeliveryTime'] ?? 0,
          'customerSatisfaction': stats['customerSatisfaction'] ?? 0,
        };
        _isLoading = false;
      });
    } catch (e) {
      // Fallback to old method if endpoint fails
      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final user = authProvider.currentUser;
        
        final deliveries = await _deliveryService.getAllDeliveries(
          livreurId: user?.id,
        );
        
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        
        final todayDeliveries = deliveries.where((d) {
          if (d.dateLivraison == null) return false;
          final deliveryDate = DateTime(d.dateLivraison!.year, d.dateLivraison!.month, d.dateLivraison!.day);
          return deliveryDate.year == today.year && 
                 deliveryDate.month == today.month && 
                 deliveryDate.day == today.day;
        }).toList();
        
        setState(() {
          _stats = {
            'totalDeliveries': deliveries.length,
            'todayDeliveries': todayDeliveries.length,
            'pendingDeliveries': deliveries.where((d) => d.status == 'PENDING').length,
            'inTransit': deliveries.where((d) => d.status == 'IN_TRANSIT').length,
          };
          _isLoading = false;
        });
      } catch (fallbackError) {
        setState(() {
          _stats = {};
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadStats,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final padding = ResponsiveHelper.getHorizontalPadding(context);
          final maxWidth = ResponsiveHelper.getMaxContentWidth(context);
          
          return SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
            // Welcome Section
            Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                final user = authProvider.currentUser;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          child: Text(
                            user?.firstName?.substring(0, 1).toUpperCase() ?? 'U',
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bonjour, ${user?.firstName ?? 'Utilisateur'}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                user?.role ?? '',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            
            // Stats Cards - Adaptées selon le rôle
            const Text(
              'Statistiques',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildRoleSpecificStats(),
            const SizedBox(height: 24),
            
            // Quick Actions - Selon le rôle
            Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                final userRole = authProvider.currentUser?.role;
                final canCreateOrder = NavigationHelper.canCreateOrder(userRole);
                
                if (canCreateOrder || NavigationHelper.hasAccess(userRole, [
                  NavigationHelper.caissier,
                  NavigationHelper.facturier,
                ])) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Actions rapides',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isMobile = ResponsiveHelper.isMobile(context);
                          
                          if (isMobile) {
                            return Column(
                              children: [
                                if (canCreateOrder)
                                  _buildActionButton(
                                    'Nouvelle Commande',
                                    Icons.add_shopping_cart,
                                    Colors.green,
                                    () {
                                      // Navigate to create order
                                    },
                                  ),
                                if (canCreateOrder && NavigationHelper.hasAccess(userRole, [
                                  NavigationHelper.admin,
                                  NavigationHelper.superAdmin,
                                  NavigationHelper.gestionnaire,
                                ]))
                                  const SizedBox(height: 16),
                                if (NavigationHelper.hasAccess(userRole, [
                                  NavigationHelper.admin,
                                  NavigationHelper.superAdmin,
                                  NavigationHelper.gestionnaire,
                                ]))
                                  _buildActionButton(
                                    'Ajouter Produit',
                                    Icons.add,
                                    Colors.blue,
                                    () {
                                      // Navigate to add product
                                    },
                                  ),
                              ],
                            );
                          }
                          
                          return Row(
                            children: [
                              if (canCreateOrder)
                                Expanded(
                                  child: _buildActionButton(
                                    'Nouvelle Commande',
                                    Icons.add_shopping_cart,
                                    Colors.green,
                                    () {
                                      // Navigate to create order
                                    },
                                  ),
                                ),
                              if (canCreateOrder && NavigationHelper.hasAccess(userRole, [
                                NavigationHelper.admin,
                                NavigationHelper.superAdmin,
                                NavigationHelper.gestionnaire,
                              ]))
                                const SizedBox(width: 16),
                              if (NavigationHelper.hasAccess(userRole, [
                                NavigationHelper.admin,
                                NavigationHelper.superAdmin,
                                NavigationHelper.gestionnaire,
                              ]))
                                Expanded(
                                  child: _buildActionButton(
                                    'Ajouter Produit',
                                    Icons.add,
                                    Colors.blue,
                                    () {
                                      // Navigate to add product
                                    },
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSpecificStats() {
    switch (_userRole?.toUpperCase()) {
      case NavigationHelper.superAdmin:
      case NavigationHelper.admin:
        return _buildAdminStats();
      case NavigationHelper.gestionnaire:
      case NavigationHelper.responsable:
        return _buildManagerStats();
      case NavigationHelper.comptable:
        return _buildAccountantStats();
      case NavigationHelper.caissier:
        return _buildCashierStats();
      case NavigationHelper.facturier:
        return _buildInvoicerStats();
      case NavigationHelper.livreur:
        return _buildDeliveryStats();
      default:
        return _buildDefaultStats();
    }
  }

  Widget _buildAdminStats() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = ResponsiveHelper.getGridColumns(context);
        final aspectRatio = ResponsiveHelper.getGridAspectRatio(context);
        
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: aspectRatio,
      children: [
        _buildStatCard('Produits', '${_stats['products'] ?? 0}', Icons.inventory_2, Colors.blue),
        _buildStatCard('Stock faible', '${_stats['lowStock'] ?? 0}', Icons.warning, Colors.orange),
        _buildStatCard('Commandes', '${_stats['orders'] ?? 0}', Icons.shopping_cart, Colors.green),
        _buildStatCard('En attente', '${_stats['pendingOrders'] ?? 0}', Icons.pending_actions, Colors.orange),
        _buildStatCard('Livraisons', '${_stats['deliveries'] ?? 0}', Icons.local_shipping, Colors.purple),
        _buildStatCard('À livrer', '${_stats['pendingDeliveries'] ?? 0}', Icons.schedule, Colors.red),
        _buildStatCard('Ventes', '${_stats['sales'] ?? 0}', Icons.point_of_sale, Colors.teal),
        _buildStatCard('Revenus', '${NumberFormat('#,###').format(_stats['revenue'] ?? 0)} FCFA', Icons.attach_money, Colors.green),
          ],
        );
      },
    );
  }

  Widget _buildManagerStats() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = ResponsiveHelper.getGridColumns(context);
        final aspectRatio = ResponsiveHelper.getGridAspectRatio(context);
        
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: aspectRatio,
      children: [
        _buildStatCard('Produits', '${_stats['products'] ?? 0}', Icons.inventory_2, Colors.blue),
        _buildStatCard('Stock faible', '${_stats['lowStock'] ?? 0}', Icons.warning, Colors.orange),
        _buildStatCard('Commandes', '${_stats['orders'] ?? 0}', Icons.shopping_cart, Colors.green),
        _buildStatCard('En attente', '${_stats['pendingOrders'] ?? 0}', Icons.pending_actions, Colors.orange),
        _buildStatCard('Livraisons', '${_stats['deliveries'] ?? 0}', Icons.local_shipping, Colors.purple),
        _buildStatCard('À livrer', '${_stats['pendingDeliveries'] ?? 0}', Icons.schedule, Colors.red),
        _buildStatCard('Tâches', '${_stats['tasks'] ?? 0}', Icons.task, Colors.indigo),
        _buildStatCard('En attente', '${_stats['pendingTasks'] ?? 0}', Icons.pending, Colors.amber),
          ],
        );
      },
    );
  }

  Widget _buildAccountantStats() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = ResponsiveHelper.getGridColumns(context);
        final aspectRatio = ResponsiveHelper.getGridAspectRatio(context);
        
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: aspectRatio,
      children: [
        _buildStatCard('Factures', '${_stats['totalInvoices'] ?? 0}', Icons.receipt_long, Colors.blue),
        _buildStatCard('Payées', '${_stats['paidInvoices'] ?? 0}', Icons.check_circle, Colors.green),
        _buildStatCard('Impayées', '${_stats['unpaidInvoices'] ?? 0}', Icons.pending, Colors.orange),
        _buildStatCard('Cette semaine', '${_stats['weeklyInvoices'] ?? 0}', Icons.calendar_today, Colors.purple),
        _buildStatCard('Montant semaine', '${NumberFormat('#,###').format(_stats['weeklyAmount'] ?? 0)} FCFA', Icons.attach_money, Colors.teal),
        _buildStatCard('En attente', '${_stats['pendingInvoices'] ?? 0}', Icons.schedule, Colors.red),
          ],
        );
      },
    );
  }

  Widget _buildCashierStats() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = ResponsiveHelper.getGridColumns(context);
        final aspectRatio = ResponsiveHelper.getGridAspectRatio(context);
        
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: aspectRatio,
      children: [
        _buildStatCard('Produits', '${_stats['products'] ?? 0}', Icons.inventory_2, Colors.blue),
        _buildStatCard('Ventes aujourd\'hui', '${_stats['todaySales'] ?? 0}', Icons.shopping_cart, Colors.green),
        _buildStatCard('Revenus aujourd\'hui', '${NumberFormat('#,###').format(_stats['todayRevenue'] ?? 0)} FCFA', Icons.attach_money, Colors.teal),
          ],
        );
      },
    );
  }

  Widget _buildInvoicerStats() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = ResponsiveHelper.getGridColumns(context);
        final aspectRatio = ResponsiveHelper.getGridAspectRatio(context);
        
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: aspectRatio,
      children: [
        _buildStatCard('Factures semaine', '${_stats['weeklyInvoices'] ?? 0}', Icons.receipt_long, Colors.blue),
        _buildStatCard('Montant semaine', '${NumberFormat('#,###').format(_stats['weeklyAmount'] ?? 0)} FCFA', Icons.attach_money, Colors.green),
        _buildStatCard('Commandes non facturées', '${_stats['unpaidOrders'] ?? 0}', Icons.shopping_cart, Colors.orange),
        _buildStatCard('Factures en attente', '${_stats['pendingInvoices'] ?? 0}', Icons.pending, Colors.red),
          ],
        );
      },
    );
  }

  Widget _buildDeliveryStats() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = ResponsiveHelper.getGridColumns(context);
        final aspectRatio = ResponsiveHelper.getGridAspectRatio(context);
        
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: aspectRatio,
      children: [
        _buildStatCard('Livraisons Aujourd\'hui', '${_stats['todayDeliveries'] ?? 0}', Icons.local_shipping, Colors.blue),
        _buildStatCard('Livraisons Terminées', '${_stats['completedDeliveries'] ?? 0}', Icons.check_circle, Colors.green),
        _buildStatCard('En Attente', '${_stats['pendingDeliveries'] ?? 0}', Icons.schedule, Colors.orange),
        _buildStatCard('Distance Totale', '${_stats['totalDistance'] ?? 0} km', Icons.straighten, Colors.teal),
        _buildStatCard('Temps Moyen', '${_stats['averageDeliveryTime'] ?? 0} min', Icons.access_time, Colors.indigo),
        _buildStatCard('Satisfaction Client', '${_stats['customerSatisfaction'] ?? 0}%', Icons.star, Colors.amber),
          ],
        );
      },
    );
  }

  Widget _buildDefaultStats() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = ResponsiveHelper.getGridColumns(context);
        final aspectRatio = ResponsiveHelper.getGridAspectRatio(context);
        
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: aspectRatio,
      children: [
        _buildStatCard('Produits', '${_stats['products'] ?? 0}', Icons.inventory_2, Colors.blue),
        _buildStatCard('Stock faible', '${_stats['lowStock'] ?? 0}', Icons.warning, Colors.orange),
          ],
        );
      },
    );
  }
}
