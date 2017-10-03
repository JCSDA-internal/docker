#
# jedi_install_ESMF
#
function ( download_build_install )
       set( esmf_URL http://www.earthsystemmodeling.org/esmf_releases/non_public/ESMF_7_0_0/esmf_7_0_0_src.tar.gz )
       set( esmf_MD5 "")
       set( esmf_git "")
       if ( (CMAKE_CXX_COMPILER_ID STREQUAL "GNU") AND (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 5.4.0) )
          set( esmf_URL "")
          set( esmf_MD5 "")
          set( esmf_git https://git.code.sf.net/p/esmf/esmf )
       endif()

       # ESMF Compiler depend on the cmake compiler
       get_filename_component (Fortran_COMPILER_NAME ${CMAKE_Fortran_COMPILER} NAME)

       if (Fortran_COMPILER_NAME MATCHES "gfortran.*")
         # gfortran
	     set (ESMF_COMPILER "gfortran" CACHE STRING "" FORCE )
       elseif (Fortran_COMPILER_NAME MATCHES "ifort.*")
         # ifort (untested)
	     set (ESMF_COMPILER "intel" CACHE STRING "" FORCE )
       elseif (Fortran_COMPILER_NAME MATCHES "pgf90.*")
         # pgi (untested)
	     set (ESMF_COMPILER "pgi" CACHE STRING "" FORCE )
       elseif (Fortran_COMPILER_NAME MATCHES "g95")
         # g95
	     set (ESMF_COMPILER "g95" CACHE STRING "" FORCE )
       else (Fortran_COMPILER_NAME MATCHES "gfortran.*")
	     message (FATAL_ERROR "Please make correspongding changes in CMakeLists to accomodate the new compiler ")
       endif (Fortran_COMPILER_NAME MATCHES "gfortran.*")

       ExternalProject_Add( ESMF
	   DEPENDS ${deps_ESMF}
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
	   URL ${esmf_URL}
	   URL_MD5 ${esmf_MD5}
           GIT_REPOSITORY ${esmf_git}
	   CONFIGURE_COMMAND ""
	   BUILD_COMMAND ${CMAKE_COMMAND} -E env "ESMF_DIR=<SOURCE_DIR>"
	   ${CMAKE_COMMAND} -E env "ESMF_INSTALL_PREFIX=${JEDI_PREFIX}"  
	   ${CMAKE_COMMAND} -E env "ESMF_INSTALL_HEADERDIR=${JEDI_PREFIX}/include"  
	   ${CMAKE_COMMAND} -E env "ESMF_INSTALL_BINDIR=${JEDI_PREFIX}/bin"  
	   ${CMAKE_COMMAND} -E env "ESMF_INSTALL_LIBDIR=${JEDI_PREFIX}/lib"  
	   ${CMAKE_COMMAND} -E env "ESMF_INSTALL_MODIDR=${JEDI_PREFIX}/mod"  
	   ${CMAKE_COMMAND} -E env "ESMF_COMM=${MPI_IMPLEMENTATION}"
	   ${CMAKE_COMMAND} -E env "ESMF_COMPILER=${ESMF_COMPILER}" 
	   ${CMAKE_COMMAND} -E env "ESMF_LAPACK=system"
	   ${CMAKE_COMMAND} -E env "ESMF_LAPACK_LIBPATH=${JEDI_PREFIX}/lib" 
	   ${CMAKE_COMMAND} -E env "ESMF_LAPACK_LIBS=-llapack -lblas" 
	   ${CMAKE_COMMAND} -E env "ESMF_NETCDF=split" 
	   ${CMAKE_COMMAND} -E env "ESMF_NETCDF_INCLUDE=${JEDI_PREFIX}/include" 
	   ${CMAKE_COMMAND} -E env "ESMF_NETCDF_LIBPATH=${JEDI_PREFIX}/lib" 
	   ${CMAKE_COMMAND} -E env "ESMF_NETCDF_LIBS=-lnetcdff -lnetcdf" 
	   ${CMAKE_COMMAND} -E env "ESMF_PNETCDF=standard" 
	   ${CMAKE_COMMAND} -E env "ESMF_PNETCDF_INCLUDE=${JEDI_PREFIX}/include" 
	   ${CMAKE_COMMAND} -E env "ESMF_PNETCDF_LIBPATH=${JEDI_PREFIX}/lib" 
	   ${CMAKE_COMMAND} -E env "ESMF_PNETCDF_LIBS=-lpnetcdf" 
	   ${CMAKE_COMMAND} -E env "ESMF_PIO=internal" 
	   ${CMAKE_COMMAND} -E env "ESMF_XERCES=standard" 
	   ${CMAKE_COMMAND} -E env "ESMF_XERCES_INCLUDE=${JEDI_PREFIX}/include" 
	   ${CMAKE_COMMAND} -E env "ESMF_XERCES_LIBPATH=${JEDI_PREFIX}/lib" 
	   ${CMAKE_COMMAND} -E env "ESMF_XERCES_LIBS=-lxerces-c" 
	   ${CMAKE_COMMAND} -E env "ESMF_SHARED_LIB_BUILD=ON" 
	   ${CMAKE_COMMAND} -E env "ESMF_CXX=${JEDI_MPI_CXX_COMPILER}"
	   ${CMAKE_COMMAND} -E env "PATH=${JEDI_PREFIX}/bin:$ENV{PATH}"
	   ${CMAKE_BUILD_TOOL} -j${NPROC}
	   INSTALL_COMMAND ${CMAKE_COMMAND} -E env "ESMF_DIR=<SOURCE_DIR>" 
	   ${CMAKE_COMMAND} -E env "ESMF_COMM=${MPI_IMPLEMENTATION}"
	   ${CMAKE_COMMAND} -E env "ESMF_COMPILER=${ESMF_COMPILER}" 
	   ${CMAKE_COMMAND} -E env "ESMF_INSTALL_PREFIX=${JEDI_PREFIX}"  
	   ${CMAKE_COMMAND} -E env "ESMF_INSTALL_HEADERDIR=${JEDI_PREFIX}/include"  
	   ${CMAKE_COMMAND} -E env "ESMF_INSTALL_BINDIR=${JEDI_PREFIX}/bin"  
	   ${CMAKE_COMMAND} -E env "ESMF_INSTALL_LIBDIR=${JEDI_PREFIX}/lib"  
	   ${CMAKE_COMMAND} -E env "ESMF_INSTALL_MODIDR=${JEDI_PREFIX}/mod"  
	   ${CMAKE_COMMAND} -E env "ESMF_LAPACK=system"
	   ${CMAKE_COMMAND} -E env "ESMF_LAPACK_LIBPATH=${JEDI_PREFIX}/lib" 
	   ${CMAKE_COMMAND} -E env "ESMF_LAPACK_LIBS=-llapack -lblas" 
	   ${CMAKE_COMMAND} -E env "ESMF_NETCDF=split" 
	   ${CMAKE_COMMAND} -E env "ESMF_NETCDF_INCLUDE=${JEDI_PREFIX}/include" 
	   ${CMAKE_COMMAND} -E env "ESMF_NETCDF_LIBPATH=${JEDI_PREFIX}/lib" 
	   ${CMAKE_COMMAND} -E env "ESMF_NETCDF_LIBS=-lnetcdff -lnetcdf" 
	   ${CMAKE_COMMAND} -E env "ESMF_PNETCDF=standard" 
	   ${CMAKE_COMMAND} -E env "ESMF_PNETCDF_INCLUDE=${JEDI_PREFIX}/include" 
	   ${CMAKE_COMMAND} -E env "ESMF_PNETCDF_LIBPATH=${JEDI_PREFIX}/lib" 
	   ${CMAKE_COMMAND} -E env "ESMF_PNETCDF_LIBS=-lpnetcdf" 
	   ${CMAKE_COMMAND} -E env "ESMF_PIO=internal" 
	   ${CMAKE_COMMAND} -E env "ESMF_XERCES=standard" 
	   ${CMAKE_COMMAND} -E env "ESMF_XERCES_INCLUDE=${JEDI_PREFIX}/include" 
	   ${CMAKE_COMMAND} -E env "ESMF_XERCES_LIBPATH=${JEDI_PREFIX}/lib" 
	   ${CMAKE_COMMAND} -E env "ESMF_XERCES_LIBS=-lxerces-c" 
	   ${CMAKE_COMMAND} -E env "ESMF_SHARED_LIB_BUILD=ON" 
	   ${CMAKE_COMMAND} -E env "ESMF_CXX=${JEDI_MPI_CXX_COMPILER}"
	   ${CMAKE_COMMAND} -E env "PATH=${JEDI_PREFIX}/bin:$ENV{PATH}"
	   ${CMAKE_BUILD_TOOL} -d install
	   BUILD_IN_SOURCE 1
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )

endfunction()
