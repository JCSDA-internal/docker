#
# jedi_install_BOOST
#

function ( download_build_install )
       set( libboost_URL https://dl.bintray.com/boostorg/release/1.65.1/source/boost_1_65_1.tar.gz )
       set( libboost_MD5  )
       ExternalProject_Add( BOOST
           DEPENDS ${deps_BOOST}
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${libboost_URL}
           CONFIGURE_COMMAND
           <SOURCE_DIR>/bootstrap.sh --prefix=${JEDI_PREFIX}
           BUILD_COMMAND <SOURCE_DIR>/b2 install
           INSTALL_COMMAND ""
           BUILD_IN_SOURCE 1
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )
endfunction()
