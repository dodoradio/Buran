cmake_minimum_required(VERSION 3.15)
project(Buran VERSION 1.0.0)
include(FetchContent)
FetchContent_Declare(
  asteroidsyncservice
  GIT_REPOSITORY  https://github.com/AsteroidOS/asteroidsyncservice
  GIT_TAG         a7993d1b9bf1bafe91c7af949e13b9e7a5951bcd
)
set(DESKTOP_PLATFORM ON)
FetchContent_MakeAvailable(asteroidsyncservice)
find_package(Qt5 COMPONENTS Qml Quick LinguistTools REQUIRED)
configure_file(
    "buran_config.h.in"
    "buran_config.h"
)
add_subdirectory(src)
