#
# author	: huang li long <huanglilongwk@outlook.com>
# time		: 2016/08/19
# brief		: 
# ref       : https://github.com/ObKo/stm32-cmake/blob/master/cmake/gcc_stm32f4.cmake
#

# comiler flags
set(CMAKE_C_FLAGS "-mthumb -fno-builtin -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=softfp -Wall -std=gnu99 -ffunction-sections -fdata-sections -fomit-frame-pointer -mabi=aapcs -fno-unroll-loops -ffast-math -ftree-vectorize" CACHE INTERNAL "c compiler flags")
set(CMAKE_CXX_FLAGS "-mthumb -fno-builtin -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=softfp -Wall -std=c++11 -ffunction-sections -fdata-sections -fomit-frame-pointer -mabi=aapcs -fno-unroll-loops -ffast-math -ftree-vectorize" CACHE INTERNAL "cxx compiler flags")
set(CMAKE_ASM_FLAGS "-mthumb -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=softfp -x assembler-with-cpp" CACHE INTERNAL "asm compiler flags")

# linker flags
set(CMAKE_EXE_LINKER_FLAGS "-Wl,--gc-sections -mthumb -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=softfp -mabi=aapcs" CACHE INTERNAL "executable linker flags")
set(CMAKE_MODULE_LINKER_FLAGS "-mthumb -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=softfp -mabi=aapcs" CACHE INTERNAL "module linker flags")
set(CMAKE_SHARED_LINKER_FLAGS "-mthumb -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=softfp -mabi=aapcs" CACHE INTERNAL "shared linker flags")

# set up stm32cub's definitions 
add_definitions(-DSTM32F429xx)

# set linker script
function(STM32_LINKER_SCRIPT TARGET)
    get_target_property(TARGET_LD_FLAGS ${TARGET} LINK_FLAGS)
    set(TARGET_LD_FLAGS "-T${CMAKE_CURRENT_SOURCE_DIR}/STM32F429ZITx_FLASH.ld")
    set_target_properties(${TARGET} PROPERTIES LINK_FLAGS ${TARGET_LD_FLAGS})
endfunction()

# create bin and hex file from elf target
function(STM32_ADD_HEX_BIN_TARGETS TARGET)
    if(EXECUTABLE_OUTPUT_PATH)
        set(FILENAME "${EXECUTABLE_OUTPUT_PATH}/${TARGET}") # save bin and hex in this path 
    else()
        set(FILENAME "${TARGET}")   # save bin and hex in current path 
    endif()
    add_custom_command(TARGET ${TARGET}
                       DEPENDS ${TARGET}
                       COMMAND ${CMAKE_OBJCOPY} -Oihex ${FILENAME} ${FILENAME}.hex)
    add_custom_command(TARGET ${TARGET}
                       DEPENDS ${TARGET}
                       COMMAND ${CMAKE_OBJCOPY} -Obinary ${FILENAME} ${FILENAME}.bin)     
endfunction()