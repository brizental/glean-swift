# Returns the architecture name in a variable
#
# Usage:
#   get_swift_host_arch(result_var_name)
#
# Sets ${result_var_name} with the converted architecture name derived from
# CMAKE_SYSTEM_PROCESSOR.
function(get_swift_host_arch result_var_name)
  if("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "x86_64")
    set("${result_var_name}" "x86_64" PARENT_SCOPE)
  elseif ("${CMAKE_SYSTEM_PROCESSOR}" MATCHES "AArch64|aarch64|arm64")
    if(CMAKE_SYSTEM_NAME MATCHES Darwin)
      set("${result_var_name}" "arm64" PARENT_SCOPE)
    else()
      set("${result_var_name}" "aarch64" PARENT_SCOPE)
    endif()
  elseif("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "ppc64")
    set("${result_var_name}" "powerpc64" PARENT_SCOPE)
  elseif("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "ppc64le")
    set("${result_var_name}" "powerpc64le" PARENT_SCOPE)
  elseif("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "s390x")
    set("${result_var_name}" "s390x" PARENT_SCOPE)
  elseif("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "armv6l")
    set("${result_var_name}" "armv6" PARENT_SCOPE)
  elseif("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "armv7l")
    set("${result_var_name}" "armv7" PARENT_SCOPE)
  elseif("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "armv7-a")
    set("${result_var_name}" "armv7" PARENT_SCOPE)
  elseif("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "AMD64")
    set("${result_var_name}" "x86_64" PARENT_SCOPE)
  elseif("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "IA64")
    set("${result_var_name}" "itanium" PARENT_SCOPE)
  elseif("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "x86")
    set("${result_var_name}" "i686" PARENT_SCOPE)
  elseif("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "i686")
    set("${result_var_name}" "i686" PARENT_SCOPE)
  else()
    message(FATAL_ERROR "Unrecognized architecture on host system: ${CMAKE_SYSTEM_PROCESSOR}")
  endif()
endfunction()

# Returns the os name in a variable
#
# Usage:
#   get_swift_host_os(result_var_name)
#
#
# Sets ${result_var_name} with the converted OS name derived from
# CMAKE_SYSTEM_NAME.
function(get_swift_host_os result_var_name)
  if(CMAKE_SYSTEM_NAME STREQUAL Darwin)
    set(${result_var_name} macosx PARENT_SCOPE)
  else()
    string(TOLOWER ${CMAKE_SYSTEM_NAME} cmake_system_name_lc)
    set(${result_var_name} ${cmake_system_name_lc} PARENT_SCOPE)
  endif()
endfunction()

function(_install_target module)
  get_swift_host_arch(swift_arch)
  get_swift_host_os(swift_os)
  install(TARGETS ${module}
    ARCHIVE DESTINATION lib/swift$<$<NOT:$<BOOL:${BUILD_SHARED_LIBS}>>:_static>/${swift_os}
    LIBRARY DESTINATION lib/swift$<$<NOT:$<BOOL:${BUILD_SHARED_LIBS}>>:_static>/${swift_os}
    RUNTIME DESTINATION bin)
  if(CMAKE_SYSTEM_NAME STREQUAL Darwin)
    install(FILES $<TARGET_PROPERTY:${module},Swift_MODULE_DIRECTORY>/${module}.swiftdoc
      DESTINATION lib/swift$<$<NOT:$<BOOL:${BUILD_SHARED_LIBS}>>:_static>/${swift_os}/${mmodule}.swiftmodule
      RENAME ${swift_arch}.swiftdoc)
    install(FILES $<TARGET_PROPERTY:${module},Swift_MODULE_DIRECTORY>/${module}.swiftmodule
      DESTINATION lib/swift$<$<NOT:$<BOOL:${BUILD_SHARED_LIBS}>>:_static>/${swift_os}/${mmodule}.swiftmodule
      RENAME ${swift_arch}.swiftmodule)
  else()
    install(FILES
      $<TARGET_PROPERTY:${module},Swift_MODULE_DIRECTORY>/${module}.swiftdoc
      $<TARGET_PROPERTY:${module},Swift_MODULE_DIRECTORY>/${module}.swiftmodule
      DESTINATION lib/swift$<$<NOT:$<BOOL:${BUILD_SHARED_LIBS}>>:_static>/${swift_os}/${swift_arch})
  endif()
endfunction()
