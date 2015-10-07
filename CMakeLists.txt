cmake_minimum_required(VERSION 3.2.0)
project(WPLibB)
set(CMAKE_VERBOSE_MAKEFILE on)

message(STATUS "Building for iOS")
include_directories(include)
add_library(WPLibB STATIC "src/WPObjectB.m")
