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
	   CMAKE_ARGS -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_INSTALL_LIBDIR:PATH=${JEDI_PREFIX}/lib -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} -DENABLE_HDF4=OFF -DENABLE_DAP=ON -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )
endfunction()
