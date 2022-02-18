cmake_minimum_required(VERSION 3.15)
find_package(QT NAMES Qt5 COMPONENTS Core Bluetooth DBus Qml Quick REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Bluetooth DBus Qml Quick REQUIRED)
add_library(asteroidsyncserviceplugin SHARED syncservice_plugin.cpp watch.cpp watches.cpp ${PLATFORM_CODE_DIR}/servicecontrol.cpp)
target_include_directories(asteroidsyncserviceplugin PRIVATE ${PLATFORM_CODE_DIR})
target_compile_features(asteroidsyncserviceplugin PUBLIC cxx_std_17)
target_link_libraries(asteroidsyncserviceplugin PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Bluetooth Qt${QT_VERSION_MAJOR}::DBus Qt${QT_VERSION_MAJOR}::Qml Qt${QT_VERSION_MAJOR}::Quick asteroid)

# Installation paths
get_target_property(REAL_QMAKE_EXECUTABLE ${Qt5Core_QMAKE_EXECUTABLE}
                    IMPORTED_LOCATION)

if (NOT QT_INSTALL_QML)
    execute_process(COMMAND "${REAL_QMAKE_EXECUTABLE}" -query QT_INSTALL_QML
                    OUTPUT_VARIABLE QT_INSTALL_QML
                    ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)
endif()

install(TARGETS asteroidsyncserviceplugin DESTINATION ${QT_INSTALL_QML}/org/asteroid/syncservice)
install(FILES qmldir DESTINATION ${QT_INSTALL_QML}/org/asteroid/syncservice)
