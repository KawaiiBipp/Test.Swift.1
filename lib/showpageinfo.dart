import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'dataentrypage.dart';

class PageInfodata extends StatefulWidget {
  const PageInfodata({Key? key}) : super(key: key);

  @override
  State<PageInfodata> createState() => _PageInfodataState();
}

class _PageInfodataState extends State<PageInfodata> {
  Future<List<String>> _personListFuture = _getPersonList();

  static Future<List<String>> _getPersonList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('person_list') ?? [];
  }

  dynamic _selectedProvince;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายชื่อบุคคล'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'ทั้งหมด'),
                Tab(text: 'แยกตามจังหวัด'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildPersonListTab(),
                  _buildPersonByProvinceTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DataEntryPage()),
          ).then((_) {
            setState(() {
              _personListFuture = _getPersonList();
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildPersonListTab() {
    return FutureBuilder<List<String>>(
      future: _personListFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล'));
        }

        List<String> personList = snapshot.data ?? [];

        if (personList.isEmpty) {
          return Center(child: Text('ไม่มีรายชื่อบุคคล'));
        }

        return ListView.builder(
          itemCount: personList.length,
          itemBuilder: (context, index) {
            String person = personList[index];
            List<String> personData = person.split(", ");
            String name = personData[0];
            String address = personData[1];
            String dob = personData[2];
            String province = personData[3];
            String district = personData[4];
            String subDistrict = personData[5];
            String weight = personData[6];
            String height = personData[7];
            String postalCode = personData[8];

            return Card(
              child: ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('ข้อมูลบุคคล'),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('ชื่อ: $name'),
                          Text('น้ำหนัก: $weight กก.'),
                          Text('ส่วนสูง: $height ซม.'),
                          Text('วัน/เดือน/ปีเกิด: $dob'),
                          Text('----------------------'),
                          Text('ที่อยู่เลขที่:$address'),
                          Text('แขวง/ตำบล: $subDistrict'),
                          Text('เขต/อำเภอ: $district'),
                          Text('จังหวัด: $province'),
                          Text('รหัสไปรษณีย์: $postalCode'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('ปิด'),
                        ),
                      ],
                    ),
                  );
                },
                title: Text('ชื่อ: $name'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('แสดงรายละเอียดอื่นๆ...'),
                    // แสดงส่วนสูง
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('ยืนยันการลบ'),
                        content: Text('คุณต้องการลบ $name ใช่หรือไม่?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                _removePerson(person);
                                _personListFuture = _getPersonList();
                              });
                            },
                            child: Text('ใช่'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('ยกเลิก'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPersonByProvinceTab() {
    return FutureBuilder<List<String>>(
      future: _personListFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล'));
        }

        List<String> personList = snapshot.data ?? [];

        if (personList.isEmpty) {
          return Center(child: Text('ไม่มีรายชื่อบุคคล'));
        }

        List<String> provinces = personList
            .map((person) {
              List<String> personData = person.split(", ");
              return personData[3];
            })
            .toSet()
            .toList();

        return Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedProvince,
              onChanged: (value) {
                setState(() {
                  _selectedProvince = value!;
                });
              },
              items: provinces.map((province) {
                return DropdownMenuItem<String>(
                  value: province,
                  child: Text(province),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'เลือกจังหวัด',
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: personList.length,
                itemBuilder: (context, index) {
                  String person = personList[index];
                  List<String> personData = person.split(", ");
                  String province = personData[3];

                  if (_selectedProvince != null &&
                      _selectedProvince != province) {
                    return Container();
                  }

                  String name = personData[0];
                  String address = personData[1];
                  String dob = personData[2];

                  String district = personData[4];
                  String subDistrict = personData[5];
                  String weight = personData[6];
                  String height = personData[7];
                  String postalCode = personData[8];
                  return Card(
                    child: ListTile(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('ข้อมูลบุคคล'),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('ชื่อ: $name'),
                                Text('น้ำหนัก: $weight กก.'),
                                Text('ส่วนสูง: $height ซม.'),
                                Text('วัน/เดือน/ปี เกิด: $dob'),
                                Text('----------------------'),
                                Text('ที่อยู่เลขที่:$address'),
                                Text('แขวง/ตำบล: $subDistrict'),
                                Text('เขต/อำเภอ: $district'),
                                Text('จังหวัด: $province'),
                                Text('รหัสไปรษณีย์: $postalCode'),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('ปิด'),
                              ),
                            ],
                          ),
                        );
                      },
                      title: Text('ชื่อ: $name'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('จังหวัด: $province'),
                          Text('แสดงรายละเอียดอื่นๆ...'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('ยืนยันการลบ'),
                              content: Text('คุณต้องการลบ $name ใช่หรือไม่?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      _removePerson(person);
                                      _personListFuture = _getPersonList();
                                    });
                                  },
                                  child: Text('ใช่'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('ยกเลิก'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

void _removePerson(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> personList = prefs.getStringList('person_list') ?? [];
  personList.remove(name);
  prefs.setStringList('person_list', personList);
}
