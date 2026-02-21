import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/data/models/package/recruit_post_applications_model.dart';
import 'package:test_us_app/domain/entities/room_entity.dart';
import 'package:test_us_app/domain/entities/room_member_entity.dart';

import '../../../data/models/user/user_model.dart';
import '../../../services/common_height_provider.dart';
import '../../../utils/time_util.dart';
import '../../bloc/message_bloc/message_bloc.dart';
import '../../bloc/message_bloc/message_event.dart';
import '../../bloc/message_bloc/message_state.dart';
import '../../provider/room_provider.dart';
import '../../provider/user_provider.dart';
import 'message_room.dart';

class MessageMainPage extends StatefulWidget {
  const MessageMainPage({super.key});

  @override
  State<MessageMainPage> createState() => _MessageMainPageState();
}

class _MessageMainPageState extends State<MessageMainPage> {
  late String userId;

  @override
  void initState() {
    super.initState();
    final token = context.read<UserProvider>().token ?? '';
    userId = context.read<UserProvider>().user!.id ?? '';
    context.read<MessageBloc>().add(RequestRoomListEvent(token, userId));
  }

  @override
  Widget build(BuildContext context) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei ?? MediaQuery.sizeOf(context).height - 120;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("메시지"),
            ),
            body: Container(
              height: hei,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Expanded(
                      child: BlocConsumer<MessageBloc, MessageBlocState>(listener: (context, state) {
                        if (state is RoomListLoadCompletedState) {
                          context.read<RoomProvider>().setRoomList(state.roomList);
                        } else if (state is RoomDeleteCompletedState) {
                          context.read<RoomProvider>().deleteRoom(state.roomId);
                        } else if (state.state == MessageLoadState.errorState) {
                          Get.snackbar("알림", "에러가 발생했습니다.");
                        }
                      }, builder: (context, state) {
                        if (state.state == MessageLoadState.dataLoadState) {
                          return Center(child: CircularProgressIndicator());
                        } else if (state.state == MessageLoadState.errorState) {
                          return Center(child: Text("에러가 발생했습니다."));
                        }
                        return Selector<RoomProvider, List<RoomEntity>>(selector: (context, provider) {
                          return provider.roomList ?? [];
                        }, builder: (context, roomList, child) {
                          if (roomList.isEmpty) {
                            return Center(child: Text("아직 대화방이 없습니다 😯", style: TextStyle(fontSize: 18)));
                          }
                          return ListView.separated(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: false,
                            itemBuilder: (context, idx) {
                              final room = roomList[idx];
                              final targetUser = room.members!.firstWhereOrNull((member) => member.user!.id != userId);
                              final dateInfo = TimeUtil().getChatMessageCreatedAt(room.lastMessageAt!);
                              final unreadCount =
                                  room.members!.firstWhere((member) => member.user!.id == userId).unreadCount ?? 0;
                              // final isActiveTarget = targetUser != null && targetUser.user!.status == UserStatus.active;
                              // final isActiveRoom = room.post.

                              return Slidable(
                                endActionPane: ActionPane(motion: ScrollMotion(), extentRatio: 0.25, children: [
                                  SlidableAction(
                                    onPressed: (_) async {
                                      await _deleteRoomDialog(context, room.id!);
                                    },
                                    backgroundColor: const Color(0xFF0392CF),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: '삭제',
                                  ),
                                ]),
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    // if(!isActive){
                                    //   Get.snackbar("알림", "종료 또는 접근할 수 없는 채팅 입니다.");
                                    //   return;
                                    // }
                                    final user = targetUser != null
                                        ? User(
                                            userId: targetUser.user!.id,
                                            nickname: targetUser.user!.nickname,
                                            status: targetUser.user!.status,
                                          )
                                        : null;
                                    Get.to(() => MessageRoom(roomId: room.id, targetUser: user));
                                  },
                                  child: SizedBox(
                                    child: Row(
                                      children: [
                                        Flexible(
                                          flex: 2,
                                          child: SizedBox(
                                            width: 60,
                                            child: ClipRect(
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(25),
                                                    child: targetUser != null && targetUser.user?.profileImg?.url != null
                                                        ? CachedNetworkImage(
                                                            imageUrl: targetUser.user!.profileImg!.url!,
                                                            width: 60,
                                                            height: 60,
                                                            fit: BoxFit.cover,
                                                            placeholder: (context, url) =>
                                                                Container(color: Colors.grey[200]),
                                                            errorWidget: (context, url, error) => Image.asset(
                                                                'assets/images/default avatar.png',
                                                                fit: BoxFit.cover),
                                                          )
                                                        : Image.asset(
                                                            'assets/images/default avatar.png',
                                                            width: 50,
                                                            height: 50,
                                                            fit: BoxFit.cover,
                                                          ))),
                                          ),
                                        ),
                                        const Gap(10),
                                        Flexible(
                                            flex: 6,
                                            child: SizedBox(
                                                width: MediaQuery.sizeOf(context).width * 0.6,
                                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        targetUser != null ? targetUser.user!.nickname! : "알 수 없는 유저",
                                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    room.lastMessageContent ?? "",
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(fontSize: 16, color: Colors.grey),
                                                  ),
                                                  const Gap(5),
                                                  Text(
                                                    room.post!.title!,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                                  ),
                                                ]))),
                                        const Gap(5),
                                        Flexible(
                                            flex: 2,
                                            child: SizedBox(
                                              width: MediaQuery.sizeOf(context).width * 0.2,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text('${dateInfo['dateTime']}',
                                                          textAlign: TextAlign.end,
                                                          style: TextStyle(fontSize: dateInfo['size'], color: Colors.grey)),
                                                    ],
                                                  ),
                                                  if (unreadCount > 0)
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Container(
                                                            width: 25,
                                                            height: 25,
                                                            decoration: BoxDecoration(
                                                              color: Colors.red,
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                unreadCount.toString(),
                                                                style: TextStyle(color: Colors.white),
                                                              ),
                                                            )),
                                                      ],
                                                    )
                                                ],
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, idx) {
                              return Gap(20);
                            },
                            itemCount: roomList.length,
                          );
                        });
                      }),
                    ),
                  ],
                ))));
  }

  Future<void> _deleteRoomDialog(BuildContext context, int roomId) async {
    return await showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Container(
                height: 200,
                width: MediaQuery.sizeOf(context).width,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // color: Colors.white
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "채팅방 나가기",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '채팅방을 나가면 이전 대화를\n다시 확인하거나 복구할 수 없습니다.',
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(20),
                    LayoutBuilder(builder: (context, constraints) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 3,
                            child: SizedBox(
                              width: constraints.maxWidth * 0.3,
                              child: OutlinedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Theme.of(context).colorScheme.primary),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  child: Text('취소')),
                            ),
                          ),
                          const Gap(10),
                          Flexible(
                            flex: 7,
                            child: SizedBox(
                              width: constraints.maxWidth * 0.7,
                              child: ElevatedButton(
                                  onPressed: () {
                                    final token = context.read<UserProvider>().token ?? '';
                                    final userId = context.read<UserProvider>().user!.id ?? '';
                                    context.read<MessageBloc>().add(DeleteRoomEvent(token, roomId, userId));
                                    Get.back();
                                  },
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  child: Text('삭제(나가기)')),
                            ),
                          )
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ));
  }
}
