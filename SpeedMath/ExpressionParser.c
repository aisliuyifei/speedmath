//
//  ExpressionParser.cpp
//  CloudClassRoomForStudent
//
//  Created by 鹏 吴 on 3/15/12.
//  Copyright (c) 2012 galiumsoft. All rights reserved.
//

#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
void trans( char a[], char b[] )
{
	char stock[128]= {0};
    
	int top = 0;
    int len = 0;
	int i = 0;
	int j = 0;
	
	top = -1;
	j = -1;
    len = strlen(a);
	
    for ( i = 0; i<len; i++ )
    {
        switch( a[i] )
        {
            case '(':
                stock[++top] = '(';
                break;
                
            case '+':
            case '-':
                while( top >= 0 && stock[top] != '(' )
                {
                    b[++j] = stock[top--];
                }
                stock[++top] = ' '; 
                stock[++top] = a[i];
                break;
                
            case '*':
            case '/':
                while( top >= 0 && stock[top] != '(' && stock[top] != '+' && stock[top] != '-' )
                {
                    b[++j] = stock[top--];
                }
                stock[++top] = ' ';
                stock[++top] = a[i];
                break;
                
            case')':
                while( stock[top]!='(' )
                {
                    b[++j] = stock[top--];
                }
                top--;
                break;
                
            default:
                b[++j] = a[i];
                if( i == len-1 || a[i+1]<'0' || a[i+1]>'9' )
                {
                    if ( a[i+1] != '.' )
                    {
                        b[++j] = ' ';
                    }
                }
                break;
        }
    }
    
    while ( top >= 0 )
	{
        b[++j] = stock[top--];
	}
	
    b[++j] = '\0';
}

double compvalue( char exp[] )
{
	int top = 0;
	int len = 0;
    int i = 0;
	int c = 0;
    
	double sum = 0;
	double digit[128]= {0};
    
	char str_num_temp[128]= {0};
	
    top = -1;
    len = strlen(exp);
	
    for ( i = 0; i<len; i++ )
    {
        switch( exp[i] )
        {
            case ' ':
                break;
                
            case '+': 
                sum = digit[top] + digit[top-1];
                digit[--top] = sum;
                break;
                
            case '-':
                sum = digit[top-1] - digit[top];
                digit[--top] = sum;
                break;
                
            case '*':
                sum = digit[top] * digit[top-1];
                digit[--top] = sum;
                break;
                
            case '/':
                sum = digit[top-1] / digit[top];
                digit[--top] = sum;
                break;
                
            default:
                c = 0;
                memset( str_num_temp, 0, sizeof(str_num_temp) );
                while( (exp[i]>='0' && exp[i]<='9') || exp[i] == '.' )
                {
                    str_num_temp[c++] = exp[i];
                    i++;
                }
                str_num_temp[c] = '\0';
                digit[++top] = atof(str_num_temp);
                break;
        }
    }
	
    return digit[0];
}

double ExpressionParser( char *Expression )
{
	char temp[128]= {0};
	trans( Expression, temp );
	return compvalue( temp );
}
