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
	   CONFIGURE_COMMAND
           <SOURCE_DIR>/configure --prefix=${JEDI_PREFIX}
           CFLAGS=${CFLAGS}
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )
endfunction()
