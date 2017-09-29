#
# jedi_install_PNG
#

function ( download_build_install )
       set( libpng_URL ftp://ftp-osl.osuosl.org/pub/libpng/src/archive/gz/libpng14/libpng-1.4.19.tar.gz )
       set( libpng_MD5 89bcbc4fc8b31f4a403906cf4f662330 )
       ExternalProject_Add( PNG
           DEPENDS ${deps_PNG}
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${libpng_URL}
           URL_MD5 ${libpng_MD5}
	   CMAKE_ARGS -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )
endfunction()
