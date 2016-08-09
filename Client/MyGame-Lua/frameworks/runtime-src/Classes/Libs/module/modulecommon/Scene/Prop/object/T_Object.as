package modulecommon.scene.prop.object 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	import com.util.UtilTools;
	import common.net.endata.EnNet;
	
	public class T_Object 
	{		
		
		
		public var thisID:uint;
		public var objID:uint;
		private var m_name:String;
		public var num:uint;
		public var m_loation:stObjLocation;
		public var m_equipData:stEquipData;
		
		public function T_Object():void
		{
			m_loation = new stObjLocation();
		}
		
		public function clone():T_Object
		{
			var ret:T_Object = new T_Object();
			ret.thisID = thisID;
			ret.objID = this.objID;
			ret.m_name = m_name;
			ret.num = num;
			ret.m_loation = m_loation.clone();
			if (m_equipData)
			{
				ret.m_equipData = m_equipData.clone();
			}
			return ret;
		}
		
		public function serialize(byte:ByteArray):void
		{
			byte.writeUnsignedInt(thisID);
			byte.writeUnsignedInt(objID);
			UtilTools.writeStr(byte, m_name,EnNet.MAX_NAMESIZE);
			byte.writeUnsignedInt(num);
			m_loation.serialize(byte);
			byte.writeBoolean(m_equipData?true:false);
			if (m_equipData)
			{
				m_equipData.serialize(byte);
			}
		}
		
		public function deserialize(byte:ByteArray):void
		{
			thisID = byte.readUnsignedInt();
			objID = byte.readUnsignedInt();			
			m_name = UtilTools.readStr(byte, EnNet.MAX_NAMESIZE);		
			num = byte.readUnsignedInt();
			m_loation.deserialize(byte);
			
			var hasEquipData:uint = byte.readUnsignedByte();
			if (hasEquipData != 0)
			{
				m_equipData = new stEquipData;
				m_equipData.deserialize(byte);
			}
		}
		
		public function toPackageKey():uint
		{
			return m_loation.toPackageKey();
		}
	}

}

/*
 //发送给客户端的道具二进制
	struct t_ObjData
	{
		DWORD thisid;
		DWORD objid;
		char name[MAX_NAMESIZE];
		DWORD num;
		stObjLocation pos;	//所在位置
		BYTE hasEquipData;
		stEquipData equipData[0];		
	};
*/