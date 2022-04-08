cmake_minimum_required(VERSION 3.15)
find_package(Qt5 COMPONENTS Qml Quick LinguistTools REQUIRED)
set(xlatFiles 
    translations/qml_en.ts 
    translations/qml_de.ts
)

qt5_create_translation(qmFiles ${CMAKE_CURRENT_SOURCE_DIR} ${xlatFiles})

function (qt5_create_translation_qrc target) 
    set(options)
    set(oneValueArgs PREFIX)
    set(multiValueArgs OPTIONS)

    cmake_parse_arguments(_XLAT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    set(xlat_files ${_XLAT_UNPARSED_ARGUMENTS})
    set(xlat_options ${_XLAT_OPTIONS})
    if(_XLAT_PREFIX) 
        set(qrcContents "<RCC>\n  <qresource prefix=\"${_XLAT_PREFIX}\">\n")
    else()
        set(qrcContents "<RCC>\n  <qresource prefix=\"i18n\">\n")
    endif()
    foreach(iter ${xlat_files})
        get_filename_component(baseqm ${iter} NAME)
        string(APPEND qrcContents "    <file alias=\"${baseqm}\">")
        string(APPEND qrcContents "${CMAKE_CURRENT_BINARY_DIR}/${baseqm}</file>\n")
    endforeach()
    string(APPEND qrcContents "  </qresource>\n</RCC>\n")
    file(GENERATE OUTPUT ${target} CONTENT "${qrcContents}")
    add_custom_target(${target} ALL DEPENDS ${xlat_files})
endfunction()

qt5_create_translation_qrc(xlat.qrc "${qmFiles}" PREFIX "qml/i18n")

add_executable(buran cpp/main.cpp 
    $<$<NOT:$<CONFIG:Debug>>:buran.qrc>
    xlat.qrc
    "${qmFiles}"
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
install(TARGETS buran CONFIGURATIONS Release)
