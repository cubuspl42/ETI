cmake_minimum_required(VERSION 2.6)
project(maxdigit)
list(APPEND CMAKE_CXX_FLAGS "-std=c++11 -o0")
add_executable (maxdigit main.cpp)
