#
# jedi_install_NetCDF_CXX
#
function ( download_build_install )
       set( netcdf_cxx_URL  ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-cxx4-4.3.0.tar.gz )
       set( netcdf_cxx_MD5 "" )
       ExternalProject_Add( NetCDF_CXX
	   DEPENDS ${deps_NetCDF_CXX}
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${netcdf_cxx_URL}
           URL_MD5 ${netcdf_cxx_MD5}
           CONFIGURE_COMMAND
           <SOURCE_DIR>/configure --prefix=${JEDI_PREFIX}
           CXX=${CMAKE_CXX_COMPILER}
	   CXXFLAGS=${CMAKE_CXX_FLAGS}
           CC=${CMAKE_C_COMPILER}
           CFLAGS=${CFLAGS}
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
