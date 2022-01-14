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
    #error "��bsp.h��ѡ������ XPT2046_DRV ���� GT1151_DRV"
           "XPT2046_DRV:  ����800*480 �����Ĵ�����."
           "GT1151_DRV:   ����480*800 �����Ĵ�����."
           "�������ѡ��, ע�͵��� error ��Ϣ, Ȼ���Զ���: LCD_display_mode[]"
  #endif
#endif

//-------------------------------------------------------------------------------------------------
// ������
//-------------------------------------------------------------------------------------------------

void init_input(){
    gpio_enable(30, DIR_IN);
    gpio_enable(7, DIR_IN);
    gpio_enable(6, DIR_IN);
    gpio_enable(20, DIR_IN);
}

void init_output(){
    gpio_enable(28, DIR_OUT);
    gpio_enable(4, DIR_OUT);
    gpio_enable(5, DIR_OUT);
    gpio_enable(23, DIR_OUT);
    gpio_enable(21, DIR_OUT);
    gpio_enable(16, DIR_OUT);
    gpio_enable(12, DIR_OUT);
    gpio_enable(10, DIR_OUT);
}

void flow(){
    gpio_write(28,1);
    gpio_write(4,1);
    gpio_write(5,1);
    gpio_write(23,1);
    gpio_write(21,1);
    gpio_write(16,1);
    gpio_write(12,1);
    gpio_write(10,1);
}

void flow_rea(){
    flow();
    gpio_write(28,0);
    delay_ms(200);
    flow();
    gpio_write(4,0);
    delay_ms(200);
    flow();
    gpio_write(5,0);
    delay_ms(200);
    flow();
    gpio_write(23,0);
    delay_ms(200);
    flow();
    gpio_write(21,0);
    delay_ms(200);
    flow();
    gpio_write(16,0);
    delay_ms(200);
    flow();
    gpio_write(12,0);
    delay_ms(200);
    flow();
    gpio_write(10,0);
    delay_ms(200);
}


void control_led(){
    int i=0;
    for(;;){
        if(gpio_read(30)==0){
            i=1;
        }
        if(gpio_read(7)==0){
            i=2;
        }
        if(gpio_read(6)==0){
            i=3;
        }
        if(gpio_read(20)==0){
            i=4;
        }
        if(i==1){
            flow_rea();
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

    //flow_rea();
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
