cmake_minimum_required(VERSION 3.15)
project(Buran VERSION 1.0.0)
find_package(Qt5 COMPONENTS Qml Quick LinguistTools REQUIRED)
configure_file(
    "buran_config.h.in"
    "buran_config.h"
)
add_subdirectory(src)
