cmake_minimum_required(VERSION 3.15)
find_package(Qt5 COMPONENTS Qml Quick REQUIRED)
add_executable(buran cpp/main.cpp)
target_compile_features(buran PUBLIC cxx_std_17)
set_target_properties(buran PROPERTIES AUTOMOC ON AUTORCC ON)
target_compile_options(buran PRIVATE -Wall -Wextra -pedantic -Werror)
target_link_libraries(buran PRIVATE Qt5::Quick Qt5::Qml)
target_include_directories(buran
    PUBLIC
        $<INSTALL_INTERFACE:.>
        $<BUILD_INTERFACE:${CMAKE_BINARY_DIR}>
)
install(TARGETS buran)
