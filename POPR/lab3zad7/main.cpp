#include <iostream>
using namespace std;
const size_t N = 4;
int main() {
    int x, i=0, g[N] = {-1}; // -1 = czeka na jedynkę, -2 = czeka na szóstkę, >=0 = jest w grze
    cin >> x;
    char c;
    while(cin >> c) {
       if(c == 'M') {
            i = i % 4;
            int k;
            cin >> k;
            if(g[i] >= 0) {
                g[i] += k;
                if(g[i] >= x) {
                    cout << "END OF GAME" << endl;
                    return 0;
                }
            } else if(g[i] == -1 && k == 1) {
                --g[i];
            } else if(g[i] == -2 && k == 6) {
                g[i] = 0;
            }
            ++i;
        } else {
            for(int j=0;j<N;++j)
                cout << (g[j] > 0 ? g[j] : 0) << ' ';
            cout << endl;
        }     
    }
    return 0;
}
