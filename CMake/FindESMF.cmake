#
# FindESMF
# -----------
#
# Authors:
#
#   - Xin Zhang <xin.l.zhang@noaa.gov>
#

# Use ESMF_Info command to query some ESMF information.
find_program (ESMF_Info NAMES ESMF_Info)
if (ESMF_Info MATCHES "NOTFOUND")
    # If ESMF_Info can not be found, check some environment variables.
    foreach (var IN ITEMS "ESMF_ROOT" )
        if (DEFINED ENV{${var}})
            set (ESMF_ROOT $ENV{${var}})
            break ()
        endif ()
    endforeach ()
    if (DEFINED ESMF_ROOT)
        set (ESMF_Info "${ESMF_ROOT}/bin/ESMF_Info")
    endif ()
else ()
    get_filename_component (nco_bin ${ESMF_Info} PATH)
    string (REGEX REPLACE "/bin$" "" ESMF_ROOT ${nco_bin})
    set (ESMF_FOUND TRUE)
endif ()

include (FindPackageHandleStandardArgs)
find_package_handle_standard_args (ESMF FOUND_VAR ESMF_FOUND
    REQUIRED_VARS  ESMF_ROOT
)
