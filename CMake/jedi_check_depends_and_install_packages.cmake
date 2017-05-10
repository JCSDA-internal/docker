#
#
# This module will check the depends of each packages and 
# install the packages according their dependeces.
#
#
# search all the cache variable start with "deps"
set(_prefix "deps_")
get_cmake_property(_vars CACHE_VARIABLES)
string (REGEX MATCHALL "${_prefix}[A-Za-z0-9_]*" _deps "${_vars}")

# remove the installed packages from the depends
foreach (_dep ${_deps})
    set (_foundPackages "")
    foreach (_package ${${_dep}})
       find_package(${_package} QUIET)
       if (${_package}_FOUND)
          list(APPEND _foundPackages ${_package})
       endif()
    endforeach()
    if ( _foundPackages )
       list(REMOVE_ITEM ${_deps} ${_foundPackages})
    endif()
    # save the deps into a temporaray variable as we will edit the deps in the floowing loops
    string (REGEX REPLACE ${_prefix} ""  _package ${_dep})
    set ( deps2_${_package} ${${_dep}} CACHE STRING "" FORCE )
    # message (STATUS "${Red} deps2_${_package} : ${deps2_${_package}} ${ColourReset}")
endforeach()

# search all the cache variable start with "deps2"
set(_prefix "deps2_")
get_cmake_property(_vars CACHE_VARIABLES)
string (REGEX MATCHALL "${_prefix}[A-Za-z0-9_]*" _deps2 "${_vars}")

while ( 1 )
    if ( NOT _deps2 )
       # exit when all package are installed
       break()
    endif()

    set (_deps3 ${_deps2} CACHE STRING "" FORCE)
    foreach (_dep ${_deps3})
        # install if not dependence
        if ( NOT ${_dep} )
           string (REGEX REPLACE ${_prefix} ""  _package ${_dep})
           jedi_install_package( ${_package} )
           message(STATUS  "${Red}${_package} will be installed${ColourReset}")
           #remove from the deps2
           list(REMOVE_ITEM _deps2 ${_dep})
           # remove the package from the dependes
           foreach (_d ${_deps2})
              foreach (_p ${${_d}})
                  list(REMOVE_ITEM ${_deps2} ${_p})
              endforeach()
           endforeach()
        endif()
    endforeach()
endwhile()

