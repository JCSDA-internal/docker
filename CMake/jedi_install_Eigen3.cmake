#
# jedi_install_Eigen3
#

function ( download_build_install )
       set( Eigen3_URL https://bitbucket.org/eigen/eigen/get/3.3.7.tar.gz )
       set( Eigen3_MD5 )
       ExternalProject_Add( Eigen3
           DEPENDS ${deps_Eigen3}
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${Eigen3_URL}
           CMAKE_ARGS -DEIGEN_TEST_CXX11=ON -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS} -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
           Boost_INCLUDE_DIRS=${JEDI_PREFIX}
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )
endfunction()
