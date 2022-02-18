cmake_minimum_required(VERSION 3.15)
project(asteroidsyncservice VERSION 1.0.0)

# options off-by-default that you can enable
option(SAILFISHOS_PLATFORM "Build the project for the SailfishOS platform" OFF)
option(UBUNTU_TOUCH_PLATFORM "Build the project for the Ubuntu Touch platform" OFF)

if (NOT SAILFISHOS_PLATFORM AND NOT UBUNTU_TOUCH_PLATFORM) 
    message(FATAL_ERROR "no platform selected: you must enable either SAILFISHOS_PLATFORM or UBUNTU_TOUCH_PLATFORM")
endif()

if (SAILFISHOS_PLATFORM)
    set(PLATFORM_CODE_DIR "platforms/sailfishos")
    set(PLATFORM_CODE_NAME "sailfishplatform.cpp")
endif()
if (UBUNTU_TOUCH_PLATFORM)
    set(PLATFORM_CODE_DIR "platforms/ubuntutouch")
    set(PLATFORM_CODE_NAME "ubuntuplatform.cpp")
endif()

configure_file(
    "asteroidsyncservice_config.h.in"
    "asteroidsyncservice_config.h"
)
add_subdirectory(asteroidsyncservice)
add_subdirectory(asteroidsyncserviced)
# add config file 
# OTHER_FILES += \
 #   README.md \
 #   rpm/asteroidsyncservice.spec
