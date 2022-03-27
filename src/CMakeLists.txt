cmake_minimum_required(VERSION 3.15)
find_package(Qt5 COMPONENTS Qml Quick LinguistTools REQUIRED)
set(xlatFiles 
    translations/harbour-starship.ts 
    translations/harbour-starship-de.ts
)
qt5_add_translation(qmFiles ${xlatFiles})
qt5_create_translation(qmFiles qml/ ${xlatFiles})
# only use this if Release version, but always make it
qt5_add_resources(qrcResources buran.qrc)
add_executable(buran cpp/main.cpp 
    $<$<NOT:$<CONFIG:Debug>>:${qrcResources}>
)
target_compile_features(buran PUBLIC cxx_std_17)
set_target_properties(buran PROPERTIES AUTOMOC ON AUTORCC ON)
target_compile_options(buran PRIVATE -Wall -Wextra -pedantic -Werror)
target_compile_definitions(buran PRIVATE 
    $<$<CONFIG:Debug>:DEBUG_BUILD>
)
target_link_libraries(buran PRIVATE Qt5::Quick Qt5::Qml)
target_include_directories(buran
    PUBLIC
        $<INSTALL_INTERFACE:.>
        $<BUILD_INTERFACE:${CMAKE_BINARY_DIR}>
)
install(TARGETS buran)
