cmake_minimum_required(VERSION 3.15)
project(Buran
    VERSION 1.0.0
    HOMEPAGE_URL https://github.com/dodoradio/Buran
    DESCRIPTION "Buran is a Linux desktop synchronization application for AsteroidOS"
)
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
set(CPACK_GENERATOR "DEB;RPM")
set(CPACK_PACKAGE_VENDOR "dodoradio")
set(CPACK_PACKAGE_CONTACT "dodoradio@outlook.com")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
set(CPACK_RESOURCE_FILE_README "${CMAKE_CURRENT_SOURCE_DIR}/README.md")
set(CPACK_RPM_PACKAGE_LICENSE "GPLv3")
set(CPACK_STRIP_FILES TRUE)
include(CPack)
