#
# jedi_install_LAPACK
#
function ( download_build_install )
       set( lapack_URL http://www.netlib.org/lapack/lapack-3.7.0.tgz )
       set( lapack_MD5 "" )
       ExternalProject_Add( LAPACK
           DEPENDS ${deps_LAPACK}
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${lapack_URL}
           URL_HASH ${lapack_HASH}
           # Add CMAKE_INSTALL_LIBDIR to make sure it will be install under
           # lib not lib64
	   CMAKE_ARGS -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_INSTALL_LIBDIR:PATH=${JEDI_PREFIX}/lib -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER} -DCMAKE_Fortran_FLAGS=${CMAKE_Fortran_FLAGS} -DBUILD_SHARED_LIBS=ON
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )
endfunction()
