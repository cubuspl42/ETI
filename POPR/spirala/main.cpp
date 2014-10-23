#include <iostream>
#include <complex>
using namespace std;

constexpr size_t N = 80;
bool t[N][N];

int main() {
    double b;
    cout << "Podaj część urojoną liczby z2: \n";
    cin >> b;
    complex<double> z = 1, z2 {1, b};
    while(1) {
        z *= z2;
        int x = z.real(), y = z.imag();
        x += N/2;
        y += N/2;
        if(x < 0 || x >= N || y < 0 || y >= N)
            break;
        t[y][x] = true;
    }
    for(size_t y=0;y<N;++y) {
        for(size_t x=0;x<N;++x) {
            cout << (t[y][x] ? '*' : ' ');
        }
        cout << '\n';
    }

    return 0;
}
