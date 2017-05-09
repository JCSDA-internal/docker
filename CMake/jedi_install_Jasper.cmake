#
# jedi_install_Jasper
#

function ( download_build_install )
       set( libjasper_URL http://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.2.tar.gz )
       set( libjasper_MD5 "" )
       ExternalProject_Add( Jasper
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${libjasper_URL}
           URL_MD5 ${libjasper_MD5}
           CONFIGURE_COMMAND
	   <SOURCE_DIR>/configure --prefix=${JEDI_PREFIX} --enable-libjpeg
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

