import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataEntryPage extends StatefulWidget {
  const DataEntryPage({Key? key}) : super(key: key);

  @override
  _DataEntryPageState createState() => _DataEntryPageState();
}

class _DataEntryPageState extends State<DataEntryPage> {
  int _currentStep = 0;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _districtController = TextEditingController();
  TextEditingController _subDistrictController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();

  List<String> _provinces = [
    'กรุงเทพมหานคร',
    'กระบี่',
    'กาญจนบุรี',
    'กาฬสินธุ์',
    'กำแพงเพชร',
    'ขอนแก่น',
    'จันทบุรี',
    'ฉะเชิงเทรา',
    'ชลบุรี',
    'ชัยนาท',
    'ชัยภูมิ',
    'ชุมพร',
    'เชียงราย',
    'เชียงใหม่',
    'ตรัง',
    'ตราด',
    'ตาก',
    'นครนายก',
    'นครปฐม',
    'นครพนม',
    'นครราชสีมา',
    'นครศรีธรรมราช',
    'นครสวรรค์',
    'นนทบุรี',
    'นราธิวาส',
    'น่าน',
    'บึงกาฬ',
    'บุรีรัมย์',
    'ปทุมธานี',
    'ประจวบคีรีขันธ์',
    'ปราจีนบุรี',
    'ปัตตานี',
    'พระนครศรีอยุธยา',
    'พะเยา',
    'พังงา',
    'พัทลุง',
    'พิจิตร',
    'พิษณุโลก',
    'เพชรบุรี',
    'เพชรบูรณ์',
    'แพร่',
    'พะแนง',
    'ภูเก็ต',
    'มหาสารคาม',
    'มุกดาหาร',
    'แม่ฮ่องสอน',
    'ยะลา',
    'ยโสธร',
    'ร้อยเอ็ด',
    'ระนอง',
    'ระยอง',
    'ราชบุรี',
    'ลพบุรี',
    'ลำปาง',
    'ลำพูน',
    'เลย',
    'ศรีสะเกษ',
    'สกลนคร',
    'สงขลา',
    'สตูล',
    'สมุทรปราการ',
    'สมุทรสงคราม',
    'สมุทรสาคร',
    'สระแก้ว',
    'สระบุรี',
    'สิงห์บุรี',
    'สุโขทัย',
    'สุพรรณบุรี',
    'สุราษฎร์ธานี',
    'สุรินทร์',
    'หนองคาย',
    'หนองบัวลำภู',
    'อ่างทอง',
    'อำนาจเจริญ',
    'อุดรธานี',
    'อุตรดิตถ์',
    'อุทัยธานี',
    'อุบลราชธานี',
    'เบญจขันธ์',
    'ยโสธร',
    'ระนอง',
    'จ. ทดสอบ',
  ];
  dynamic _selectedProvince;
  List<Step> _steps = [];

  @override
  void initState() {
    super.initState();
    _steps = [
      Step(
        title: Text('ข้อมูลส่วนตัว'),
        content: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'ชื่อ-นามสกุล',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'กรุณากรอกชื่อ-นามสกุล';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _dobController,
              decoration: InputDecoration(
                labelText: 'วัน/เดือน/ปี เกิด (dd/mm/yyyy)',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'กรุณากรอกวัน/เดือน/ปี เกิด';
                }
                if (!RegExp(r'^\d{1,2}/\d{1,2}/\d{4}$').hasMatch(value)) {
                  return 'รูปแบบวัน/เดือน/ปี เกิดไม่ถูกต้อง';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'น้ำหนัก (กก.)',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'กรุณากรอกน้ำหนัก';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'ส่วนสูง (ซม.)',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'กรุณากรอกส่วนสูง';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      Step(
        title: Text('ข้อมูลที่อยู่ตามบัตรประชาชน'),
        content: Column(
          children: [
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'ที่อยู่',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'กรุณากรอกที่อยู่';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _subDistrictController,
              decoration: InputDecoration(
                labelText: 'แขวง/ตำบล',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'กรุณากรอกแขวง/ตำบล';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _districtController,
              decoration: InputDecoration(
                labelText: 'เขต/อำเภอ',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'กรุณากรอกเขต/อำเภอ';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'จังหวัด',
              ),
              value: _selectedProvince,
              onChanged: (value) {
                setState(() {
                  _selectedProvince = value!;
                });
              },
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    !_provinces.contains(value)) {
                  return 'กรุณาเลือกจังหวัด';
                }
                return null;
              },
              items: _provinces.map((String province) {
                return DropdownMenuItem<String>(
                  value: province,
                  child: Text(province),
                );
              }).toList(),
            ),
            TextFormField(
              controller: _postalCodeController,
              decoration: InputDecoration(
                labelText: 'รหัสไปรษณีย์',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'กรุณากรอกรหัสไปรษณีย์';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('กรอกข้อมูล'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < _steps.length - 1) {
            setState(() {
              _currentStep++;
            });
          } else {
            _saveData();
            Navigator.pop(context);
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep--;
            });
          } else {
            Navigator.pop(context);
          }
        },
        steps: _steps,
      ),
    );
  }

  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = _nameController.text;
    String address = _addressController.text;
    String dob = _dobController.text;
    String province = _selectedProvince.toString();
    String district = _districtController.text;
    String subDistrict = _subDistrictController.text;
    String weight = _weightController.text;
    String height = _heightController.text;
    String postalCode = _postalCodeController.text;

    if (name.isEmpty ||
        address.isEmpty ||
        dob.isEmpty ||
        province.isEmpty ||
        district.isEmpty ||
        subDistrict.isEmpty ||
        weight.isEmpty ||
        postalCode.isEmpty ||
        height.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('ข้อมูลไม่ครบถ้วน'),
          content: Text('กรุณากรอกข้อมูลให้ครบถ้วนทุกช่อง'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ตกลง'),
            ),
          ],
        ),
      );
      return;
    }

    List<String> personList = prefs.getStringList('person_list') ?? [];
    personList.add(
        '$name, $address, $dob, $province, $district, $subDistrict, $weight, $height, $postalCode');
    prefs.setStringList('person_list', personList);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('บันทึกข้อมูลสำเร็จ'),
        content: Text('ข้อมูลได้ถูกบันทึกเรียบร้อยแล้ว'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('ตกลง'),
          ),
        ],
      ),
    );
  }
}
