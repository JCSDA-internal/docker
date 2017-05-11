#
# jedi_install_NCO
#
function ( download_build_install )
       ExternalProject_Add( NCO
           DEPENDS ${deps_NCO}
           DOWNLOAD_DIR ${JEDI_DOWNLOADS_DIR}
           URL ${nco_URL}
           URL_MD5 ${nco_MD5}
	   CMAKE_ARGS -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX:PATH=${JEDI_PREFIX} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}
           INSTALL_COMMAND ""
	   BUILD_IN_SOURCE 1
           LOG_DOWNLOAD 1
           LOG_CONFIGURE 1
           LOG_BUILD 1
           LOG_INSTALL 1
           )

       ExternalProject_Add_Step(
	   NCO copyExe
	   COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/ncbo ${JEDI_PREFIX}/bin/ncbo
	   COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/ncecat ${JEDI_PREFIX}/bin/ncecat
	   COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/ncflint ${JEDI_PREFIX}/bin/ncflint
	   COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/ncks ${JEDI_PREFIX}/bin/ncks
	   COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/ncpdq ${JEDI_PREFIX}/bin/ncpdq
	   COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/ncra ${JEDI_PREFIX}/bin/ncra
	   COMMAND ${CMAKE_COMMAND} -E copy <SOURCE_DIR>/ncrename ${JEDI_PREFIX}/bin/ncrename
	   COMMENT "nco install, copy executables to the bin"
	   DEPENDEES install
	   )
endfunction()
