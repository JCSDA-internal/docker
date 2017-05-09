#
# jedi_install_SZIP
#
function ( download_build_install )
       set( szip_URL https://support.hdfgroup.org/ftp/lib-external/szip/2.1.1/src/szip-2.1.1.tar.gz )
       set( szip_MD5 "")
       ExternalProject_Add( SZIP
           DEPENDS ${deps_SZIP}
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${szip_URL}
	   URL_HASH ${szip_MD5}
	   CMAKE_ARGS -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DSZIP_ENABLE_ENCODING=ON -DBUILD_SHARED_LIBS=ON -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )

       if (NOT APPLE)
          ExternalProject_Add_Step(
	      SZIP rename
              COMMAND ${CMAKE_COMMAND} -E copy ${JEDI_PREFIX}/lib/libszip.a ${JEDI_PREFIX}/lib/libsz.a
	      COMMAND ${CMAKE_COMMAND} -E copy ${JEDI_PREFIX}/lib/libszip.so ${JEDI_PREFIX}/lib/libsz.so
	      COMMENT "Some lib seeks sz , other than szip"
	      DEPENDEES install
	      )
       endif()
endfunction()
