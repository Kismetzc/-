/*
 * Copyright (C) 2020-2021 Suzhou Tiancheng Software Ltd.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <string.h>

#include "bsp.h"

#if defined(LS1B)
#include "ls1b.h"
#include "ls1b_irq.h"
#elif defined(LS1C)
#include "ls1c.h"
#include "ls1c_irq.h"
#else
#error "No Loongson1x Soc defined."
#endif

#include "cpu.h"
#include "mips.h"

#include "tick.h"

extern void except_common_entry(void);
extern void mips_init_isr_table(void);
extern void console_init(unsigned int baudrate);
extern int main(void);

/*
 * LS1x bsp start
 */
void bsp_start(void)
{
    mips_interrupt_disable();

    /*
     *安装 exec vec。 数据<==>指令必须使用K1地址
     */
	memcpy((void *)K0_TO_K1(T_VEC), except_common_entry, 40);
	memcpy((void *)K0_TO_K1(C_VEC), except_common_entry, 40);
	memcpy((void *)K0_TO_K1(E_VEC), except_common_entry, 40);

    mips_init_isr_table();          /* 初始化isr表 */
    
    console_init(115200);           /* 初始化控制台 */

    Clock_initialize();             /* 初始化代码 */

    /*
     * 启用所有中断，FPU
     */
#if __mips_hard_float
    mips_unmask_interrupt(SR_CU1 | SR_IMASK | SR_IE);
#else
    mips_unmask_interrupt(SR_IMASK | SR_IE);
#endif

    /* 转到主函数 */
    main();
}


