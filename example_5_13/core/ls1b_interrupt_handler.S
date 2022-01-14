/*
 * ls1b_interrupt_handler.S
 *
 * created: 2021-09-11
 *  author: 
 */

#include "regdef.h"
#include "cpu.h"
#include "asm.h"

#include "ls1b.h"

//-----------------------------------------------------------------------------

    .text

FRAME(ls1b_interrupt_handler,sp,0,ra)
	.set noreorder

    move    s0, ra

    /*
     * 中断处理代码插在此处
     */

    move    ra, s0
    j       ra
	nop

	.set reorder
ENDFRAME(ls1b_interrupt_handler)

//-----------------------------------------------------------------------------

/*
 * @@ END
 */

