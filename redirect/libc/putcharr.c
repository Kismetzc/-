/*
 * putcharr.c
 *
 * created: 2021/12/22
 *  author: 
 */


#include "uart3.h"


int _putchar1(char ch)
{
    uart3_write(( unsigned char *)&ch, 1);   //无符号强制类型转换，单字符
    return 0;
}

