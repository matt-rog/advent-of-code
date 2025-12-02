#include <fstream>
#include <string>
#include <iostream>
using namespace std;

#define MAX 99

int main(void) {
    string line;
    ifstream inputFile("input.txt");
    if (inputFile.is_open())
    {
        const int N = MAX + 1;
        int acc = 50;
        int zeroCount = 0;

        while (getline(inputFile, line))
        {
            if (line.empty()) continue;

            char dir = line[0];
            int delta = stoi(line.substr(1));

            int pos = acc % N;
            if (pos < 0) pos += N;

            int leftDistanceToZero  = (pos > 0) ? pos : N;
            int rightDistanceToZero = (pos > 0) ? (N - pos) : N;

            int postZeroDelta = 0;

            if (dir == 'L' && delta >= leftDistanceToZero)
            {
                zeroCount += 1;
                postZeroDelta = delta - leftDistanceToZero;
            }
            else if (dir == 'R' && delta >= rightDistanceToZero)
            {
                zeroCount += 1;
                postZeroDelta = delta - rightDistanceToZero;
            }

            zeroCount += (postZeroDelta / N);

            acc += (dir == 'L') ? (-delta) : delta;

            cout << zeroCount << endl;
        }

        cout << zeroCount << endl;
        inputFile.close();
    }

    return 0;
}
