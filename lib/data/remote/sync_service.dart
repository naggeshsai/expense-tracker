/// Abstract sync service interface for Phase 2 cloud sync implementation
/// This can be implemented with Supabase, Firebase, or other backend services
abstract class SyncService {
  /// Initialize sync service
  Future<void> initialize();
  
  /// Sync all local changes to remote
  Future<void> syncToRemote();
  
  /// Sync all remote changes to local
  Future<void> syncFromRemote();
  
  /// Check if device is online
  Future<bool> isOnline();
  
  /// Listen to connectivity changes
  Stream<bool> get connectivityStream;
}
