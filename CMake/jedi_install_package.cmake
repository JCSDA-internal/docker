#
# jedi_install_package
#

function ( jedi_install_package _package )
       include(jedi_install_${_package})
       download_build_install()
endfunction()

