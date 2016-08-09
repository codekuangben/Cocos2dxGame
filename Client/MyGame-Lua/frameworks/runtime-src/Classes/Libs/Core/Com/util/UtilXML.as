package com.util
{
	
	/**
	 * ...
	 * @author
	 */
	public class UtilXML
	{
		public static function attributeValue(xml:XML, attributeName:String):String
		{
			var ret:String;
			var xmlList:XMLList = xml.attribute(attributeName);
			
			if (xmlList.length())
			{
				ret = xmlList[0];
			}
			return ret;
		}
		public static function attributeIntValue(xml:XML, attributeName:String):int
		{
			var ret:int;
			var xmlList:XMLList = xml.attribute(attributeName);
			
			if (xmlList.length())
			{
				ret = parseInt(xmlList[0]);
			}
			return ret;
		}
		
		public static function attributeAsBoolean(xml:XML, attributeName:String):Boolean
		{
			var ret:Boolean=false;
			var xmlList:XMLList = xml.attribute(attributeName);
			
			if (xmlList.length())
			{
				if (0 != parseInt(xmlList[0]))
				{
					ret = true;
				}
			}
			return ret;
		}
		public static function hasAttribute(xml:XML, attributeName:String):Boolean
		{
			var xmlList:XMLList = xml.attribute(attributeName);
			return xmlList.length() > 0;
		}
		
		/*
		 * 返回xml中的文本内容：
		 * 例如：参数xml就是标签为briefdesc的xml对象
		 * <briefdesc>去找找</briefdesc>
		 * 函数返回“去找找”
		 */
		public static function getXMLText(xml:XML):String
		{
			return xml.toString();
		}
		
		/*
		 * 返回xml的子节点(nodeName)中的文本内容：
		 * 例如：参数xml就是标签为briefdesc的xml对象
		 * <item>
		 * 	<briefdesc>去找找</briefdesc>
		 * </item>
		 * 输入(xml(item节点对象), briefdesc)
		 * 函数返回“去找找”
		 */
		public static function getTextOfSubNode(xml:XML, nodeName:String):String
		{
			var xmlList:XMLList = xml.child(nodeName);
			if (xmlList && xmlList.length() == 1)
			{
				return xmlList[0].toString();
			}
			return null;
		}
		
		/*
		 * 调用此函数的前提是，xml中只有1个以subName为名字的子节点
		 */ 
		public static function getSubXml(xml:XML, subName:String):XML
		{
			var list:XMLList = xml.child(subName);
			if (list.length() > 0)
			{
				return list[0];
			}
			return null;
		}
		
		public static function getChildXmlList(xml:XML, subName:String):XMLList
		{
			return xml.child(subName)
		}
		
		public static function getAllChildXmlList(xml:XML):XMLList
		{
			return xml.elements();
		}
	}

}