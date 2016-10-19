
# SET(SEMIHOSTING "enable")


include(stm32.cmake)

# Нужен cmake >=2.6
CMAKE_MINIMUM_REQUIRED(VERSION 2.6)


PROJECT(stm32template)


# Включаем ассемблер
ENABLE_LANGUAGE(ASM)

# Размера флеша
SET(STM32_FLASH_SIZE "64K")
# Размер рамы
SET(STM32_RAM_SIZE "20K")
# Адрес стека - конец оперативки => 0x20000000 + размер оперативки
SET(STM32_STACK_ADDRESS "0x20010000")

# Адреса RAM и Flash
SET(STM32_FLASH_ORIGIN "0x08000000")
SET(STM32_RAM_ORIGIN "0x20000000")



# Дерективы препроцессора, нужные для библиотеки STM.
ADD_DEFINITIONS(
# Тут нужно подставить свой чип (MD, MD_VL и т.д)
  -DSTM32F10X_MD
  -DUSE_STDPERIPH_DRIVER
)

# Стартовый файл
# Тут нужно подставить свой чип (MD, MD_VL и т.д)
SET(STARTUP_SOURCE ${STM32_STARTUP_MD})

# Какие модули собирать
SET(MOD_SOURCES
#  ${STM32_MISC_SOURCE}
#  ${STM32_ADC_SOURCE}
#  ${STM32_BKP_SOURCE}
#  ${STM32_CAN_SOURCE}
#  ${STM32_CEC_SOURCE}
#  ${STM32_CRC_SOURCE}
#  ${STM32_DAC_SOURCE}
#  ${STM32_DBGMCU_SOURCE}
#  ${STM32_DMA_SOURCE}
#  ${STM32_EXTI_SOURCE}
#  ${STM32_FLASH_SOURCE}
#  ${STM32_FSMC_SOURCE}
#  ${STM32_GPIO_SOURCE}
#  ${STM32_I2C_SOURCE}
#  ${STM32_IWDG_SOURCE}
#  ${STM32_PWR_SOURCE}
#  ${STM32_RCC_SOURCE}
#  ${STM32_RTC_SOURCE}
#  ${STM32_SDIO_SOURCE}
#  ${STM32_SPI_SOURCE}
#  ${STM32_TIM_SOURCE}
#  ${STM32_USART_SOURCE}
#  ${STM32_WWDG_SOURCE}
)



##################################################################################
# add all sources and headers from ./src
# Исходники проекта 
##################################################################################
file(GLOB_RECURSE SRC_C_FILES ${PROJECT_SOURCE_DIR}/src/*.c)
file(GLOB_RECURSE SRC_CXX_FILES ${PROJECT_SOURCE_DIR}/src/*.cpp)
file(GLOB_RECURSE SRC_HEADERS ${PROJECT_SOURCE_DIR}/src/*.h)
include_directories(${PROJECT_SOURCE_DIR}/src/)
SET(PROJECT_SOURCES
  ${SRC_C_FILES}
  ${SRC_CXX_FILES}
  ${SRC_HEADERS}
)

# Исходники стандартых обработчиков прерываний и CMSIS
SET(SERVICE_SOURCES
  ${STM32_SYSTEM_SOURCE}
)

# Флаги компилятора для разных типов сборки.
SET(COMPILE_DEFINITIONS_DEBUG -O0 -g3 -DDEBUG)
SET(COMPILE_DEFINITIONS_RELEASE -Os)

# Конфигурируем файл - скрипт компилятора: заменяем переменные в файле на размеры и адреса
CONFIGURE_FILE(${CMAKE_CURRENT_SOURCE_DIR}/stm32_flash.ld.in ${CMAKE_CURRENT_BINARY_DIR}/stm32_flash.ld)
SET(CMAKE_EXE_LINKER_FLAGS "-T${CMAKE_CURRENT_BINARY_DIR}/stm32_flash.ld ${CMAKE_EXE_LINKER_FLAGS}")

# Добавляем пути поиска заголовочных файлов
INCLUDE_DIRECTORIES(
  ${CMAKE_CURRENT_SOURCE_DIR}/.
  ${STM32_StdPeriphLib_INCLUDE_DIRS}
)

# Собираем исходники пректа, модули, и т.д. в elf
ADD_EXECUTABLE(${CMAKE_PROJECT_NAME}.elf ${PROJECT_SOURCES} ${MOD_SOURCES} ${STARTUP_SOURCE} ${SERVICE_SOURCES})

# Конвертируем elf в hex и bin

ADD_CUSTOM_COMMAND(TARGET ${CMAKE_PROJECT_NAME}.elf POST_BUILD COMMAND ${CMAKE_OBJCOPY} ARGS -Oihex ${CMAKE_PROJECT_NAME}.elf ${CMAKE_PROJECT_NAME}.hex)
ADD_CUSTOM_COMMAND(TARGET ${CMAKE_PROJECT_NAME}.elf POST_BUILD COMMAND ${CMAKE_OBJCOPY} ARGS -Obinary ${CMAKE_PROJECT_NAME}.elf ${CMAKE_PROJECT_NAME}.bin)
