#include <fstream>
#include <string>
#include <iostream>
using namespace std;

#define MAX 99
int main(void) {

    string line;
    ifstream inputFile ("input.txt");
    if (inputFile.is_open())
    {
        int acc = 50;
        int zeroCount = 0;
        while (getline(inputFile,line))
        {
            int rotation = stoi(line.substr(1));
            if (line.substr(0,1).compare("L"))
            {
                acc += rotation;
            }
            else
            {
                acc -= rotation;
            }
            if (acc % (MAX + 1) == 0)
            {
                zeroCount += 1;
            }
        }
        cout << zeroCount << endl;
        inputFile.close();
    }


    return 0;
}