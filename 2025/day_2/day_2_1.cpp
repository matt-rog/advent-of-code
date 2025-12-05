#include <fstream>
#include <string>
#include <iostream>
#include <boost/multiprecision/cpp_int.hpp>
#include <vector>
#include <sstream>
using namespace std;

std::vector<std::string> split_string(const std::string& str, char delimiter) {
    std::vector<std::string> tokens;
    std::stringstream ss(str);
    std::string token;

    // Tokenize the string based on the delimiter
    while (std::getline(ss, token, delimiter)) {
        if (!token.empty()) {  // Skip empty tokens
            tokens.push_back(token);
        }
    }

    return tokens;
}

#define BIGINT boost::multiprecision::uint256_t
int main(int argc, char* argv[])
{
    string line;
    ifstream inputFile (argv[1]);
    if (inputFile.is_open())
    {  
        BIGINT invalidIdSum(0);

        // Parse ranges
        getline(inputFile,line);

        auto ranges = split_string(line, ',');
        for (const auto& rangeString : ranges)
        {
            int dashPos = rangeString.find("-");
            
            string startString = rangeString.substr(0, dashPos);
            string endString = rangeString.substr(dashPos + 1);
            BIGINT start(startString);
            BIGINT end(endString);
            
            // cout << start << " -> " << end << endl;
            
            for (BIGINT i = start; i < end + 1; i++)
            {
                string iString = to_string(i);
                if (iString.length() % 2 == 0)
                {   
                    int mid = iString.length() / 2;
                    string iStringA = iString.substr(0, mid);
                    string iStringB = iString.substr(mid);
                    if (iStringA == iStringB)
                    {
                        cout << iString << endl;
                        invalidIdSum += i;
                    }
                    
                }
            }

        }
        
        cout << invalidIdSum << endl;
        inputFile.close();
    }


    return 0;
}