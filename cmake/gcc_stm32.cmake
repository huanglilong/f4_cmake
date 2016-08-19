#
# author	: huang li long <huanglilongwk@outlook.com>
# time		: 2016/08/19
# brief		: 
# ref       : https://github.com/ObKo/stm32-cmake/blob/master/cmake/gcc_stm32.cmake
#

# select compiler by user
include(CMakeForceCompiler)

# support chip families
set(STM32_SUPPORTED_FAMILY F0 F1 F2 F4 CACHE INTERNAL "stm32 supported families")

# set compiler bash path 
if(NOT TOOLCHAIN_BASE_PATH)
	set(TOOLCHAIN_BASE_PATH "/usr")
	message(STATUS "using default toolchain base path is ${TOOLCHAIN_BASE_PATH}")
endif()

# set compiler's prefix part
if(NOT TOOLCHAIN_PREFIX)
	set(TOOLCHAIN_PREFIX "arm-none-eabi")
	message(STATUS "using default toolchain prefix part: ${TOOLCHAIN_PREFIX}")
endif()

# get chip's family message 
if(NOT STM32_FAMILY)
	message(STATUS "get family message from STM32_CHIP")
	if(NOT STM32_CHIP)
		message(FATAL_ERROR "must be specific STM32_CHIP in command-line")
	else()
		string(REGEX REPLACE "^[sS][tT][mM]32(([fF][0-4])).+$" "\\1" STM32_FAMILY ${STM32_CHIP})
		string(TOUPPER ${STM32_FAMILY} STM32_FAMILY)
		message(STATUS "selected STM32 family is ${STM32_FAMILY}")
	endif()
endif()

#string(TOUPPER ${STM32_FAMILY} STM32_FAMILY)
list(FIND STM32_SUPPORTED_FAMILY ${STM32_FAMILY} FAMILY_INDEX)
if(FAMILY_INDEX EQUAL -1)	# NOT support family
	message(FATAL_ERROR "Invaild or unsupported STM32 family: ${STM32_FAMILY}")
endif()

# set toolchain compiler, header files and library's path
set(TOOLCHAIN_BIN_DIR ${TOOLCHAIN_BASE_PATH}/bin)
set(TOOLCHAIN_INC_DIR ${TOOLCHAIN_BASE_PATH}/${TOOLCHAIN_PREFIX}/include)
set(TOOLCHAIN_INC_DIR ${TOOLCHAIN_BASE_PATH}/${TOOLCHAIN_PREFIX}/lib)

# set target 
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

# select compiler manually
CMAKE_FORCE_C_COMPILER(${TOOLCHAIN_BIN_DIR}/${TOOLCHAIN_PREFIX}-gcc GNU)
CMAKE_FORCE_CXX_COMPILER(${TOOLCHAIN_BIN_DIR}/${TOOLCHAIN_PREFIX}-g++ GNU)
set(CMAKE_ASM_COMPILER ${TOOLCHAIN_BIN_DIR}/${TOOLCHAIN_PREFIX}-gcc)

# other tools
set(CMAKE_OBJCOPY ${TOOLCHAIN_BIN_DIR}/${TOOLCHAIN_PREFIX}-objcopy CACHE INTERNAL "objcopy tool")
set(CMAKE_OBJDUMP ${TOOLCHAIN_BIN_DIR}/${TOOLCHAIN_PREFIX}-objdump CACHE INTERNAL "objdump tool")
set(CMAKE_SIZE    ${TOOLCHAIN_BIN_DIR}/${TOOLCHAIN_PREFIX}-size	   CACHE INTERNAL "size tool")
set(CMAKE_GDB     ${TOOLCHAIN_BIN_DIR}/${TOOLCHAIN_PREFIX}-gdb     CACHE INTERNAL "gdb tool")

# debug compiler flags --> -g, if CMAKE_BUILD_TYPE=Debug, then auto add to CMAKE_C_FLAGS...
set(CMAKE_C_FLAGS_DEBUG 		 "-Og -g" CACHE INTERNAL "c compiler flags debug")
set(CMAKE_CXX_FLAGS_DEBUG 		 "-Og -g" CACHE INTERNAL "cxx compiler flags debug")
set(CMAKE_ASM_FLAGS_DEBUG 		 "-g" 	  CACHE INTERNAL "asm compiler flags debug")
set(CMAKE_EXE_LINKER_FLAGS_DEBUG "" 	  CACHE INTERNAL "linker flags debug")

# release compiler flags
set(CMAKE_C_FLAGS_RELEASE 			"-Os -flto" CACHE INTERNAL "c compiler flags release")
set(CMAKE_CXX_FLAGS_RELEASE 		"-Os -flto" CACHE INTERNAL "cxx compiler flags release")
set(CMAKE_ASM_FLAGS_RELEASE 		"" 			CACHE INTERNAL "asm compiler flags release")
set(CMAKE_EXE_LINKER_FLAGS_RELEASE  "-flto" 	CACHE INTERNAL "linker flags release")

# libraries and programs 
set(CMAKE_FIND_ROOT_PATH ${TOOLCHAIN_BIN_DIR}/${TOOLCHAIN_PREFIX})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)	# using host system programs only
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)		# using cross compiler's libraries only
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)		# using cross compiler's header files only

# include gcc_stm32f4.cmake 
string(TOLOWER ${STM32_FAMILY} STM32_FAMILY_LOWER)
include(gcc_stm32${STM32_FAMILY_LOWER})