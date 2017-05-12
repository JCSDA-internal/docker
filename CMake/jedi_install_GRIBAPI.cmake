#
# jedi_install_GRIBAPI
#

function (download_build_install)
   set(url "https://software.ecmwf.int/wiki/download/attachments/3473437/grib_api-1.19.0-Source.tar.gz")
   set(url_md5 "")
   ExternalProject_Add( GRIBAPI
       DEPENDS ${deps_GRIBAPI}
       DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
       URL ${url}
       URL_MD5 ${url_md5}
       CMAKE_ARGS -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DENABLE_PNG=ON -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}
       LOG_DOWNLOAD 1
       LOG_CONFIGURE 1
       LOG_BUILD 1
       LOG_INSTALL 1
       )
endfunction()
