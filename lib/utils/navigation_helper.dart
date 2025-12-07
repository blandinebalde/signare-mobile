import 'package:flutter/material.dart';

/// Helper class pour gérer la navigation selon les rôles
class NavigationHelper {
  /// Rôles disponibles dans l'application
  static const String superAdmin = 'SUPERADMIN';
  static const String admin = 'ADMIN';
  static const String gestionnaire = 'GESTIONNAIRE';
  static const String responsable = 'RESPONSABLE';
  static const String comptable = 'COMPTABLE';
  static const String caissier = 'CAISSIER';
  static const String livreur = 'LIVREUR';
  static const String facturier = 'FACTURIER';

  /// Vérifie si l'utilisateur a accès à une fonctionnalité
  static bool hasAccess(String? userRole, List<String> allowedRoles) {
    if (userRole == null) return false;
    return allowedRoles.contains(userRole.toUpperCase());
  }

  /// Obtient les éléments de navigation selon le rôle
  static List<NavigationItem> getNavigationItems(String? userRole) {
    if (userRole == null) return [];

    final role = userRole.toUpperCase();
    final items = <NavigationItem>[];

    // Tous les rôles ont accès au dashboard
    items.add(NavigationItem(
      icon: Icons.dashboard,
      label: 'Accueil',
      route: '/dashboard',
    ));

    // Produits et Stocks - Accessible à tous sauf LIVREUR
    if (role != livreur) {
      items.add(NavigationItem(
        icon: Icons.inventory_2,
        label: 'Produits',
        route: '/products',
      ));
    }

    // Commandes - Accessible à GESTIONNAIRE, RESPONSABLE, ADMIN, SUPERADMIN
    if ([gestionnaire, responsable, admin, superAdmin].contains(role)) {
      items.add(NavigationItem(
        icon: Icons.shopping_cart,
        label: 'Commandes',
        route: '/orders',
      ));
    }

    // Tâches - Accessible à tous
    items.add(NavigationItem(
      icon: Icons.task,
      label: 'Tâches',
      route: '/tasks',
    ));

    // Livraisons - Accessible à LIVREUR, GESTIONNAIRE, RESPONSABLE, ADMIN, SUPERADMIN
    if ([livreur, gestionnaire, responsable, admin, superAdmin].contains(role)) {
      // Pour le livreur, utiliser l'écran spécialisé
      if (role == livreur) {
        items.add(NavigationItem(
          icon: Icons.local_shipping,
          label: 'Livraisons',
          route: '/livreur-home',
        ));
      } else {
        items.add(NavigationItem(
          icon: Icons.local_shipping,
          label: 'Livraisons',
          route: '/deliveries',
        ));
      }
    }

    // Factures - Accessible à FACTURIER, COMPTABLE, GESTIONNAIRE, RESPONSABLE, ADMIN, SUPERADMIN
    if ([facturier, comptable, gestionnaire, responsable, admin, superAdmin].contains(role)) {
      items.add(NavigationItem(
        icon: Icons.receipt,
        label: 'Factures',
        route: '/invoices',
      ));
    }

    // Profil - Accessible à tous
    items.add(NavigationItem(
      icon: Icons.person,
      label: 'Profil',
      route: '/profile',
    ));

    return items;
  }

  /// Vérifie si l'utilisateur peut créer une commande
  static bool canCreateOrder(String? userRole) {
    return hasAccess(userRole, [gestionnaire, responsable, admin, superAdmin]);
  }

  /// Vérifie si l'utilisateur peut voir les factures
  static bool canViewInvoices(String? userRole) {
    return hasAccess(userRole, [facturier, comptable, gestionnaire, responsable, admin, superAdmin]);
  }

  /// Vérifie si l'utilisateur peut gérer les livraisons
  static bool canManageDeliveries(String? userRole) {
    return hasAccess(userRole, [livreur, gestionnaire, responsable, admin, superAdmin]);
  }
}

/// Modèle pour les éléments de navigation
class NavigationItem {
  final IconData icon;
  final String label;
  final String route;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

