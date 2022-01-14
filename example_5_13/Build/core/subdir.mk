#
# Auto-Generated file. Do not edit!
#

# Add inputs and outputs from these tool invocations to the build variables
ASM_SRCS += \
../core/cache.S \
../core/irq_s.S \
../core/ls1b_exception_handler.S \
../core/ls1b_interrupt_handler.S \
../core/start.S

STARTO += ./core/start.o

OBJS += \
./core/cache.o \
./core/irq_s.o \
./core/ls1b_exception_handler.o \
./core/ls1b_interrupt_handler.o \

ASM_DEPS += \
./core/cache.d \
./core/irq_s.d \
./core/ls1b_exception_handler.d \
./core/ls1b_interrupt_handler.d \
./core/start.d

# Each subdirectory must supply rules for building sources it contributes
core/%.o: ../core/%.S
	@echo 'Building file: $<'
	@echo 'Invoking: SDE Lite C Compiler'
	F:/LoongIDE/mips-2015.05/bin/mips-sde-elf-gcc.exe -mips32 -G0 -EL -msoft-float -DLS1B  -O0 -g -Wall -c -fmessage-length=0 -pipe -I"../" -I"../include" -I"../core/include" -I"../core/mips" -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

