#
# FindNCO
# -----------
#
# Authors:
#
#   - Xin Zhang <xin.l.zhang@noaa.gov>
#

# Use ncks command to query some NCO information.
find_program (ncks NAMES ncks)
if (ncks MATCHES "NOTFOUND")
    # If ncks can not be found, check some environment variables.
    foreach (var IN ITEMS "NCO_ROOT" )
        if (DEFINED ENV{${var}})
            set (NCO_ROOT $ENV{${var}})
            break ()
        endif ()
    endforeach ()
    if (DEFINED NCO_ROOT)
        set (ncks "${NCO_ROOT}/bin/ncks")
    endif ()
else ()
    get_filename_component (nco_bin ${ncks} PATH)
    string (REGEX REPLACE "/bin$" "" NCO_ROOT ${nco_bin})
    set (NCO_FOUND TRUE)
endif ()

include (FindPackageHandleStandardArgs)
find_package_handle_standard_args (NCO FOUND_VAR NCO_FOUND
    REQUIRED_VARS  NCO_ROOT
)
