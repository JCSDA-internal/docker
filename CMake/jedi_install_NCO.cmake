#
# jedi_install_NCO
#
function ( download_build_install )
       set( nco_URL https://github.com/nco/nco/archive/4.7.6.tar.gz )
       set( nco_MD5 "84296a0ec44b9a58dab198fda9fac7f0")
       ExternalProject_Add( NCO
           DEPENDS ${deps_NCO}
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${nco_URL}
           URL_MD5 ${nco_MD5}
           CONFIGURE_COMMAND
           <SOURCE_DIR>/configure --prefix=${JEDI_PREFIX} --enable-netcdf4 --disable-ncap2
           NETCDF_ROOT=${JEDI_PREFIX}
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

#      ExternalProject_Add_Step(
#      NCO copyExe
#      COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/ncbo ${JEDI_PREFIX}/bin/ncbo
#      COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/ncecat ${JEDI_PREFIX}/bin/ncecat
#      COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/ncflint ${JEDI_PREFIX}/bin/ncflint
#      COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/ncks ${JEDI_PREFIX}/bin/ncks
#      COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/ncpdq ${JEDI_PREFIX}/bin/ncpdq
#      COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/ncra ${JEDI_PREFIX}/bin/ncra
#      COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/ncrename ${JEDI_PREFIX}/bin/ncrename
#      COMMENT "nco install, copy executables to the bin"
#      DEPENDEES install
#      )
endfunction()
