cmake_minimum_required(VERSION 3.15)
find_package(Qt5 COMPONENTS Quick REQUIRED)
add_executable(harbour-starship src/harbour-starship.cpp)

target_compile_features(harbour-starship PUBLIC cxx_std_17)
set_target_properties(harbour-starship PROPERTIES AUTOMOC ON)
target_compile_options(harbour-starship PRIVATE -Wall -Wextra -pedantic -Werror)
target_link_libraries(harbour-starship PRIVATE Qt5::Quick)
target_include_directories(harbour-starship
    PUBLIC
        $<INSTALL_INTERFACE:.>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/services
)
install(TARGETS harbour-starship)
