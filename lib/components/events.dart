import 'package:calendr/components/shimmerwidget.dart';
import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:shimmer/shimmer.dart';

class Events extends StatelessWidget {
  Events({super.key,this.isLoading=false});

  NepaliDateTime _todayDate = NepaliDateTime.now();

  bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.5),
          ),
          SizedBox(
            height: 18,
          ),
          Text("${NepaliDateFormat.MMMMEEEEd().format(_todayDate)}"),
          SizedBox(
            height: 18,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) => ListTile(
                    title: isLoading?ShimmerWidget.rectangular(height: 12): Text(
                        "Buddha jayanti",
                    ),
                    leading: isLoading?ShimmerWidget.circular(height: 30, width: 30): CircleAvatar(
                      radius: 15,
                    ),
                    subtitle:  isLoading?ShimmerWidget.rectangular(height: 12): Text(
                        "Today is the day bouddha is born ............"),
                  )),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Upcoming Events",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.5),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: Container(
            child: ListView.builder(
                itemCount: 3,
                itemBuilder: ((context, index) => ListTile(
                      title:  isLoading?ShimmerWidget.rectangular(height: 12):Text("Krishna janastami"),
                      trailing: isLoading?null: IconButton(
                          onPressed: () {},
                          tooltip: "Add the remainder for Event",
                          icon: Icon(Icons.notification_add)),
                      leading: isLoading?ShimmerWidget.circular(height: 30, width: 30):CircleAvatar(
                        radius: 15,
                      ),
                      subtitle:  isLoading?ShimmerWidget.rectangular(height: 12): Text("The day lord krishna is born..."),
                    ))),
          ))
        ],
      ),
    );
  }
}
