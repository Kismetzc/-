/*
 * Copyright (C) 2020-2021 Suzhou Tiancheng Software Ltd.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

/*
 * Loongson 1B Bare Program, Sample main file
 */

#include <stdio.h>

#include "ls1b.h"
#include "mips.h"

#include "ls1b_gpio.h"

//-------------------------------------------------------------------------------------------------
// BSP
//-------------------------------------------------------------------------------------------------

#include "bsp.h"

#ifdef BSP_USE_FB
  #include "ls1x_fb.h"
  #ifdef XPT2046_DRV
    char LCD_display_mode[] = LCD_800x480;
  #elif defined(GT1151_DRV)
    char LCD_display_mode[] = LCD_480x800;
  #else
    #error "在bsp.h中选择配置 XPT2046_DRV 或者 GT1151_DRV"
           "XPT2046_DRV:  用于800*480 横屏的触摸屏."
           "GT1151_DRV:   用于480*800 竖屏的触摸屏."
           "如果都不选择, 注释掉本 error 信息, 然后自定义: LCD_display_mode[]"
  #endif
#endif

//-------------------------------------------------------------------------------------------------
// 主程序
//-------------------------------------------------------------------------------------------------

void init_input(){
    gpio_enable(4, DIR_IN);
    gpio_enable(5, DIR_IN);
    gpio_enable(23, DIR_IN);
    gpio_enable(21, DIR_IN);
}

void init_output(){
    gpio_enable(29, DIR_OUT);
    gpio_enable(30, DIR_OUT);
    gpio_enable(7, DIR_OUT);
    gpio_enable(6, DIR_OUT);
    gpio_enable(22, DIR_OUT);
    gpio_enable(20, DIR_OUT);
    gpio_enable(17, DIR_OUT);
    gpio_enable(15, DIR_OUT);
}


void breath_led()
{
    gpio_write(29,0);
    delay_ms(1000);
    gpio_write(29,1);
    delay_ms(1000);
    gpio_write(29,0);
    delay_ms(1000);

    gpio_write(30,0);
    delay_ms(1000);
    gpio_write(30,1);
    delay_ms(1000);
    gpio_write(29,0);
    delay_ms(1000);

    gpio_write(7,0);
    delay_ms(1000);
    gpio_write(7,1);
    delay_ms(1000);
    gpio_write(7,0);
    delay_ms(1000);

    gpio_write(6,0);
    delay_ms(1000);
    gpio_write(6,1);
    delay_ms(1000);
    gpio_write(6,0);
    delay_ms(1000);
    control_led();
}

void flow(){
    gpio_write(29,1);
    gpio_write(30,1);
    gpio_write(7,1);
    gpio_write(6,1);
    gpio_write(22,1);
    gpio_write(20,1);
    gpio_write(17,1);
    gpio_write(15,1);
}


void flow_rea(){
    flow();
    gpio_write(29,0);
    delay_ms(200);
    flow();
    gpio_write(30,0);
    delay_ms(200);
    flow();
    gpio_write(7,0);
    delay_ms(200);
    flow();
    gpio_write(6,0);
    delay_ms(200);
    flow();
    gpio_write(22,0);
    delay_ms(200);
    flow();
    gpio_write(20,0);
    delay_ms(200);
    flow();
    gpio_write(17,0);
    delay_ms(200);
    flow();
    gpio_write(15,0);
    delay_ms(200);
    control_led();
}


void control_led()
{
    int i=0;
    for(;;)
    {
        if(gpio_read(4)==0)
        {
            i=1;
            flow_rea();
        }
        if(gpio_read(5)==0)
        {
            i=2;
            breath_led();
        }
        if(gpio_read(23)==0)
        {
            i=3;
        }
        if(gpio_read(21)==0)
        {
            i=4;
        }
    }
}


int main(void)
{
    printk("\r\nmain() function.\r\n");

    ls1x_drv_init();            		/* Initialize device drivers */

    install_3th_libraries();      		/* Install 3th libraies */

    init_input();
    init_output();

    breath_led();
    control_led();
    delay_ms(100);

    /*
     * Never goto here!
     */
    return 0;
}

/*
 * @@ End
 */
