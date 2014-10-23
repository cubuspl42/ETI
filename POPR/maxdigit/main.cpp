#include <iostream>
using namespace std;

int main() {
    long long n=0,m=0;
    cin >> n;
    do {
        int c = n%10;
        n /= 10;
        m = (c>m?c:m);
    }while(n);
    cout << m << endl;
}
