/*
 * putcharr.c
 *
 * created: 2021/12/22
 *  author: 
 */


#include "uart3.h"


int _putchar1(char ch)
{
    uart3_write(( unsigned char *)&ch, 1);   //�޷���ǿ������ת�������ַ�
    return 0;
}

