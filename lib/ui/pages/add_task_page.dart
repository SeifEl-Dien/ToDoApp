import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:udemy_todo/controllers/task_controller.dart';
import 'package:udemy_todo/models/task.dart';
import 'package:udemy_todo/ui/theme.dart';
import 'package:udemy_todo/ui/widgets/button.dart';

import '../widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());

  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _notecontroller = TextEditingController();

  DateTime _selecteddate = DateTime.now();
  String _starttime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endtime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();

  int _selectedremind = 0;
  List<int> remindlist = [0, 5, 10, 15, 20];
  String _selectedrepeat = 'None';
  List<String> repeatlist = ['None', 'Daily', 'Weekly', 'Monthly'];

  int _selectedcolor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: _appbar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Add Task',
                style: headingStyle,
              ),
              InputField(
                title: 'Title',
                hint: 'Enter title here',
                controller: _titlecontroller,
              ),
              InputField(
                title: 'Note',
                hint: 'Enter note here',
                controller: _notecontroller,
              ),
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selecteddate),
                widget: IconButton(
                  onPressed: () => _getDateFromUser(),
                  icon: Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: 'Start time',
                      hint: _starttime,
                      widget: IconButton(
                          onPressed: () => _getTimeFromUser(isStartTime: true),
                          icon: Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: InputField(
                      title: 'End time',
                      hint: _endtime,
                      widget: IconButton(
                          onPressed: () => _getTimeFromUser(isStartTime: false),
                          icon: Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          )),
                    ),
                  ),
                ],
              ),
              InputField(
                  title: 'Remind',
                  hint: _selectedremind == 0
                      ? 'None'
                      : '$_selectedremind Minutes early',
                  widget: Row(
                    children: [
                      DropdownButton(
                        dropdownColor: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(10),
                        items: remindlist
                            .map(
                              (value) => DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value == 0 ? 'None' : '$value Minutes early',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                            .toList(),
                        icon:
                            Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                        iconSize: 32,
                        elevation: 4,
                        underline: Container(height: 0),
                        style: subTitleStyle,
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedremind = newValue!;
                          });
                        },
                      ),
                      const SizedBox(width: 6),
                    ],
                  )),
              InputField(
                  title: 'Repeat',
                  hint: '$_selectedrepeat',
                  widget: Row(
                    children: [
                      DropdownButton(
                        dropdownColor: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(10),
                        items: repeatlist
                            .map(
                              (value) => DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                            .toList(),
                        icon:
                            Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                        iconSize: 32,
                        elevation: 4,
                        underline: Container(height: 0),
                        style: subTitleStyle,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedrepeat = newValue!;
                          });
                        },
                      ),
                      const SizedBox(width: 6),
                    ],
                  )),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  colorpalette(),
                  MyButton(
                      label: 'Create task',
                      ontap: () {
                        _validatedate();
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appbar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 24,
          color: primaryClr,
        ),
      ),
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage(
            'images/person.jpeg',
          ),
          radius: 18,
        ),
        SizedBox(width: 20)
      ],
    );
  }

  _validatedate() {
    if (_titlecontroller.text.isNotEmpty && _notecontroller.text.isNotEmpty) {
      _addTasksToDb();
      Get.back();
    } else if (_titlecontroller.text.isEmpty && _notecontroller.text.isEmpty) {
      _sNAckbar('All fields are required');
    } else if (_titlecontroller.text.isEmpty) {
      _sNAckbar('Title is required');
    } else if (_notecontroller.text.isEmpty) {
      _sNAckbar('Note is required');
    } else {
      print('######## Snackbar problem ########');
    }
  }

  _sNAckbar(String snackmessage) {
    return Get.snackbar('required', snackmessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.black,
        icon: const Icon(
          Icons.warning_amber_outlined,
          color: Colors.red,
        ));
  }

  _addTasksToDb() async {
    int value = await _taskController.addTask(
        task: Task(
            title: _titlecontroller.text,
            note: _notecontroller.text,
            isCompleted: 0,
            date: DateFormat.yMd().format(_selecteddate),
            startTime: _starttime,
            endTime: _endtime,
            color: _selectedcolor,
            remind: _selectedremind,
            repeat: _selectedrepeat));
    print('$value');
  }

  Widget colorpalette() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Color',
            style: titleStyle,
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
              children: List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedcolor = index;
                  });
                },
                child: CircleAvatar(
                  child: _selectedcolor == index
                      ? Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 16,
                        )
                      : null,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : orangeClr,
                  radius: 14,
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }

  _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
        context: context,
        initialDate: _selecteddate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2030));
    if (_pickedDate != null) {
      setState(() {
        _selecteddate = _pickedDate;
      });
    } else
      print('It\'s null or something if wrong');
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
        context: context,
        initialTime: isStartTime
            ? TimeOfDay.fromDateTime(DateTime.now())
            : TimeOfDay.fromDateTime(
                DateTime.now().add(const Duration(minutes: 15))));
    String _formattedTime = _pickedTime!.format(context);
    if (isStartTime) {
      setState(() {
        _starttime = _formattedTime;
      });
    } else if (!isStartTime) {
      setState(() {
        _endtime = _formattedTime;
      });
    } else
      print('Time canceled or something is wrong');
  }
}
