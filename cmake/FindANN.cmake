# FindANN.cmake
# 
# Finds native ANN includes and library
#
# This will define the following variables
# 
#     ANN_FOUND
#     ANN_INCLUDE_DIR
#     ANN_LIBRARIES
#
# and the following imported targets
#
#     ANN::ANN
#
# Author: Lucas Kahlert <lucas.kahlert@tu-dresden.de>

include(FindPackageHandleStandardArgs)

find_path(ANN_INCLUDE_DIR ANN/ANN.h)
find_library(ANN_LIBRARY NAMES ANN ann)

find_package_handle_standard_args(ANN DEFAULT_MSG
    ANN_LIBRARY ANN_INCLUDE_DIR)

if(ANN_FOUND)
	set(ANN_INCLUDE_DIRS ${ANN_INCLUDE_DIR})
	set(ANN_LIBRARIES ${ANN_LIBRARY})

	# Define imported target if not already defined
	if (NOT TARGET ANN::ANN)
		add_library(ANN::ANN UNKNOWN IMPORTED)
		set_target_properties(ANN::ANN PROPERTIES
			INTERFACE_INCLUDE_DIRECTORIES ${ANN_INCLUDE_DIRS}
			IMPORTED_LOCATION ${ANN_LIBRARIES})
	endif()
endif()
