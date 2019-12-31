#include <iostream>
#include <fstream>

using namespace std;

void flipFile(string name1, string name2)
{
	ifstream input;
	input.open(name1.c_str());
	ofstream output;
	output.open(name2.c_str());
	int counter = 128;
	while(!input.eof())
	{
		string a[4];
		input >> a[0] >> a[1] >> a[2] >> a[3];
		for(int i = 0; i < 4; i++)
		{
			output  << "mem["<< counter+i << "]= 8'h" << a[i] << ";" << endl;
		}
		counter += 4;
	}
	
	input.close();
	output.close();
}

int main()
{
	flipFile("FormatedMemory.txt", "FPGAInstructions.txt");
	return 0;
}
