#
# FindCDO
# -----------
#
# Authors:
#
#   - Xin Zhang <xin.l.zhang@noaa.gov>
#

# Use cdo command to query some CDO information.
find_program (cdo NAMES cdo)
if (cdo MATCHES "NOTFOUND")
    # If cdo can not be found, check some environment variables.
    foreach (var IN ITEMS "CDO_ROOT" )
        if (DEFINED ENV{${var}})
            set (CDO_ROOT $ENV{${var}})
            break ()
        endif ()
    endforeach ()
    if (DEFINED CDO_ROOT)
        set (cdo "${CDO_ROOT}/bin/cdo")
    endif ()
else ()
    get_filename_component (nco_bin ${cdo} PATH)
    string (REGEX REPLACE "/bin$" "" CDO_ROOT ${nco_bin})
    set (CDO_FOUND TRUE)
endif ()

include (FindPackageHandleStandardArgs)
find_package_handle_standard_args (CDO FOUND_VAR CDO_FOUND
    REQUIRED_VARS  CDO_ROOT
)
