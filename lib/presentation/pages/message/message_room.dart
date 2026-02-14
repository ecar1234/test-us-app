import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/data/models/package/recruit_post_applications_model.dart';
import 'package:test_us_app/domain/entities/message_entity.dart';
import 'package:test_us_app/presentation/bloc/message_bloc/message_event.dart';
import 'package:test_us_app/presentation/bloc/message_bloc/message_state.dart';
import 'package:test_us_app/presentation/provider/socket_provider.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';

import '../../../data/models/user/user_model.dart';
import '../../../services/common_height_provider.dart';
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
  late int? roomId;
  late String senderId;
  late SocketProvider socketProvider;
  bool _isInitialized = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    roomId = widget.roomId;
    senderId = context.read<UserProvider>().user!.id!;
    socketProvider = context.read<SocketProvider>();

    _initializeData();
  }

  void _initializeData() {
    if (_isInitialized) return;

    socketProvider.connect();
    final token = context.read<UserProvider>().token ?? '';

    if (widget.postId != null) {
      // 신규 방 생성 시나리오
      socketProvider.joinUser(widget.targetUser!.userId!);
      socketProvider.joinUser(senderId);
      context
          .read<MessageBloc>()
          .add(RequestRoomMessagesByPostIdEvent(token, widget.postId!, widget.targetUser!.userId!));
    } else if (widget.roomId != null) {
      // 기존 방 입장 시나리오
      socketProvider.joinUser(widget.targetUser!.userId!);
      socketProvider.joinUser(senderId);
      socketProvider.joinRoom(widget.roomId!);
      context.read<MessageBloc>().add(RequestRoomMessagesByRoomIdEvent(token, widget.roomId!, senderId));
    }

    _isInitialized = true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
    socketProvider.leaveRoom(roomId, senderId, widget.targetUser!.userId!);
  }

  @override
  Widget build(BuildContext context) {
    // final hei = GetIt.I.get<ResponsiveHeightProvider>().hei!;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title:
                  Text(widget.targetUser!.status == UserStatus.active ? '${widget.targetUser!.nickname}' : '알 수 없는 유져'),
            ),
            body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: BlocListener<MessageBloc, MessageBlocState>(
                  listener: (context, state) {
                    if (state is RoomMessagesLoadCompletedState) {
                      socketProvider.setMessages(state.messageList);
                      if (state.messageList.isNotEmpty) {
                        roomId = state.messageList[0].roomId!;
                        socketProvider.resetUnreadCount(state.messageList.first.roomId!);
                      }
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
                              if (roomId != null) {
                                return message.roomId == roomId;
                              }
                              return false;
                            }).toList();
                          }, builder: (context, messages, child) {
                            return ListView.separated(
                                padding: EdgeInsets.only(bottom: 10),
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                reverse: true,
                                itemBuilder: (context, idx) {
                                  if (messages.isEmpty) {
                                    return Center(child: Text('메시지가 없습니다.'));
                                  }
                                  final message = messages[idx];
                                  final DateTime? createdAt = message.createdAt;
                                  final next = idx > 0 ? messages[idx - 1] : null;
                                  final prev = idx < messages.length - 1 ? messages[idx + 1] : null;

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
                                    if (idx == messages.length - 1) {
                                      showDateHeader = true;
                                    } else {
                                      final nextCreatedAt = messages[idx + 1].createdAt;
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
                                      if (message.sender!.userId != senderId)
                                        _buildLeftMessage(message, showProfile, showTime)
                                      else
                                        _buildRightMessage(message)
                                    ],
                                  );
                                },
                                separatorBuilder: (context, idx) => const Gap(10),
                                itemCount: messages.length);
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
                                      onPressed: () {
                                        if (_controller.text.isEmpty) {
                                          Get.snackbar('알림', '메시지를 입력해주세요.');
                                          return;
                                        }
                                        final req = TReqMessageEntity(
                                          roomId: roomId,
                                          content: _controller.text,
                                          targetId: widget.targetUser!.userId,
                                          postId: widget.postId,
                                        );
                                        socketProvider.sendMessage(req);
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

  bool isDifferentDay(DateTime a, DateTime b) {
    return a.year != b.year || a.month != b.month || a.day != b.day;
  }

  Widget _buildLeftMessage(MessageEntity message, bool showProfile, bool showTime) {
    final isDarkMode = context.read<ThemeProvider>().isDarkMode;
    final isActive = message.sender!.status == UserStatus.active;
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
                    maxWidth: MediaQuery.sizeOf(context).width * 0.4,
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
            maxWidth: MediaQuery.sizeOf(context).width * 0.4,
          ),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: BoxDecoration(
            color: message.sender!.userId == widget.targetUser!.userId
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
