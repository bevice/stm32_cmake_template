
#STM32F103 Project Template

## Переменные среды 

* ARM_TOOLCHAIN_PATH - путь к установленному тулчейну 
* STM32_StdPeriphLib_DIR - путь к StdPerithLib (STM32F10x_StdPeriph_Lib_V3.5.0)

## Flashing

### st-link tools
     st-flash --reset write firmware.bin 0x8000000


## OpenOCD

	openocd -f /usr/local/share/openocd/scripts/interface/stlink-v2.cfg -f /usr/local/share/openocd/scripts/target/stm32f1x.cfg 


## GDB script (.gdbinit):

	target extended localhost:3333
	monitor arm semihosting enable
	monitor reset halt
	load
	monitor reset init
