cmake_minimum_required(VERSION 3.15)
find_package(Qt5 COMPONENTS Core Bluetooth DBus Qml REQUIRED)

add_subdirectory(libasteroid)

add_executable(asteroidsyncserviced 
    main.cpp
    watchesmanager.cpp
    dbusinterface.cpp
    bluez/bluezclient.cpp
    bluez/bluez_agentmanager1.cpp
    bluez/bluez_adapter1.cpp
    bluez/bluez_device1.cpp
    bluez/freedesktop_objectmanager.cpp
    bluez/freedesktop_properties.cpp
    "${PLATFORM_CODE_DIR}/${PLATFORM_CODE_NAME}"
)
set_target_properties(asteroidsyncserviced PROPERTIES AUTOMOC ON)
target_compile_features(asteroidsyncserviced PUBLIC cxx_std_17)
target_include_directories(asteroidsyncserviced PRIVATE ${CMAKE_BINARY_DIR} ${PLATFORM_CODE_DIR} libasteroid/src bluez)
target_link_libraries(asteroidsyncserviced PRIVATE Qt5::Bluetooth Qt5::Core Qt5::DBus Qt5::Qml asteroid)
install(TARGETS asteroidsyncserviced)
