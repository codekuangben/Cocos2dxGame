package com.util 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public final class UtilHtml 
	{
		public static const LEFT:String = "LEFT";
		public static const RIGHT:String = "right";
		public static const JUSTIFY:String = "justify";
		public static const CENTER:String = "center";
		
		public static const CSSATTR_leading:String = "leading";
		public static const CSSATTR_color:String = "color";
		public static const CSSATTR_letterSpacing:String = "letterSpacing";
		protected static var m_sContent:String;
				
		public static function formatFont(str:String, color:uint, size:uint = 12):String
		{
			return "<FONT size=\"" + size + "\" COLOR=\"#" + color.toString(16) + "\">" + str + "</FONT>";
		}
		
		public static function formatFontWithName(str:String, color:uint, size:uint, fontName:String):String
		{
			return "<FONT size=\"" + size + "\"" + "face=\""+ fontName + "\" COLOR=\"#" + color.toString(16) + "\">" + str + "</FONT>";
		}
		
		//整块的文字都进行缩进，而不仅仅是第一行。indent单位是像素
		public static function formatBlockindent(str:String, indent:int):String
		{
			return "<textformat blockindent='"+indent.toString()+"'>"+str+"</textformat>";
		}
		
		public static function formatP(str:String, align:String = LEFT):String
		{
			return "<p align=\"" + align + "\">" + str +"</p>";
		}
		public static function formatHypertextLink(strShow:String, eventText:String):String
		{
			return "<a href='event:"+eventText+ "'>" + strShow +"</a>";
		}
		
		public static function formatUnderline(str:String):String
		{
			return "<u>" + str +"</u>";
		}
		
		public static function formatBold(str:String):String
		{
			return "<b>" + str +"</b>";
		}
		
		public static function formatPDirect(str:String, color:uint, size:uint, align:String = UtilHtml.LEFT):String
		{
			return formatP(formatFont(str, color, size), align);
		}
		
		public static function removeWhitespace(str:String):String
		{
			var newStr:String;
			var myPattern:RegExp = /[\r\n\t ]*<p/g;			
				
			newStr = str.replace(myPattern, "<p");
			
			myPattern = /[\r\n\t ]*<font/g;				  
			newStr = newStr.replace(myPattern, "<font");
			
			myPattern = /[\r\n\t ]*<b/g;	  
			newStr = newStr.replace(myPattern, "<b");
			
			myPattern = /[\r\n\t ]*<var/g;	
			newStr = newStr.replace(myPattern, "<var");
			
			myPattern = /[\r\n\t ]*<\/p/g;	
			newStr = newStr.replace(myPattern, "</p");
			
			myPattern = /[\r\n]*/g;
			newStr = newStr.replace(myPattern, "");
			
			return newStr;
		}
		
		public static function getSBCSpace(n:int):String
		{
			var ret:String = "";
			var i:int;
			for (i = 0; i < n; i++)
			{
				ret += String.fromCharCode(12288);
			}
			return ret;
		}
		
		public static function beginCompose():void
		{
			if (m_sContent == null)
			{
				m_sContent = new String();
			}
			m_sContent = "";
		}
		public static function breakline():void
		{
			m_sContent += "<br/>";
		}
		public static function addStringNoFormat(str:String):void
		{
			m_sContent += str;
		}
		public static function add(str:String, color:uint, size:uint = 12):void
		{
			m_sContent += formatFont(str, color, size);
		}
		public static function addWithFontName(str:String, color:uint, size:uint, fontName:String):void
		{
			m_sContent += formatFontWithName(str, color, size, fontName);
		}
		public static function addHypertextLink(strShow:String, eventText:String):void
		{
			m_sContent += formatHypertextLink(strShow, eventText);
		}
		public static function getComposedContent():String
		{
			return m_sContent;
		}
		
	}

}