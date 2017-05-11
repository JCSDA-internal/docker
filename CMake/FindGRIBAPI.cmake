find_library(GRIBAPI_LIBRARIES NAMES grib_api)
find_path(GRIBAPI_INCLUDE_DIR NAMES grib_api.h)
include(FindPackageHandleStandardArgs)
# since there's no grib_api.pc let's check if this installation of grib required jasper and jpeg
include(CheckLibraryExists)
set(CMAKE_REQUIRED_LIBRARIES m)
check_library_exists(${GRIBAPI_LIBRARIES} grib_index_new_from_file "" GRIBAPI_COMPILES)
if(GRIBAPI_COMPILES)
	find_package_handle_standard_args(GRIBAPI DEFAULT_MSG GRIBAPI_LIBRARIES GRIBAPI_INCLUDE_DIR)
else(GRIBAPI_COMPILES)
	find_package(Jasper)
	if(JASPER_FOUND)
		set(CMAKE_REQUIRED_LIBRARIES ${JASPER_LIBRARIES} m)
		check_library_exists(${GRIBAPI_LIBRARIES} grib_index_new_from_file "" GRIBAPI_COMPILES_JASPER)
		if(GRIBAPI_COMPILES_JASPER)
			set(GRIBAPI_LIBRARIES ${GRIBAPI_LIBRARIES} ${JASPER_LIBRARIES})
			set(GRIBAPI_INCLUDE_DIR ${GRIBAPI_INCLUDE_DIR} ${JASPER_INCLUDE_DIR})
			find_package_handle_standard_args(GRIBAPI DEFAULT_MSG GRIBAPI_LIBRARIES GRIBAPI_INCLUDE_DIR)
		endif(GRIBAPI_COMPILES_JASPER)
	endif(JASPER_FOUND)
endif(GRIBAPI_COMPILES)
set(CMAKE_REQUIRED_LIBRARIES)
mark_as_advanced(
GRIBAPI_LIBRARIES
GRIBAPI_INCLUDE_DIR
GRIBAPI_COMPILES
GRIBAPI_COMPILES_JASPER
)
