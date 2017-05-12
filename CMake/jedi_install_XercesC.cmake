#
# jedi_install_XercesC
#
function ( download_build_install )
       set( xerces_URL http://apache.mirrors.lucidnetworks.net//xerces/c/3/sources/xerces-c-3.1.4.tar.gz )
       set( xerces_MD5 "21bb097b711a513275379b59757cba4c" )
       ExternalProject_Add( XercesC
           DEPENDS ${deps_XercesC}
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${xerces_URL}
           URL_MD5 ${xerces_MD5}
           CONFIGURE_COMMAND
	   <SOURCE_DIR>/configure --prefix=${JEDI_PREFIX} --with-curl --without-icu
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
