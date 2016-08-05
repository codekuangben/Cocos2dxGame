package modulecommon.scene.prop.table
{
	//import com.pblabs.engine.entity.EntityCValue;
	import modulecommon.scene.prop.ITbl;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author 
	 */
	public class UICfgTable implements ITbl
	{
		/*[Embed(source="../../../../../../../bin/asset/table/uicfg.xml", mimeType="application/octet-stream")]
		protected var m_asset:Class;
		protected var m_cfgList:Vector.<UICfgItem>;
		
		public function UICfgTable() 
		{
			var byteDataXml:ByteArray = new m_asset();  
            var xml:XML = XML(byteDataXml.readUTFBytes(byteDataXml.bytesAvailable));  
			initXML(xml, EntityCValue.RESTXML);
		}
		*/
		// xml 数据初始化      
		public function initXML(content:XML, type:uint):void
		{
			/*var idx:uint = 0;
			var item:UICfgItem;
			var itemList:XMLList = content.child("item");
			while (idx < itemList.length())
			{
				item = new UICfgItem();
				item.m_id = parseInt(itemList[idx].@id);
				item.m_name = itemList[idx].@name;
				m_cfgList.push(item);
				++idx;
			}*/
		}
		
		// 二进制数据初始化    
		public function initBin(content:ByteArray, type:uint):void
		{
			
		}
	}
}