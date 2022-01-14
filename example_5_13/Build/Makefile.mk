#
# Auto-generated file. Do not edit!
#

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include objects.mk
-include subdir.mk
-include core/subdir.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(CPP_DEPS)),)
-include $(CPP_DEPS)
endif
ifneq ($(strip $(ASM_DEPS)),)
-include $(ASM_DEPS)
endif
endif

-include ../makefile.defs

OUT_ELF=example_5_13.exe
OUT_MAP=example_5_13.map
OUT_BIN=example_5_13.bin

LINKCMDS=../ld.script

# Add inputs and outputs from these tool invocations to the build variables

# All Target
all: $(OUT_ELF)

# Tool invocations
$(OUT_ELF): $(STARTO) $(OBJS) $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: SDE Lite C Linker'
	F:/LoongIDE/mips-2015.05/bin/mips-sde-elf-gcc.exe  -mips32 -G0 -EL -msoft-float -nostartfiles -nodefaultlibs -nostdlib -static -T $(LINKCMDS) -o $(OUT_ELF) -e start $(STARTO) $(OBJS) $(USER_OBJS) $(LIBS) 
	@echo 'Invoking: SDE Lite C Objcopy'
	F:/LoongIDE/mips-2015.05/bin/mips-sde-elf-objcopy.exe -O binary $(OUT_ELF) $(OUT_BIN)
	@echo 'Invoking: SDE Lite C Size'
	F:/LoongIDE/mips-2015.05/bin/mips-sde-elf-size.exe $(OUT_ELF)
	@echo 'Finished building target: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(STARTO) $(OBJS) $(C_DEPS) $(CPP_DEPS) $(ASM_DEPS) $(EXECUTABLES) $(OUT_ELF) $(OUT_MAP) $(OUT_BIN)
	-@echo ' '

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets


