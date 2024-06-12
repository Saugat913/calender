import'package:flutter/material.dart';
//import'package:nepali'
import 'package:nepali_utils/nepali_utils.dart';



class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  String _selectedMonth = "Baisakh";
  int _selectedYear = 2070;
  bool _isHover = false;

  List<String> _months = [
    "Baisakh",
    "Jestha",
    "Asadh",
    "Shrawan",
    "Bhadra",
    "Aswin",
    "Kartik",
    "Mangsir",
    "Poush",
    "Magh",
    "Falgun",
    "Chaitra"
  ];
  String _selectedDay = "3";
  List<String> _days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

  int getFirstDayOfMonthIndex(int year, int month) {
    if (month == 13 || month > 12) {
      year = year + 1;
      month = month - 12;
    }
    var format = NepaliDateFormat.E();
    var firstDayOfMonth = format.format(NepaliDateTime.parse(
        '$year-${month.toString().padLeft(2, '0')}-01T11:56:25'));
    var firstDayOfMonthIndex = _days.indexOf(firstDayOfMonth);

    return firstDayOfMonthIndex;
  }

  List<String> getcalenderData(int year, int month) {
    int? _extraPosition;
    var calenderData = [
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
    ];

    //First find the first day of month
    var firstDayOfMonthIndex = getFirstDayOfMonthIndex(year, month);
    var firstDayOfNextMonthIndex = getFirstDayOfMonthIndex(year, month + 1);
    bool _isLastWeek = false;
    bool _isOverflow=false;

    for (var i = 0; i < calenderData.length - firstDayOfMonthIndex; i++) {
      if ((i + firstDayOfMonthIndex) / 7 == 4) {
        _isLastWeek = true;
      }
      if (_isLastWeek &&
          (i + firstDayOfMonthIndex) % 7 == firstDayOfNextMonthIndex) {
            if (i+1 <29) {
              calenderData[firstDayOfMonthIndex + i] = (i + 1).toString();
              _isOverflow=true;
              continue;
            }
        break;
      }
      if(_isOverflow){ _extraPosition=i+1;}
      calenderData[firstDayOfMonthIndex + i] = (i + 1).toString();
    }
    if (_isOverflow) {
      for (var i = 0; i<firstDayOfNextMonthIndex; i++) {
        calenderData[i]=(_extraPosition! +i+1).toString();
      }
    }
    print(calenderData);
    //print(firstDayOfNextMonthIndex);
    //print(_days.indexOf(firstDayOfMonth));
    return calenderData;
  }


   late List<String> _calenderData;
   
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _calenderData=getcalenderData(2079, 8);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: [
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.all(13),
            color: Colors.redAccent,
            child: Column(
              children: [
                SizedBox(
                  height: 19,
                ),
                Text(
                  "Select Date",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      "Sun,Bai 24",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ))
              ],
            ),
          ),
        ),
        Expanded(
            flex: 7,
            child: Container(
              //color: Colors.blue,
              padding: EdgeInsets.only(top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 17),
                    child: Row(
                      children: [
                        DropdownButton(
                          value: _selectedMonth,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: List.generate(
                              _months.length,
                              (index) => DropdownMenuItem(
                                  value: _months.elementAt(index),
                                  child: Text(_months.elementAt(index)))),
                          onChanged: (value) {
                            setState(() {
                              _selectedMonth = value!;
                              _calenderData=getcalenderData(_selectedYear, _months.indexOf(_selectedMonth)+1);
                            });
                          },
                        ),
                        DropdownButton(
                             //elevation: 0,
                            value: _selectedYear,
                            items: List.generate(
                                10,
                                (index) => DropdownMenuItem(
                                      child: Text('${2070 + index}'),
                                      value: 2070 + index,
                                    )),
                            onChanged: (value) {
                              setState(() {
                                _selectedYear = value!;
                                _calenderData=getcalenderData(_selectedYear, _months.indexOf(_selectedMonth)+1);
                              });
                            }),
                        SizedBox(width: 80,),
                        IconButton(
                            onPressed: (() {
                              if(_months.indexOf(_selectedMonth)-1 == -1){
                                _selectedMonth=_months.elementAt(10);//Reset month to Chaitra
                                _selectedYear=_selectedYear-1;
                              }
                              setState(() {
                                _selectedMonth=_months.elementAt(_months.indexOf(_selectedMonth)-1);
                                print(_selectedMonth);
                                _calenderData=getcalenderData(_selectedYear, _months.indexOf(_selectedMonth)+1);
                              });
                            }),
                            icon: Icon(Icons.arrow_left)),
                        IconButton(
                            onPressed: (() {
                              if(_months.indexOf(_selectedMonth)+1 ==12){
                                _selectedMonth=_months.elementAt(0);//Reset month to baisakh
                                _selectedYear=_selectedYear+1;
                              }
                              setState(() {
                                 _selectedMonth=_months.elementAt(_months.indexOf(_selectedMonth)+1);
                                _calenderData=getcalenderData(_selectedYear, _months.indexOf(_selectedMonth)+1);
                              });
                            }),
                            icon: Icon(Icons.arrow_right)),
                      ],
                    ),
                  ),
                  SizedBox(height: 12,),
                  DataTable(
                    dividerThickness: 0,
                    columnSpacing: 2,
                    columns:
                        _days.map((e) => DataColumn(label: Text(e))).toList(),
                    rows: List.generate(
                        5,
                        (rowData) => DataRow(
                            cells: List.generate(
                                7,
                                (cellData) => DataCell(
                                  _calenderData.elementAt(rowData*7+cellData)!=''?
                                  IconButton(
                                    splashRadius: 17,
                                    hoverColor: Colors.pinkAccent,
                                    onPressed: () {
                                      setState(() {
                                        _selectedDay =_calenderData.elementAt(rowData*7+cellData);
                                      });
                                    },
                                    
                                    icon: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _selectedDay ==  _calenderData.elementAt(rowData*7+cellData)
                                                ? Colors.pinkAccent
                                                : null),
                                        child: Center(
                                            child: Text('${_calenderData.elementAt(rowData*7+cellData)}')))
                                            ):Container()
                                            )))),
                  )
                ],
              ),
            )),
      ]),
    );
  }
}