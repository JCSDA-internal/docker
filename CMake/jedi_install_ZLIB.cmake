#
# jedi_install_ZLIB
#
function ( download_build_install )
       set( zlib_URL http://www.zlib.net/zlib-1.2.11.tar.gz )
       set( zlib_HASH SHA256=c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1)
       ExternalProject_Add( ZLIB
           DEPENDS ${deps_ZLIB}
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${zlib_URL}
           URL_HASH ${zlib_HASH}
	   CMAKE_ARGS -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )
endfunction()
