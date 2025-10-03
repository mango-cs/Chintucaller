import '../services/supabase_service.dart';

class AnalyticsService {
  final _client = SupabaseService.instance.client;

  /// Get user analytics summary
  Future<Map<String, dynamic>> getUserAnalyticsSummary(
      {int daysBack = 30}) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client.rpc('get_user_analytics_summary', params: {
        'user_uuid': userId,
        'days_back': daysBack,
      });

      return response[0] as Map<String, dynamic>;
    } catch (error) {
      throw Exception('Failed to get analytics summary: $error');
    }
  }

  /// Get call records for a user
  Future<List<Map<String, dynamic>>> getCallRecords({
    int limit = 50,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      var query = _client
          .from('call_records')
          .select('*, user_profiles!inner(*)')
          .eq('user_id', userId);

      if (status != null) {
        query = query.eq('call_status', status);
      }

      if (startDate != null) {
        query = query.gte('start_time', startDate.toIso8601String());
      }

      if (endDate != null) {
        query = query.lte('start_time', endDate.toIso8601String());
      }

      final response = await query
          .order('start_time', ascending: false)
          .limit(limit);
      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to get call records: $error');
    }
  }

  /// Get daily analytics data for charts
  Future<List<Map<String, dynamic>>> getDailyAnalytics({
    int daysBack = 7,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final endDate = DateTime.now();
      final startDate = endDate.subtract(Duration(days: daysBack));

      final response = await _client
          .from('call_analytics')
          .select(
              'date, total_calls, successful_calls, missed_calls, total_duration, average_duration')
          .eq('user_id', userId)
          .gte('date', startDate.toIso8601String().split('T')[0])
          .lte('date', endDate.toIso8601String().split('T')[0])
          .order('date', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to get daily analytics: $error');
    }
  }

  /// Create a new call record
  Future<Map<String, dynamic>> createCallRecord({
    required String callerName,
    required String callerPhone,
    required String callType,
    required String callStatus,
    DateTime? startTime,
    DateTime? endTime,
    int? duration,
    String? transcript,
    String? summary,
    double? aiConfidenceScore,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final callData = {
        'user_id': userId,
        'caller_name': callerName,
        'caller_phone': callerPhone,
        'call_type': callType,
        'call_status': callStatus,
        if (startTime != null) 'start_time': startTime.toIso8601String(),
        if (endTime != null) 'end_time': endTime.toIso8601String(),
        if (duration != null) 'duration': duration,
        if (transcript != null) 'transcript': transcript,
        if (summary != null) 'summary': summary,
        if (aiConfidenceScore != null) 'ai_confidence_score': aiConfidenceScore,
      };

      final response =
          await _client.from('call_records').insert(callData).select().single();

      return response;
    } catch (error) {
      throw Exception('Failed to create call record: $error');
    }
  }

  /// Update call record
  Future<Map<String, dynamic>> updateCallRecord({
    required String recordId,
    String? callStatus,
    DateTime? endTime,
    int? duration,
    String? transcript,
    String? summary,
    double? aiConfidenceScore,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (callStatus != null) updateData['call_status'] = callStatus;
      if (endTime != null) updateData['end_time'] = endTime.toIso8601String();
      if (duration != null) updateData['duration'] = duration;
      if (transcript != null) updateData['transcript'] = transcript;
      if (summary != null) updateData['summary'] = summary;
      if (aiConfidenceScore != null)
        updateData['ai_confidence_score'] = aiConfidenceScore;

      final response = await _client
          .from('call_records')
          .update(updateData)
          .eq('id', recordId)
          .select()
          .single();

      return response;
    } catch (error) {
      throw Exception('Failed to update call record: $error');
    }
  }
}