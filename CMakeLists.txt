#-----------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.1.0)
#-----------------------------------------------------------------------------
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/CMake" ${CMAKE_MODULE_PATH})
include (ExternalProject)
include (jedi_colors)
include (jedi_check_cmake_https)
include (jedi_external_proj_depends)
include (jedi_install_package)

set(BUILD_OMPI "ON" CACHE STRING "Build the OMPI library")
project( jedi_common_libs C Fortran CXX )

#-----------------------------------------------------------------------------
# Set a default build type if none was specified
#-----------------------------------------------------------------------------
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to 'Debug' as none was specified.")
  set(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build." FORCE)
  mark_as_advanced(CMAKE_BUILD_TYPE)
  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Release" "Debug"
    "MinSizeRel" "RelWithDebInfo")
endif()

#-----------------------------------------------------------------------------
# Prerequisites
#-----------------------------------------------------------------------------
find_package(Git   REQUIRED)
find_package(CURL  REQUIRED)
find_package(EXPAT REQUIRED)

if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID STREQUAL "Intel")
    # require at least gcc 4.8.4
    if (CMAKE_CXX_COMPILER_VERSION VERSION_LESS 4.8.4)
        message(FATAL_ERROR "GCC version must be at least 4.8.4!")
    endif()
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")
    SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fPIC")
    SET(CFLAGS "${CMAKE_C_FLAGS}")
    SET(CXXFLAGS "${CMAKE_CXX_FLAGS}")
endif()

include(ProcessorCount)
ProcessorCount(NPROC)
if(NPROC GREATER 4)
  set(NPROC 4)
  message(STATUS "Using ${NPROC} threads for parallel building")
endif(NPROC GREATER 4)
#-----------------------------------------------------------------------------
set(JEDI_PREFIX ${PROJECT_SOURCE_DIR})
set(JEDI_BASEDIR ${PROJECT_SOURCE_DIR})
set(JEDI_BATDIR ${PROJECT_SOURCE_DIR})

set(JEDI_BATDIR ${JEDI_BATDIR} CACHE PATH "jedi source directory" FORCE)
set(JEDI_BASEDIR ${JEDI_BASEDIR} CACHE PATH "jedi global work directory" FORCE)
set(JEDI_PREFIX ${JEDI_PREFIX} CACHE PATH "jedi prefix directory" FORCE)

SET(JEDI_DOWNLOADS_DIR ${JEDI_BASEDIR}/downloads CACHE PATH "path for downloads")

set(CMAKE_LIBRARY_PATH ${JEDI_BASEDIR}/lib ${CMAKE_LIBRARY_PATH})

set(JEDI_MODULE_PATH ${JEDI_BATDIR}/cmake/Modules)

#-----------------------------------------------------------------------------
# Determine if we have MPI package
if (NOT BUILD_OMPI)
   find_package(MPI QUIET)
endif()
if (MPI_FOUND)
   set(BUILD_OMPI "OFF" CACHE STRING "Build the OMPI library" FORCE )
   message(STATUS "MPI IMPLEMENTATION is ${MPI_IMPLEMENTATION}")
   message(STATUS "MPI Fortran compiler is ${MPI_Fortran_COMPILER}")
   set(JEDI_MPI_C_COMPILER   ${MPI_C_COMPILER})
   set(JEDI_MPI_CXX_COMPILER ${MPI_CXX_COMPILER})
   set(JEDI_MPI_F77_COMPILER ${MPI_Fortran_COMPILER})
   set(JEDI_MPI_F90_COMPILER ${MPI_Fortran_COMPILER})
else ()
   if (BUILD_PNETCDF)
      set(BUILD_OMPI "ON" CACHE STRING "Build the OMPI library" FORCE )
      message(STATUS "Not MPI_FOUND, will install in source openmpi")
   endif ()
   set(JEDI_MPI_C_COMPILER   ${JEDI_PREFIX}/bin/mpicc)
   set(JEDI_MPI_CXX_COMPILER ${JEDI_PREFIX}/bin/mpicxx)
   set(JEDI_MPI_F77_COMPILER ${JEDI_PREFIX}/bin/mpifort)
   set(JEDI_MPI_F90_COMPILER ${JEDI_PREFIX}/bin/mpifort)
   set(MPI "ompi")
   set(ESMF_COMM "openmpi")
   set(MPI_IMPLEMENTATION "openmpi")
   message(STATUS "BUILD_OMPI is ${BUILD_OMPI}")
endif ()

jedi_check_cmake_https()

include(jedi_check_depends_and_install_packages)
