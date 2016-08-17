#include "MPosOfLine.h"

MPosOfLine::MPosOfLine()
{

}

MPosOfLine::~MPosOfLine()
{

}

public function PosOfLine() 
{
			
}
//输入:有","分隔的3个数字
public function parse(str:String):void
{
	var list:Array = str.split(",");
	m_x = parseInt(list[0]);
	m_y = parseInt(list[1]);
	m_dir = parseInt(list[2]);
}