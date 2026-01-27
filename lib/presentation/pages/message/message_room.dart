import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/data/models/package/recruit_post_applications_model.dart';
import 'package:test_us_app/domain/entities/message_entity.dart';
import 'package:test_us_app/presentation/bloc/message_bloc/message_event.dart';
import 'package:test_us_app/presentation/bloc/message_bloc/message_state.dart';
import 'package:test_us_app/presentation/provider/socket_provider.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';

import '../../../services/common_height_provider.dart';
import '../../../services/socket/socket_io_client.dart';
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
  late int messageRoonId;
  late SocketProvider socketProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    socketProvider = context.read<SocketProvider>();
    socketProvider.connect();

    final token = context.read<UserProvider>().token ?? '';

    if (widget.postId != null) {
      context
          .read<MessageBloc>()
          .add(RequestRoomMessagesByPostIdEvent(token, widget.postId!, widget.targetUser!.userId!));
    } else {
      socketProvider.joinRoom(widget.roomId!);
      context.read<MessageBloc>().add(RequestRoomMessagesByRoomIdEvent(token, widget.roomId!));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
    socketProvider.leaveRoom(widget.roomId ?? messageRoonId);
  }

  @override
  Widget build(BuildContext context) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei!;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('${widget.targetUser!.nickname}'),
            ),
            body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: BlocConsumer<MessageBloc, MessageBlocState>(listener: (context, state) {
                if (state is RoomMessagesLoadCompletedState) {
                  context.read<SocketProvider>().setMessages(state.messageList);
                  if (state.messageList.isNotEmpty) {
                    messageRoonId = state.messageList.first.roomId!;
                    if(widget.roomId == null){
                      socketProvider.joinRoom(messageRoonId);
                    }
                  }
                }
              }, builder: (context, state) {
                if(state.state == MessageLoadState.dataLoadState){
                  return Center(child: CircularProgressIndicator());
                }
                return Container(
                  height: hei,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Selector<SocketProvider, List<MessageEntity>>(selector: (context, provider) {
                          return provider.messages ?? [];
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

                                // 1. 날짜 구분선을 표시해야 하는지 확인
                                bool showDateHeader = false;

                                if (createdAt != null) {
                                  // 1️⃣ 리스트의 첫 번째 메시지 (가장 오래된 메시지)
                                  if (idx == messages.length - 1) {
                                    showDateHeader = true;
                                  }
                                  // 2️⃣ 바로 이전(시간상 과거) 메시지와 날짜가 다를 때
                                  else {
                                    final nextCreatedAt = messages[idx + 1].createdAt;
                                    if (nextCreatedAt != null) {
                                      showDateHeader =
                                          createdAt.year != nextCreatedAt.year ||
                                              createdAt.month != nextCreatedAt.month ||
                                              createdAt.day != nextCreatedAt.day;
                                    }
                                  }
                                }
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    if (showDateHeader) _buildDateHeader(createdAt!),
                                    Row(
                                      mainAxisAlignment: message.sender!.userId == widget.targetUser!.userId
                                          ? MainAxisAlignment.start
                                          : MainAxisAlignment.end,
                                      children: [
                                        //todo: 메시지 UI 만들어여 하고, 메시지 전송시 동일안 member로 추가 안되는 문제 해결해야됨.
                                        Text(
                                          TimeUtil().getChatDateTimeString(message.createdAt!),
                                          style: TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                        const Gap(10),
                                        Container(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.sizeOf(context).width * 0.6,
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
                                            messages[idx].content!,
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                              separatorBuilder: (context, idx) => const Gap(10),
                              itemCount: messages.length);
                        }),
                      ),
                      SizedBox(
                        // height: 50,
                        width: MediaQuery.sizeOf(context).width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 8,
                              child: SizedBox(
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
                                    counterText: "",
                                  ),
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
                                      final req = TReqMessageEntity(
                                        roomId: widget.roomId ?? messageRoonId,
                                        content: _controller.text,
                                        targetId: widget.targetUser!.userId,
                                        postId: widget.postId,
                                      );
                                      context.read<SocketProvider>().sendMessage(req);
                                      _controller.clear();
                                    },
                                    style: ElevatedButton.styleFrom(
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
                );
              }),
            )));
  }

  Widget _buildDateHeader(DateTime date) {
    final compareData = date.compareTo(DateTime.now());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: compareData == 0
              ? Text(
                  "오늘",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                )
              : (compareData == 1
                  ? Text('어제')
                  : Text(
                      "${date.year}년 ${date.month}월 ${date.day}일",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    )),
        ),
      ),
    );
  }

  bool isDifferentDay(DateTime a, DateTime b) {
    return a.year != b.year || a.month != b.month || a.day != b.day;
  }
}
