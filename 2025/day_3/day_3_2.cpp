#include <fstream>
#include <string>
#include <iostream>
#include <vector>
#include <sstream>
#include <cmath>
#include <boost/multiprecision/cpp_int.hpp>
using namespace std;

#define JOLTAGE_BANK_SIZE 12
#define BIGINT boost::multiprecision::uint256_t
int main(int argc, char* argv[])
{
    string bank;
    ifstream inputFile (argv[1]);
    if (inputFile.is_open())
    {  
        BIGINT joltageSum = 0;

        // Parse lines        
        while (getline(inputFile, bank))
        {
            if (bank.empty()) continue;
            
            vector<int> maxBatteries(JOLTAGE_BANK_SIZE,0);

            for (int i = 0; i < bank.length(); i++)
            {
                int battery = bank[i] - '0';

                for (int j = 0; j < maxBatteries.size(); j++)
                {  
                    // things left in bank to consider = bank.length() - i + 1
                    // things left in max to consider = maxBatteries.size() - j + 1
                    if (battery > maxBatteries.at(j) && maxBatteries.size() - j + 1 <= bank.length() - i + 1)
                    {
                        maxBatteries.at(j) = battery;
                        cout << battery << " " << j << " " << maxBatteries.size() - (bank.length() - i)<< endl;
                        // Reset rest of banks to 0
                        for (int k = j + 1; k < maxBatteries.size(); k++)
                        {
                            maxBatteries.at(k) = 0;
                        }
                        break;
                    }
                }
            }
            cout << endl;

            // Build joltage number
            BIGINT joltage = 0;
            for (int i = 0; i < maxBatteries.size(); i++)
            {
                cout << maxBatteries.at(i);
                joltage = joltage + BIGINT(maxBatteries.at(i) * pow(10, maxBatteries.size() - i - 1));
            }
            cout << endl;
            cout << joltage << endl;
            joltageSum = joltageSum + joltage;
        }
        
        cout << joltageSum << endl;
        inputFile.close();
    }


    return 0;
}