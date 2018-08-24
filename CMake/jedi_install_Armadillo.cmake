#
# jedi_install_Armadillo
#

function ( download_build_install )
       set( Armadillo_URL http://sourceforge.net/projects/arma/files/armadillo-9.100.5.tar.xz )
       set( Armadillo_MD5 )
       ExternalProject_Add( Armadillo
           DEPENDS ${deps_Armadillo}
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${Armadillo_URL}
           CMAKE_ARGS -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS} -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
           Boost_INCLUDE_DIRS=${JEDI_PREFIX}
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )
endfunction()
