/*
 * bsp_start.S
 *
 * created: 2021-08-14
 *  author:
 */

#include "regdef.h"
#include "cpu.h"
#include "asm.h"

//-----------------------------------------------------------------------------



/*
int str[10] = {23,84,13,92,32,64,57,99,74,19};
    for (i = 0; i < 10 ; i++)
    {
        for (j = i + 1; j < 10; j++)
        {
            if (str[i] > str[j])
            {
                t = str[i];
                str[i] = str[j];
                str[j] = t;
            }

        }
    }
/*




    .text

FRAME(bsp_start,sp,0,ra)
	.set noreorder

    move    s0, ra      /* 返回地址 */

    /*
     * 用户代码插在下面

     */
/*---------------------------------------*/
.data

array: .byte 23,84,13,92,32,64,57,99,74,19  //数组赋值
             

.text
    la v0,array     //将数组头地址放进v0
    addi s0,zero,10  //外循环次数为10 储存到s0
    addi s1,zero,9   //内循环次数为9 储存到s1
    move a1,s1      //将s1->a1

1:
    lbu t1,0(v0)    //提取array[0] 加载到t1
    lbu t2,1(v0)    //提取array[1] 加载到t2
    sltu a0,t1,t2   //如何t1 < t3 则为1 反之
    bgtz a0,2f      //如果a0大于1 则跳转2 继续  反之进行交换
    nop
    sb t1,1(v0)    //将array[1]移到t1中
    sb t2,0(v0)    //将array[0]移到t2中

2:
    addi v0,v0,1    //移到下一个  即array[i+1]
    addi s1,s1,-1   //同时内循环次数-1
    bgtz s1,1b      //如果s1 > 0则跳转到1
    nop
    addi s0,s0,-1   //外循环次数减1
    la v0,array     //将数组头地址重新保存在v0 准备下次排序
    addi a1,a1,-1   //a1-1
    move s1,a1      //a1->s1，控制下一次排序的次数，比之前减1
    bgtz s0,1b      //如果s0 > 0 则跳转到1
    nop
    
    nop             //循环结束


	.set reorder
ENDFRAME(bsp_start)

//-----------------------------------------------------------------------------

/*
 * @@ END
 */


