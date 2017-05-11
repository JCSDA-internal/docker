#
# jedi_install_PNETCDF
#
function ( download_build_install )
       set( pnetcdf_URL http://cucis.ece.northwestern.edu/projects/PnetCDF/Release/parallel-netcdf-1.8.1.tar.gz )
       set( pnetcdf_MD5 "" )
       ExternalProject_Add( PNETCDF
	   DEPENDS ${deps_Pnetcdf}
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${pnetcdf_URL}
           URL_MD5 ${pnetcdf_MD5}
           CONFIGURE_COMMAND
	   <SOURCE_DIR>/configure --prefix=${JEDI_PREFIX}
           CFLAGS=${CFLAGS}
           CXXFLAGS=${CXXFLAGS}
           FFLAGS=${CMAKE_Fortran_FLAGS}
           FCFLAGS=${CMAKE_Fortran_FLAGS}
	   MPICC=${JEDI_MPI_C_COMPILER}
	   MPICXX=${JEDI_MPI_CXX_COMPILER}
	   MPIF77=${JEDI_MPI_F77_COMPILER}
	   MPIF90=${JEDI_MPI_F90_COMPILER}
           BUILD_COMMAND ${CMAKE_BUILD_TOOL} -j${NPROC}
           INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install
	   BUILD_IN_SOURCE 1
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )

       ExternalProject_Add_Step(
	   PNETCDF touchConfigs
	   COMMAND ${CMAKE_COMMAND} -E touch <SOURCE_DIR>/src/utils/ncmpigen/ncmpigenyy.c <SOURCE_DIR>/src/utils/ncmpigen/ncmpigentab.h <SOURCE_DIR>/src/utils/ncmpigen/ncmpigentab.c
	   COMMENT "Updating the timestamp of ncmpigenyy.c ncmpigentab.h to avoid errors on some platforms"
	   DEPENDEES configure
	   DEPENDERS build
	   )

       ExternalProject_Add_Step(
	   PNETCDF makeSharedLib
	   COMMAND ${CMAKE_COMMAND} -E copy ${JEDI_PREFIX}/lib/libpnetcdf.a ${JEDI_PREFIX}/lib/libpnetcdf.so
	   COMMENT "Pnetcdf is hardcoded static library, copy libpnetcdf.a to libpnetcdf.so"
	   DEPENDEES install
	   )
endfunction()
