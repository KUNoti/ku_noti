
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ku_noti/core/constants/colors.dart';
import 'package:ku_noti/features/domain/event/entities/event.dart';
import 'package:ku_noti/features/presentation/event/bloc/event/event_event.dart';
import 'package:ku_noti/features/presentation/event/bloc/event/events_bloc.dart';
import 'package:ku_noti/features/presentation/event/widgets/select_chips.dart';
import 'package:ku_noti/features/presentation/place_picker/entities/location_result.dart';
import 'package:ku_noti/features/presentation/place_picker/place_picker.dart';
import 'package:ku_noti/features/presentation/user/bloc/auth_bloc.dart';

class CreateEventDialog extends StatefulWidget {
  const CreateEventDialog({super.key});

  @override
  CreateEventDialogState createState() => CreateEventDialogState();
}

class CreateEventDialogState extends State<CreateEventDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _locationNameController = TextEditingController();
  File? _image;
  DateTime _selectedStartDate = DateTime.now();
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  DateTime _selectedEndDate = DateTime.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();
  num? lat;
  num? long;
  String? selectedTag;
  int selectedChipIndex = 0;


  @override
  void dispose() {
    _titleController.dispose();
    _detailController.dispose();
    _locationNameController.dispose();
    super.dispose();
  }

  //image
  final ImagePicker _picker = ImagePicker();

  void createEvents(BuildContext context) {
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    final user = authBloc.state.user;
    if(user != null) {
      EventEntity event = EventEntity(
          title: _titleController.text,
          latitude: lat,
          longitude: long,
          startDateTime: combineDateTime(_selectedStartDate, _selectedStartTime),
          endDateTime: combineDateTime(_selectedEndDate, _selectedEndTime),
          price: 0.0,
          imageFile: _image,
          creator: user.userId, // userId
          detail: _detailController.text,
          locationName: _locationNameController.text,
          needRegis: false,
          tag: selectedTag
      );
      BlocProvider.of<EventsBloc>(context).add(CreateEvent(event));
      BlocProvider.of<EventsBloc>(context).add(const GetEvents());
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildImagePicker(context),
                      _buildInput(context),
                      const SizedBox(height: 10),
                      _buildDateSelector(context),
                      const SizedBox(height: 10),
                      SelectChips(selectedChipIndex: selectedChipIndex, onChipSelected: (String selectedLabel, int index) {
                          setState(() {
                            selectedChipIndex = index;
                            selectedTag = selectedLabel;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _locationNameController,
                        decoration: const InputDecoration(
                          labelText: 'Location Name',
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildPlacePicker()
                    ],
                  ),
                ),
              ),
            ),
            _buildButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            'Add Event',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        IconButton(
          iconSize: 28,
          color: MyColors().primary,
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ElevatedButton(
          onPressed: () {
            // Save the event or perform other actions here
            createEvents(context);
          },
          child: const Text('Create'),
        ),
      ),
    );
  }

  Widget _buildInput(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Title',
          ),
        ),
        TextField(
          controller: _detailController,
          maxLines: null,
          decoration: const InputDecoration(
            labelText: 'Detail',
          ),
        )
      ],
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _selectStartDate(context),
                child: TextField(
                  controller: TextEditingController(
                    text:
                    '${_selectedStartDate.day}/${_selectedStartDate.month}/${_selectedStartDate.year}',
                  ),
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: 'Start Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () => _selectStartTime(context),
                child: TextField(
                  controller: TextEditingController(
                    text:
                    '${_selectedStartTime.hour}:${_selectedStartTime.minute}',
                  ),
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: 'Start Time',
                    suffixIcon: Icon(Icons.access_time),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _selectEndDate(context),
                child: TextField(
                  controller: TextEditingController(
                    text:
                    '${_selectedEndDate.day}/${_selectedEndDate.month}/${_selectedEndDate.year}',
                  ),
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: 'End Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () => _selectEndTime(context),
                child: TextField(
                  controller: TextEditingController(
                    text:
                    '${_selectedEndTime.hour}:${_selectedEndTime.minute}',
                  ),
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: 'End Time',
                    suffixIcon: Icon(Icons.access_time),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  void _pickImage(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _pickImageFromSource(ImageSource.camera); // Proceed to pick image from camera
              },
              child: const Text('Camera'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _pickImageFromSource(ImageSource.gallery); // Proceed to pick image from gallery
              },
              child: const Text('Gallery'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Widget _buildImagePicker(BuildContext context) => InkWell(
    onTap: () => _pickImage(context),
    child: Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: _image != null
          ? Image.file(_image!, fit: BoxFit.cover)
          : Icon(Icons.photo_library, color: Colors.grey[800]),
    ),
  );

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime,
    );
    if (picked != null && picked != _selectedStartTime) {
      setState(() {
        _selectedStartTime = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedEndDate) {
      setState(() {
        _selectedEndDate = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedEndTime,
    );
    if (picked != null && picked != _selectedEndTime) {
      setState(() {
        _selectedEndTime = picked;
      });
    }
  }

  Widget _buildPlacePicker() {
    return Center(
      child: ElevatedButton(
        onPressed: ()  {
          showPlacePicker();
        },
        child: const Text("Pick Location"),
      ),
    );
  }

  void showPlacePicker() async {
    LocationResult? result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PlacePicker("")));

    _locationNameController.text = result?.name ?? "name";
    lat = result?.latLng?.latitude ?? 13.8476;
    long = result?.latLng?.longitude ?? 100.5696;
  }

  DateTime combineDateTime(DateTime date, TimeOfDay timeOfDay) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
  }
}