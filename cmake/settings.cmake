cmake_minimum_required(VERSION 3.15)
cmake_policy(SET CMP0091 NEW)

if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    if (CMAKE_CXX_COMPILER_FRONTEND_VARIANT STREQUAL "MSVC")
        set(IS_CLANGCL true)
    else()
        set(IS_CLANG true)
    endif()
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(IS_GCC true)
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Intel")
    set(IS_INTEL true)
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    set(IS_MSVC true)
endif()

macro(setup target)
    # COMPILE
    # LINK
    # DEBUG_COMPILE
    # DEBUG_LINK
    # RELEASE_COMPILE
    # RELEASE_LINK
    # RELDEB_COMPILE
    # RELDEB_LINK

    if(DEFINED IS_CLANGCL OR DEFINED IS_MSVC)
        string(REGEX REPLACE "/Ob1" "/Ob3" CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")
        string(REGEX REPLACE "/Ob1" "/Ob3" CMAKE_C_FLAGS_RELWITHDEBINFO   "${CMAKE_C_FLAGS_RELWITHDEBINFO}")
        string(REGEX REPLACE "/Ob2" "/Ob3" CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")
        string(REGEX REPLACE "/Ob2" "/Ob3" CMAKE_C_FLAGS_RELWITHDEBINFO   "${CMAKE_C_FLAGS_RELWITHDEBINFO}")

        set(COMPILE /MP /cgthreads8 /Zc:preprocessor /wd5105)
        set(LINK /INCREMENTAL:NO /CGTHREADS:8)

        set(DEBUG_COMPILE /JMC /Od /MDd)

        set(RELEASE_COMPILE /O2 /GS- /guard:cf /D NDEBUG /JMC- /GL /Ob3 /MD /fp:fast)
        set(RELEASE_LINK /OPT:REF /OPT:ICF=10000 /LTCG)

        set(RELDEB_COMPILE ${RELEASE_COMPILE})
        set(RELDEB_LINK ${RELEASE_LINK})
    else()
        set(COMPILE
            -Wno-deprecated-comma-subscript
            -Wno-macro-redefined
            -Wno-address-of-temporary
            -fmacro-backtrace-limit=0
            -fexceptions
            -fdiagnostics-color
        )
        set(LINK -Xlinker /subsystem:console)
        set(DEBUG_COMPILE -O0 -g)
        set(RELEASE_COMPILE -Ofast -flto -march=native -DNDEBUG)
        set(RELDEB_COMPILE ${RELEASE_COMPILE} -g)
    endif()

    target_compile_definitions(${target} PUBLIC _CRT_SECURE_NO_WARNINGS)

    target_compile_options(${target} PUBLIC "${COMPILE}")
    target_compile_options(${target} PUBLIC "$<$<CONFIG:Debug>:${DEBUG_COMPILE}>")
    target_compile_options(${target} PUBLIC "$<$<CONFIG:Release>:${RELEASE_COMPILE}>")
    target_compile_options(${target} PUBLIC "$<$<CONFIG:RelWithDebInfo>:${RELDEB_COMPILE}>")

    target_link_options(${target} PUBLIC "${LINK}")
    target_link_options(${target} PUBLIC "$<$<CONFIG:Debug>:${DEBUG_LINK}>")
    target_link_options(${target} PUBLIC "$<$<CONFIG:Release>:${RELEASE_LINK}>")
    target_link_options(${target} PUBLIC "$<$<CONFIG:RelWithDebInfo>:${RELDEB_LINK}>")

    set_target_properties(
        ${target} PROPERTIES
        C_STANDARD 18
        C_EXTENSIONS ON
        CXX_STANDARD 20
        CXX_EXTENSIONS ON
    )

    target_include_directories(
        ${target} PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include/>
    )
    target_include_directories(${target} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src/)
endmacro()

macro(make_static_library target)
    find_sources()
    add_library(${target} STATIC ${SOURCES})
    setup(${target})
endmacro()

macro(make_dynamic_library target)
    find_sources()
    add_library(${target} SHARED ${SOURCES})
    setup(${target})
endmacro()

macro(make_executable target)
    find_sources()
    add_executable(${target} ${SOURCES})
    setup(${target})
endmacro()

macro(find_sources)
    file(
        GLOB_RECURSE SOURCES
        "${CMAKE_CURRENT_SOURCE_DIR}/src/*.c"
        "${CMAKE_CURRENT_SOURCE_DIR}/src/*.h"
        "${CMAKE_CURRENT_SOURCE_DIR}/include/*.c"
        "${CMAKE_CURRENT_SOURCE_DIR}/include/*.h"
        "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp"
        "${CMAKE_CURRENT_SOURCE_DIR}/src/*.hpp"
        "${CMAKE_CURRENT_SOURCE_DIR}/include/*.cpp"
        "${CMAKE_CURRENT_SOURCE_DIR}/include/*.hpp"
        "${CMAKE_CURRENT_SOURCE_DIR}/ui/*.ui"
        "${CMAKE_CURRENT_SOURCE_DIR}/res/*.qrc"
    )

    set(SOURCES ${SOURCES} PARENT_SCOPE)
endmacro()
