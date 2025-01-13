import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfileView(),
    );
  }
}

class User {
  String firstName;
  String lastName;
  String password;
  String birthDate;
  String email;

  User({
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.birthDate,
    required this.email,
  });
}

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  User user = User(
    firstName: 'Michelle',
    lastName: 'Alexandra',
    password: 'password123',
    birthDate: '22-04-2009',
    email: 'michie48@gmail.com',
  );

  void updateUser(User updatedUser) {
    setState(() {
      user = updatedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Info'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {}, // Notification action
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileView(
                      user: user,
                      onSave: updateUser,
                    ),
                  ),
                );
              },
              child: AccountSection(user: user),
            ),
            SizedBox(height: 20),
            RecordsSection(), // Records Section
            SizedBox(height: 20),
            MoodFlowSection(), // Updated Mood Flow Section
            SizedBox(height: 20),
            MoodBarSection(), // Updated Mood Bar Section
          ],
        ),
      ),
    );
  }
}

class AccountSection extends StatelessWidget {
  final User user;

  AccountSection({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Placeholder image
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.firstName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('Joined in 2024'),
                ],
              ),
            ],
          ),
          Icon(Icons.arrow_forward_ios, size: 16), // Arrow icon on the right
        ],
      ),
    );
  }
}

class RecordsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("My Records", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: RecordCard(
                  label: 'Recorded Days',
                  value: '129',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: RecordCard(
                  label: 'Photos',
                  value: '12',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RecordCard extends StatelessWidget {
  final String label;
  final String value;

  RecordCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 16)),
                  SizedBox(height: 4),
                  Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MoodFlowSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("This month's mood flow", style: TextStyle(fontSize: 16)),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MoodCircle(color: Colors.blue), // 11/1 Circle
                  MoodCircle(color: Colors.blue), // 11/6 Circle
                  MoodCircle(color: Colors.pink), // 11/11 Circle
                  MoodCircle(color: Colors.blue), // 11/16 Circle
                  MoodCircle(color: Colors.blue), // 11/21 Circle
                  MoodCircle(color: Colors.pink), // 11/26 Circle
                  MoodCircle(color: Colors.blue), // 12/1 Circle
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MoodLine(), // 11/1 Line
                  MoodLine(), // 11/6 Line
                  MoodLine(), // 11/11 Line
                  MoodLine(), // 11/16 Line
                  MoodLine(), // 11/21 Line
                  MoodLine(), // 11/26 Line
                  MoodLine(), // 12/1 Line
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MoodCircle(color: Colors.blue), // 11/1 Circle
                  MoodCircle(color: Colors.blue), // 11/6 Circle
                  MoodCircle(color: Colors.pink), // 11/11 Circle
                  MoodCircle(color: Colors.blue), // 11/16 Circle
                  MoodCircle(color: Colors.blue), // 11/21 Circle
                  MoodCircle(color: Colors.pink), // 11/26 Circle
                  MoodCircle(color: Colors.blue), // 12/1 Circle
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MoodLine(), // 11/1 Line
                  MoodLine(), // 11/6 Line
                  MoodLine(), // 11/11 Line
                  MoodLine(), // 11/16 Line
                  MoodLine(), // 11/21 Line
                  MoodLine(), // 11/26 Line
                  MoodLine(), // 12/1 Line
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MoodCircle(color: Colors.blue), // 11/1 Circle
                  MoodCircle(color: Colors.blue), // 11/6 Circle
                  MoodCircle(color: Colors.pink), // 11/11 Circle
                  MoodCircle(color: Colors.blue), // 11/16 Circle
                  MoodCircle(color: Colors.blue), // 11/21 Circle
                  MoodCircle(color: Colors.pink), // 11/26 Circle
                  MoodCircle(color: Colors.blue), // 12/1 Circle
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MoodLine(), // 11/1 Line
                  MoodLine(), // 11/6 Line
                  MoodLine(), // 11/11 Line
                  MoodLine(), // 11/16 Line
                  MoodLine(), // 11/21 Line
                  MoodLine(), // 11/26 Line
                  MoodLine(), // 12/1 Line
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MoodCircle(color: Colors.blue), // 11/1 Circle
                  MoodCircle(color: Colors.blue), // 11/6 Circle
                  MoodCircle(color: Colors.pink), // 11/11 Circle
                  MoodCircle(color: Colors.blue), // 11/16 Circle
                  MoodCircle(color: Colors.blue), // 11/21 Circle
                  MoodCircle(color: Colors.pink), // 11/26 Circle
                  MoodCircle(color: Colors.blue), // 12/1 Circle
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MoodLine(), // 11/1 Line
                  MoodLine(), // 11/6 Line
                  MoodLine(), // 11/11 Line
                  MoodLine(), // 11/16 Line
                  MoodLine(), // 11/21 Line
                  MoodLine(), // 11/26 Line
                  MoodLine(), // 12/1 Line
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MoodCircle(color: Colors.blue), // 11/1 Circle
                  MoodCircle(color: Colors.blue), // 11/6 Circle
                  MoodCircle(color: Colors.pink), // 11/11 Circle
                  MoodCircle(color: Colors.blue), // 11/16 Circle
                  MoodCircle(color: Colors.blue), // 11/21 Circle
                  MoodCircle(color: Colors.pink), // 11/26 Circle
                  MoodCircle(color: Colors.blue), // 12/1 Circle
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MoodLine(), // 11/1 Line
                  MoodLine(), // 11/6 Line
                  MoodLine(), // 11/11 Line
                  MoodLine(), // 11/16 Line
                  MoodLine(), // 11/21 Line
                  MoodLine(), // 11/26 Line
                  MoodLine(), // 12/1 Line
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("11/1"),
                    Text("11/6"),
                    Text("11/11"),
                    Text("11/16"),
                    Text("11/21"),
                    Text("11/26"),
                    Text("12/1"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MoodCircle extends StatelessWidget {
  final Color color;

  MoodCircle({required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.circle, color: color, size: 16), // Mood Circle
      ],
    );
  }
}

class MoodLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 1,
      color: Colors.grey, // Mood Line
    );
  }
}



class MoodBarSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Total percentages
    double angryPercentage = 0.0;
    double sadPercentage = 0.23;
    double neutralPercentage = 0.30;
    double happyPercentage = 0.15;
    double excitedPercentage = 0.30;

    double totalMood = angryPercentage + sadPercentage + neutralPercentage + happyPercentage + excitedPercentage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text("This month's mood bar", style: TextStyle(fontSize: 16)),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('😡', style: TextStyle(fontSize: 30)), // Angry emoji
            Text('😞', style: TextStyle(fontSize: 30)), // Sad emoji
            Text('😐', style: TextStyle(fontSize: 30)), // Neutral emoji
            Text('😊', style: TextStyle(fontSize: 30)), // Happy emoji
            Text('😄', style: TextStyle(fontSize: 30)), // Excited emoji
          ],
        ),
        SizedBox(height: 10),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            widthFactor: totalMood, // Fill the total mood percentage
            child: Container(
              decoration: BoxDecoration(
                color: Colors.pink, // Color of the progress
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("0%", style: TextStyle(fontSize: 12)),
            Text("23%", style: TextStyle(fontSize: 12)),
            Text("30%", style: TextStyle(fontSize: 12)),
            Text("15%", style: TextStyle(fontSize: 12)),
            Text("30%", style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }
}

class EditProfileView extends StatelessWidget {
  final User user;
  final Function(User) onSave;

  EditProfileView({required this.user, required this.onSave});

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Set the initial values in the controllers
    firstNameController.text = user.firstName;
    lastNameController.text = user.lastName;
    passwordController.text = user.password;
    birthDateController.text = user.birthDate;
    emailController.text = user.email;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfilePicture(),
            SizedBox(height: 20),
            _buildTextField(firstNameController, 'First name'),
            SizedBox(height: 12), // Added space between fields
            _buildTextField(lastNameController, 'Last name'),
            SizedBox(height: 12), // Added space between fields
            _buildTextField(passwordController, 'Password', obscureText: true),
            SizedBox(height: 12), // Added space between fields
            _buildTextField(birthDateController, 'Birthdate'),
            SizedBox(height: 12), // Added space between fields
            _buildTextField(emailController, 'Email'),
            SizedBox(height: 20), // Added space before the button
            ElevatedButton(
              onPressed: () {
                User updatedUser = User(
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  password: passwordController.text,
                  birthDate: birthDateController.text,
                  email: emailController.text,
                );

                onSave(updatedUser);
                Navigator.pop(context);
              },
              child: Text('SAVE CHANGES'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool obscureText = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(50),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
        obscureText: obscureText,
      ),
    );
  }
}

class ProfilePicture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Placeholder image
          ),
          TextButton(
            onPressed: () {
              // Logic to change profile picture
            },
            child: Text('Change profile picture'),
          ),
        ],
      ),
    );
  }
}

