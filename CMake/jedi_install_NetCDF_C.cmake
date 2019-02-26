#
# jedi_install_NetCDF_C
#
function ( download_build_install )
       set( netcdf_c_URL ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-4.4.1.1.tar.gz )
       set( netcdf_c_MD5 "" )
       ExternalProject_Add( NetCDF_C
	   DEPENDS ${deps_NetCDF_C}
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${netcdf_c_URL}
           URL_MD5 ${netcdf_c_MD5}
	   #CMAKE_ARGS -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} -DENABLE_HDF4=OFF -DENABLE_DAP=ON -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}
           CONFIGURE_COMMAND
           <SOURCE_DIR>/configure --enable-pnetcdf --enable-netcdf-4 --prefix=${JEDI_PREFIX}
           CC=${CMAKE_C_COMPILER}
           CFLAGS=${CFLAGS}
           FC=${CMAKE_Fortran_COMPILER}
           FCFLAGS=${CMAKE_Fortran_FLAGS}
           F77=${CMAKE_Fortran_COMPILER}
           FFLAGS=${CMAKE_Fortran_FLAGS}
           CPPFLAGS=-I${JEDI_PREFIX}/include
           LDFLAGS=-L${JEDI_PREFIX}/lib
           BUILD_COMMAND ${CMAKE_BUILD_TOOL}
           INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )
endfunction()
