# Путь к тулчейну
if(DEFINED ENV{ARM_TOOLCHAIN_PATH})
	SET(TOOLCHAIN_DIR $ENV{ARM_TOOLCHAIN_PATH})
else()
	message(FATAL_ERROR "Please set ARM_TOOLCHAIN_PATH environment value")
endif()

# Путь к библиотеке стандартной переферии.
if(DEFINED ENV{STM32_StdPeriphLib_DIR})
	SET(STM32_StdPeriphLib_DIR $ENV{STM32_StdPeriphLib_DIR})
else()
	message(FATAL_ERROR "Please set STM32_StdPeriphLib_DIR environment value")
endif()


# Пути, где лежат заголовки
SET(STM32_StdPeriphLib_INCLUDE_DIRS
    ${STM32_StdPeriphLib_DIR}/Libraries/STM32F10x_StdPeriph_Driver/inc/
    ${STM32_StdPeriphLib_DIR}/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/
    ${STM32_StdPeriphLib_DIR}/Libraries/CMSIS/CM3/CoreSupport/
)

# Другие полезные пути
SET(TOOLCHAIN_BIN_DIR ${TOOLCHAIN_DIR}/bin)
SET(TOOLCHAIN_LIBC_DIR ${TOOLCHAIN_DIR}/arm-none-eabi/libc)
SET(TOOLCHAIN_INC_DIR ${TOOLCHAIN_LIBC_DIR}/include)
SET(TOOLCHAIN_LIB_DIR ${TOOLCHAIN_DIR}/arm-none-eabi/lib/)
link_directories(${TOOLCHAIN_LIB_DIR})

SET(CMAKE_SYSTEM_NAME Linux CACHE INTERNAL "system name")
SET(CMAKE_SYSTEM_PROCESSOR arm CACHE INTERNAL "processor")

if(WIN32)
    SET(EXE_SUFFIX ".exe")
else()
    SET(EXE_SUFFIX "")
endif()
# Компиляторы
SET(CMAKE_C_COMPILER "${TOOLCHAIN_BIN_DIR}/arm-none-eabi-gcc${EXE_SUFFIX}" CACHE INTERNAL "")
SET(CMAKE_CXX_COMPILER "${TOOLCHAIN_BIN_DIR}/arm-none-eabi-g++${EXE_SUFFIX}" CACHE INTERNAL "")
SET(CMAKE_ASM_COMPILER "${TOOLCHAIN_BIN_DIR}/arm-none-eabi-gcc${EXE_SUFFIX}" CACHE INTERNAL "")
# objcopy и objdump для создания хексов и бинариков
SET(CMAKE_OBJCOPY "${TOOLCHAIN_BIN_DIR}/arm-none-eabi-objcopy${EXE_SUFFIX}" CACHE INTERNAL "")
SET(CMAKE_OBJDUMP "${TOOLCHAIN_BIN_DIR}/arm-none-eabi-objdump${EXE_SUFFIX}" CACHE INTERNAL "")
SET(CMAKE_SIZE "${TOOLCHAIN_BIN_DIR}/arm-none-eabi-size${EXE_SUFFIX}" CACHE INTERNAL "")

# Включаем ассемблер
ENABLE_LANGUAGE(ASM)

SET(CMAKE_SYSTEM_NAME Generic)
SET(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_C_COMPILER_WORKS 1)
set(CMAKE_CXX_COMPILER_WORKS 1)
SET(CMAKE_CROSSCOMPILING 1)
IF(SEMIHOSTING STREQUAL "enable")
  message(STATUS "Arm semihosting: Enabled")
  ADD_DEFINITIONS(-DSEMIHOSTING_ENABLE)
  SET(EXTRA_FLAGS_SEMIHOSTING "--specs=rdimon.specs -lc -lrdimon")
else()
  message(STATUS "Arm semihosting: Disabled")

ENDIF()

# Установка HSE_VALUE
if(NOT HSE_VALUE)
    message(STATUS "Setting HSE to default")
else()
    message(STATUS "Setting HSE to ${HSE_VALUE}")
    ADD_DEFINITIONS("-DHSE_VALUE=${HSE_VALUE}")

endif()

# Флаги компиляторов, тут можно подкрутить
SET(CMAKE_C_FLAGS "-isystem ${TOOLCHAIN_INC_DIR} -mthumb -mcpu=cortex-m3 -fno-builtin -Wall -std=gnu99 ${EXTRA_FLAGS_SEMIHOSTING}" CACHE INTERNAL "c compiler flags")
SET(CMAKE_CXX_FLAGS "-isystem ${TOOLCHAIN_INC_DIR} -mthumb -mcpu=cortex-m3 -fno-builtin -Wall " CACHE INTERNAL "cxx compiler flags")
SET(CMAKE_EXE_LINKER_FLAGS "-nostartfiles -Wl,-Map -Wl,main.map -mthumb -mcpu=cortex-m3 " CACHE INTERNAL "exe link flags")
SET(CMAKE_MODULE_LINKER_FLAGS "-L${TOOLCHAIN_LIB_DIR}" CACHE INTERNAL "module link flags")
SET(CMAKE_SHARED_LINKER_FLAGS "-L${TOOLCHAIN_LIB_DIR}" CACHE INTERNAL "shared lnk flags")
SET(CMAKE_SHARED_LIBRARY_LINK_C_FLAGS)

SET(CMAKE_FIND_ROOT_PATH ${TOOLCHAIN_LIBC_DIR} CACHE INTERNAL "cross root directory")
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM BOTH CACHE INTERNAL "")
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY CACHE INTERNAL "")
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY CACHE INTERNAL "")

# Стартовые файлы - в них происходит низкоуровневая (начальная) инициализация чипа
SET(STM32_STARTUP_CL ${STM32_StdPeriphLib_DIR}/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/startup/gcc_ride7/startup_stm32f10x_cl.s)
SET(STM32_STARTUP_HD ${STM32_StdPeriphLib_DIR}/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/startup/gcc_ride7/startup_stm32f10x_hd.s)
SET(STM32_STARTUP_HD_VL ${STM32_StdPeriphLib_DIR}/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/startup/gcc_ride7/startup_stm32f10x_hd_vl.s)
SET(STM32_STARTUP_LD ${STM32_StdPeriphLib_DIR}/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/startup/gcc_ride7/startup_stm32f10x_ld.s)
SET(STM32_STARTUP_LD_VL ${STM32_StdPeriphLib_DIR}/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/startup/gcc_ride7/startup_stm32f10x_ld_vl.s)
SET(STM32_STARTUP_MD ${STM32_StdPeriphLib_DIR}/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/startup/gcc_ride7/startup_stm32f10x_md.s)
SET(STM32_STARTUP_MD_VL ${STM32_StdPeriphLib_DIR}/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/startup/gcc_ride7/startup_stm32f10x_md_vl.s)
SET(STM32_STARTUP_XL ${STM32_StdPeriphLib_DIR}/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/startup/gcc_ride7/startup_stm32f10x_xl.s)

# Исходник CMSIS
SET(STM32_SYSTEM_SOURCE ${STM32_StdPeriphLib_DIR}/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/system_stm32f10x.c)

# Модули библиотеки стандартной переферии
SET(STM32_MISC_SOURCE ${STM32_StdPeriphLib_DIR}/Libraries/STM32F10x_StdPeriph_Driver/src/misc.c)
SET(STM32_ADC_SOURCE ${STM32_StdPeriphLib_DIR}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_adc.c)
SET(STM32_BKP_SOURCE ${STM32_StdPeriphLib_DIR}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_bkp.c)
SET(STM32_CAN_SOURCE ${STM32_StdPeriphLib_DIR}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_can.c)
SET(STM32_CEC_SOURCE ${STM32_StdPeriphLib_DIR}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_cec.c)
SET(STM32_CRC_SOURCE ${STM32_StdPeriphLib_DIR}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_crc.c)
SET(STM32_DAC_SOURCE ${STM32_StdPeriphLib_DIR}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_dac.c)
SET(STM32_DBGMCU_SOURCE ${STM32_StdPeriphLib_DIR}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_dbgmcu.c)
SET(STM32_DMA_SOURCE ${STM32_StdPeriphLib_DIR}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_dma.c)
SET(STM32_EXTI_SOURCE ${STM32_StdPeriphLib_DIR}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_exti.c)
SET(STM32_FLASH_SOURCE ${STM32_StdPeriphLib_DIR}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_flash.c)
SET(STM32_FSMC_SOURCE ${STM32_StdPeriphLib_DIR}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_fsmc.c)
SET(STM32_GPIO_SOURCE ${STM32_StdPeriphLib_DIR}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_gpio.c)
SET(STM32_I2C_SOURCE ${STM32_StdPeriphLib_DIR}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_i2c.c)
SET(STM32_IWDG_SOURCE ${STM32_StdPeriphLib_DIR}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_iwdg.c)
SET(STM32_PWR_SOURCE ${STM32_StdPeriphLib_DIR}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_pwr.c)
SET(STM32_RCC_SOURCE ${STM32_StdPeriphLib_DIR}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_rcc.c)
SET(STM32_RTC_SOURCE ${STM32_StdPeriphLib_DIR}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_rtc.c)
SET(STM32_SDIO_SOURCE ${STM32_StdPeriphLib_DIR}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_sdio.c)
SET(STM32_SPI_SOURCE ${STM32_StdPeriphLib_DIR}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_spi.c)
SET(STM32_TIM_SOURCE ${STM32_StdPeriphLib_DIR}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_tim.c)
SET(STM32_USART_SOURCE ${STM32_StdPeriphLib_DIR}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_usart.c)
SET(STM32_WWDG_SOURCE ${STM32_StdPeriphLib_DIR}/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_wwdg.c)
SET(SMT32_CMSIS_CORE_CM3 ${STM32_StdPeriphLib_DIR}/Libraries/CMSIS/CM3/CoreSupport/core_cm3.c)

