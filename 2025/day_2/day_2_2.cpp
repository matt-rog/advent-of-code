#include <fstream>
#include <string>
#include <iostream>
#include <boost/multiprecision/cpp_int.hpp>
#include <vector>
#include <sstream>
using namespace std;

std::vector<std::string> split_string(const std::string& str, string delimiter) {
    std::vector<std::string> tokens;

    if (delimiter.empty()) {
        if (!str.empty()) {
            tokens.push_back(str);
        }
        return tokens;
    }

    std::size_t start = 0;
    while (true) {
        std::size_t pos = str.find(delimiter, start);
        if (pos == std::string::npos) {
            if (start < str.size()) {
                tokens.push_back(str.substr(start));
            }
            break;
        }

        if (pos > start) {
            // Non-empty token
            tokens.push_back(str.substr(start, pos - start));
        }

        // Move past this delimiter
        start = pos + delimiter.size();
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

        auto ranges = split_string(line, ",");
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
                
                // Find a j s.t. j equal chunks of iString are equal
                for (int j = 1; j < iString.length(); j++)
                {
                    string delim = iString.substr(0, j);
                    auto chunks = split_string(iString, delim);
                    if (chunks.size() == 0)
                    {
                        // cout << i << endl;
                        invalidIdSum += i;
                        break;
                    }
                }
            }

        }
        
        cout << invalidIdSum << endl;
        inputFile.close();
    }


    return 0;
}