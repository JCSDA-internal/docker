project( jedi_common_libs )

# TODO Missing dependencies:
# - Firebird
# - Pango (needs glib)
# - Replace jpeg with jpeg-turbo

cmake_minimum_required(VERSION 2.8)

include (ExternalProject)

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

set( freetype_URL http://download.savannah.gnu.org/releases/freetype/freetype-2.5.5.tar.bz2 )
set( freetype_MD5 2a7a314927011d5030903179cf183be0 )
set( _PACKAGES ${_PACKAGES} freetype )


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
    ExternalProject_Add( zlib-fetch
        SOURCE_DIR ${CMAKE_BINARY_DIR}/zlib-src
        DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
        URL ${zlib_URL}
        URL_HASH ${zlib_HASH}
        LIST_SEPARATOR ^^
        PATCH_COMMAND ${CMAKE_COMMAND} -E remove zconf.h
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
        TEST_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/zlib.h ${JEDI_PREFIX}/licenses/zlib/
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    ExternalProject_Add( zlib-debug
        DEPENDS zlib-fetch
        SOURCE_DIR ${CMAKE_BINARY_DIR}/zlib-src
        DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
        LIST_SEPARATOR ^^
        CMAKE_ARGS -DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_PREFIX_PATH:PATH=${JEDI_PREFIX}
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    ExternalProject_Add( zlib-release
        DEPENDS zlib-fetch
        SOURCE_DIR ${CMAKE_BINARY_DIR}/zlib-src
        DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
        LIST_SEPARATOR ^^
        CMAKE_ARGS -DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_PREFIX_PATH:PATH=${JEDI_PREFIX}
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    ExternalProject_Add( zlib
        DEPENDS zlib-release zlib-debug
        SOURCE_DIR ${CMAKE_BINARY_DIR}/zlib-src
        DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
        )

    file(MAKE_DIRECTORY ${JEDI_PREFIX}/licenses/libpng)
    ExternalProject_Add( libpng-fetch
        SOURCE_DIR ${CMAKE_BINARY_DIR}/libpng-src
        DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
        URL ${libpng_URL}
        URL_MD5 ${libpng_MD5}
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
        TEST_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/LICENSE ${JEDI_PREFIX}/licenses/libpng
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    ExternalProject_Add( libpng-debug
        DEPENDS zlib libpng-fetch
        SOURCE_DIR ${CMAKE_BINARY_DIR}/libpng-src
        DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
        CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=Debug -DCMAKE_MODULE_PATH:PATH=${JEDI_MODULE_PATH} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_PREFIX_PATH:PATH=${JEDI_PREFIX}
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )
    ExternalProject_Add( libpng-release
        DEPENDS zlib libpng-fetch
        SOURCE_DIR ${CMAKE_BINARY_DIR}/libpng-src
        DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
        CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_MODULE_PATH:PATH=${JEDI_MODULE_PATH} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_PREFIX_PATH:PATH=${JEDI_PREFIX}
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

    ExternalProject_Add( libpng
        DEPENDS libpng-release libpng-debug
        SOURCE_DIR ${CMAKE_BINARY_DIR}/libpng-src
        DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E echo
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
        )

    file(MAKE_DIRECTORY ${JEDI_PREFIX}/licenses/libjpeg)
    ExternalProject_Add( libjpeg
        DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
        URL ${libjpeg_URL}
        URL_MD5 ${libjpeg_MD5}
        LIST_SEPARATOR ^^
	CMAKE_ARGS -DCMAKE_SYSTEM_IGNORE_PATH=/lib^^/usr/lib^^/usr/local/lib^^/usr/include^^/usr/local/include -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_PREFIX_PATH:PATH=${JEDI_PREFIX}
        TEST_COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/README ${JEDI_PREFIX}/licenses/libjpeg/
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
        )

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

    set( _OLDPATH $ENV{PATH} )
    set( _NEWPATH ${JEDI_PREFIX}\\bin ${_OLDPATH} )
    set( ENV{PATH} "${_NEWPATH}" )

# INSTALLATION


   INSTALL(DIRECTORY "${JEDI_PREFIX}/licenses" DESTINATION "." COMPONENT binaries)
   INSTALL(DIRECTORY "${JEDI_PREFIX}/docs-to-install/" DESTINATION "doc" COMPONENT documentation)


   FILE(GLOB bzip2_libs "${JEDI_PREFIX}/lib/libbz2*")
   INSTALL(FILES ${bzip2_libs} DESTINATION "lib" COMPONENT binaries)

   FILE(GLOB zlib_libs "${JEDI_PREFIX}/lib/libz*")
   INSTALL(FILES ${zlib_libs} DESTINATION "lib" COMPONENT binaries)

   FILE(GLOB jpeg_libs "${JEDI_PREFIX}/lib/libjpeg*")
   INSTALL(FILES ${jpeg_libs} DESTINATION "lib" COMPONENT binaries)

# TODO include, share

   # Packages/installers
   #

   # Put everything in a single ZIP file
#  set(CPACK_COMPONENTS_ALL_IN_ONE_PACKAGE 1)

#  set(CMAKE_INSTALL_PREFIX "${JEDI_BASEDIR}/build/installation" CACHE PATH "Installation prefix, required for CPack due to absolute paths" FORCE)
#  SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Wt binary build")
#  SET(CPACK_PACKAGE_VENDOR "emweb bvba")
#  SET(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/ReadMe.txt")
#  SET(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/Copyright.txt")
#  SET(CPACK_PACKAGE_VERSION_MAJOR ${WT_VERSION_MAJOR})
#  SET(CPACK_PACKAGE_VERSION_MINOR ${WT_VERSION_MINOR})
#  SET(CPACK_PACKAGE_VERSION_PATCH ${WT_VERSION_PATCH})
#  SET(CPACK_PACKAGE_INSTALL_DIRECTORY "Wt ${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH} ${_WT_COMPILER} ${_WT_ARCH}")

#  if(WIN32)
#   SET(CPACK_GENERATOR "ZIP;NSIS")
#  elseif(CMAKE_HOST_APPLE)
#   SET(CPACK_GENERATOR "Bundle")
#  else(WIN32)
#   SET(CPACK_GENERATOR "TBZ2")
#  endif(WIN32)

#  set(CPACK_COMPONENTS_ALL binaries documentation examples symbols)

#  set(CPACK_COMPONENT_BINARIES_DISPLAY_NAME "Binaries")
#  set(CPACK_COMPONENT_BINARIES_DESCRIPTION "Wt binaries and third party dependencies. Includes DLLs and import libraries.")
#  set(CPACK_COMPONENT_EXAMPLES_DISPLAY_NAME "Examples")
#  set(CPACK_COMPONENT_EXAMPLES_DESCRIPTION "Examples, ready to run. Source code is not included.")
#  set(CPACK_COMPONENT_DOCUMENTATION_DISPLAY_NAME "Documentation")
#  set(CPACK_COMPONENT_DOCUMENTATION_DESCRIPTION "Wt documentation in HTML format")
#  set(CPACK_COMPONENT_SYMBOLS_DISPLAY_NAME "Debug Symbols")
#  set(CPACK_COMPONENT_SYMBOLS_DESCRIPTION "PDB files for all debug DLLs")

#  set(CPACK_COMPONENT_BINARIES_REQUIRED TRUE)

#  #set(CPACK_COMPONENT_EXAMPLES_DEPENDS binaries)

#  INCLUDE(CPack)
ENDIF( FETCH_ONLY )
