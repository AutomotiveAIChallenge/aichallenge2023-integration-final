# FindSPINNAKER.cmake
#
# Finds the PointGrey SDK installed on the system.
#
# This will define the following variables
#
#    SPINNAKER_FOUND
#    SPINNAKER_INCLUDE_DIRS
#    SPINNAKER_LIBRARIES
#
# and the following imported targets
#
#     SPINNAKER::SPINNAKER

find_path(SPINNAKER_INCLUDE_DIR
  NAMES Spinnaker.h
  PATHS "/usr/include/spinnaker/*" "/opt/spinnaker/*"
)
find_library(SPINNAKER_LIBRARY NAMES Spinnaker PATHS "/opt/spinnaker/*")

mark_as_advanced(SPINNAKER_FOUND SPINNAKER_INCLUDE_DIR SPINNAKER_LIBRARY)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SPINNAKER
  REQUIRED_VARS SPINNAKER_INCLUDE_DIR SPINNAKER_LIBRARY
)

if(SPINNAKER_FOUND)
  list(APPEND SPINNAKER_INCLUDE_DIRS
    "${SPINNAKER_INCLUDE_DIR}"
    "${SPINNAKER_INCLUDE_DIR}/spinnaker")
  list(APPEND SPINNAKER_LIBRARIES "${SPINNAKER_LIBRARY}")
endif()

if(SPINNAKER_FOUND AND NOT TARGET SPINNAKER::SPINNAKER)
  add_library(SPINNAKER::SPINNAKER IMPORTED SHARED)
  set_target_properties(SPINNAKER::SPINNAKER PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${SPINNAKER_INCLUDE_DIRS}"
      INTERFACE_LINK_LIBRARIES "${SPINNAKER_LIBRARIES}"
  )
endif()