#
# jedi_install_NetCDF_Fortran
#
function ( download_build_install )
       set( netcdf_fortran_URL ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-fortran-4.4.4.tar.gz )
       set( netcdf_fortran_MD5 "" )
       ExternalProject_Add( NetCDF_Fortran
	   DEPENDS ${deps_NetCDF_Fortran}
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${netcdf_fortran_URL}
           URL_MD5 ${netcdf_fortran_MD5}
	   # Comment out due to on Apple, cmake add -fmacro_backtrace_limit to gcc, which fails the compilation.
	   # To use cmake on Apple, please use Xcode clang and clang ++
	   #CMAKE_ARGS -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_INSTALL_LIBDIR:PATH=${JEDI_PREFIX}/lib -DENABLE_DAP=ON -DENABLE_TESTS=OFF -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER} -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS} 
           CONFIGURE_COMMAND
	   <SOURCE_DIR>/configure --prefix=${JEDI_PREFIX} --libdir=${JEDI_PREFIX}/lib --includedir=${JEDI_PREFIX}/include
           CC=${JEDI_MPI_C_COMPILER}
           CFLAGS=${CFLAGS}
	   FC=${JEDI_MPI_F90_COMPILER}
	   FCFLAGS=${CMAKE_Fortran_FLAGS}
	   F77=${JEDI_MPI_F77_COMPILER}
	   FFLAGS=${CMAKE_Fortran_FLAGS}
	   CPPFLAGS=-I${JEDI_PREFIX}/include
           BUILD_COMMAND ${CMAKE_BUILD_TOOL}
           INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )
endfunction()
