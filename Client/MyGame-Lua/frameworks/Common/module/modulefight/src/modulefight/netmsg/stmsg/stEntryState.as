package modulefight.netmsg.stmsg
{
	import flash.utils.ByteArray;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TRoleStateItem;
	//import modulefight.FightEn;
	/**
	 * ...
	 * @author 
	 * 
	 * 客户端stEntryState结构包含服务器端的stEntryState和stState结构
	 */
	public class stEntryState
	{
		public static const PICName_ShiqiTisheng:int = 130;	//士气提升
		public static const PICName_Xiajiang:int = 131;	//士气下降
		//------这3个状态不是服务器发过来的
		public var roundIndexOfAdd:uint;	//产生此状态时，是第几回合，zero-based
		
		private var m_base:TRoleStateItem;
		public var m_gkContext:GkContext;
		//-----------	
		
		public var bufferID:uint;
		//public var icon_id:uint;
		//public var mode:uint;
		public var value:uint;
		public var time:uint;
		//public var picname:String;			 // 这个是buff 的时候，头顶上显示的数字 
		
		public function deserialize(byte:ByteArray):void
		{			
			bufferID = byte.readUnsignedShort();	
			value = byte.readUnsignedInt();
			time = byte.readUnsignedByte();
		}
		
		public function get base():TRoleStateItem
		{
			if (m_base==null)
			{
				m_base = m_gkContext.m_dataTable.getItem(DataTable.TABLE_ROLESTATE, bufferID) as TRoleStateItem;
			}
			return m_base;
		}
		public function get name():String
		{			
			return base.m_name;
		}
		public function get stateDesc():String
		{
			return base.m_desc;
		}
	}
}

//struct stEntryState
//{
	//stEntryState& operator = (stEntryState& s)
	//{
		//if(this == &s) return *this;
//
		//pos = s.pos;
		//index = s.index;
		//for(BYTE i = 0; i < StateMax; ++i)
		//{
			//state[i] = s.state[i];
		//}
	//}
	//BYTE pos; //武将所在的位置(在这个位置上的武将)
	//stState state;
//}

/*struct stState
	{		
		WORD id;  //buf Id
		DWORD value;	//buf 影响数值
		BYTE time;  //持续回合次数
	};*/
	