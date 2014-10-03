cmake_minimum_required(VERSION 2.6)
project(Hello)
list(APPEND CMAKE_CXX_FLAGS "-std=c++11")
add_executable (hello main.cpp)
