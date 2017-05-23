#
# jedi_install_CDO
#

function ( download_build_install )
   set(cdo_url "https://code.zmaw.de/attachments/download/14686/cdo-1.8.2.tar.gz")
   set(cdo_md5 "")
   ExternalProject_Add( CDO
       DEPENDS ${deps_CDO}
       DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
       URL ${cdo_url}
       URL_MD5 ${cdo_md5}
       CONFIGURE_COMMAND
       <SOURCE_DIR>/configure --prefix=${JEDI_PREFIX} -with-curl --with-szlib=${JEDI_PREFIX} --with-grib_api=${JEDI_PREFIX} --with-udunits2=${JEDI_PREFIX} --with-hdf5=${JEDI_PREFIX} --with-netcdf=${JEDI_PREFIX} --with-jasper=${JEDI_PREFIX}
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
