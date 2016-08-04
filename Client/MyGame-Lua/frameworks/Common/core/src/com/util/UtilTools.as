package com.util
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.ByteArray;
	//import flash.utils.Dictionary;		
		
	/**
	 * @brief 各种通用功能
	 */
	public class UtilTools
	{
		//public static var m_gkContext:GkContext;
		/*
		 *向bytes中写入字符串,最多写入len - 1个字节。且保证写入的字符串是以零结尾的
		 */
		public static function writeStr(bytes:ByteArray, str:String, len:int, coding:String = "utf-8"):void
		{
			if (str == null)
			{
				bytes.writeByte(0);
				bytes.position += (len - 1);
			}
			else
			{
				var posInit:int = bytes.position;
				var posEnd:int = bytes.position + len;
				bytes.writeMultiByte(str, coding);
				bytes.writeByte(0);
				bytes.position = posEnd;
				bytes.length = posEnd;
			}
		}
		
		/*public static function swFilter(str:String):String
		{
			return m_gkContext.m_SWMgr.filter(str);
		}*/
		
		/*
		 * 向bytes中写入字符串的长度(单位是字节),然后把完整的字符串写入。写入的字符串不是以零结尾的
		 * bytesOfSize表示长度的字节数量，可以为1,2,4个字节
		 */
		public static function writeStrUnfixed(bytes:ByteArray, str:String, bytesOfSize:uint = 2, coding:String = "utf-8"):void
		{
			var positionSize:uint = bytes.position;
			var postionStr:uint = bytes.position + bytesOfSize;
			
			//先写入字符串
			bytes.position = postionStr;
			if (str)
			{
				bytes.writeMultiByte(str, coding);
			}
			
			//计算写入的字节数量
			var positionEnd:uint = bytes.position;
			var size:uint = positionEnd - postionStr;
			
			//写入长度数值
			bytes.position = positionSize;
			if (bytesOfSize == 2)
			{
				bytes.writeShort(size);
			}
			else if (bytesOfSize == 4)
			{
				bytes.writeUnsignedInt(size);
			}
			else if (bytesOfSize == 1)
			{
				bytes.writeByte(size);
			}
			
			//将position设置到正确位置
			bytes.position = positionEnd;
		}
		
		public static function readStrUnfixed(bytes:ByteArray, bytesOfSize:uint = 2, coding:String = "utf-8"):String
		{
			var size:int;
			if (bytesOfSize == 1)
			{
				size = bytes.readUnsignedByte();
			}
			else if (bytesOfSize == 2)
			{
				size = bytes.readUnsignedShort();
			}
			else if (bytesOfSize == 4)
			{
				size = bytes.readUnsignedInt();
			}
			var str:String = bytes.readMultiByte(size, "utf-8");
			return str;
		}
		public static function readStr(bytes:ByteArray, len:int):String
		{
			return bytes.readMultiByte(len, "utf-8");
		}
		
		//读取字符串，前2个字节表示长度
		public static function readStrEx(bytes:ByteArray):String
		{
			var size:uint = bytes.readUnsignedShort();
			return bytes.readMultiByte(size, "utf-8");
		}
		
		// 转换服务器 [0, 1, 2, 3, 4, 5, 6, 7]  这类的索引到客户端的度数 [ 0, 45, 90, 135, 180, 225, 270, 315]，这个是上层方向，底层需要自动加 45     
		public static function convS2CDir(dir:uint):Number
		{
			if (1 == dir)
			{
				return 45;
			}
			else if (2 == dir)
			{
				return 90;
			}
			else if (3 == dir)
			{
				return 135;
			}
			else if (4 == dir)
			{
				return 180;
			}
			else if (5 == dir)
			{
				return 225;
			}
			else if (6 == dir)
			{
				return 270;
			}
			else if (7 == dir)
			{
				return 315;
			}
			else if(0 == dir)
			{
				return 0;
			}
			else 
			{
				throw new Error("convS2CDir dir great seven");
			}
		}
		
		
		
		public static function getDisplayObjectByChild(cl:Class, ds:DisplayObject):Object
		{
			var ret:DisplayObjectContainer;
			if (ds == null) return null;
			
			if (ds is cl)
			{
				return ds;
			}
			ret = ds.parent;
			while (ret)
			{
				if (ret is cl)
				{
					return ret;
				}
				ret = ret.parent;
			}
			return null;
		}
		
		// 获取装备强化表中的数据, equipLvl:装备等级, enLvl:强化等级
		/*
		1001~1999为1级装备
		5001~5999为5级装备
		10001~10999为10级装备
		千位万位十万位为装备等级
		个,十,百位为强化等级
		*/
		public static function equipEnID(equipLvl:uint, enLvl:uint):uint
		{
			return equipLvl * 1000 + enLvl;
		}
		
		// 获取装备上限表中 id, equipLvl:装备等级, enQuality:装备品质
		/*
		装备品质颜色 0--白 1--绿 2--蓝 3--紫 4--金
		个位表示品质,十位以上表示装备等级 * 
		*/
		public static function equipEnUpper(equipLvl:uint, enQuality:uint):uint
		{
			return equipLvl * 10 + enQuality;
		}
		
		//数字转化为字串，小于10时，个位数字前加0，方便时间显示
		public static function intToString(num:uint, k=2):String
		{
			var str:String = num.toString();
			var i:int;
			for (i = str.length; i < k; i++)
			{
				str = "0" + str;
			}			
			return str;
		}
		//showHour=true表示显示小时数
		public static function formatTimeToString(time:uint, showHour:Boolean=true,showSecond:Boolean=true,showType:Boolean=false):String
		{
			var h:uint;
			var m:uint;
			
			var str:String = "";
			if(time >= 3600)
			{
				h = time/3600;
				if(h < 10)
				{
					str += "0";
					str += h;
					if (showType)
					{
						str += "小时";
					}else
					{
						str += ":";
					}
				}else
				{
					str += h;
					if (showType)
					{
						str += "小时";
					}else
					{
						str += ":";
					}
				}
				time -= h*3600;
			}else
			{
				if (showHour)
				{
					if (showType)
					{
						str += "00小时";
					}else
					{
						str += "00:";
					}
				}
			}
			if(time >= 60)
			{
				m = time/60;
				if(m < 10)
				{
					str += "0";
					str += m;
					if (showType)
					{
						str += "分钟";
					}else
					{
						if (showSecond)
						{
							str += ":";
						}
					}
				}
				else
				{
					str += m;
					if (showType)
					{
						str += "分钟";
					}else
					{
						if (showSecond)
						{
							str += ":";
						}
					}
				}
				time -= m*60;
			}else
			{
				if (showType)
				{
					str +="00分钟";
				}else
				{
					str +="00";
					if (showSecond)
					{
						str += ":";
					}
				}
			}
			if (showSecond)
			{
				if(0 == time)
				{
					str += "00";
						
				}else if(time > 0 && time < 10)
				{
					str += "0";
					str += time;			
				}else
				{
					str += time;
				}
				if (showType)
				{
					str += "秒";
				}
			}
			return str;
		}
		
		
		
		//Number类型值->字符串	nAfterDot:小数点后位数(nAfterDot>0)
		public static function formatNumber(num:Number, nAfterDot:int):String
		{
			var retStr:String;
			var srcStr:String;
			var dotPos:int;
			
			srcStr = (num).toString();
			
			var strlen:int = srcStr.length;
			dotPos = srcStr.indexOf(".", 0);
			
			var i:int;
			if (-1 == dotPos)
			{
				retStr = srcStr + ".";
				for (i = 0; i < nAfterDot; i++)
				{
					retStr = retStr + "0";
				}
				
				return retStr;
			}
			else 
			{
				if ((strlen - dotPos - 1) >= nAfterDot)
				{
					var nTen:Number = 1;
					for (i = 0; i < nAfterDot; i++)
					{
						nTen = nTen * 10;
					}
					
					var resultNum:Number = Math.round(num * nTen) / nTen;
					retStr = resultNum.toString();
					
					if (0 == resultNum)
					{
						retStr = "0.0"
					}
					
					var afterDotNums:int = retStr.length - 1;
					var tempDotPos:int = retStr.indexOf(".", 0);
					
					if (tempDotPos >= 0)
					{
						afterDotNums -= tempDotPos;
					}
					else
					{
						retStr += ".";
					}
					
					for (i = afterDotNums; i < nAfterDot; i++)
					{
						retStr += "0";
					}
					
					return retStr;
				}
				else
				{
					retStr = srcStr;
					for (i = 0; i < (nAfterDot -strlen + dotPos + 1); i++)
					{
						retStr = retStr + "0";
					}
				}
			}
			
			return retStr;
		}
	}
}