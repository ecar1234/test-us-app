import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/data/models/package/recruit_post_applications_model.dart';
import 'package:test_us_app/domain/entities/room_entity.dart';

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
    // TODO: implement initState
    super.initState();
    final token = context.read<UserProvider>().token ?? '';
    userId = context.read<UserProvider>().user!.id ?? '';
    context.read<MessageBloc>().add(RequestRoomListEvent(token, userId));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("메지지"),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: BlocConsumer<MessageBloc, MessageBlocState>(listener: (context, state) {
                if (state is RoomListLoadCompletedState) {
                  context.read<RoomProvider>().setRoomList(state.roomList);
                }
              }, builder: (context, state) {
                if (state.state == MessageLoadState.dataLoadState) {
                  return Center(child: CircularProgressIndicator());
                } else if (state.state == MessageLoadState.errorState) {
                  return Center(child: Text("에러가 발생했습니다."));
                }
                return Selector<RoomProvider, List<RoomEntity>>(selector: (context, provider) {
                  return provider.roomList??[];
                }, builder: (context, roomList, child) {
                  if (roomList.isEmpty) {
                    return Center(child: Text("아직 대화방이 없습니다 😯"));
                  }
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, idx) {
                      final room = roomList[idx];
                      final targetUser = room.members!.firstWhere((m) => m.user!.id != userId);
                      final dateInfo = TimeUtil().getChatMessageCreatedAt(room.lastMessageAt!);
                      final unreadCount = room.members!.firstWhere((member) => member.user!.id == userId).unreadCount;


                      return Slidable(
                        endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          extentRatio: 0.25,
                          children: [
                            SlidableAction(
                              onPressed: (_) {
                                Get.snackbar("실행", "채팅방 삭제 실행");
                                // context.read<MessageBloc>().add(DeleteRoomEvent(room.id!));
                              },
                              backgroundColor: const Color(0xFF0392CF),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: '삭제',
                            ),
                          ]
                        ),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            final user = User(
                              userId: targetUser.user!.id,
                              nickname: targetUser.user!.nickname,
                            );
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
                                      child: targetUser.user!.profileImg?.url != null
                                          ? CachedNetworkImage(
                                              imageUrl: targetUser.user!.profileImg!.url!,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Container(color: Colors.grey[200]),
                                              errorWidget: (context, url, error) =>
                                                  Image.asset('assets/images/default avatar.png', fit: BoxFit.cover),
                                            )
                                          : Image.asset(
                                              'assets/images/default avatar.png',
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                    )),
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
                                                targetUser.user!.nickname!,
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
                                          if(unreadCount != null && unreadCount > 0)
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
                                                    child: Text(unreadCount.toString(), style: TextStyle(color: Colors.white),),
                                                  )
                                                ),
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
            )));
  }
}
