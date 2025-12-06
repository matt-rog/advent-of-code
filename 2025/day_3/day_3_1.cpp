#include <fstream>
#include <string>
#include <iostream>
#include <vector>
#include <sstream>
using namespace std;

int main(int argc, char* argv[])
{
    string bank;
    ifstream inputFile (argv[1]);
    if (inputFile.is_open())
    {  
        int joltageSum = 0;

        // Parse lines        
        while (getline(inputFile, bank))
        {
            if (bank.empty()) continue;

            int maxB1 = 0;
            int maxB2 = 0; 
            for (int i = 0; i < bank.length(); i++)
            {
                int battery = bank[i] - '0';
                if (battery > maxB1 && i != bank.length() - 1)
                {
                    maxB1 = battery;
                    maxB2 = 0;
                } 
                else if (battery > maxB2)
                {
                    maxB2 = battery;
                }
            }
            cout << endl;

            joltageSum += (maxB1 * 10) + maxB2;
        }
        
        cout << joltageSum << endl;
        inputFile.close();
    }


    return 0;
}