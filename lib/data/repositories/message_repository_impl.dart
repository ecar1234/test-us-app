

import 'package:test_us_app/data/data_sources/message_data/message_data_source.dart';

import '../../domain/repositories/message_repository.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageDataSource remote;

  MessageRepositoryImpl(this.remote);
}