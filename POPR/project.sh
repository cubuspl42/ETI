mkdir $1
mkdir $1/build

cat > $1/main.cpp << EOF
#include <iostream>
using namespace std;

int main() {
    return 0;
}
EOF

cat > $1/CMakeLists.txt  << EOF
cmake_minimum_required(VERSION 2.6)
project($1)
list(APPEND CMAKE_CXX_FLAGS "-std=c++11")
add_executable ($1 main.cpp)
EOF