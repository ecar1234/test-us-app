

import '../../../core/net_driver.dart';
import 'message_data_source.dart';

class MessageDataSourceImpl implements MessageDataSource {
  final NetDriver netDriver;

  MessageDataSourceImpl(this.netDriver);
}