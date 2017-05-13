#
# jedi_install_HDF5
#

function ( download_build_install )
       set( hdf5_URL https://support.hdfgroup.org/ftp/HDF5/current18/src/hdf5-1.8.18.tar.gz )     
       set( hdf5_MD5 dd2148b740713ca0295442ec683d7b1c )
       ExternalProject_Add( HDF5
           DEPENDS ${deps_HDF5}
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${hdf5_URL}
           URL_MD5 ${hdf5_MD5}
           CMAKE_ARGS -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} -DHDF5_BUILD_FORTRAN=ON  -DHDF5_ENABLE_F2003:BOOL=ON -DHDF5_ENABLE_Z_LIB_SUPPORT:BOOL=ON -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER} -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS} -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS} -DHDF5_BUILD_CPP_LIB:BOOL=ON -DHDF5_ENABLE_SZIP_SUPPORT=BOLL=ON -DHDF5_ENABLE_SZIP_ENCODING:BOOL=ON -DSZIP_DIR=${JEDI_PREFIX}/share/cmake -DCMAKE_Fortran_FLAGS=${CMAKE_Fortran_FLAGS}
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )
endfunction()