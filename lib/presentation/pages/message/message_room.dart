
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/data/models/package/recruit_post_applications_model.dart';
import 'package:test_us_app/domain/entities/message_entity.dart';
import 'package:test_us_app/presentation/bloc/message_bloc/message_event.dart';
import 'package:test_us_app/presentation/bloc/message_bloc/message_state.dart';
import 'package:test_us_app/presentation/provider/room_provider.dart';
import 'package:test_us_app/presentation/provider/socket_provider.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';

import '../../../data/models/user/user_model.dart';
import '../../../services/socket/socket_io_client.dart';
import '../../../services/theme_provider.dart';
import '../../../utils/time_util.dart';
import '../../bloc/message_bloc/message_bloc.dart';

class MessageRoom extends StatefulWidget {
  final User? targetUser;
  final String? postId;
  final int? roomId;

  const MessageRoom({super.key, this.targetUser, this.postId, this.roomId});

  @override
  State<MessageRoom> createState() => _MessageRoomState();
}

class _MessageRoomState extends State<MessageRoom> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late int? _roomId;
  late String _senderId;
  late SocketProvider _socketProvider;
  late RoomProvider _roomProvider;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _roomId = widget.roomId;
    _senderId = context.read<UserProvider>().user!.id!;
    _socketProvider = context.read<SocketProvider>();
    _roomProvider = context.read<RoomProvider>();

    _initializeData();
  }

  void _initializeData() {
    if (_isInitialized) return;

    _socketProvider.connect();
    final token = context.read<UserProvider>().token ?? '';

    if (widget.postId != null) {
      // 신규 방 생성 시나리오
      // socketProvider.joinUser(widget.targetUser!.userId!);
      _socketProvider.joinUser(_senderId);
      context
          .read<MessageBloc>()
          .add(RequestRoomMessagesByPostIdEvent(token, widget.postId!, widget.targetUser!.userId!));
    } else if (widget.roomId != null) {
      // 기존 방 입장 시나리오
      // socketProvider.joinUser(widget.targetUser!.userId!);
      _socketProvider.joinUser(_senderId);
      _socketProvider.joinRoom(widget.roomId!);
      context.read<MessageBloc>().add(RequestRoomMessagesByRoomIdEvent(token, widget.roomId!, _senderId));
    }

    _isInitialized = true;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
    _socketProvider.leaveRoom(_roomId, _senderId, widget.targetUser?.userId);
  }

  @override
  Widget build(BuildContext context) {
    // final hei = GetIt.I.get<ResponsiveHeightProvider>().hei!;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title:
                  Text(widget.targetUser != null ? '${widget.targetUser!.nickname}' : '알 수 없는 유져'),
            ),
            body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: BlocListener<MessageBloc, MessageBlocState>(
                  listener: (context, state) {
                    if (state is RoomMessagesLoadCompletedState) {
                      setState(() {
                        _roomId = state.messageList.last.roomId;
                      });
                      _socketProvider.setMessages(state.messageList);
                      if(state.messageList.isNotEmpty){
                        _roomProvider.updateRoom(state.messageList.last, _senderId, isJoin: true);
                      }
                    }else if(state.state == MessageLoadState.failedState){
                      Get.snackbar('알림', '이용 할 수 없습니다.');
                      Navigator.pop(context);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 20, left: 20, bottom: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Selector<SocketProvider, List<MessageEntity>>(selector: (context, provider) {
                            if (provider.messages == null || provider.messages!.isEmpty) {
                              return [];
                            }
                            return provider.messages!.where((message) {
                              if (_roomId != null) {
                                return message.roomId == _roomId;
                              }
                              return false;
                            }).toList();
                          }, builder: (context, messages, child) {
                            final isLeft = widget.targetUser == null;
                            final itemCount = messages.length + (isLeft ? 1 : 0);

                            // if (itemCount == 0) {
                            //   return Center(child: Text('메시지가 없습니다.'));
                            // }

                            return ListView.separated(
                                padding: EdgeInsets.only(bottom: 10),
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                reverse: true,
                                itemBuilder: (context, idx) {

                                  if(isLeft && idx == 0) {
                                    return _buildLeaveFooter(context);
                                  }

                                  final messageIdx = isLeft ? idx - 1 : idx;
                                  if (messageIdx < 0 || messageIdx >= messages.length) {
                                    return const SizedBox.shrink();
                                  }
                                  final message = messages[messageIdx];

                                  final DateTime? createdAt = message.createdAt;
                                  final next = messageIdx > 0 ? messages[messageIdx - 1] : null;
                                  final prev = messageIdx < messages.length - 1 ? messages[messageIdx + 1] : null;

                                  bool isSameUser(MessageEntity? a, MessageEntity? b) =>
                                      a?.sender!.userId == b?.sender!.userId;

                                  bool isSameMinute(DateTime? a, DateTime? b) {
                                    if (a == null || b == null) return false;
                                    return a.year == b.year &&
                                        a.month == b.month &&
                                        a.day == b.day &&
                                        a.hour == b.hour &&
                                        a.minute == b.minute;
                                  }

                                  bool showProfile =
                                      !isSameUser(message, prev) || !isSameMinute(message.createdAt, prev?.createdAt);
                                  bool showTime =
                                      !isSameUser(message, next) || !isSameMinute(message.createdAt, next?.createdAt);
                                  bool showDateHeader = false;

                                  if (createdAt != null) {
                                    if (messageIdx == messages.length - 1) {
                                      showDateHeader = true;
                                    } else {
                                      final nextCreatedAt = messages[messageIdx + 1].createdAt;
                                      if (nextCreatedAt != null) {
                                        showDateHeader = createdAt.year != nextCreatedAt.year ||
                                            createdAt.month != nextCreatedAt.month ||
                                            createdAt.day != nextCreatedAt.day;
                                      }
                                    }
                                  }

                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      if (showDateHeader) _buildDateHeader(createdAt!),
                                      if (message.sender!.userId != _senderId)
                                        _buildLeftMessage(message, showProfile, showTime)
                                      else if(message.sender!.userId == _senderId)
                                        _buildRightMessage(message),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, idx) => const Gap(10),
                                itemCount: itemCount);
                          }),
                        ),
                        const Gap(5),
                        SizedBox(
                          // height: 50,
                          width: MediaQuery.sizeOf(context).width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 8,
                                child: SizedBox(
                                  height: 40,
                                  width: (MediaQuery.sizeOf(context).width - 40) * 0.8,
                                  child: TextField(
                                    controller: _controller,
                                    focusNode: _focusNode,
                                    minLines: 1,
                                    maxLines: 2,
                                    // 중요 ⭐
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                    decoration: const InputDecoration(
                                      // isDense: true,
                                      counterText: "",
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    ),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              const Gap(10),
                              Flexible(
                                flex: 2,
                                child: SizedBox(
                                  height: 40,
                                  width: (MediaQuery.sizeOf(context).width - 40) * 0.2,
                                  child: ElevatedButton(
                                      onPressed:widget.targetUser == null ? null : () {
                                        if (_controller.text.isEmpty) {
                                          Get.snackbar('알림', '메시지를 입력해주세요.');
                                          return;
                                        }
                                        final req = TReqMessageEntity(
                                          roomId: _roomId,
                                          content: _controller.text,
                                          targetId: widget.targetUser!.userId,
                                          postId: widget.postId,
                                        );
                                        _socketProvider.sendMessage(req);
                                        _controller.clear();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text('전송')),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            )));
  }

  Widget _buildDateHeader(DateTime date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              TimeUtil().getChatRoomHeaderDate(date),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            )),
      ),
    );
  }
  Widget _buildLeaveFooter(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '상대방이 방을 나갔습니다.',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            )),
      ),
    );
  }

  bool isDifferentDay(DateTime a, DateTime b) {
    return a.year != b.year || a.month != b.month || a.day != b.day;
  }

  Widget _buildLeftMessage(MessageEntity message, bool showProfile, bool showTime) {
    final isDarkMode = context.read<ThemeProvider>().isDarkMode;
    final isActive = widget.targetUser != null && message.sender!.status == UserStatus.active;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showProfile)
          ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: message.sender!.profileImg?.url != null && isActive
                  ? CachedNetworkImage(
                      imageUrl: message.sender!.profileImg!.url!,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: Colors.grey[200]),
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/images/default avatar.png', fit: BoxFit.cover),
                    )
                  : Image.asset(
                      'assets/images/default avatar.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ))
        else
          SizedBox(
            width: 40,
          ),
        const Gap(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showProfile)
              Text(isActive ? message.sender!.nickname! : '알 수 없는 유져',
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  key: ValueKey(message.id),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width * 0.6,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade600)),
                  child: Text(
                    message.content!,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                if (showTime) ...[
                  const Gap(5),
                  Text(
                    TimeUtil().getChatDateTimeString(message.createdAt!),
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ]
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRightMessage(MessageEntity message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          TimeUtil().getChatDateTimeString(message.createdAt!),
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const Gap(10),
        Container(
          key: ValueKey(message.id),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.6,
          ),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: BoxDecoration(
            color: message.sender!.userId == widget.targetUser?.userId
                ? Colors.white
                : Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10),
            // border: Border.all(color: Colors.grey.shade600)
          ),
          child: Text(
            message.content!,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
