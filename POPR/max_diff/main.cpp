#include <cassert>
#include <iostream>
using namespace std;

size_t max_diff(int array[], size_t size) {
    assert(size > 1); // Zakładamy, że tablica ma co najmniej 2 elementy
    size_t max_diff_i = 0; // Indeks pierwszej z pary kolejnych dwóch liczb o największej różnicy
    for(size_t i = 0; i < size - 1; ++i) {
        if(array[i+1]-array[i] >= array[max_diff_i+1]-array[max_diff_i])
            max_diff_i = i;
    }
    return max_diff_i;
}

int main() {
    int array[8] = {2, 3, 5, 7, 11, 13, 17, 19};
    cout << max_diff(array, 8) << endl;
    return 0;
}
