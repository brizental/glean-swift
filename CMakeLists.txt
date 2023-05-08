cmake_minimum_required(VERSION 3.16)
project(glean-swift
  LANGUAGES Swift)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/modules)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_Swift_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/swift)

include(CTest)
include(SwiftSupport)

add_subdirectory(Sources)
if(BUILD_TESTING)
  add_subdirectory(Tests)
endif()

get_property(SWIFT_NUMERICS_EXPORTS GLOBAL PROPERTY SWIFT_NUMERICS_EXPORTS)
export(TARGETS ${SWIFT_NUMERICS_EXPORTS}
  NAMESPACE GleanSwift::
  FILE glean-swift-config.cmake
  EXPORT_LINK_INTERFACE_LIBRARIES)
