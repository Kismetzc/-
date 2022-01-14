/*
 * Copyright (C) 2020-2021 Suzhou Tiancheng Software Ltd.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

/*
 * Typical standalone start up code required for MIPS32
 */

#include "regdef.h"
#include "cpu.h"
#include "asm.h"

    .extern init_common_exception_vector
    
	.extern _fbss, 4                        /* The name in ld.script */
	.extern _end, 4                         /* The name in ld.script */
	.extern _stack_start, 4                 /* The name in ld.script */
	.extern _stack_end, 4                   /* The name in ld.script */

	.lcomm  memory_cfg_struct, 12           /* 1st: 4 bytes, memory size
	                                         * 2st: 4 bytes, icache size
	                                         * 3th: 4 bytes, dcache size
	                                         */

	.text

//-----------------------------------------------------------------------------
//初始化C0
FRAME(start, sp, 0, ra)
    .set    noreorder

    mtc0    zero, C0_SR                    /* 清除 IntMsks/ 内核/禁用模式 */
    nop
    li      v0, CAUSE_DC
    mtc0    v0, C0_CAUSE                    /* 清除软件中断 */
    nop
    
    lui     v0, 0xFFFF
    mtc0    v0, C0_COMPARE                  /* 可能是 COUNT/COMPARE 中断，清除它。
    nop

/******************************************************************************
 * Because of we are start form pmon, boot-initialization things has done.
 * If we start form FLASH, we must do these thing here.
 ******************************************************************************/

    la      gp, _gp                         /* Initialize gp register (pointer to "small" data)*/

/*
 * clear bss before using it
 */
    la      v0, _fbss                       /* start of bss */
    la      v1, _end                        /* end of bss */
3:
    sw      zero, 0(v0)
    bltu    v0, v1, 3b
    add     v0, 4

/*
 * Set system stack. The stack is in .bss segment and has cleared, see ld.script
 */
    la      t0, _stack_end            
    sub     t0, t0, (4 * 4)                 /* XXX overhead */
    move    sp, t0  
    nop

/*
 * Set memory size global
 */
    la      a0, _RamSize 
    jal     set_memory_size
	nop
	
/*
 * determine size of D & I caches of LS232, the routine is in "cache.S"
 */
    jal     config_cache
    nop
    
/*
 * fill memory config struct
 */
    la      a0, memory_cfg_struct
    jal     get_memory_conf
    nop

/*
 * Initialize cache now. clear all
 */
    jal     flush_cache                     /* cache 操作的汇编不能单步跟踪 */
    nop
    
/*
 * Enable cache
 */
    mfc0    v0, C0_CONFIG, 0                /* set K0 "cacheable noncoherent" mode */
    and     v0, v0, ~CFG0_K0
    or      v0, v0, CFG_C_CACHABLE          /* = 0x03 */
    mtc0    v0, C0_CONFIG, 0
    nop

/*
 * Install the mips exception vector
 */
    jal     init_common_exception_vector

/*
 * End of CPU initialization, ready to start kernel
 */
    move    a0, zero                        /* Set argc passed to main */
    jal     bsp_start
    nop

/*
 * Kernel has been shutdown, jump to the "exit" routine
 */
    jal     _sys_exit
    move    a0, v0                          # pass through the exit code

/*
 * XXX 代码执行不到此处
 */
1:
    beq     zero, zero, 1b
    nop

    .set    reorder
ENDFRAME(start)

//-----------------------------------------------------------------------------

/*
 * _sys_exit -- Exit from the application. Normally we cause a user trap
 *              to return to the ROM monitor for another run. NOTE: This is
 *              the only other routine we provide in the crt0.o object, since
 *              it may be tied to the "_start" routine. It also allows
 *              executables that contain a complete world to be linked with
 *              just the crt0.o object.
 */

FRAME(_sys_exit,sp,0,ra)
    break   1023
    nop
13:
    b       13b                     /* but loop back just in-case */
    nop
ENDFRAME(_sys_exit)

//-----------------------------------------------------------------------------

/*
 * function: get_memory_size()
 * return:   memory size.
 */
FRAME(get_memory_size,sp,0,ra)
    .set    noreorder
    la      a0, memory_cfg_struct
    lw      a0, 0(a0)               /* Get memory size from struct */
    move    v0, a0                  /* memory_size */
    j       ra
    nop
    .set    reorder
ENDFRAME(get_memory_size)

//-----------------------------------------------------------------------------
// end of start.S
//-----------------------------------------------------------------------------

/*
 * @@ END
 */

