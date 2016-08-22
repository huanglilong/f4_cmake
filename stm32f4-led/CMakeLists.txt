#
# @author   : huang li long <huanglilongwk@outlook.com>
# @time     : 2016/08/19
# @brief    : for learning cmake 
# @ref      : https://github.com/ObKo/stm32-cmake
#

# set CMAKE_MODULE_PATH for search modules
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../cmake ${CMAKE_MODULE_PATH})

# set CMAKE_TOOLCHAIN_FILE for closs compile 
set(CMAKE_TOOLCHAIN_FILE ../cmake/gcc_stm32.cmake)

# After PROJECT() command, execute toolchain-file.cmake
project(stm32f4-led)
cmake_minimum_required(VERSION 2.8)
enable_language(ASM)

# build type -- debug
set(CMAKE_BUILD_TYPE Debug)

# find stm32's package -- library and header files
find_package(CMSIS REQUIRED)
find_package(STM32HAL COMPONENTS gpio REQUIRED)

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMSIS_INCLUDE_DIRS}
	${STM32HAL_INCLUDE_DIR}
)

set(PROJECT_SOURCES
    main.c
	stm32f429i_discovery.c
	stm32f4xx_it.c
)

add_executable(${CMAKE_PROJECT_NAME} ${PROJECT_SOURCES} ${CMSIS_SOURCES} ${STM32HAL_SOURCES})

# set linker script
STM32_LINKER_SCRIPT(${CMAKE_PROJECT_NAME})

# produce bin and hex file
STM32_ADD_HEX_BIN_TARGETS(${CMAKE_PROJECT_NAME})
