#
# jedi_install_PIO
#
function ( download_build_install )
       set( pio_git https://github.com/NCAR/ParallelIO.git )
       set( pio_MD5 "" )
       ExternalProject_Add( PIO
           DEPENDS ${deps_PIO}
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           GIT_REPOSITORY ${pio_git}
	   CMAKE_ARGS -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_Fortran_COMPILER=${JEDI_MPI_F90_COMPILER} -DCMAKE_C_COMPILER=${JEDI_MPI_C_COMPILER} -DNetCDF_C_PATH=${JEDI_PREFIX} -DNetCDF_Fortran_PATH=${JEDI_PREFIX} -DPnetCDF_PATH=${JEDI_PREFIX} -DHDF5_PATH=${JEDI_PREFIX}  --DPIO_USE_MALLOC=ON DPIO_ENABLE_TIMING=OFF 
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )
endfunction()
