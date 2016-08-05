package modulecommon.net.msg.mailCmd 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	import modulecommon.net.msg.sceneUserCmd.t_ItemData;
	import modulecommon.scene.prop.object.T_Object;
	import modulecommon.scene.prop.object.ZObject;
	import com.util.UtilTools;
	
	public class MailBody 
	{		
		public var m_mailHead:MailHead;
		public var text:String;
		public var m_moneyList:Vector.<t_ItemData>;
		public var m_objList:Array;
		public var m_extraData:Object;
		
		public function deserialize(byte:ByteArray):void 
		{
						
			var textSize:int = byte.readUnsignedShort();
			var moneySize:int = byte.readUnsignedByte();
			var objSize:int = byte.readUnsignedByte();
			text = UtilTools.readStr(byte, textSize);
			m_moneyList = t_ItemData.readWidthNum_Vector(byte, moneySize);
			m_objList = new Array();
			
			var i:int;
			var tobj:T_Object;
			var zObj:ZObject;
			while (i < objSize)
			{
				zObj = new ZObject();
				tobj = new T_Object();
				tobj.deserialize(byte);
				zObj.setObject(tobj);
				m_objList.push(zObj);
				i++;
			}
			
			if (m_mailHead.isBaowuLootMail)
			{
				var baowu:BaoWuRansom = new BaoWuRansom();
				baowu.deserialize(byte);
				m_extraData = baowu;
			}
			
		}
		
	}

}