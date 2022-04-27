cmake_minimum_required(VERSION 3.15)
project(Buran VERSION 1.0.0)
include(FetchContent)
FetchContent_Declare(
  asteroidsyncservice
  GIT_REPOSITORY  https://github.com/AsteroidOS/asteroidsyncservice
  GIT_TAG         8bfd1992242e305b580452eb928d8757ae6bd559
)
set(DESKTOP_PLATFORM ON)
FetchContent_MakeAvailable(asteroidsyncservice)
find_package(Qt5 COMPONENTS Qml Quick LinguistTools REQUIRED)
configure_file(
    "buran_config.h.in"
    "buran_config.h"
)
add_subdirectory(src)
