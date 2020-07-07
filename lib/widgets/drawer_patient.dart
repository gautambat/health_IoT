import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:remote_care/constants/constants.dart';
import 'package:remote_care/models/user.dart';

Widget PatientDrawer(BuildContext context, User user) {
  return patientDetailsDrawerLayout(user);
}

patientDetailsDrawerLayout(User user) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Expanded(
          flex:9,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top:50.0,left: 20,right: 5,bottom: 3),
                  child: Text(
                      user.name!=null?user.name:"-",
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.white,//Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        height: 1.625,
                      )
                  )
              ),
              Container(
                  height: 50.0,
                  margin: EdgeInsets.only(left:20.0,bottom: 5.0,right: 10.0),
                  child: Text(
                      user.mobile!=null?user.mobile:"-",
                      textAlign: TextAlign.left,
                      style:  TextStyle(
                        color: AppColors.white,//Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        height: 1.625,
                      )
                  )
              ),
            ],
          )
      ),
      Container(
        margin: EdgeInsets.only(top: 10.0,right: 15.0),
        height: 50.0,
        width: 50.0,
        decoration: user.imageUrl != null && user.imageUrl.isNotEmpty ? BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(user.imageUrl)
            )
        ) : BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue[100],
        ),
        child: user.imageUrl != null && user.imageUrl.isNotEmpty ? Container() : Icon(Icons.person, size: 30, color: AppColors.iconColor,),
      ),
    ],
  );
}