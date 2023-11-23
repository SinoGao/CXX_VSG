cmake_minimum_required(VERSION 3.12)

project(vsgXchange
        VERSION 1.0.5
        DESCRIPTION "VulkanSceneGraph 3rd party data integration library"
        LANGUAGES CXX C
)
set(VSGXCHANGE_SOVERSION 1)
SET(VSGXCHANGE_RELEASE_CANDIDATE 0)

set(VSG_CMAKE_CURRENT_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/vsgXchange" CACHE INTERNAL "VSG Current Source Dir.")
set(VSGXCHANGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/vsgXchange" CACHE INTERNAL "Root source directory of vsgXchange.")
set(VSGXCHANGE_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}" CACHE INTERNAL "Root binary directory of vsgXchange.")


# set the use of C++17 globally as all examples require it
set(CMAKE_CXX_STANDARD 17)

# Find Vulkan and the VSG
if (VULKAN_SDK)
    set(ENV{VULKAN_SDK} ${VULKAN_SDK})
endif()

set(VSG_MIN_VERSION 1.0.9)
find_package(vsg ${VSG_MIN_VERSION})

vsg_setup_dir_vars()
vsg_setup_build_vars()

# for generated cmake support files
set(FIND_DEPENDENCY ${FIND_DEPENDENCY} "find_dependency(vsg ${VSG_MIN_VERSION} REQUIRED)")

set(vsgXchange_assimp ON)
# source directory for main vsgXchange library
add_subdirectory(${VSGXCHANGE_SOURCE_DIR}/src)

set(VSGXCHANGE_VERSION_HEADER "${VSGXCHANGE_BINARY_DIR}/include/vsgXchange/Version.h")

set(INSTALL_DIRECTORY "${CMAKE_BINARY_DIR}/include")

file(COPY ${VSGXCHANGE_SOURCE_DIR}/include/vsgXchange
        DESTINATION ${INSTALL_DIRECTORY} )
#message(FATAL_ERROR ${INSTALL_DIRECTORY})

file(COPY ${VSGXCHANGE_VERSION_HEADER}
        DESTINATION ${INSTALL_DIRECTORY}/vsgXchange )

vsg_add_feature_summary()
