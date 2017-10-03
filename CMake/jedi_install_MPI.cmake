#
# jedi_install_MPI
#
function ( download_build_install )
       set( ompi_URL https://www.open-mpi.org/software/ompi/v2.1/downloads/openmpi-2.1.0.tar.gz )
       set( ompi_MD5 "")
       ExternalProject_Add( MPI
           DEPENDS ${deps_MPI}
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${ompi_URL}
           URL_MD5 ${ompi_MD5}
           CONFIGURE_COMMAND
           <SOURCE_DIR>/configure --prefix=${JEDI_PREFIX} --enable-mpi-cxx
           CC=${CMAKE_C_COMPILER}
           CXX=${CMAKE_CXX_COMPILER}
           CFLAGS=${CFLAGS}
           CXXFLAGS=${CXXFLAGS}
	       FC=${CMAKE_Fortran_COMPILER}
           BUILD_COMMAND ${CMAKE_BUILD_TOOL} -j ${NPROC} all
           INSTALL_COMMAND ${CMAKE_BUILD_TOOL} install
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )

       ExternalProject_Add_Step(
	   MPI touchConfigs
	   COMMAND ${CMAKE_COMMAND} -E touch <SOURCE_DIR>/configure <SOURCE_DIR>/aclocal.m4 <SOURCE_DIR>/Makefile.am <SOURCE_DIR>/Makefile.in  <SOURCE_DIR>/ompi/mca/io/romio314/romio/configure <SOURCE_DIR>/ompi/mca/io/romio314/romio/aclocal.m4 <SOURCE_DIR>/ompi/mca/io/romio314/romio/Makefile.am <SOURCE_DIR>/ompi/mca/io/romio314/romio/Makefile.in <SOURCE_DIR>/opal/mca/event/libevent2022/libevent/configure <SOURCE_DIR>/opal/mca/event/libevent2022/libevent/aclocal.m4 <SOURCE_DIR>/opal/mca/event/libevent2022/libevent/Makefile.am <SOURCE_DIR>/opal/mca/event/libevent2022/libevent/Makefile.in <SOURCE_DIR>/opal/mca/pmix/pmix112/pmix/configure <SOURCE_DIR>/opal/mca/pmix/pmix112/pmix/aclocal.m4 <SOURCE_DIR>/opal/mca/pmix/pmix112/pmix/Makefile.am <SOURCE_DIR>/opal/mca/pmix/pmix112/pmix/Makefile.in
	   COMMENT "Updating the timestamp of configure aclocal.m4 Makefile.am Makefile.in to avoid errors on some platforms"
	   DEPENDEES configure
	   DEPENDERS build
	   )
endfunction()
