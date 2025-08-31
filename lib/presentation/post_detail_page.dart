import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../domain/entities/post_entity.dart';

class PostDetailPage extends StatefulWidget {
  final PostEntity? post;
  const PostDetailPage({super.key, this.post});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              // bottom: PreferredSize(
              //   preferredSize: Size.fromHeight(100),
              //   child: Container(
              //     child: Text(";alskdjflaksdjlaksdf"),
              //   )
              // ),
              leading: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon( Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios_new),
              ),
              actions: [
                widget.post!.author != null ?
                PopupMenuButton(icon: Icon(Icons.more_vert_rounded), itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(value: 1, child: Text("Edit")),
                    PopupMenuItem(value: 2, child: Text("Delete"))
                  ];
                }, )
                    : SizedBox()
              ],
              expandedHeight: 300,
              // pinned: true,
            ),
            if(widget.post == null)
              SliverList(
                key: const ValueKey("nullValue"),
                  delegate: SliverChildBuilderDelegate(
                (context, index) => SizedBox(
                  height: 100,
                  child: Card(
                    child: Text(index.toString()),
                  ),
                ),
                childCount: 30,
              ))
            else
            SliverToBoxAdapter(
              key: const ValueKey("postValue"),
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(child: Text(widget.post!.title!, style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold
                    ),)),
                    const Gap(10),
                    SizedBox(child: Text(widget.post!.subtitle!, style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ))),
                    const Gap(30),
                    SizedBox(child: Text(widget.post!.contents!)),
                    const Gap(40),
                    if(widget.post!.author != null)
                    Center(
                      child: SizedBox(
                        height: 50,
                        width: MediaQuery.sizeOf(context).width - 80,
                        child: ElevatedButton(
                          onPressed: (){},
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            )
                          ),
                          child: Text("테스터 신청"),
                        ),
                      ),
                    ),
                    if(widget.post!.author != null)
                    const Gap(80),
                  ],
                ),
              ),
            )
          ],
        ),
    ));
  }
}
