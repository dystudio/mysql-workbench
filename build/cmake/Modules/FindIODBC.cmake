# Copyright (c) 2013, 2018, Oracle and/or its affiliates. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License, version 2.0,
# as published by the Free Software Foundation.
#
# This program is also distributed with certain software (including
# but not limited to OpenSSL) that is licensed under separate terms, as
# designated in a particular file or component or in included license
# documentation.  The authors of MySQL hereby grant you an additional
# permission to link the program and your derivative works with the
# separately licensed software that they have included with MySQL.
# This program is distributed in the hope that it will be useful,  but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
# the GNU General Public License, version 2.0, for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA 

if (IODBC_INCLUDE_PATH)
    find_path(IODBC_INCLUDE_DIRS iodbcunix.h
      PATHS ${IODBC_INCLUDE_PATH} 
            ${CMAKE_SYSTEM_INCLUDE_PATH}
            /usr/include
            /usr/local/include
            /usr/include/libiodbc
    )
else()
    find_path(IODBC_INCLUDE_DIRS iodbcunix.h
      PATHS ${CMAKE_SYSTEM_INCLUDE_PATH}
            /usr/include
            /usr/local/include
            /usr/include/libiodbc
    )
endif(IODBC_INCLUDE_PATH)

if (IODBC_INCLUDE_DIRS AND IODBC_LIBRARIES)
  set(IODBC_FOUND true)
endif(IODBC_INCLUDE_DIRS AND IODBC_LIBRARIES)

if (IODBC_CONFIG_PATH)

  if (IODBC_LIBRARIES_PATH)
    # Converto to a list of library argments
    string(REPLACE " " ";" IODBC_LIB_ARGS ${IODBC_LIBRARIES_PATH})
    # Parse the list in order to find the library path
    foreach(IODBC_LIB_ARG ${IODBC_LIB_ARGS})
      string(REPLACE "-L" "" IODBC_LIB_ARG_CLEAR ${IODBC_LIB_ARG})
      if(NOT ${IODBC_LIB_ARG_CLEAR} STREQUAL ${IODBC_LIB_ARG})
        set(IODBC_SUPPLIED_LIB_DIR ${IODBC_LIB_ARG_CLEAR})
      else()
        set(IODBC_SUPPLIED_LIB_DIR ${IODBC_LIB_ARG})
      endif()
    endforeach(IODBC_LIB_ARG)
  
    find_library(lib_iodbc NAMES libiodbc.so HINTS ${IODBC_SUPPLIED_LIB_DIR})
    find_library(lib_iodbcinst NAMES libiodbcinst.so HINTS ${IODBC_SUPPLIED_LIB_DIR})
    
    unset(IODBC_LIB_ARG_CLEAR)
    unset(IODBC_LIB_ARG)
    unset(IODBC_LIB_ARGS)
    
    set(IODBC_LIBRARIES ${lib_iodbc} ${lib_iodbcinst})

  else()
    exec_program(${IODBC_CONFIG_PATH} ARGS --libs
                    OUTPUT_VARIABLE IODBC_LIBRARIES)
  endif(IODBC_LIBRARIES_PATH)

  find_program(IODBC_CONFIG_PATH iodbc-config)


  if (NOT EXISTS ${IODBC_CONFIG_PATH})
    MESSAGE(FATAL_ERROR "iodbc-config not found in " ${IODBC_CONFIG_PATH})
  endif()

  exec_program(${IODBC_CONFIG_PATH} ARGS --cflags
                  OUTPUT_VARIABLE IODBC_DEFINITIONS)

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(IODBC DEFAULT_MSG
    IODBC_CONFIG_PATH IODBC_LIBRARIES IODBC_DEFINITIONS
           )

  mark_as_advanced(
    IODBC_CONFIG_PATH
    IODBC_LIBRARIES
    IODBC_DEFINITIONS
    IODBC_INCLUDE_DIRS
    )
endif (IODBC_CONFIG_PATH)

