import 'package:flutter/material.dart';
import 'package:hairdresser/layout_page/components/layouts_card.dart';

class LayoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: List.generate(
            6,
                (index) {
              switch (index) {
                case 0:
                  return Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 5,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Клиент:',
                                style: TextStyle(
                                  color: Color(0xff3d3d3d),
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w200,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Ирина Иванова',
                                style: TextStyle(
                                  color: Color(0xff3d3d3d),
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 5,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Процедура:',
                                style: TextStyle(
                                  color: Color(0xff3d3d3d),
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w200,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Окрашивание волос',
                                style: TextStyle(
                                  color: Color(0xff3d3d3d),
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Дата визита:',
                                      style: TextStyle(
                                        color: Color(0xff3d3d3d),
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w200,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '21.02.2021',
                                      style: TextStyle(
                                        color: Color(0xff3d3d3d),
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xff333333),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 5,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Последнее изменение:',
                                style: TextStyle(
                                  color: Color(0xff3d3d3d),
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w200,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '21.02.2021',
                                style: TextStyle(
                                  color: Color(0xff3d3d3d),
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                case 1:
                  return LayoutCard(
                      backgroundImage:
                      new AssetImage('assets/images/head-top.png'));
                case 2:
                  return LayoutCard(
                      backgroundImage:
                      AssetImage('assets/images/head-face.png'));
                case 3:
                  return LayoutCard(
                      backgroundImage:
                      AssetImage('assets/images/head-occiput.png'));
                case 4:
                  return LayoutCard(
                      backgroundImage:
                      AssetImage('assets/images/head-right.png'));
                case 5:
                  return LayoutCard(
                      backgroundImage:
                      AssetImage('assets/images/head-left.png'));
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
