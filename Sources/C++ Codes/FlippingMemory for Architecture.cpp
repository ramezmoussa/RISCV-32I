#include <iostream>
#include <fstream>

using namespace std;

void flipFile(string name1, string name2)
{
	ifstream input;
	input.open(name1.c_str());
	ofstream output;
	output.open(name2.c_str());
	
	while(!input.eof())
	{
		string a;
		input >> a;
		output  << a[6]<< a[7] << " "<< a[4] << a[5] << " "<< a[2] << a[3]<< " "<< a[0]<< a[1] << endl;
	}
	
	input.close();
	output.close();
}

int main()
{
	flipFile("RARSOutput.txt", "FormatedMemory.txt");
	return 0;
}
