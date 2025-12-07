import 'dart:async';
import 'package:flutter/foundation.dart';
import '../services/delivery_service.dart';
import '../services/notification_service.dart';
import '../models/delivery_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeliveryPollingService {
  static final DeliveryPollingService _instance = DeliveryPollingService._internal();
  factory DeliveryPollingService() => _instance;
  DeliveryPollingService._internal();

  final DeliveryService _deliveryService = DeliveryService();
  final NotificationService _notificationService = NotificationService();
  Timer? _pollingTimer;
  bool _isPolling = false;
  
  // Stocker les IDs des livraisons déjà notifiées
  final Set<String> _notifiedDeliveryIds = {};
  final Set<String> _notifiedCompletedIds = {};
  final Set<String> _notifiedReturnedIds = {};


  Future<void> startPolling({int intervalSeconds = 30}) async {
    if (_isPolling) {
      debugPrint('⚠️ DeliveryPollingService: Polling déjà en cours');
      return;
    }

    _isPolling = true;
    debugPrint('🔄 DeliveryPollingService: Démarrage du polling (intervalle: ${intervalSeconds}s)');

    // Charger les IDs déjà notifiés depuis le stockage local
    await _loadNotifiedIds();

    // Première vérification immédiate
    await _checkForUpdates();

    // Démarrer le timer pour les vérifications périodiques
    _pollingTimer = Timer.periodic(
      Duration(seconds: intervalSeconds),
      (_) => _checkForUpdates(),
    );
  }

  void stopPolling() {
    if (!_isPolling) return;

    _isPolling = false;
    _pollingTimer?.cancel();
    _pollingTimer = null;
    debugPrint('⏹️ DeliveryPollingService: Arrêt du polling');
  }

  Future<void> _checkForUpdates() async {
    try {
      debugPrint('🔍 DeliveryPollingService: Vérification des mises à jour...');
      
      // Récupérer toutes les livraisons du livreur
      final deliveries = await _deliveryService.getMyDeliveries();
      
      if (deliveries.isEmpty) {
        debugPrint('📭 DeliveryPollingService: Aucune livraison trouvée');
        return;
      }

      debugPrint('📦 DeliveryPollingService: ${deliveries.length} livraison(s) trouvée(s)');

      // Vérifier les nouvelles livraisons
      await _checkNewDeliveries(deliveries);

      // Vérifier les livraisons complétées
      await _checkCompletedDeliveries(deliveries);

      // Vérifier les livraisons retournées
      await _checkReturnedDeliveries(deliveries);

      // Sauvegarder les IDs notifiés
      await _saveNotifiedIds();

      debugPrint('✅ DeliveryPollingService: Vérification terminée');
    } catch (e) {
      debugPrint('❌ DeliveryPollingService: Erreur lors de la vérification: $e');
    }
  }

  Future<void> _checkNewDeliveries(List<Delivery> deliveries) async {
      for (final delivery in deliveries) {
        // Vérifier si c'est une nouvelle livraison (EN_ATTENTE et pas encore notifiée)
        final deliveryStatus = delivery.status ?? delivery.statutLivraison ?? '';
        if ((deliveryStatus == 'EN_ATTENTE' || deliveryStatus == 'EN_ATTENTE') && 
            !_notifiedDeliveryIds.contains(delivery.id.toString())) {
        
        // Vérifier si la livraison est récente (créée dans les dernières 24h)
        final deliveryDate = delivery.deliveryDate ?? delivery.dateLivraison;
        if (deliveryDate != null) {
          final deliveryAge = DateTime.now().difference(deliveryDate);
          if (deliveryAge.inHours <= 24) {
            await _notificationService.showNewDeliveryNotification(
              deliveryId: delivery.id.toString(),
              clientName: delivery.fullClientName,
              address: delivery.address,
            );
            
            _notifiedDeliveryIds.add(delivery.id.toString());
            debugPrint('🔔 Notification envoyée: Nouvelle livraison ${delivery.id}');
          }
        } else {
          // Si pas de date, notifier quand même si c'est une nouvelle livraison
          await _notificationService.showNewDeliveryNotification(
            deliveryId: delivery.id.toString(),
            clientName: delivery.fullClientName,
            address: delivery.address,
          );
          
          _notifiedDeliveryIds.add(delivery.id.toString());
          debugPrint('🔔 Notification envoyée: Nouvelle livraison ${delivery.id}');
        }
      }
    }
  }

  Future<void> _checkCompletedDeliveries(List<Delivery> deliveries) async {
    for (final delivery in deliveries) {
      // Vérifier si la livraison est complétée et pas encore notifiée
      final deliveryStatus = delivery.status ?? delivery.statutLivraison ?? '';
      if ((deliveryStatus == 'LIVREE' || deliveryStatus == 'LIVREE') && 
          !_notifiedCompletedIds.contains(delivery.id.toString())) {
        
        // Vérifier si c'est une mise à jour récente (dans les dernières heures)
        final deliveryDate = delivery.deliveryDate ?? delivery.dateLivraison;
        if (deliveryDate != null) {
          final deliveryAge = DateTime.now().difference(deliveryDate);
          if (deliveryAge.inHours <= 2) {
            await _notificationService.showDeliveryCompletedNotification(
              deliveryId: delivery.id.toString(),
              clientName: delivery.fullClientName,
            );
            
            _notifiedCompletedIds.add(delivery.id.toString());
            debugPrint('🔔 Notification envoyée: Livraison complétée ${delivery.id}');
          }
        } else {
          // Notifier quand même si pas de date
          await _notificationService.showDeliveryCompletedNotification(
            deliveryId: delivery.id.toString(),
            clientName: delivery.fullClientName,
          );
          
          _notifiedCompletedIds.add(delivery.id.toString());
          debugPrint('🔔 Notification envoyée: Livraison complétée ${delivery.id}');
        }
      }
    }
  }

  Future<void> _checkReturnedDeliveries(List<Delivery> deliveries) async {
    for (final delivery in deliveries) {
      // Vérifier si la livraison est retournée et pas encore notifiée
      final deliveryStatus = delivery.status ?? delivery.statutLivraison ?? '';
      if ((deliveryStatus == 'RETOURNE' || deliveryStatus == 'ANNULEE') && 
          !_notifiedReturnedIds.contains(delivery.id.toString())) {
        
        await _notificationService.showDeliveryReturnedNotification(
          deliveryId: delivery.id.toString(),
          clientName: delivery.fullClientName,
          reason: delivery.description,
        );
        
        _notifiedReturnedIds.add(delivery.id.toString());
        debugPrint('🔔 Notification envoyée: Livraison retournée ${delivery.id}');
      }
    }
  }

  Future<void> _loadNotifiedIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final newIds = prefs.getStringList('notified_delivery_ids') ?? [];
      final completedIds = prefs.getStringList('notified_completed_ids') ?? [];
      final returnedIds = prefs.getStringList('notified_returned_ids') ?? [];
      
      _notifiedDeliveryIds.addAll(newIds);
      _notifiedCompletedIds.addAll(completedIds);
      _notifiedReturnedIds.addAll(returnedIds);
      
      debugPrint('📥 DeliveryPollingService: ${_notifiedDeliveryIds.length} IDs chargés');
    } catch (e) {
      debugPrint('❌ DeliveryPollingService: Erreur lors du chargement des IDs: $e');
    }
  }

  Future<void> _saveNotifiedIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setStringList('notified_delivery_ids', _notifiedDeliveryIds.toList());
      await prefs.setStringList('notified_completed_ids', _notifiedCompletedIds.toList());
      await prefs.setStringList('notified_returned_ids', _notifiedReturnedIds.toList());
    } catch (e) {
      debugPrint('❌ DeliveryPollingService: Erreur lors de la sauvegarde des IDs: $e');
    }
  }

  void reset() {
    _notifiedDeliveryIds.clear();
    _notifiedCompletedIds.clear();
    _notifiedReturnedIds.clear();
  }
}

