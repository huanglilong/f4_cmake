#
# author	: huang li long <huanglilongwk@outlook.com>
# time		: 2016/08/20
# ref 		: https://github.com/ObKo/stm32-cmake/blob/master/cmake/FindSTM32HAL.cmake
#

####### Notes ########
# what find_package() command do?
# 1. collects header files 
# 2. collects source files 
# 3. gets header files's include directory path and save in  <package>_INCLUDE_DIR variable
# 4. gets each source files's absolute path and save in <package>_SOURCES variable
#
if(STM32_FAMILY STREQUAL "F4")
	set(HAL_COMPONENTS adc can cec cortex crc cryp dac dcmi dma dma2d eth flash
					   flash_ramfunc fmpi2c gpio hash hcd i2c i2s irda iwdg ltdc
					   nand nor pccard pcd pwr qspi rcc rng rtc sai sd sdram
					   smartcard spdifrx spi sram tim uart usart wwdg fmc fsmc
					   sdmmc usb)

	# required components
	set(HAL_REQUIRED_COMPONENTS cortex pwr rcc)

	# component file end with _ex 
	set(HAL_EX_COMPONENTS adc cryp dac dcmi dma flash fmpi2c hash i2c i2s pcd
                          pwr rcc rtc sai tim)
	
	# components files that "ll_" in names instead of hal_
	set(HAL_LL_COMPONENTS fmc fsmc sdmmc usb)

	# component file prefix 
	set(HAL_PREFIX stm32f4xx_)

	# header file for select component 
	set(HAL_HEADERS
		stm32f4xx_hal.h
        stm32f4xx_hal_def.h
	)

	set(HAL_SRCS stm32f4xx_hal.c)
endif()

# select components
if(NOT STM32HAL_FIND_COMPONENTS)	# no components specified
	set(STM32HAL_FIND_COMPONENTS ${HAL_COMPONENTS})
	message(STATUS "No STM32HAL components selected, using all: ${HAL_COMPONENTS}")
endif()

# force select required components
foreach(cmp ${HAL_REQUIRED_COMPONENTS})
	list(FIND STM32HAL_FIND_COMPONENTS ${cmp} STM32HAL_FOUND_INDEX)
	if(${STM32HAL_FOUND_INDEX} LESS 0) # required component doesn't contain in 
		list(APPEND STM32HAL_FIND_COMPONENTS ${cmp})
	endif()
endforeach()

# check components's vaild and collects header files and source files
foreach(cmp ${STM32HAL_FIND_COMPONENTS})
	list(FIND HAL_COMPONENTS ${cmp} STM32HAL_FOUND_INDEX)
	if(${STM32HAL_FOUND_INDEX} LESS 0)
		message(FATAL_ERROR "Unknown STM32HAL component: ${cmp}, all available components: ${HAL_COMPONENTS}")
	endif()

	# collect header files and source files (prior to using "ll_")
	list(FIND HAL_LL_COMPONENTS ${cmp} STM32HAL_FOUND_INDEX)
	if(${STM32HAL_FOUND_INDEX} LESS 0) # not ll_ part
		list(APPEND HAL_HEADERS ${HAL_PREFIX}hal_${cmp}.h)
		list(APPEND HAL_SRCS    ${HAL_PREFIX}hal_${cmp}.c)
	else()
		list(APPEND HAL_HEADERS ${HAL_PREFIX}ll_${cmp}.h)
		list(APPEND HAL_SRCS    ${HAL_PREFIX}ll_${cmp}.c)
	endif()

	list(FIND HAL_EX_COMPONENTS ${cmp} STM32HAL_FOUND_INDEX)
	if(NOT (${STM32HAL_FOUND_INDEX} LESS 0))
		list(APPEND HAL_HEADERS ${HAL_PREFIX}hal_${cmp}_ex.h)
		list(APPEND HAL_SRCS    ${HAL_PREFIX}hal_${cmp}_ex.c)
	endif()
endforeach()


# remove duplicates files 
list(REMOVE_DUPLICATES HAL_HEADERS)
list(REMOVE_DUPLICATES HAL_SRCS)

string(TOLOWER ${STM32_FAMILY} STM32_FAMILY_LOWER)

# get header files's path
find_path(STM32HAL_INCLUDE_DIR ${HAL_HEADERS}
		  HINTS ${STM32Cube_DIR}/Drivers/STM32F4xx_HAL_Driver/Inc
		  CMAKE_FIND_ROOT_PATH_BOTH
)

# collect all required components source files
foreach(HAL_SRC ${HAL_SRCS})
	find_file(HAL_${HAL_SRC}_FILE ${HAL_SRC}
		HINTS ${STM32Cube_DIR}/Drivers/STM32F4xx_HAL_Driver/Src
		CMAKE_FIND_ROOT_PATH_BOTH
	)
	list(APPEND STM32HAL_SOURCES ${HAL_${HAL_SRC}_FILE})
endforeach()

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(STM32HAL DEFAULT_MSG STM32HAL_INCLUDE_DIR STM32HAL_SOURCES)