/* Assignment: 1
Author: Dan Ben Ami, ID: 316333079
Author: Tom Kessous, ID: 206018749
*/
#include "Menu.h"
#include<iostream>
using namespace std;

Menu::Menu() {}

void Menu::mainMenu() {
	int option = 0;
	while (option != 4) {
		while (option < 1 || option > 4) {                //displaying main menu
			cout << "-------Main menu--------" << endl;
			cout << "1 - twoDigitsMenu" << endl;
			cout << "2 - fractionMenu" << endl;
			cout << "3 - stringMenu" << endl;
			cout << "4 - Exit the program" << endl;
			cout << "Choose an option from 1-4: " << endl;
			cin >> option;
		}
		if (option == 1) this->twoDigitsMenu();
		if (option == 2) this->fractionMenu();
		if (option == 3) this->stringMenu();
		if (option == 4) cout << "Goodbye"<< endl;
		if (option != 4) option = 0;				//returning to main menu if 4 wasn't pressed
	}
}

void Menu::twoDigitsMenu() {
	char first_digit = -1, sec_digit = -1;
	while (first_digit <'0' || first_digit > '9') {          //getting the first digit of num1
		cout << "Please enter the dozens digit: " << endl;
		cin >> first_digit;
	}
	while (sec_digit < '0' || sec_digit > '9') {				 //getting the second digit of num1
		cout << "Please enter the units digit: " << endl;
		cin >> sec_digit;
	}
	TwoDigits num1(first_digit, sec_digit);					//constructor of 2 chars	
	int input_num = 100;
	while (input_num < 0 || input_num > 99) {			//getting num2 by int
		cout << "Please enter number from 0 to 99: ";
		cin >> input_num;
	}
	TwoDigits num2(input_num);		//constructor of int

	int option = 0;
	while (option != 4) {					// displaying menu
		while (option < 1 || option > 4) {
			cout << "-------two Digits Menu--------" << endl;
			cout << "1 - Update num1 by int" << endl;
			cout << "2 - Sum of num1 and num2" << endl;
			cout << "3 - Print numbers" << endl;
			cout << "4 - Back to main menu" << endl;
			cout << "Choose an option from 1-4: " << endl;
			cin >> option;
		}
		if (option == 1) {
			int new_int;
			cout << "Please enter new number from 0 to 99" << endl;
			cin >> new_int;
			num1.update(new_int);
			option = 0;
		}
		if (option == 2) {
			cout << "The sum of " << num1.value() << "+" <<
				num2.value() << " is: " << num1.value() + num2.value() << endl;
			option = 0;
		}
		if (option == 3) {
			cout << "First two digit number: " << num1.value() << endl;
			cout << "Second two digit number: " << num2.value() << endl;
			option = 0;
		}
	}
}

void Menu::fractionMenu() {
	int mone, mechane;
	cout << "Please enter a Numerator (int): ";
	cin >> mone;
	cout << "Please enter a Denominator (int): ";
	cin >> mechane;
	Fraction shever(mone, mechane);				// constructor of fraction

	int option = 0;
	while (option != 5) {					 //displaying menu
		while (option < 1 || option > 5) {
			cout << "-------fraction Menu--------" << endl;
			cout << "1 - Update Numerator" << endl;
			cout << "2 - Update Denominator" << endl;
			cout << "3 - Print fraction" << endl;
			cout << "4 - Sum with another float" << endl;
			cout << "5 - Back to main menu" << endl;
			cout << "Choose an option from 1-5: " << endl;
			cin >> option;
		}
		if (option == 1) {
			int mone;
			cout << "please enter new numerator: ";
			cin >> mone;
			shever.updateNumerator(mone);
		}
		if (option == 2) {
			int mechane;
			cout << "please enter new denominator: ";
			cin >> mechane;
			shever.updateDenominator(mechane);
		}
		if (option == 3) shever.printValue();
		if (option == 4) {
			float tmp;
			cout << "please enter a float number: ";
			cin >> tmp;
			cout << "The sum of " << shever.value() << " and " << tmp << " is: " << tmp + shever.value() << endl;
		}
		if (option != 5) option = 0;			//if 5 wasnt pressed get back to menu
	}
}

void Menu::stringMenu() {
	String str;
	int option = 0;
	while (option != 8) {
		while (option < 1 || option > 8) {						 //displaying menu
			cout << "-------string Menu--------" << endl;
			cout << "1 - Update string" << endl;
			cout << "2 - Update char after char" << endl;
			cout << "3 - Set char at specific index" << endl;
			cout << "4 - Get char by index" << endl;
			cout << "5 - Print the string" << endl;
			cout << "6 - Print the string in lowercase" << endl;
			cout << "7 - Print the string in uppercase" << endl;
			cout << "8 - Back to main menu" << endl;
			cout << "Choose an option from 1-8: " << endl;
			cin >> option;
		}
		if (option == 1) {
			char input[10];
			cin.ignore();
			cout << "please enter a string in maximum length of 9 characters: " << endl;
			cin.get(input, 10);
			str.updateValue(input);
		}
		if (option == 2) {
			if (!str.setCharsByUser())
				cout << "The index is not in the correct range" << endl;
		}
		if (option == 3) {
			char new_char;
			int idx;
			cout << "Please enter a char: ";
			cin >> new_char;
			cout<< endl;
			cout << "Please enter an index from 0 to the length of the string(maximum 8): ";
			cin >> idx;
			cout << endl;

			if (!str.setCharAt(new_char, idx))				//If index is not valid setcharat return false.
				cout << "Index not valid" << endl;
		}
		if (option == 4) {
			int idx;
			cout << "Please enter a index: " << endl;
			cin >> idx;
			cout << "The value in index " << idx << " is: " << str.getCharAt(idx) << endl;
		}
		if (option == 5) str.printValue();
		if (option == 6) str.printValue(false);
		if (option == 7) str.printValue(true);
		if (option != 8) option = 0;					//if 8 wasnt pressed get back to menu
		while ((getchar()) != '\n');			//clearing the buffer
	}	

}