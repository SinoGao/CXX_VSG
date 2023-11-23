cmake_minimum_required(VERSION 3.12)
project(VSG-All-In-One
        VERSION 9.0.1.525
        )
set(APP_CLOUDRENDER_NAME VSG_Examples)

option(SEA3D_DEBUGINFO_ENABLED "项目中打印的信息" ON)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set_property(GLOBAL PROPERTY PREDEFINED_TARGETS_FOLDER CMakeDefault)

if (MSVC)
    # warning level 4 and all warnings as errors
    add_compile_options(/wd4819)
    add_compile_options(/wd4099)
else()
    # lots of warnings and all warnings as errors
    #add_compile_options(-Wall -Wextra -pedantic -Werror)
endif()

include(scripts/copy.cmake)

# Vulkan_Debug
add_definitions(-DVULKAN_DEBUG_INFO=1)
add_definitions(-DvsgXchange_FOUND=1)

include_directories(${CMAKE_BINARY_DIR}/include)

add_subdirectory(vsg-dev/CXX_VulkanSceneGraph)
add_subdirectory(vsg-dev/CXX_assimp)
add_subdirectory(vsg-dev/CXX_vsgXchange)

set(SOURCES
       vsg-dev/CXX_vsgExamples/vsgExamples/examples/app/vsgviewer/vsgviewer.cpp
)

add_executable(${APP_CLOUDRENDER_NAME} ${SOURCES})

add_dependencies(${APP_CLOUDRENDER_NAME} vsg::vsg)
add_dependencies(${APP_CLOUDRENDER_NAME} assimp::assimp)
add_dependencies(${APP_CLOUDRENDER_NAME} vsgXchange::vsgXchange)

target_link_libraries(${APP_CLOUDRENDER_NAME} PRIVATE vsg::vsg)
target_link_libraries(${APP_CLOUDRENDER_NAME} PRIVATE assimp::assimp)
target_link_libraries(${APP_CLOUDRENDER_NAME} PRIVATE vsgXchange::vsgXchange)
#message(FATAL_ERROR vsg::vsg)
#target_link_libraries(${APP_CLOUDRENDER_NAME} PRIVATE vsgXchange::vsgXchange)