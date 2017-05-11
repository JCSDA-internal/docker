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
# This is  working variable
string (REGEX MATCHALL "${_prefix}[A-Za-z0-9_]*" _deps1 "${_vars}")

# Remove the installed packages from the installation list
set (_foundPackages "")
foreach (_dep ${_deps1})
    string (REGEX REPLACE ${_prefix} "" _package ${_dep})
    find_package(${_package} QUIET)
    if (${_package}_FOUND)
       message(STATUS "${Green}${_package} is found${ColourReset}")
       list(APPEND _foundPackages ${_package})
       list(REMOVE_ITEM _deps ${_prefix}${_package})
    endif()
    message(STATUS ${_foundPackages})
    if ( _foundPackages )
       list(REMOVE_ITEM ${_deps} ${_foundPackages})
       list(REMOVE_ITEM _deps ${_prefix}${_foundPackages})
    endif()
endforeach()

# Remove the installed packages from the dependent list
foreach (_dep ${_deps})
   foreach (_p ${${_dep}})
      list (FIND _foundPackages _p _index)
      if (${_index} GREATER -1)
         list(REMOVE_ITEM ${_dep} ${_p})
      endif()
   endforeach()
endforeach()

# This is  working variable
set(_deps2 ${_deps} CACHE STRING "" FORCE)

# Install the packages based on the dependent relationship
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

