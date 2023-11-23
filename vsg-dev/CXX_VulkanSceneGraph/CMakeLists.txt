cmake_minimum_required(VERSION 3.7)

project(vsg
        VERSION 1.0.9
        DESCRIPTION "VulkanSceneGraph library"
        LANGUAGES CXX
)
set(VSG_SOVERSION 14)
SET(VSG_RELEASE_CANDIDATE 0)

set(VSG_CMAKE_CURRENT_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/VulkanSceneGraph" CACHE INTERNAL "VSG Current Source Dir.")
set(VSG_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/VulkanSceneGraph" CACHE INTERNAL "Root source directory of VulkanSceneGraph.")
set(VSG_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/" CACHE INTERNAL "Root binary directory of VulkanSceneGraph.")

# create the version header
set(VSG_MAX_DEVICES 1 CACHE STRING "Set maximum number of vk/vsg::Device that are supported.")
set(VSG_VERSION_HEADER "${PROJECT_BINARY_DIR}/include/vsg/core/Version.h")

list(APPEND CMAKE_MODULE_PATH ${VSG_CMAKE_CURRENT_SOURCE_DIR}/cmake)
include(vsgMacros)

vsg_setup_dir_vars()
vsg_setup_build_vars()

if (MSVC)
    # Increase Number of Sections in .Obj file
    add_compile_options(/bigobj)
endif()

if (VULKAN_SDK)
    message("Within VulkanSceneGraph cmake, setting VULKAN_SDK env var to " ${VULKAN_SDK})
    set(ENV{VULKAN_SDK} ${VULKAN_SDK})
endif()

find_package(Vulkan ${Vulkan_MIN_VERSION} REQUIRED)

find_package(Threads REQUIRED)

# Enable/disable shader compilation support that pulls in glslang
set(VSG_SUPPORTS_ShaderCompiler  1 CACHE STRING "Optional shader compiler support, 0 for off, 1 for enabled." )
if (VSG_SUPPORTS_ShaderCompiler)
    if (NOT EXISTS ${VSG_CMAKE_CURRENT_SOURCE_DIR}/src/glslang/build_vars.cmake)

        if (Git_FOUND)

            set(glslang_URL "https://github.com/vsg-dev/glslang.git" CACHE STRING "URL of the glslang git repository")
            set(glslang_branch "VSG-1.0.x" CACHE STRING "branch/tag of the glslang git repository")

            execute_process(COMMAND ${GIT_EXECUTABLE} clone --depth 1 --branch ${glslang_branch} ${glslang_URL}
                    WORKING_DIRECTORY ${VSG_CMAKE_CURRENT_SOURCE_DIR}/src
                    RESULT_VARIABLE GIT_SUBMOD_RESULT)

            if(NOT GIT_SUBMOD_RESULT EQUAL "0")
                message(WARNING "git clone of glslang failed. ShaderCompile support disabled.")
                set(VSG_SUPPORTS_ShaderCompiler 0)
            endif()
        else()
            message(WARNING "git clone of glslang failed. ShaderCompile support disabled.")
            set(VSG_SUPPORTS_ShaderCompiler 0)
        endif()
    endif()
endif()

set(VSG_SUPPORTS_Windowing  1 CACHE STRING "Optional native windowing support providing a default implementation of vsg::Window::create(), 0 for off, 1 for enabled." )
if (VSG_SUPPORTS_Windowing)
    if (ANDROID)
        set(FIND_DEPENDENCY_WINDOWING "")
        find_library(AndroidLib android)
        if(CMAKE_SYSTEM_VERSION GREATER 24)
            find_library(AndroidNativeWindowLib nativewindow)
        endif()
    elseif (WIN32)
        set(FIND_DEPENDENCY_WINDOWING "")
        # just use native windowing
    elseif (APPLE)
        set(FIND_DEPENDENCY_WINDOWING "find_library(COCOA_LIBRARY Cocoa)\nfind_library(QUARTZCORE_LIBRARY QuartzCore)\n")
        find_library(COCOA_LIBRARY Cocoa)
        find_library(QUARTZCORE_LIBRARY QuartzCore)
    else()
        set(FIND_DEPENDENCY_WINDOWING "find_package(PkgConfig REQUIRED)\npkg_check_modules(xcb REQUIRED IMPORTED_TARGET xcb)\n")
        # just use Xcb for native windowing
        find_package(PkgConfig REQUIRED)
        pkg_check_modules(xcb REQUIRED IMPORTED_TARGET xcb)
    endif()
endif()

# this line needs to be after the call to setup_build_vars()
configure_file("${VSG_SOURCE_DIR}/src/vsg/core/Version.h.in" "${VSG_VERSION_HEADER}")

#message(STATUS ${VSG_VERSION_HEADER})

vsg_add_option_maintainer(
        PREFIX v
        RCLEVEL ${VSG_RELEASE_CANDIDATE}
)
add_subdirectory(${VSG_CMAKE_CURRENT_SOURCE_DIR}/src/vsg)

# install headers
set(INSTALL_DIRECTORY "${CMAKE_BINARY_DIR}/include")

file(COPY ${VSG_SOURCE_DIR}/include/vsg
    DESTINATION ${INSTALL_DIRECTORY} )

file(COPY ${VSG_VERSION_HEADER}
        DESTINATION ${INSTALL_DIRECTORY}/vsg/core )
vsg_add_feature_summary()