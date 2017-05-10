#
# jedi_install_JPEG
#

function ( download_build_install )
       set( libjpeg_URL http://www.ijg.org/files/jpegsrc.v9b.tar.gz )
       set( libjpeg_MD5 6a9996ce116ec5c52b4870dbcd6d3ddb)
       ExternalProject_Add( JPEG
           DEPENDS ${deps_JPEG}
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
endfunction()
