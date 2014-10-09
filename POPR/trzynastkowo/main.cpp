#include <iostream>
#include <string>
using namespace std;

int parse(const string &s) {
    int num=0;
    int m=1;
    for(int i=s.size()-1; i>=0; --i) {
        char c = s[i];
        int digit = c > '9' ? 10 + c - 'A' : c - '0';
        cout << digit << endl;
        num += digit * m;
        m *= 13;
    }
    return num;
}

int main() {
    string a, b;
    cin >> a >> b;
    int x = parse(a), y = parse(b);
    cout << a << ' ' << b << ' ' << x << ' ' << y << ' ' << x+y << endl;
    return 0;
}