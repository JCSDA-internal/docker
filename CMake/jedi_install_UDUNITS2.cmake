#
# jedi_install_UDUNITS2
#

function ( download_build_install )
       set( udunits_URL ftp://ftp.unidata.ucar.edu/pub/udunits/udunits-2.2.24.tar.gz )
       set( udunits_MD5 "")
       ExternalProject_Add( UDUNITS2
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${udunits_URL}
           URL_MD5 ${udunits_MD5}
	   CMAKE_ARGS -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )
endfunction()
