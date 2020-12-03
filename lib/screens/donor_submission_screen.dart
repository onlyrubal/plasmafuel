import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import '../providers/donor_info.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';
import '../providers/auth.dart';

class DonorSubmissionScreen extends StatefulWidget {
  static const routeName = '/donor-submission-screen';
  @override
  _DonorSubmissionScreenState createState() => _DonorSubmissionScreenState();
}

class _DonorSubmissionScreenState extends State<DonorSubmissionScreen> {
  // Focus Nodes
  final _cityFocusNode = FocusNode();
  final _genderFocusNode = FocusNode();
  final _contactFocusNode = FocusNode();
  final _covidSymptomFocusNode = FocusNode();

  // Form Key
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  List<String> _genderList = ['Male', 'Female', 'Prefer Not to Say'];
  List<String> _symptomResponseList = ['Yes', 'No'];
  List<String> _bloodGroupList = [
    'A+',
    'B+',
    'O+',
    'AB+',
    'A-',
    'O-',
    'B-',
    'AB-',
  ];
  DateTime _selectedDate;

  var _editedDonor = Donor(
    donorId: null,
    donorName: '',
    donorAddress: '',
    donorGender: '',
    donorAge: 0,
    donorContactNumber: '',
    approveStatus: 'Pending',
    covidSymptoms: false,
    bloodGroup: '',
    recordProof: null,
    covidNegativeTestDate: '',
    isAnonymous: false,
    userId: '',
  );

  var _initDefaultDonorValues = {
    'donorName': '',
    'donorAddress': '',
    'donorGender': '',
    'donorAge': '',
    'donorContactNumber': '',
    'recordProof': '',
    'isAnonymous': false,
  };

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then(
      (datePicked) {
        if (datePicked == null) return;
        setState(() {
          _selectedDate = datePicked;

          //Saving the covid negative test date to the Donor Object.
          _editedDonor = Donor(
            donorId: _editedDonor.donorId,
            donorName: _editedDonor.donorName,
            donorAddress: _editedDonor.donorAddress,
            donorGender: _editedDonor.donorGender,
            donorAge: _editedDonor.donorAge,
            donorContactNumber: _editedDonor.donorContactNumber,
            approveStatus: _editedDonor.approveStatus,
            covidSymptoms: _editedDonor.covidSymptoms,
            bloodGroup: _editedDonor.bloodGroup,
            recordProof: _editedDonor.recordProof,
            covidNegativeTestDate:
                DateFormat.yMMMd().format(_selectedDate).toString(),
            isAnonymous: _editedDonor.isAnonymous,
            userId: _editedDonor.userId,
          );
        });
      },
    );
  }

  InputDecoration textDecoration(String labelText) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(10),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).buttonColor,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).accentColor,
        ),
      ),
      labelText: labelText,
      labelStyle: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 18),
    );
  }

  Future<void> _saveProductDetailsForm() async {
    final _isFormValid = _formKey.currentState.validate();

    if (_editedDonor.recordProof == null) {
      print('No image selected');
    }

    if (!_isFormValid) {
      return;
    }

    _formKey.currentState.save();

    setState(() {
      _isLoading = false;
    });

    try {
      await Provider.of<Donors>(context, listen: false)
          .addNewDonor(_editedDonor);
    } catch (error) {
      return showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occured !'),
          content: Text('There is something wrong. Please return later.'),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('Close'),
            )
          ],
        ),
      );
    } finally {
      setState(
        () {
          _isLoading = false;
        },
      );
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    // Disposing the Focus Nodes
    _cityFocusNode.dispose();
    _genderFocusNode.dispose();
    _contactFocusNode.dispose();
    _covidSymptomFocusNode.dispose();
    super.dispose();
  }

  String imageUrl;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  Future<void> uploadImage() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;

    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image

      image = await _picker.getImage(source: ImageSource.gallery);
      var file = File(image.path);
      if (image != null) {
        //Upload to Firebase
        var snapshot = await _storage
            .ref()
            .child(
                'uploads/${Provider.of<Auth>(context, listen: false).userId}')
            .putFile(file);

        var downloadUrl = await snapshot.ref.getDownloadURL();

        setState(
          () {
            imageUrl = downloadUrl;
            _editedDonor = Donor(
              donorId: _editedDonor.donorId,
              donorName: _editedDonor.donorName,
              donorAddress: _editedDonor.donorAddress,
              donorGender: _editedDonor.donorGender,
              donorAge: _editedDonor.donorAge,
              donorContactNumber: _editedDonor.donorContactNumber,
              approveStatus: _editedDonor.approveStatus,
              covidSymptoms: _editedDonor.covidSymptoms,
              bloodGroup: _editedDonor.bloodGroup,
              recordProof: imageUrl,
              covidNegativeTestDate: _editedDonor.covidNegativeTestDate,
              isAnonymous: _editedDonor.isAnonymous,
              userId: _editedDonor.userId,
            );
          },
        );
      } else {
        print('No path recieved');
      }
    } else {
      print('Permission not granted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Plasma Donor Submission',
          style: Theme.of(context).textTheme.headline1.copyWith(
                fontSize: 22,
                color: Theme.of(context).accentColor,
              ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: new IconThemeData(
          color: Colors.black,
        ),
      ),
      resizeToAvoidBottomPadding: false,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            SwitchListTile(
                              title: Text('Do you want to stay anonymous?'),
                              value: _editedDonor.isAnonymous,
                              onChanged: (newValue) {
                                setState(() {
                                  _editedDonor = Donor(
                                    donorId: _editedDonor.donorId,
                                    donorName: _editedDonor.donorName,
                                    donorAddress: _editedDonor.donorAddress,
                                    donorGender: _editedDonor.donorGender,
                                    donorAge: _editedDonor.donorAge,
                                    donorContactNumber:
                                        _editedDonor.donorContactNumber,
                                    approveStatus: _editedDonor.approveStatus,
                                    covidSymptoms: _editedDonor.covidSymptoms,
                                    bloodGroup: _editedDonor.bloodGroup,
                                    recordProof: _editedDonor.recordProof,
                                    covidNegativeTestDate:
                                        _editedDonor.covidNegativeTestDate,
                                    isAnonymous: newValue,
                                    userId: _editedDonor.userId,
                                  );
                                });
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: TextFormField(
                                initialValue:
                                    _initDefaultDonorValues['donorName'],
                                textInputAction: TextInputAction.next,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(fontSize: 18),
                                decoration: textDecoration('Enter Full Name'),
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_cityFocusNode);
                                },
                                onSaved: (newValue) {
                                  _editedDonor = Donor(
                                    donorId: _editedDonor.donorId,
                                    donorName: newValue,
                                    donorAddress: _editedDonor.donorAddress,
                                    donorGender: _editedDonor.donorGender,
                                    donorAge: _editedDonor.donorAge,
                                    donorContactNumber:
                                        _editedDonor.donorContactNumber,
                                    approveStatus: _editedDonor.approveStatus,
                                    covidSymptoms: _editedDonor.covidSymptoms,
                                    bloodGroup: _editedDonor.bloodGroup,
                                    recordProof: _editedDonor.recordProof,
                                    covidNegativeTestDate:
                                        _editedDonor.covidNegativeTestDate,
                                    isAnonymous: _editedDonor.isAnonymous,
                                    userId: _editedDonor.userId,
                                  );
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Name cannot be empty!';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: TextFormField(
                                initialValue:
                                    _initDefaultDonorValues['donorAddress'],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(fontSize: 18),
                                textInputAction: TextInputAction.next,
                                decoration: textDecoration('Enter City'),
                                focusNode: _cityFocusNode,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_genderFocusNode);
                                },
                                onSaved: (newValue) {
                                  _editedDonor = Donor(
                                    donorId: _editedDonor.donorId,
                                    donorName: _editedDonor.donorName,
                                    donorAddress: newValue,
                                    donorGender: _editedDonor.donorGender,
                                    donorAge: _editedDonor.donorAge,
                                    donorContactNumber:
                                        _editedDonor.donorContactNumber,
                                    approveStatus: _editedDonor.approveStatus,
                                    covidSymptoms: _editedDonor.covidSymptoms,
                                    bloodGroup: _editedDonor.bloodGroup,
                                    recordProof: _editedDonor.recordProof,
                                    covidNegativeTestDate:
                                        _editedDonor.covidNegativeTestDate,
                                    isAnonymous: _editedDonor.isAnonymous,
                                    userId: _editedDonor.userId,
                                  );
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'City cannot be empty!';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: DropdownButtonFormField(
                                decoration:
                                    textDecoration('Select Your Gender'),
                                items: _genderList.map(
                                  (gender) {
                                    return DropdownMenuItem(
                                      child: Text(
                                        gender,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(fontSize: 18),
                                      ),
                                      value: gender,
                                    );
                                  },
                                ).toList(),
                                focusNode: _genderFocusNode,
                                onSaved: (newValue) {
                                  _editedDonor = Donor(
                                    donorId: _editedDonor.donorId,
                                    donorName: _editedDonor.donorName,
                                    donorAddress: _editedDonor.donorAddress,
                                    donorGender: newValue,
                                    donorAge: _editedDonor.donorAge,
                                    donorContactNumber:
                                        _editedDonor.donorContactNumber,
                                    approveStatus: _editedDonor.approveStatus,
                                    covidSymptoms: _editedDonor.covidSymptoms,
                                    bloodGroup: _editedDonor.bloodGroup,
                                    recordProof: _editedDonor.recordProof,
                                    covidNegativeTestDate:
                                        _editedDonor.covidNegativeTestDate,
                                    isAnonymous: _editedDonor.isAnonymous,
                                    userId: _editedDonor.userId,
                                  );
                                },
                                onChanged: (_) {},
                                onTap: () {},
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: TextFormField(
                                initialValue:
                                    _initDefaultDonorValues['donorAge'],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(fontSize: 18),
                                textInputAction: TextInputAction.next,
                                decoration: textDecoration('Enter Age'),
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_contactFocusNode);
                                },
                                onSaved: (newValue) {
                                  _editedDonor = Donor(
                                    donorId: _editedDonor.donorId,
                                    donorName: _editedDonor.donorName,
                                    donorAddress: _editedDonor.donorAddress,
                                    donorGender: _editedDonor.donorGender,
                                    donorAge: int.parse(newValue),
                                    donorContactNumber:
                                        _editedDonor.donorContactNumber,
                                    approveStatus: _editedDonor.approveStatus,
                                    covidSymptoms: _editedDonor.covidSymptoms,
                                    bloodGroup: _editedDonor.bloodGroup,
                                    recordProof: _editedDonor.recordProof,
                                    covidNegativeTestDate:
                                        _editedDonor.covidNegativeTestDate,
                                    isAnonymous: _editedDonor.isAnonymous,
                                    userId: _editedDonor.userId,
                                  );
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Age cannot be empty!';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: TextFormField(
                                initialValue: _initDefaultDonorValues[
                                    'donorContactNumber'],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(fontSize: 18),
                                textInputAction: TextInputAction.next,
                                decoration:
                                    textDecoration('Enter Contact Number'),
                                focusNode: _contactFocusNode,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_covidSymptomFocusNode);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Contact Number cannot be empty!';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  _editedDonor = Donor(
                                    donorId: _editedDonor.donorId,
                                    donorName: _editedDonor.donorName,
                                    donorAddress: _editedDonor.donorAddress,
                                    donorGender: _editedDonor.donorGender,
                                    donorAge: _editedDonor.donorAge,
                                    donorContactNumber: newValue,
                                    approveStatus: _editedDonor.approveStatus,
                                    covidSymptoms: _editedDonor.covidSymptoms,
                                    bloodGroup: _editedDonor.bloodGroup,
                                    recordProof: _editedDonor.recordProof,
                                    covidNegativeTestDate:
                                        _editedDonor.covidNegativeTestDate,
                                    isAnonymous: _editedDonor.isAnonymous,
                                    userId: _editedDonor.userId,
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: DropdownButtonFormField(
                                focusNode: _covidSymptomFocusNode,
                                decoration: textDecoration(
                                    'Do you currently have symptoms?'),
                                items: _symptomResponseList.map(
                                  (symptomResponse) {
                                    return DropdownMenuItem(
                                      child: Text(
                                        symptomResponse,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(fontSize: 18),
                                      ),
                                      value: symptomResponse,
                                    );
                                  },
                                ).toList(),
                                onSaved: (newValue) {
                                  _editedDonor = Donor(
                                    donorId: _editedDonor.donorId,
                                    donorName: _editedDonor.donorName,
                                    donorAddress: _editedDonor.donorAddress,
                                    donorGender: _editedDonor.donorGender,
                                    donorAge: _editedDonor.donorAge,
                                    donorContactNumber:
                                        _editedDonor.donorContactNumber,
                                    approveStatus: _editedDonor.approveStatus,
                                    covidSymptoms:
                                        newValue == 'Yes' ? true : false,
                                    bloodGroup: _editedDonor.bloodGroup,
                                    recordProof: _editedDonor.recordProof,
                                    covidNegativeTestDate:
                                        _editedDonor.covidNegativeTestDate,
                                    isAnonymous: _editedDonor.isAnonymous,
                                    userId: _editedDonor.userId,
                                  );
                                },
                                onChanged: (_) {},
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: DropdownButtonFormField(
                                decoration:
                                    textDecoration('Choose your blood group'),
                                items: _bloodGroupList.map(
                                  (bloodGroup) {
                                    return DropdownMenuItem(
                                      child: Text(
                                        bloodGroup,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(fontSize: 18),
                                      ),
                                      value: bloodGroup,
                                    );
                                  },
                                ).toList(),
                                onSaved: (newValue) {
                                  _editedDonor = Donor(
                                    donorId: _editedDonor.donorId,
                                    donorName: _editedDonor.donorName,
                                    donorAddress: _editedDonor.donorAddress,
                                    donorGender: _editedDonor.donorGender,
                                    donorAge: _editedDonor.donorAge,
                                    donorContactNumber:
                                        _editedDonor.donorContactNumber,
                                    approveStatus: _editedDonor.approveStatus,
                                    covidSymptoms: _editedDonor.covidSymptoms,
                                    bloodGroup: newValue,
                                    recordProof: _editedDonor.recordProof,
                                    covidNegativeTestDate:
                                        _editedDonor.covidNegativeTestDate,
                                    isAnonymous: _editedDonor.isAnonymous,
                                    userId: _editedDonor.userId,
                                  );
                                },
                                onChanged: (_) {},
                              ),
                            ),
                            SizedBox(height: 20),
                            Text('Last covid negative test report date'),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  if (_selectedDate == null)
                                    Container(
                                      margin: EdgeInsets.only(right: 20),
                                      child: RaisedButton(
                                        onPressed: () {
                                          _showDatePicker();
                                        },
                                        // padding: EdgeInsets.all(10),
                                        child: Text(
                                          'Choose Date',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(fontSize: 18),
                                        ),
                                        textColor: Color(0xff4c4c4c),
                                      ),
                                    ),
                                  Expanded(
                                    child: Text(
                                      (_selectedDate == null)
                                          ? 'No Date Chosen!'
                                          : 'Date Picked: ${DateFormat.yMMMd().format(_selectedDate)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                                'Attach additional supporting documents\n (Last covid negative test reports etc.)'),
                            SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RaisedButton(
                                    onPressed: () => uploadImage(),
                                    focusColor:
                                        Colors.lightBlue.withOpacity(0.2),
                                    child: Text(
                                      'Upload',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(fontSize: 18),
                                    ),
                                    textColor: Color(0xff4c4c4c),
                                  ),
                                  SizedBox(height: 20),
                                  (imageUrl != null)
                                      ? Image.network(
                                          imageUrl,
                                          height: 200,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : Placeholder(
                                          fallbackHeight: 200,
                                          fallbackWidth: double.infinity,
                                        ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 180,
                                    child: SecondaryButton(btnText: 'Cancel'),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                InkWell(
                                  onTap: () {
                                    _editedDonor = Donor(
                                      donorId: _editedDonor.donorId,
                                      donorName: _editedDonor.donorName,
                                      donorAddress: _editedDonor.donorAddress,
                                      donorGender: _editedDonor.donorGender,
                                      donorAge: _editedDonor.donorAge,
                                      donorContactNumber:
                                          _editedDonor.donorContactNumber,
                                      approveStatus: _editedDonor.approveStatus,
                                      covidSymptoms: _editedDonor.covidSymptoms,
                                      bloodGroup: _editedDonor.bloodGroup,
                                      recordProof: _editedDonor.recordProof,
                                      covidNegativeTestDate:
                                          _editedDonor.covidNegativeTestDate,
                                      isAnonymous: _editedDonor.isAnonymous,
                                      userId: Provider.of<Auth>(context,
                                              listen: false)
                                          .userId,
                                    );
                                    _saveProductDetailsForm();
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 180,
                                    child: PrimaryButton(btnText: 'Save'),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
