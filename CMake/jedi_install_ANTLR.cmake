#
# jedi_install_ANTLR
#
function ( download_build_install )
       set( antlr_URL http://www.antlr2.org/download/antlr-2.7.7.tar.gz )
       set( antlr_MD5 "01cc9a2a454dd33dcd8c856ec89af090")
       ExternalProject_Add( ANTLR
           DEPENDS ${deps_ANTLR}
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${antlr_URL}
           URL_MD5 ${antlr_MD5}
           CONFIGURE_COMMAND
           <SOURCE_DIR>/configure --prefix=${JEDI_PREFIX} --disable-examples
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

endfunction()
