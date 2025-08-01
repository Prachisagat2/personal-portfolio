#include<iostream>
#include<fstream>
#include<string.h>

using namespace std;

class student
{
    typedef struct stud
    {
        int roll;
        char name[10];
        char div;
        char add[10];
    } stud;

    stud rec;

public:
    void create();
    void display();
    int search();
    void deleteRecord();
};

void student::create()
{
    char ans;
    ofstream fout;
    fout.open("stud.dat", ios::out | ios::binary);
    
    do
    {
        cout << "\nEnter roll no of student: ";
        cin >> rec.roll;
        
        cout << "Enter name of student: ";
        cin >> rec.name;
        
        cout << "Enter division of student: ";
        cin >> rec.div;
        
        cout << "Enter address of student: ";
        cin >> rec.add;
        
        fout.write((char*)&rec, sizeof(stud));
        cout << "\nDo you want to add more records? (y/n): ";
        cin >> ans;
        
    } while (ans == 'y' || ans == 'Y');
    
    fout.close();
}

void student::display()
{
    ifstream fin;
    fin.open("stud.dat", ios::in | ios::binary);
    
    if (!fin)
    {
        cout << "\nFile could not be opened!" << endl;
        return;
    }

    cout << "\nDisplaying student records:\n";
    while (fin.read((char*)&rec, sizeof(stud)))
    {
        cout << "Roll No: " << rec.roll << endl;
        cout << "Name: " << rec.name << endl;
        cout << "Division: " << rec.div << endl;
        cout << "Address: " << rec.add << endl;
        cout << "----------------------------\n";
    }
    
    fin.close();
}

int student::search()
{
    int rollNo;
    ifstream fin;
    fin.open("stud.dat", ios::in | ios::binary);
    
    if (!fin)
    {
        cout << "\nFile could not be opened!" << endl;
        return -1;
    }
    
    cout << "\nEnter roll number to search: ";
    cin >> rollNo;

    while (fin.read((char*)&rec, sizeof(stud)))
    {
        if (rec.roll == rollNo)
        {
            cout << "\nRecord found: \n";
            cout << "Roll No: " << rec.roll << endl;
            cout << "Name: " << rec.name << endl;
            cout << "Division: " << rec.div << endl;
            cout << "Address: " << rec.add << endl;
            fin.close();
            return 0;
        }
    }
    
    cout << "\nRecord not found!" << endl;
    fin.close();
    return -1;
}

void student::deleteRecord()
{
    int rollNo;
    ifstream fin;
    ofstream fout;
    
    fin.open("stud.dat", ios::in | ios::binary);
    if (!fin)
    {
        cout << "\nFile could not be opened!" << endl;
        return;
    }
    
    fout.open("temp.dat", ios::out | ios::binary);
    if (!fout)
    {
        cout << "\nTemporary file could not be created!" << endl;
        fin.close();
        return;
    }
    
    cout << "\nEnter roll number to delete: ";
    cin >> rollNo;

    bool found = false;
    while (fin.read((char*)&rec, sizeof(stud)))
    {
        if (rec.roll != rollNo)
        {
            fout.write((char*)&rec, sizeof(stud));
        }
        else
        {
            found = true;
        }
    }
    
    if (found)
    {
        cout << "\nRecord deleted successfully!" << endl;
    }
    else
    {
        cout << "\nRecord not found!" << endl;
    }

    fin.close();
    fout.close();
    
    remove("stud.dat");  // Delete the original file
    rename("temp.dat", "stud.dat");  // Rename temp file to original name
}

int main()
{
    student s;
    int choice;
    
    do
    {
        cout << "\nMenu: ";
        cout << "\n1. Create student Record";
        cout << "\n2. Display student Records";
        cout << "\n3. Search Student Record";
        cout << "\n4. Delete Student Record";
        cout << "\n5. Exit";
        cout << "\nEnter your choice: ";
        cin >> choice;

        switch (choice)
        {
            case 1:
                s.create();
                break;
            case 2:
                s.display();
                break;
            case 3:
                s.search();
                break;
            case 4:
                s.deleteRecord ();
                break;
            case 5:
                cout << "\nExiting program." << endl;
                break;
            default:
                cout << "\nInvalid choice! Please try again." << endl;
        }

    } while (choice != 5);

    return 0;
    }
    




