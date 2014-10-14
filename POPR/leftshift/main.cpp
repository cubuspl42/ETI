#include <iostream>
#include <cassert>
using namespace std;

int main() {
    int a = 1 << 31;
    unsigned b = 1u << 31;
    cout << a << ' ' << b << endl;
    assert(reinterpret_cast<unsigned&>(a) == b);

    double c = 0.0;
    double d = -1.0*c;

    assert(c == d);
    return 0;
}
