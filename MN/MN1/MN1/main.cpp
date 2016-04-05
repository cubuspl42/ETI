#include <iostream>
#include <cmath>
#include <map>

// silnia

template<typename T>
T factorial(T x) {
    T p = 1;
    for (int i = 0; i < x; ++i) {
        p *= (i + 1);
    }
    return p;
}

// licznik i-tego wyrazu szeregu Taylora

template<typename T>
T sin_term_nominator(int i, T x) {
    T s = i % 2 ? -1 : 1;
    T a = std::pow(x, 2 * i + 1);
    return s * a;
}

// mianownik i-tego wyrazu szeregu Taylora

template<typename T>
T sin_term_denominator(int i, T x) {
    T b = factorial<T>(2 * i + 1);
    return b;
}

// i-ty wyraz szeregu Taylora

template<typename T>
T sin_term(int i, T x) {
    T n = sin_term_nominator(i, x);
    T d = sin_term_denominator(i, x);
    return n / d;
}

// standardowa funkcja sinus

template<typename T>
T sin0(T x, int) {
    return std::sinl(x);
}

// sinus wyliczany poprzez sumowanie wyrazów szeregu Taylora od największego do najmniejszego

template<typename T>
T sin1_ltr(T x, int n) {
    T s = 0;
    for(int i = 0; i < n; ++i) {
        s += sin_term<T>(i, x);
    }
    return s;
}

// sinus wyliczany poprzez sumowanie wyrazów szeregu Taylora od najmniejszego do największego

template<typename T>
T sin1_rtl(T x, int n) {
    T s = 0;
    for(int i = n - 1; i >= 0; --i) {
        s += sin_term<T>(i, x);
    }
    return s;
}

// sinus wyliczany poprzez sumowanie wyrazów szeregu Taylora, gdzie każdy wyraz
// jest wyliczany na podstawie poprzedniego

template<typename T>
T sin2_(T x, int n) {
    T s = x;
    T y = x;
    T z = 1;
    for(int i = 1; i < n; ++i) {
        y *= -x * x;
        z *= (2 * i) * (2 * i + 1);
        s += y / z;
    }
    return s;
}

template<typename T>
T sin2(T x, int n) {
    T s = x;
    T y = x;
    for(int i = 1; i < n; ++i) {
        y *= (-x * x) / ((2 * i) * (2 * i + 1));
        s += y;
    }
    return s;
}

// funkcja główna, wypisuje wartość sinusa przyjmując metodę, typ zmiennoprzecinkowy,
// liczbę wyrazów szeregu oraz wartość x

// przykład wywołania: ./a.out sin2 double 8 0.5

int main(int argc, const char * argv[]) {
    int prec = std::numeric_limits<long double>::max_digits10;
    
    std::cout.precision(prec);
    std::cout << std::fixed;
    
    std::cerr.precision(prec);
    std::cerr << std::fixed;
    
    std::map<std::string,
        std::map<std::string,
            std::function<long double(long double, int)>>> f;

    f["sin0"]["float"] = sin0<float>;
    f["sin0"]["double"] = sin0<double>;
    f["sin0"]["longdouble"] = sin0<long double>;
    
    f["sin1_ltr"]["float"] = sin1_ltr<float>;
    f["sin1_ltr"]["double"] = sin1_ltr<double>;
    f["sin1_ltr"]["longdouble"] = sin1_ltr<long double>;
    
    f["sin1_rtl"]["float"] = sin1_rtl<float>;
    f["sin1_rtl"]["double"] = sin1_rtl<double>;
    f["sin1_rtl"]["longdouble"] = sin1_rtl<long double>;
    
    f["sin2"]["float"] = sin2<float>;
    f["sin2"]["double"] = sin2<double>;
    f["sin2"]["longdouble"] = sin2<long double>;

    std::string fn = argv[1];
    std::string tp = argv[2];
    int n = std::stoi(argv[3]);
    long double x = std::stold(argv[4]);
    
    // auto sin0 = f["sin0"][tp];
    auto sin_f = f[fn][tp];
    
    long double v = sin_f(x, n);
    long double sv = sin0(x, 0);
    
    std::cout << std::abs(v - sv) / sv;
    
    return 0;
}
