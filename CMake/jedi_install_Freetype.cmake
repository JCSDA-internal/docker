
# jedi_install_Freetype
#

function ( download_build_install )
       set( freetype_URL http://download.savannah.gnu.org/releases/freetype/freetype-2.5.5.tar.bz2 )
       set( freetype_MD5 2a7a314927011d5030903179cf183be0 )
       ExternalProject_Add( Freetype
           DEPENDS ${deps_Freetype}
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${freetype_URL}
           URL_MD5 ${freetype_MD5}
	   CMAKE_ARGS -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS} -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )
endfunction()
