cmake_minimum_required(VERSION 3.15)
project(Buran VERSION 1.0.0)
include(FetchContent)
FetchContent_Declare(
  asteroidsyncservice
  GIT_REPOSITORY  https://github.com/AsteroidOS/asteroidsyncservice
  GIT_TAG         ba7eecfc6d6d923227aedb32372a340bcab5315d
)
set(DESKTOP_PLATFORM ON)
FetchContent_MakeAvailable(asteroidsyncservice)
find_package(Qt6 COMPONENTS Qml Quick LinguistTools REQUIRED)
configure_file(
    "buran_config.h.in"
    "buran_config.h"
)
add_subdirectory(src)
