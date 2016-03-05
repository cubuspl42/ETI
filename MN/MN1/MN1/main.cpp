#include <iostream>
#include <cmath>

template<typename T>
void csv(T arg) {
    std::cout << arg << ", " << std::endl;
}

template<typename Head, typename... Tail>
void csv(Head head, Tail... tail) {
    std::cout << head << ", ";
    csv(tail...);
}

template<typename T>
T factorial(T x) {
    T p = 1;
    for (int i = 0; i < x; ++i) {
        p *= (i + 1);
    }
    return p;
}

template<typename T>
T sin_term_nominator(int i, T x) {
    T s = i % 2 ? -1 : 1;
    T a = pow(x, 2 * i + 1);
    return s * a;
}

template<typename T>
T sin_term_denominator(int i, T x) {
    T b = factorial(2 * i + 1);
    return b;
}

template<typename T>
T sin_term(int i, T x) {
    T n = sin_term_nominator(i, x);
    T d = sin_term_denominator(i, x);
    return n / d;
}

template<typename T>
T sin1_ltr(T x, int n) {
    T s = 0;
    for(int i = 0; i < n; ++i) {
        s += sin_term<T>(i, x);
    }
    return s;
}

template<typename T>
T sin1_rtl(T x, int n) {
    T s = 0;
    for(int i = n - 1; i >= 0; --i) {
        s += sin_term<T>(i, x);
    }
    return s;
}

template<typename T>
T sin2_ltr(T x, int n) {
    T s = x;
    T y = x;
    T z = 1;
    for(int i = 1; i < n; ++i) {
        y *= -x * x;
        z *= (2 * i) * (2 * i + 1);
        // std::cout << i << ": " << y << " " << z << std::endl;
        s += y / z;
    }
    return s;
}

template<typename T>
T sin2_rtl(T x, int n) {
    T s = 0;
    T y = sin_term_nominator(n - 1, x);
    T z = sin_term_denominator(n - 1, x);
    for(int i = n - 1; i >= 0; --i) {
        // std::cout << i << ": " << y << " " << z << std::endl;
        s += y / z;
        y /= -x * x;
        z /= (2 * i) * (2 * i + 1);
    }
    return s;
}

template<typename T>
void print_result(std::string fn, std::string type, T x, T v) {
    T sv = std::sin(x);
    csv(fn, type, x, v, v - sv, (v - sv)/sv);
    // std::cout << fn << " " << v << " " << v - sv << " " << (v - sv)/sv << std::endl;
}

template<typename T>
void print_results(std::string type, T x, int n) {
    print_result("std::sin", type, x, std::sin(x));
    print_result("sin1_ltr", type, x, sin1_ltr(x, n));
    print_result("sin1_rtl", type, x, sin1_rtl(x, n));
    print_result("sin2_ltr", type, x, sin2_ltr(x, n));
    print_result("sin2_rtl", type, x, sin2_rtl(x, n));
}

int main(int argc, const char * argv[]) {
    
    std::cout.precision(24);
    // std::cout << std::fixed;

    int n = 16;
    
    for(double x = 0; x < M_PI / 2; x += 0.2) {
        print_results<float>("float", x, n);
        print_results<double>("double", x, n);
        print_results<long double>("long double", x, n);
    }
    
    return 0;
}
