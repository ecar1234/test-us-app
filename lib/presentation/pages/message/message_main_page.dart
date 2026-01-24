import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../bloc/message_bloc/message_bloc.dart';
import '../../bloc/message_bloc/message_event.dart';
import '../../bloc/message_bloc/message_state.dart';
import '../../provider/room_provider.dart';
import '../../provider/user_provider.dart';

class MessageMainPage extends StatefulWidget {
  final String? targetUserId;

  const MessageMainPage({super.key, this.targetUserId});

  @override
  State<MessageMainPage> createState() => _MessageMainPageState();
}

class _MessageMainPageState extends State<MessageMainPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final token = context.read<UserProvider>().token ?? '';
    final userId = context.read<UserProvider>().user!.id ?? '';
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
              padding: EdgeInsets.all(20),
              child: BlocConsumer<MessageBloc, MessageBlocState>(
                  listener: (context, state) {
                    if(state is RoomListLoadCompletedState){
                      context.read<RoomProvider>().setRoomList(state.roomList!);
                    }
                  },
                  builder: (context, state) {
                    if(state.state == MessageLoadState.dataLoadState){
                      return Center(child: CircularProgressIndicator());
                    }else if(state is RoomListLoadCompletedState){
                      if(state.roomList.isEmpty){
                        return Center(child: Text("메지지가 없습니다."));
                      }
                      return ListView.separated(
                        itemBuilder: (context, idx) {
                          return Container();
                        },
                        separatorBuilder: (context, idx) {
                          return Gap(20);
                        },
                        itemCount: state.roomList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                      );
                    } else if(state.state == MessageLoadState.errorState){
                      return Center(child: Text("에러가 발생했습니다."));
                    }
                    return SizedBox();
                  }),
            )));
  }
}
