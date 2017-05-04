#-----------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.1.0)

#-----------------------------------------------------------------------------
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/CMake" ${CMAKE_MODULE_PATH})
include (ExternalProject)
include (jedi_check_cmake_https)

project( jedi_common_libs C Fortran CXX )

#-----------------------------------------------------------------------------
# Set a default build type if none was specified
#-----------------------------------------------------------------------------
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to 'Release' as none was specified.")
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build." FORCE)
  mark_as_advanced(CMAKE_BUILD_TYPE)
  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Release" "Debug"
    "MinSizeRel" "RelWithDebInfo")
endif()

#-----------------------------------------------------------------------------
# Prerequisites
#-----------------------------------------------------------------------------
find_package(Git)
if(NOT GIT_FOUND)
  message(FATAL_ERROR "error: Install Git and try to re-configure")
endif()

if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    # require at least gcc 4.8.4
    if (CMAKE_CXX_COMPILER_VERSION VERSION_LESS 4.8.4)
        message(FATAL_ERROR "GCC version must be at least 4.8.4!")
    endif()
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")
    SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fPIC")
    SET(CFLAGS "${CMAKE_C_FLAGS}")
    SET(CXXFLAGS "${CMAKE_CXX_FLAGS}")
endif()

include(ProcessorCount)
ProcessorCount(NPROC)
if(NPROC GREATER 4)
  set(NPROC 4)
  message(STATUS "Using ${NPROC} threads for parallel building")
endif(NPROC GREATER 4)
#-----------------------------------------------------------------------------
option(BUILD_ALL      "Build all libs " OFF)
option(BUILD_OMPI     "Build open-mpi " OFF)
option(BUILD_ZLIB     "Build zlib "     OFF)
option(BUILD_EXPAT    "Build expat "    OFF)
option(BUILD_CURL     "Build curl "     OFF)
option(BUILD_SZIP     "Build szip "     OFF)
option(BUILD_JPEG     "Build jpeg "     OFF)
option(BUILD_PNG      "Build png "      OFF)
option(BUILD_JASPER   "Build jasper "   OFF)
option(BUILD_HDF5     "Build hdf5 "     OFF)
option(BUILD_FREETYPE "Build freetype " OFF)
option(BUILD_NETCDF   "Build netcdf "   OFF)
option(BUILD_PNETCDF  "Build pnetcdf "  OFF)
option(BUILD_LAPACK   "Build lapack "   OFF)
option(BUILD_XERCES   "Build xerces "   OFF)
option(BUILD_ESMF     "Build esmf "     OFF)
option(BUILD_UDUNITS  "Build udunits "  OFF)
option(BUILD_NCO      "Build nco "      OFF)

if (BUILD_NCO)
    message(STATUS "setting options for NCO")
    set(BUILD_SZIP "ON" CACHE STRING "Build the SZIP library" FORCE )
    set(BUILD_CURL "ON" CACHE STRING "Build the CURL library" FORCE )
    set(BUILD_HDF5 "ON" CACHE STRING "Build the HDF5 library" FORCE )
    set(BUILD_NETCDF "ON" CACHE STRING "Build the NETCDF library" FORCE )
    set(BUILD_ZLIB "ON" CACHE STRING "Build the ZLIB library" FORCE )
endif(BUILD_NCO)

if (BUILD_ESMF)
    message(STATUS "setting options for ESMF")
    set(BUILD_PNETCDF "ON" CACHE STRING "Build the PNETCDF library" FORCE )
    set(BUILD_LAPACK "ON" CACHE STRING "Build the LAPACK library" FORCE )
    set(BUILD_NETCDF "ON" CACHE STRING "Build the NETCDF library" FORCE )
    set(BUILD_XERCES "ON" CACHE STRING "Build the XERCES library" FORCE )
endif(BUILD_ESMF)

if (BUILD_NETCDF)
  message(STATUS "setting values for NETCDF")
  set(BUILD_ZLIB "ON" CACHE STRING "Build the ZLIB library" FORCE )
  set(BUILD_SZIP "ON" CACHE STRING "Build the SZIP library" FORCE )
  set(BUILD_HDF5 "ON" CACHE STRING "Build the HDF5 library" FORCE )
endif(BUILD_NETCDF)

if (BUILD_UDUNITS)
  message(STATUS "setting options for UDUNITS")
  set(BUILD_EXPAT "ON" CACHE STRING "Build the EXPAT library" FORCE )
endif(BUILD_UDUNITS)

if (BUILD_PNG)
  message(STATUS "setting options for PNG")
  set(BUILD_ZLIB "ON" CACHE STRING "Build the ZLIB library" FORCE )
endif(BUILD_PNG)

if (BUILD_FREETYPE)
  message(STATUS "setting options for FREETYPE")
  set(BUILD_ZLIB "ON" CACHE STRING "Build the ZLIB library" FORCE )
endif(BUILD_FREETYPE)

if (BUILD_PNETCDF)
  message(STATUS "setting options for PNETCDF")
  set(BUILD_OMPI "ON" CACHE STRING "Build the OMPI library" FORCE )
endif(BUILD_PNETCDF)


if(BUILD_ALL )
  message(STATUS "setting options for all libraries")
  set(BUILD_ZLIB "ON" CACHE STRING "Build the ZLIB library" FORCE )
  set(BUILD_SZIP "ON" CACHE STRING "Build the SZIP library" FORCE )
  set(BUILD_EXPAT "ON" CACHE STRING "Build the EXPAT library" FORCE )
  set(BUILD_CURL "ON" CACHE STRING "Build the CURL library" FORCE )
  set(BUILD_JPEG "ON" CACHE STRING "Build the JPEG library" FORCE )
  set(BUILD_PNG "ON" CACHE STRING "Build the PNG library" FORCE )
  set(BUILD_JASPER "ON" CACHE STRING "Build the JASPER library" FORCE )
  set(BUILD_HDF5 "ON" CACHE STRING "Build the HDF5 library" FORCE )
  set(BUILD_FREETYPE "ON" CACHE STRING "Build the FREETYPE library" FORCE )
  set(BUILD_NETCDF "ON" CACHE STRING "Build the NETCDF library" FORCE )
  set(BUILD_LAPACK "ON" CACHE STRING "Build the LAPACK library" FORCE )
  set(BUILD_PNETCDF "ON" CACHE STRING "Build the PNETCDF library" FORCE )
  set(BUILD_XERCES "ON" CACHE STRING "Build the XCERCES library" FORCE )
  set(BUILD_ESMF "ON" CACHE STRING "Build the ESMF library" FORCE )
  set(BUILD_UDUNITS "ON" CACHE STRING "Build the UDUNITS library" FORCE )
  set(BUILD_NCO "ON" CACHE STRING "Build the NCO library" FORCE )
endif(BUILD_ALL)

#-----------------------------------------------------------------------------
set(JEDI_PREFIX ${PROJECT_SOURCE_DIR})
set(JEDI_BASEDIR ${PROJECT_SOURCE_DIR})
set(JEDI_BATDIR ${PROJECT_SOURCE_DIR})

set(JEDI_BATDIR ${JEDI_BATDIR} CACHE PATH "jedi source directory" FORCE)
set(JEDI_BASEDIR ${JEDI_BASEDIR} CACHE PATH "jedi global work directory" FORCE)
set(JEDI_PREFIX ${JEDI_PREFIX} CACHE PATH "jedi prefix directory" FORCE)

SET(JEDI_DOWNLOADS_DIR ${JEDI_BASEDIR}/downloads CACHE PATH "path for downloads")

set(CMAKE_LIBRARY_PATH ${JEDI_BASEDIR}/lib ${CMAKE_LIBRARY_PATH})

set(JEDI_MODULE_PATH ${JEDI_BATDIR}/cmake/Modules)

#-----------------------------------------------------------------------------
set(CMAKE_PREFIX_PATH ${JEDI_PREFIX})
include_directories( ${JEDI_PREFIX}/include )
link_directories( ${JEDI_PREFIX}/lib )

# Determine if we have MPI package
find_package(MPI QUIET)
if (MPI_FOUND)
   set(BUILD_OMPI "OFF" CACHE STRING "Build the OMPI library" FORCE )
   set(JEDI_MPI_C_COMPILER   ${MPI_C_COMPILER})
   set(JEDI_MPI_CXX_COMPILER ${MPI_CXX_COMPILER})
   set(JEDI_MPI_F77_COMPILER ${MPI_Fortran_COMPILER})
   set(JEDI_MPI_F90_COMPILER ${MPI_Fortran_COMPILER})
else ()
   if (BUILD_PNETCDF)
      set(BUILD_OMPI "ON" CACHE STRING "Build the OMPI library" FORCE )
      message(STATUS "Not MPI_FOUND, will install in source openmpi")
   endif ()
   set(JEDI_MPI_C_COMPILER   ${JEDI_PREFIX}/bin/mpicc)
   set(JEDI_MPI_CXX_COMPILER ${JEDI_PREFIX}/bin/mpicxx)
   set(JEDI_MPI_F77_COMPILER ${JEDI_PREFIX}/bin/mpifort)
   set(JEDI_MPI_F90_COMPILER ${JEDI_PREFIX}/bin/mpifort)
   set(MPI "ompi")
   set(ESMF_COMM "openmpi")
endif ()

# Files to download

set( esmf_URL http://www.earthsystemmodeling.org/esmf_releases/non_public/ESMF_7_0_0/esmf_7_0_0_src.tar.gz )
set( esmf_MD5 "")
set( _PACKAGES ${_PACKAGES} esmf )

set( ompi_URL https://www.open-mpi.org/software/ompi/v2.1/downloads/openmpi-2.1.0.tar.gz )
set( ompi_MD5 "")
set( _PACKAGES ${_PACKAGES} ompi )

set( zlib_URL http://www.zlib.net/zlib-1.2.11.tar.gz )
set( zlib_HASH SHA256=c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1)
set( _PACKAGES ${_PACKAGES} zlib )

set( szip_URL https://support.hdfgroup.org/ftp/lib-external/szip/2.1.1/src/szip-2.1.1.tar.gz )
set( szip_MD5 "")
set( _PACKAGES ${_PACKAGES} szip )

set( libpng_URL http://sourceforge.net/projects/libpng/files/libpng14/1.4.19/libpng-1.4.19.tar.gz )
set( libpng_MD5 89bcbc4fc8b31f4a403906cf4f662330 )
set( _PACKAGES ${_PACKAGES} libpng )

set( libjpeg_URL http://www.ijg.org/files/jpegsrc.v9b.tar.gz )
set( libjpeg_MD5 6a9996ce116ec5c52b4870dbcd6d3ddb)
set( _PACKAGES ${_PACKAGES} libjpeg )

set( libjasper_URL http://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.2.tar.gz )
set( libjasper_MD5 "" )
set( _PACKAGES ${_PACKAGES} libjasper )

set( freetype_URL http://download.savannah.gnu.org/releases/freetype/freetype-2.5.5.tar.bz2 )
set( freetype_MD5 2a7a314927011d5030903179cf183be0 )
set( _PACKAGES ${_PACKAGES} freetype )

set( hdf5_URL https://support.hdfgroup.org/ftp/HDF5/current18/src/hdf5-1.8.18.tar.gz )     
set( hdf5_MD5 dd2148b740713ca0295442ec683d7b1c )
set( _PACKAGES ${_PACKAGES} hdf5 )

set( netcdf_c_URL ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-4.4.1.1.tar.gz )
set( netcdf_c_MD5 "" )
set( _PACKAGES ${_PACKAGES} netcdf_c )

set( netcdf_fortran_URL ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-fortran-4.4.4.tar.gz )
set( netcdf_fortran_MD5 "" )
set( _PACKAGES ${_PACKAGES} netcdf_fortran )

set( pnetcdf_URL http://cucis.ece.northwestern.edu/projects/PnetCDF/Release/parallel-netcdf-1.8.1.tar.gz )
set( pnetcdf_MD5 "" )
set( _PACKAGES ${_PACKAGES} pnetcdf )

set( lapack_URL http://www.netlib.org/lapack/lapack-3.7.0.tgz )
set( lapack_MD5 "" )
set( _PACKAGES ${_PACKAGES} lapack )

set( xerces_URL http://apache.mirrors.lucidnetworks.net//xerces/c/3/sources/xerces-c-3.1.4.tar.gz )
set( xerces_MD5 "21bb097b711a513275379b59757cba4c" )
set( _PACKAGES ${_PACKAGES} xerces )

set( udunits_URL ftp://ftp.unidata.ucar.edu/pub/udunits/udunits-2.2.24.tar.gz )
set( udunits_MD5 "")
set( _PACKAGES ${_PACKAGES} udunits )

set( nco_URL https://github.com/nco/nco/archive/4.6.6.tar.gz )
set( nco_MD5 "df6fa47aaf6e41adfc0631912a7a341f")
set( _PACKAGES ${_PACKAGES} nco )

set( curl_URL https://curl.haxx.se/download/curl-7.54.0.tar.gz )
set( curl_MD5 "")
set( _PACKAGES ${_PACKAGES} curl )

set( expat_URL https://github.com/libexpat/libexpat.git )
set( expat_MD5 "")
set( _PACKAGES ${_PACKAGES} expat )

slicer_check_cmake_https()

# If in fetch mode, only download and set a "fetch-only" indicator
if ( FETCH_ONLY )
    foreach( pkg ${_PACKAGES} )
    message( STATUS "Downloading ${pkg}" )
        get_filename_component( fn ${${pkg}_URL} NAME )
	file( DOWNLOAD ${${pkg}_URL} ${JEDI_DOWNLOADS_DIR}/${fn} EXPECTED_MD5 ${${pkg}_MD5} SHOW_PROGRESS )
    endforeach(pkg)

    file( WRITE ${PROJECT_BINARY_DIR}/fetch-only "" )

ELSE ( FETCH_ONLY )

    if (BUILD_LAPACK)
       ExternalProject_Add( lapack
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
    endif (BUILD_LAPACK)

    if (BUILD_SZIP)
       ExternalProject_Add( szip
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${szip_URL}
	   URL_HASH ${szip_MD5}
	   CMAKE_ARGS -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DSZIP_ENABLE_ENCODING=ON -DBUILD_SHARED_LIBS=ON -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )

       ExternalProject_Add_Step(
	   szip rename
	   COMMAND ${CMAKE_COMMAND} -E copy ${JEDI_PREFIX}/lib/libszip.a ${JEDI_PREFIX}/lib/libsz.a
	   COMMAND ${CMAKE_COMMAND} -E copy ${JEDI_PREFIX}/lib/libszip.so ${JEDI_PREFIX}/lib/libsz.so
	   COMMENT "Some lib seeks sz , other than szip"
	   DEPENDEES install
	   )
    endif (BUILD_SZIP)

    if (BUILD_ZLIB)
       ExternalProject_Add( zlib
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${zlib_URL}
           URL_HASH ${zlib_HASH}
	   CMAKE_ARGS -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )
    endif (BUILD_ZLIB)

    if (BUILD_PNG)
       ExternalProject_Add( libpng
           DEPENDS zlib
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${libpng_URL}
           URL_MD5 ${libpng_MD5}
	   CMAKE_ARGS -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )
    endif (BUILD_PNG)

    if (BUILD_CURL)
       ExternalProject_Add( curl
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${curl_URL}
           URL_MD5 ${curl_MD5}
           CONFIGURE_COMMAND
           <SOURCE_DIR>/configure --prefix=${JEDI_PREFIX}
           CC=${CMAKE_C_COMPILER}
           CXX=${CMAKE_CXX_COMPILER}
           CFLAGS=${CFLAGS}
           CXXFLAGS=${CXXFLAGS}
           BUILD_COMMAND ${CMAKE_BUILD_TOOL}
           INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )

    endif (BUILD_CURL)

    if (BUILD_OMPI)
       ExternalProject_Add( ompi
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${ompi_URL}
           URL_MD5 ${ompi_MD5}
           CONFIGURE_COMMAND
           <SOURCE_DIR>/configure --prefix=${JEDI_PREFIX} --enable-mpi-cxx
           CC=${CMAKE_C_COMPILER}
           CXX=${CMAKE_CXX_COMPILER}
           CFLAGS=${CFLAGS}
           CXXFLAGS=${CXXFLAGS}
	   FC=${CMAKE_Fortran_COMPILER}
           BUILD_COMMAND ${CMAKE_BUILD_TOOL} -j ${NPROC} all
           INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )

       ExternalProject_Add_Step(
	   ompi touchConfigs
	   COMMAND ${CMAKE_COMMAND} -E touch <SOURCE_DIR>/configure <SOURCE_DIR>/aclocal.m4 <SOURCE_DIR>/Makefile.am <SOURCE_DIR>/Makefile.in  <SOURCE_DIR>/ompi/mca/io/romio314/romio/configure <SOURCE_DIR>/ompi/mca/io/romio314/romio/aclocal.m4 <SOURCE_DIR>/ompi/mca/io/romio314/romio/Makefile.am <SOURCE_DIR>/ompi/mca/io/romio314/romio/Makefile.in <SOURCE_DIR>/opal/mca/event/libevent2022/libevent/configure <SOURCE_DIR>/opal/mca/event/libevent2022/libevent/aclocal.m4 <SOURCE_DIR>/opal/mca/event/libevent2022/libevent/Makefile.am <SOURCE_DIR>/opal/mca/event/libevent2022/libevent/Makefile.in <SOURCE_DIR>/opal/mca/pmix/pmix112/pmix/configure <SOURCE_DIR>/opal/mca/pmix/pmix112/pmix/aclocal.m4 <SOURCE_DIR>/opal/mca/pmix/pmix112/pmix/Makefile.am <SOURCE_DIR>/opal/mca/pmix/pmix112/pmix/Makefile.in
	   COMMENT "Updating the timestamp of configure aclocal.m4 Makefile.am Makefile.in to avoid errors on some platforms"
	   DEPENDEES configure
	   DEPENDERS build
	   )
    endif (BUILD_OMPI)

    if (BUILD_JPEG)
       ExternalProject_Add( libjpeg
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${libjpeg_URL}
           URL_MD5 ${libjpeg_MD5}
           CONFIGURE_COMMAND
           <SOURCE_DIR>/configure --prefix=${JEDI_PREFIX} --enable-shared=yes
           CC=${CMAKE_C_COMPILER}
           CXX=${CMAKE_CXX_COMPILER}
           CFLAGS=${CFLAGS}
           CXXFLAGS=${CXXFLAGS}
	   FC=${CMAKE_Fortran_COMPILER}
           BUILD_COMMAND ${CMAKE_BUILD_TOOL}
           INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )
    endif (BUILD_JPEG)

    if (BUILD_FREETYPE)
       ExternalProject_Add( freetype
           DEPENDS zlib
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${freetype_URL}
           URL_MD5 ${freetype_MD5}
	   CMAKE_ARGS -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS} -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )
    endif (BUILD_FREETYPE)

    if (BUILD_JASPER)
       ExternalProject_Add( jasper
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${libjasper_URL}
           URL_MD5 ${libjasper_MD5}
           CONFIGURE_COMMAND
	   <SOURCE_DIR>/configure --prefix=${JEDI_PREFIX} 
           CC=${CMAKE_C_COMPILER}
           CXX=${CMAKE_CXX_COMPILER}
           CFLAGS=${CFLAGS}
           CXXFLAGS=${CXXFLAGS}
	   FC=${CMAKE_Fortran_COMPILER}
           BUILD_COMMAND ${CMAKE_BUILD_TOOL}
           INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )
    endif (BUILD_JASPER)

    if (BUILD_EXPAT)
       ExternalProject_Add( expat
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           GIT_REPOSITORY ${expat_URL}
           UPDATE_COMMAND ""
	   CMAKE_ARGS -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS} -DBUILD_doc=OFF 
	   BUILD_IN_SOURCE 1
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )

       ExternalProject_Add_Step(
	   expat copyExat
	   COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/expat <SOURCE_DIR>
	   COMMENT "Copy the CMakeList.txt directory to SOURCE_DIR"
	   DEPENDEES download
	   )
    endif (BUILD_EXPAT)

    if (BUILD_UDUNITS)
       ExternalProject_Add( udunits
           DEPENDS expat
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${udunits_URL}
           URL_MD5 ${udunits_MD5}
	   CMAKE_ARGS -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )
    endif (BUILD_UDUNITS)

    if (BUILD_HDF5)
       ExternalProject_Add( hdf5
           DEPENDS zlib szip
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${hdf5_URL}
           URL_MD5 ${hdf5_MD5}
	   CMAKE_ARGS -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} -DHDF5_BUILD_FORTRAN=ON  -DHDF5_ENABLE_F2003:BOOL=ON -DHDF5_ENABLE_Z_LIB_SUPPORT:BOOL=ON -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER} -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS} -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS} -DHDF5_BUILD_CPP_LIB:BOOL=ON -DHDF5_ENABLE_SZIP_SUPPORT=BOLL=ON -DHDF5_ENABLE_SZIP_ENCODING:BOOL=ON -DSZIP_DIR=${JEDI_PREFIX}/share/cmake -DHDF5_ENABLE_SZIP_SUPPORT=ON
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )
    endif (BUILD_HDF5)

    if (BUILD_NETCDF)
       ExternalProject_Add( netcdf_c
	   DEPENDS hdf5
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${netcdf_c_URL}
           URL_MD5 ${netcdf_c_MD5}
	   CMAKE_ARGS -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_INSTALL_LIBDIR:PATH=${JEDI_PREFIX}/lib -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} -DENABLE_HDF4=OFF -DENABLE_DAP=OFF -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )

       ExternalProject_Add( netcdf_fortran
	   DEPENDS netcdf_c
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${netcdf_fortran_URL}
           URL_MD5 ${netcdf_fortran_MD5}
	   # Comment out due due to on Apple, cmake add -fmacro_backtrace_limit to gcc, which fails the compilation.
	   # To use cmake on Apple, please use Xcode clang and clang ++
	   #CMAKE_ARGS -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_INSTALL_LIBDIR:PATH=${JEDI_PREFIX}/lib -DENABLE_DAP=OFF -DENABLE_TESTS=OFF -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER} -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS} -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
           CONFIGURE_COMMAND
	   <SOURCE_DIR>/configure --prefix=${JEDI_PREFIX} --libdir=${JEDI_PREFIX}/lib --includedir=${JEDI_PREFIX}/include
           CC=${CMAKE_C_COMPILER}
           CXX=${CMAKE_CXX_COMPILER}
           CFLAGS=${CFLAGS}
           CXXFLAGS=${CXXFLAGS}
	   FC=${CMAKE_Fortran_COMPILER}
	   CPPFLAGS=-I${JEDI_PREFIX}/include
           BUILD_COMMAND ${CMAKE_BUILD_TOOL}
           INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )
    endif (BUILD_NETCDF)

    if (BUILD_NCO)
       ExternalProject_Add( nco
           DEPENDS zlib curl szip netcdf_c netcdf_fortran hdf5
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${nco_URL}
           URL_MD5 ${nco_MD5}
	   CMAKE_ARGS -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}
           INSTALL_COMMAND ""
	   BUILD_IN_SOURCE 1
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )

       ExternalProject_Add_Step(
	   nco copyExe
	   COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/ncbo ${JEDI_PREFIX}/bin/ncbo
	   COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/ncecat ${JEDI_PREFIX}/bin/ncecat
	   COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/ncflint ${JEDI_PREFIX}/bin/ncflint
	   COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/ncks ${JEDI_PREFIX}/bin/ncks
	   COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/ncpdq ${JEDI_PREFIX}/bin/ncpdq
	   COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/ncra ${JEDI_PREFIX}/bin/ncra
	   COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/ncrename ${JEDI_PREFIX}/bin/ncrename
	   COMMENT "nco install, copy executables to the bin"
	   DEPENDEES install
	   )
    endif (BUILD_NCO)

    if (BUILD_PNETCDF)

       ExternalProject_Add( pnetcdf
	   DEPENDS ${MPI}
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${pnetcdf_URL}
           URL_MD5 ${pnetcdf_MD5}
           CONFIGURE_COMMAND
	   <SOURCE_DIR>/configure --prefix=${JEDI_PREFIX}
           CC=${CMAKE_C_COMPILER}
           CFLAGS=${CFLAGS}
           CXXFLAGS=${CXXFLAGS}
	   MPICC=${PNETCDF_MPI_C_COMPILER}
           CXX=${CMAKE_CXX_COMPILER}
	   MPICXX=${PNETCDF_MPI_CXX_COMPILER}
	   FC=${CMAKE_Fortran_COMPILER}
	   MPIF77=${PNETCDF_MPI_F77_COMPILER}
	   F90=${CMAKE_Fortran_COMPILER}
	   MPIF90=${PNETCDF_MPI_F90_COMPILER}
           BUILD_COMMAND ${CMAKE_BUILD_TOOL} -j${NPROC}
           INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install
	   BUILD_IN_SOURCE 1
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )

       ExternalProject_Add_Step(
	   pnetcdf touchConfigs
	   COMMAND ${CMAKE_COMMAND} -E touch <SOURCE_DIR>/src/utils/ncmpigen/ncmpigenyy.c <SOURCE_DIR>/src/utils/ncmpigen/ncmpigentab.h <SOURCE_DIR>/src/utils/ncmpigen/ncmpigentab.c
	   COMMENT "Updating the timestamp of ncmpigenyy.c ncmpigentab.h to avoid errors on some platforms"
	   DEPENDEES configure
	   DEPENDERS build
	   )

       ExternalProject_Add_Step(
	   pnetcdf makeSharedLib
	   COMMAND ${CMAKE_COMMAND} -E copy ${JEDI_PREFIX}/lib/libpnetcdf.a ${JEDI_PREFIX}/lib/libpnetcdf.so
	   COMMENT "Pnetcdf is hardcoded static library, copy libpnetcdf.a to libpnetcdf.so"
	   DEPENDEES install
	   )

    endif (BUILD_PNETCDF)

    if (BUILD_XERCES)
       ExternalProject_Add( xerces
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${xerces_URL}
           URL_MD5 ${xerces_MD5}
           CONFIGURE_COMMAND
	   <SOURCE_DIR>/configure --prefix=${JEDI_PREFIX} --without-curl --without-icu
           CC=${CMAKE_C_COMPILER}
           CXX=${CMAKE_CXX_COMPILER}
           CFLAGS=${CFLAGS}
           CXXFLAGS=${CXXFLAGS}
           BUILD_COMMAND ${CMAKE_BUILD_TOOL}
           INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )
    endif (BUILD_XERCES)

    if (BUILD_ESMF)
       # ESMF Compiler depend on the cmake compiler
       get_filename_component (Fortran_COMPILER_NAME ${CMAKE_Fortran_COMPILER} NAME)

       if (Fortran_COMPILER_NAME MATCHES "gfortran.*")
         # gfortran
	 set (ESMF_COMPILER "gfortran" CACHE STRING "" FORCE )
       elseif (Fortran_COMPILER_NAME MATCHES "ifort.*")
         # ifort (untested)
	 set (ESMF_COMPILER "intel" CACHE STRING "" FORCE )
       elseif (Fortran_COMPILER_NAME MATCHES "g95")
         # g95
	 set (ESMF_COMPILER "g95" CACHE STRING "" FORCE )
       else (Fortran_COMPILER_NAME MATCHES "gfortran.*")
	 message (FATAL_ERROR "Please make correspongding changes in CMakeLists to accomodate the new compiler ")
       endif (Fortran_COMPILER_NAME MATCHES "gfortran.*")

       ExternalProject_Add( esmf
	   DEPENDS pnetcdf xerces netcdf_c netcdf_fortran lapack
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
	   URL ${esmf_URL}
	   URL_MD5 ${esmf_MD5}
	   CONFIGURE_COMMAND ""
	   BUILD_COMMAND ${CMAKE_COMMAND} -E env "ESMF_DIR=<SOURCE_DIR>"
	   ${CMAKE_COMMAND} -E env "ESMF_INSTALL_PREFIX=${JEDI_PREFIX}"  
	   ${CMAKE_COMMAND} -E env "ESMF_COMM=${MPI_IMPLEMENTATION}"
	   ${CMAKE_COMMAND} -E env "ESMF_COMPILER=${ESMF_COMPILER}" 
	   ${CMAKE_COMMAND} -E env "ESMF_LAPACK=system"
	   ${CMAKE_COMMAND} -E env "ESMF_LAPACK_LIBPATH=${JEDI_PREFIX}/lib" 
	   ${CMAKE_COMMAND} -E env "ESMF_LAPACK_LIBS=-llapack -lblas" 
	   ${CMAKE_COMMAND} -E env "ESMF_NETCDF=split" 
	   ${CMAKE_COMMAND} -E env "ESMF_NETCDF_INCLUDE=${JEDI_PREFIX}/include" 
	   ${CMAKE_COMMAND} -E env "ESMF_NETCDF_LIBPATH=${JEDI_PREFIX}/lib" 
	   ${CMAKE_COMMAND} -E env "ESMF_NETCDF_LIBS=-lnetcdff -lnetcdf" 
	   #${CMAKE_COMMAND} -E env "ESMF_PNETCDF=standard" 
	   #${CMAKE_COMMAND} -E env "ESMF_PNETCDF_INCLUDE=${JEDI_PREFIX}/include" 
	   #${CMAKE_COMMAND} -E env "ESMF_PNETCDF_LIBPATH=${JEDI_PREFIX}/lib" 
	   #${CMAKE_COMMAND} -E env "ESMF_PNETCDF_LIBS=-lpnetcdf" 
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
	   ${CMAKE_COMMAND} -E env "ESMF_LAPACK=system"
	   ${CMAKE_COMMAND} -E env "ESMF_LAPACK_LIBPATH=${JEDI_PREFIX}/lib" 
	   ${CMAKE_COMMAND} -E env "ESMF_LAPACK_LIBS=-llapack -lblas" 
	   ${CMAKE_COMMAND} -E env "ESMF_NETCDF=split" 
	   ${CMAKE_COMMAND} -E env "ESMF_NETCDF_INCLUDE=${JEDI_PREFIX}/include" 
	   ${CMAKE_COMMAND} -E env "ESMF_NETCDF_LIBPATH=${JEDI_PREFIX}/lib" 
	   ${CMAKE_COMMAND} -E env "ESMF_NETCDF_LIBS=-lnetcdff -lnetcdf" 
	   #${CMAKE_COMMAND} -E env "ESMF_PNETCDF=standard" 
	   #${CMAKE_COMMAND} -E env "ESMF_PNETCDF_INCLUDE=${JEDI_PREFIX}/include" 
	   #${CMAKE_COMMAND} -E env "ESMF_PNETCDF_LIBPATH=${JEDI_PREFIX}/lib" 
	   #${CMAKE_COMMAND} -E env "ESMF_PNETCDF_LIBS=-lpnetcdf" 
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

    endif (BUILD_ESMF)


ENDIF( FETCH_ONLY )
