# common files
set(CMSIS_COMMON_HEADERS
    arm_common_tables.h
    arm_const_structs.h
    arm_math.h
    core_cmFunc.h
    core_cmInstr.h
    core_cmSimd.h
)
if(STM32_FAMILY STREQUAL "F4")
	if(NOT STM32Cube_DIR)
		set(STM32Cube_DIR "/opt/STM32Cube_FW_F4_V1.13.0")
		message(STATUS "No STM32 Cube directory specificed: using default: ${STM32Cube_DIR}")
	endif()
	
	# cortex-m4 cpu
	list(APPEND CMSIS_COMMON_HEADERS core_cm4.h)

	# for stm32f4 processors
    set(CMSIS_DEVICE_HEADERS stm32f4xx.h system_stm32f4xx.h)
    set(CMSIS_DEVICE_SOURCES system_stm32f4xx.c)
endif()

# startup file 
if(NOT CMSIS_STARTUP_SOURCE)
	set(CMSIS_STARTUP_SOURCE startup_stm32f429xx.s)
endif()

# header path 
find_path(CMSIS_COMMON_INCLUDE_DIR ${CMSIS_COMMON_HEADERS}
		  HINTS ${STM32Cube_DIR}/Drivers/CMSIS/Include
		  CMAKE_FIND_ROOT_PATH_BOTH
)

find_path(CMSIS_DEVICE_INCLUDE_DIR ${CMSIS_DEVICE_HEADERS}
		  HINTS ${STM32Cube_DIR}/Drivers/CMSIS/Device/ST/STM32F4xx/Include
		  CMAKE_FIND_ROOT_PATH_BOTH
)

# CMSIS header files' path
set(CMSIS_INCLUDE_DIRS
	${CMSIS_COMMON_INCLUDE_DIR}
	${CMSIS_DEVICE_INCLUDE_DIR}
)

foreach(SRC ${CMSIS_DEVICE_SOURCES})
	find_file(SRC_FILE ${SRC}
			  HINTS ${STM32Cube_DIR}/Drivers/CMSIS/Device/ST/STM32${STM32_FAMILY}xx/Source/Templates/
			  CMAKE_FIND_ROOT_PATH_BOTH
	)
	list(APPEND CMSIS_SOURCES ${SRC_FILE})
endforeach()

# startup source file
find_file(STARTUP_FILE ${CMSIS_STARTUP_SOURCE}
		  HINTS ${STM32Cube_DIR}/Drivers/CMSIS/Device/ST/STM32${STM32_FAMILY}xx/Source/Templates/gcc/
		  CMAKE_FIND_ROOT_PATH_BOTH
)
list(APPEND CMSIS_SOURCES ${STARTUP_FILE})

include(FindPackageHandleStandardArgs)

FIND_PACKAGE_HANDLE_STANDARD_ARGS(CMSIS DEFAULT_MSG CMSIS_INCLUDE_DIRS CMSIS_SOURCES)
