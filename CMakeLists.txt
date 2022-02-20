cmake_minimum_required(VERSION 3.15)
project(Buran VERSION 1.0.0)
configure_file(
    "buran_config.h.in"
    "buran_config.h"
)
add_subdirectory(harbour-starship)

