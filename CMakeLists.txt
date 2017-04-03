project( jedi_common_libs C Fortran CXX )

# TODO Missing dependencies:
# - Firebird
# - Pango (needs glib)
# - Replace jpeg with jpeg-turbo

cmake_minimum_required(VERSION 2.8)

include (ExternalProject)

# make sure that the default is a RELEASE
if (NOT CMAKE_BUILD_TYPE)
   set (CMAKE_BUILD_TYPE RELEASE CACHE STRING
       "Choose the type of build, options are: None Debug Release."
       FORCE)
endif (NOT CMAKE_BUILD_TYPE)

option(BUILD_ZLIB "Build zlib " ON)
option(BUILD_JPEG "Build jpeg " ON)
option(BUILD_PNG "Build png " ON)
option(BUILD_JASPER "Build jasper " ON)
option(BUILD_HDF5 "Build hdf5 " ON)
option(BUILD_FREETYPE "Build freetype " ON)
option(BUILD_NETCDF "Build netcdf " ON)
option(BUILD_LAPACK "Build lapack " ON)

# This variable is set in the bootstrapping script (jedi/jedi.bat)
set(JEDI_PREFIX ${PROJECT_SOURCE_DIR})
set(JEDI_BASEDIR ${PROJECT_SOURCE_DIR})
set(JEDI_BATDIR ${PROJECT_SOURCE_DIR})

set(JEDI_BATDIR ${JEDI_BATDIR} CACHE PATH "jedi source directory" FORCE)
set(JEDI_BASEDIR ${JEDI_BASEDIR} CACHE PATH "jedi global work directory" FORCE)
set(JEDI_PREFIX ${JEDI_PREFIX} CACHE PATH "jedi prefix directory" FORCE)

SET(JEDI_DOWNLOADS_DIR ${JEDI_BASEDIR}/downloads CACHE PATH "path for downloads")

set(CMAKE_INSTALL_PREFIX "${JEDI_BASEDIR}/build/installation" CACHE PATH "Installation prefix, required for CPack due to absolute paths" FORCE)

#our version of FindXXX.cmake
set(JEDI_MODULE_PATH ${JEDI_BATDIR}/cmake/Modules)

# Make sure we use bootstrapped dependencies
set(CMAKE_PREFIX_PATH ${JEDI_PREFIX} )

# Files to download

set( zlib_URL http://www.zlib.net/zlib-1.2.11.tar.gz )
set( zlib_HASH SHA256=c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1)
set( _PACKAGES ${_PACKAGES} zlib )

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

set( lapack_URL http://www.netlib.org/lapack/lapack-3.7.0.tgz )
set( lapack_MD5 "" )
set( _PACKAGES ${_PACKAGES} lapack )

# If in fetch mode, only download and set a "fetch-only" indicator
if ( FETCH_ONLY )
    foreach( pkg ${_PACKAGES} )
    message( STATUS "Downloading ${pkg}" )
        get_filename_component( fn ${${pkg}_URL} NAME )
	file( DOWNLOAD ${${pkg}_URL} ${JEDI_DOWNLOADS_DIR}/${fn} EXPECTED_MD5 ${${pkg}_MD5} SHOW_PROGRESS )
    endforeach(pkg)

    file( WRITE ${PROJECT_BINARY_DIR}/fetch-only "" )

ELSE ( FETCH_ONLY )

    # Make sure autotools-based 3rd-parties use the bootstrapped libraries
    file( WRITE ${JEDI_PREFIX}/share/config.site "CPPFLAGS='-I${JEDI_PREFIX}/include'\nLDFLAGS='-L${JEDI_PREFIX}/lib'\n" )
    file(MAKE_DIRECTORY ${JEDI_PREFIX}/licenses/zlib)

    if (BUILD_LAPACK)
       ExternalProject_Add( lapack
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${lapack_URL}
           URL_HASH ${lapack_HASH}
           LIST_SEPARATOR ^^
           CMAKE_ARGS -DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} 
           LOG_DOWNLOAD 1
           LOG_UPDATE 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_TEST 1
           LOG_INSTALL 1
           )
    endif (BUILD_LAPACK)

    if (BUILD_ZLIB)
       ExternalProject_Add( zlib
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${zlib_URL}
           URL_HASH ${zlib_HASH}
           CONFIGURE_COMMAND
           <SOURCE_DIR>/configure --prefix=${JEDI_PREFIX} 
           BUILD_COMMAND ${CMAKE_BUILD_TOOL}
           INSTALL_COMMAND ${CMAKE_BUILD_TOOL} check install
           LOG_DOWNLOAD 1
           LOG_UPDATE 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_TEST 1
           LOG_INSTALL 1
           )
    endif (BUILD_ZLIB)

    if (BUILD_PNG)
       file(MAKE_DIRECTORY ${JEDI_PREFIX}/licenses/libpng)
       ExternalProject_Add( libpng
           DEPENDS zlib
           SOURCE_DIR ${CMAKE_BINARY_DIR}/libpng-src
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${libpng_URL}
           URL_MD5 ${libpng_MD5}
           CONFIGURE_COMMAND 
            <SOURCE_DIR>/configure --prefix=${JEDI_PREFIX}
           BUILD_COMMAND ${CMAKE_BUILD_TOOL} test
           INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install
           LOG_DOWNLOAD 1
           LOG_UPDATE 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_TEST 1
           LOG_INSTALL 1
           )
    endif (BUILD_PNG)

    if (BUILD_JPEG)
       file(MAKE_DIRECTORY ${JEDI_PREFIX}/licenses/libjpeg)
       ExternalProject_Add( libjpeg
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${libjpeg_URL}
           URL_MD5 ${libjpeg_MD5}
           CONFIGURE_COMMAND
           <SOURCE_DIR>/configure --prefix=${JEDI_PREFIX} --enable-shared=yes
           BUILD_COMMAND ${CMAKE_BUILD_TOOL}
           INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install
           LOG_DOWNLOAD 1
           LOG_UPDATE 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_TEST 1
           LOG_INSTALL 1
           )
    endif (BUILD_JPEG)

    if (BUILD_FREETYPE)
       file(MAKE_DIRECTORY ${JEDI_PREFIX}/licenses/freetype)
       ExternalProject_Add( freetype
           DEPENDS zlib libpng 
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${freetype_URL}
           URL_MD5 ${freetype_MD5}
           LIST_SEPARATOR ^^
           CMAKE_ARGS -DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_PREFIX_PATH:PATH=${JEDI_PREFIX}
           TEST_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/docs/LICENSE.TXT ${JEDI_PREFIX}/licenses/freetype/
           LOG_DOWNLOAD 1
           LOG_UPDATE 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_TEST 1
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
           BUILD_COMMAND ${CMAKE_BUILD_TOOL}
           INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install
           LOG_DOWNLOAD 1
           LOG_UPDATE 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_TEST 1
           LOG_INSTALL 1
           )
    endif (BUILD_JASPER)

    if (BUILD_HDF5)
       ExternalProject_Add( hdf5
           DEPENDS zlib
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${hdf5_URL}
           URL_MD5 ${hdf5_MD5}
           CONFIGURE_COMMAND
           <SOURCE_DIR>/configure --prefix=${JEDI_PREFIX} --with-zlib=${JEDI_PREFIX} --enable-fortran --enable-fortran2003
           BUILD_COMMAND ${CMAKE_BUILD_TOOL} 
           INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install
           LOG_DOWNLOAD 1
           LOG_UPDATE 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_TEST 1
           LOG_INSTALL 1
           )
    endif (BUILD_HDF5)

    if (BUILD_NETCDF)
       ExternalProject_Add( netcdf_c
           DEPENDS hdf5
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${netcdf_c_URL}
           URL_MD5 ${netcdf_c_MD5}
           BUILD_COMMAND   ${CMAKE_BUILD_TOOL} 
           INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install 
           CONFIGURE_COMMAND 
           <SOURCE_DIR>/configure --prefix=${JEDI_PREFIX} --libdir=${JEDI_PREFIX}/lib --with-pic --disable-hdf4 --disable-dap  
           LOG_DOWNLOAD 1
           LOG_UPDATE 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_TEST 1
           LOG_INSTALL 1
           )

       ExternalProject_Add( netcdf_fortran
           DEPENDS netcdf_c
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${netcdf_fortran_URL}
           URL_MD5 ${netcdf_fortran_MD5}
           BUILD_COMMAND   ${CMAKE_BUILD_TOOL} 
           INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install 
           CONFIGURE_COMMAND 
           <SOURCE_DIR>/configure --prefix=${JEDI_PREFIX} --libdir=${JEDI_PREFIX}/lib --with-pic 
           LOG_DOWNLOAD 1
           LOG_UPDATE 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_TEST 1
           LOG_INSTALL 1
           )
    endif (BUILD_NETCDF)

    set( _OLDPATH $ENV{PATH} )
    set( _NEWPATH ${JEDI_PREFIX}\\bin ${_OLDPATH} )
    set( ENV{PATH} "${_NEWPATH}" )

# INSTALLATION


   INSTALL(DIRECTORY "${JEDI_PREFIX}/licenses" DESTINATION "." COMPONENT binaries)
   #INSTALL(DIRECTORY "${JEDI_PREFIX}/docs-to-install/" DESTINATION "doc" COMPONENT documentation)


   FILE(GLOB bzip2_libs "${JEDI_PREFIX}/lib/libbz2*")
   INSTALL(FILES ${bzip2_libs} DESTINATION "lib" COMPONENT binaries)

   FILE(GLOB zlib_libs "${JEDI_PREFIX}/lib/libz*")
   INSTALL(FILES ${zlib_libs} DESTINATION "lib" COMPONENT binaries)

   FILE(GLOB jpeg_libs "${JEDI_PREFIX}/lib/libjpeg*")
   INSTALL(FILES ${jpeg_libs} DESTINATION "lib" COMPONENT binaries)

ENDIF( FETCH_ONLY )
