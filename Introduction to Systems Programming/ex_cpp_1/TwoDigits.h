/* Assignment: 1
Author: Dan Ben Ami, ID: 316333079
Author: Tom Kessous, ID: 206018749
*/
#pragma once
class TwoDigits
{
private:
	char lsb, msb;			
public:
	TwoDigits();							//set both lsb and msb to zeros.
	TwoDigits(int num);						//convert int to lsb and msb chars.
	TwoDigits(char msb, char lsb);			//set lsb and msb.
	int value();							//return the value msb*10+lsb
	void update(int new_num);				//update the msb and lsb to the given number.
	void printValue();						//print the value.
};

