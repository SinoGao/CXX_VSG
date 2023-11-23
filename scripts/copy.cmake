#copy assimp
file(COPY ${CMAKE_SOURCE_DIR}/scripts/assimp/CMakeLists.txt
        DESTINATION ${CMAKE_SOURCE_DIR}/vsg-dev/CXX_assimp/assimp )

file(COPY ${CMAKE_SOURCE_DIR}/scripts/assimp/code/CMakeLists.txt
        DESTINATION ${CMAKE_SOURCE_DIR}/vsg-dev/CXX_assimp/assimp/code )