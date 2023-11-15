import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schedule_sgk/bloc/group.bloc/group_bloc.dart';
import 'package:schedule_sgk/widgets/search/group_search_list.dart';

import '../bloc/group.bloc/group_event.dart';

class GroupDialog extends StatelessWidget {
  final GroupBloc groupBloc;

  const GroupDialog({Key? key, required this.groupBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return BlocProvider.value(
      value: groupBloc,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          groupBloc.add(GroupLoadEvent());
          Navigator.pop(context);
        },
        child: Stack(
          children: [
            Positioned(
              top: ScreenUtil().screenHeight * 0.3,
              left: ScreenUtil().screenWidth * 0.1,
              width: ScreenUtil().screenWidth * 0.8,
              child: Card(
                elevation: 5,
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(
                          ScreenUtil().setWidth(15),
                          ScreenUtil().setHeight(10),
                          ScreenUtil().setWidth(15),
                          ScreenUtil().setHeight(25),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).cardColor,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  child: Image.asset(
                                    'assets/glass.png',
                                    width: ScreenUtil().setWidth(15),
                                    height: ScreenUtil().setHeight(15),
                                  ),
                                  padding: EdgeInsets.fromLTRB(
                                    ScreenUtil().setWidth(25),
                                    0,
                                    0,
                                    0,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                      ScreenUtil().setWidth(15),
                                      0,
                                      ScreenUtil().setWidth(0),
                                      0,
                                    ),
                                    child: TextField(
                                      onChanged: (searchTerm) {
                                        groupBloc.add(GroupSearchEvent(searchTerm: searchTerm));
                                      },
                                      style: TextStyle(
                                        fontFamily: Theme.of(context).textTheme.bodyText1?.fontFamily,
                                        color: Theme.of(context).textTheme.labelMedium?.color,
                                        fontSize: ScreenUtil().setSp(16),
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Поиск',
                                        hintStyle: TextStyle(
                                          fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF9E9E9E),
                                          fontSize: ScreenUtil().setSp(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(250),
                        height: ScreenUtil().setHeight(250),
                        child: GroupSearchList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
