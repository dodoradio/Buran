cmake_minimum_required(VERSION 3.15)
project(Buran VERSION 1.0.0)
include(FetchContent)
FetchContent_Declare(
  asteroidsyncservice
  GIT_REPOSITORY  https://github.com/AsteroidOS/asteroidsyncservice
  GIT_TAG         d50844bc316a84c1f22e3cf96c25217f468845e5
)
set(DESKTOP_PLATFORM ON)
FetchContent_MakeAvailable(asteroidsyncservice)
find_package(Qt6 COMPONENTS Qml Quick LinguistTools REQUIRED)
configure_file(
    "buran_config.h.in"
    "buran_config.h"
)
add_subdirectory(src)
install(FILES buran.desktop DESTINATION /usr/share/applications)
install(FILES buran.svg DESTINATION /usr/share/pixmaps)
