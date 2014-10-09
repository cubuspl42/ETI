#include <cfloat>
#include <iostream>
#include <cmath>
using namespace std;

int main() {
    double a, b, c;
    cin >> a >> b >> c;
    if(a == 0) {
        // bx + c = 0
        if(b == 0) {
            if(c == 0) {
                for(double x = 0; x < INFINITY; x += DBL_EPSILON) {
                    cout << "x = " << x << " v" << endl;
                }
            } else {
                cout << "brak rozwiązań" << endl;
            }
        } else {
            cout << "x = " << -c/b << endl;
        }
    } else {
        double delta = b*b-4*a*c;
        // ax^2 + bx + c = 0
        if(delta < 0) {
            cout << "delta < 0 brak rozwiązań" << endl;
        } else {
            double sqrtdelta = sqrt(delta);
            double x1 = (-b-sqrtdelta)/(2*a);
            double x2 = (-b+sqrtdelta)/(2*a);
            cout << "x1 = " << x1 << " x2 = " << x2 << endl;
        }
    }
    return 0;
}
