#
# jedi_install_HDF5
#

function ( download_build_install )
       set( hdf5_URL https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8.17/src/hdf5-1.8.17.tar.gz )
       set( hdf5_MD5 7d572f8f3b798a628b8245af0391a0ca )
       ExternalProject_Add( HDF5
           DEPENDS ${deps_HDF5}
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${hdf5_URL}
           URL_MD5 ${hdf5_MD5}
           #Cmake has problem to generate h5fc etc. unsolved
           #CMAKE_ARGS -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} -DHDF5_BUILD_FORTRAN=ON  -DHDF5_ENABLE_F2003:BOOL=ON -DHDF5_ENABLE_Z_LIB_SUPPORT:BOOL=ON -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER} -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS} -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS} -DHDF5_BUILD_CPP_LIB:BOOL=ON -DHDF5_ENABLE_SZIP_SUPPORT=BOLL=ON -DHDF5_ENABLE_SZIP_ENCODING:BOOL=ON -DSZIP_DIR=${JEDI_PREFIX}/share/cmake -DCMAKE_Fortran_FLAGS=${CMAKE_Fortran_FLAGS}
           CONFIGURE_COMMAND
           <SOURCE_DIR>/configure --prefix=${JEDI_PREFIX} --enable-fortran --enable-fortran2003 --enable-cxx --with-zlib=${JEDI_PREFIX} --with-szlib=${JEDI_PREFIX}
           CC=${CMAKE_C_COMPILER}
           CXX=${CMAKE_CXX_COMPILER}
           CFLAGS=${CFLAGS}
           CXXFLAGS=${CXXFLAGS}
           FC=${CMAKE_Fortran_COMPILER}
           FCFLAGS=${CMAKE_Fortran_FLAGS}
           BUILD_COMMAND ${CMAKE_BUILD_TOOL}
           INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )
endfunction()
