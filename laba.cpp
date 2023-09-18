#include <iostream>
#include <fstream>
#include <string>

using namespace std;

// Structure for Student
struct Student {
    int SID;
    string NAME;
    string BRANCH;
    int SEMESTER;
    string ADDRESS;
};

// Function to insert a new student
void insertStudent() {
    Student student;
    ofstream file("students.txt", ios::app);

    if (!file.is_open()) {
        cout << "Error opening the file." << endl;
        return;
    }

    cout << "Enter SID: ";
    cin >> student.SID;
    cout << "Enter Name: ";
    cin >> student.NAME;
    cout << "Enter Branch: ";
    cin >> student.BRANCH;
    cout << "Enter Semester: ";
    cin >> student.SEMESTER;
    cout << "Enter Address: ";
    cin >> student.ADDRESS;

    file << student.SID << " " << student.NAME << " " << student.BRANCH << " " << student.SEMESTER << " " << student.ADDRESS << endl;

    file.close();
}

// Function to modify the address of a student based on SID
void modifyAddress(int sid) {
    ifstream file("students.txt");
    ofstream tempFile("temp.txt");
    Student student;
    int found = 0;

    if (!file.is_open() || !tempFile.is_open()) {
        cout << "Error opening files." << endl;
        return;
    }

    while (file >> student.SID >> student.NAME >> student.BRANCH >> student.SEMESTER >> student.ADDRESS) {
        if (student.SID == sid) {
            cout << "Enter new Address for SID " << sid << ": ";
            cin >> student.ADDRESS;
            found = 1;
        }
        tempFile << student.SID << " " << student.NAME << " " << student.BRANCH << " " << student.SEMESTER << " " << student.ADDRESS << endl;
    }

    file.close();
    tempFile.close();

    if (found) {
        remove("students.txt");
        rename("temp.txt", "students.txt");
        cout << "Address updated successfully." << endl;
    } else {
        remove("temp.txt");
        cout << "Student with SID " << sid << " not found." << endl;
    }
}

// Function to delete a student based on SID
void deleteStudent(int sid) {
    ifstream file("students.txt");
    ofstream tempFile("temp.txt");
    Student student;
    int found = 0;

    if (!file.is_open() || !tempFile.is_open()) {
        cout << "Error opening files." << endl;
        return;
    }

    while (file >> student.SID >> student.NAME >> student.BRANCH >> student.SEMESTER >> student.ADDRESS) {
        if (student.SID == sid) {
            found = 1;
            continue; // Skip this student (deleting)
        }
        tempFile << student.SID << " " << student.NAME << " " << student.BRANCH << " " << student.SEMESTER << " " << student.ADDRESS << endl;
    }

    file.close();
    tempFile.close();

    if (found) {
        remove("students.txt");
        rename("temp.txt", "students.txt");
        cout << "Student with SID " << sid << " deleted successfully." << endl;
    } else {
        remove("temp.txt");
        cout << "Student with SID " << sid << " not found." << endl;
    }
}

// Function to list all students
void listAllStudents() {
    ifstream file("students.txt");
    Student student;

    if (!file.is_open()) {
        cout << "Error opening the file." << endl;
        return;
    }

    cout << "List of all students:" << endl;
    while (file >> student.SID >> student.NAME >> student.BRANCH >> student.SEMESTER >> student.ADDRESS) {
        cout << "SID: " << student.SID << ", Name: " << student.NAME << ", Branch: " << student.BRANCH << ", Semester: " << student.SEMESTER << ", Address: " << student.ADDRESS << endl;
    }

    file.close();
}

// Function to list all students of CSE branch
void listCSEStudents() {
    ifstream file("students.txt");
    Student student;

    if (!file.is_open()) {
        cout << "Error opening the file." << endl;
        return;
    }

    cout << "List of CSE students:" << endl;
    while (file >> student.SID >> student.NAME >> student.BRANCH >> student.SEMESTER >> student.ADDRESS) {
        if (student.BRANCH == "CSE") {
            cout << "SID: " << student.SID << ", Name: " << student.NAME << ", Branch: " << student.BRANCH << ", Semester: " << student.SEMESTER << ", Address: " << student.ADDRESS << endl;
        }
    }

    file.close();
}

// Function to list all CSE students residing in Kuvempunagar
void listCSEStudentsInKuvempunagar() {
    ifstream file("students.txt");
    Student student;

    if (!file.is_open()) {
        cout << "Error opening the file." << endl;
        return;
    }

    cout << "List of CSE students residing in Kuvempunagar:" << endl;
    while (file >> student.SID >> student.NAME >> student.BRANCH >> student.SEMESTER >> student.ADDRESS) {
        if (student.BRANCH == "CSE" && student.ADDRESS.find("Kuvempunagar") != string::npos) {
            cout << "SID: " << student.SID << ", Name: " << student.NAME << ", Branch: " << student.BRANCH << ", Semester: " << student.SEMESTER << ", Address: " << student.ADDRESS << endl;
        }
    }

    file.close();
}

int main() {
    int choice, sid;

    while (true) {
        cout << "\nMenu:" << endl;
        cout << "1. Insert a new student" << endl;
        cout << "2. Modify the address of a student" << endl;
        cout << "3. Delete a student" << endl;
        cout << "4. List all students" << endl;
        cout << "5. List all students of CSE branch" << endl;
        cout << "6. List all CSE students residing in Kuvempunagar" << endl;
        cout << "7. Exit" << endl;
        cout << "Enter your choice: ";
        cin >> choice;

        switch (choice) {
            case 1:
                insertStudent();
                break;
            case 2:
                cout << "Enter SID to modify address: ";
                cin >> sid;
                modifyAddress(sid);
                break;
            case 3:
                cout << "Enter SID to delete student: ";
                cin >> sid;
                deleteStudent(sid);
                break;
            case 4:
                listAllStudents();
                break;
            case 5:
                listCSEStudents();
                break;
            case 6:
                listCSEStudentsInKuvempunagar();
        }
    }
}
