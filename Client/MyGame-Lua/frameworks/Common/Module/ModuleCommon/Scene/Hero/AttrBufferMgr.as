package modulecommon.scene.hero 
{
	import flash.utils.ByteArray;
	import modulecommon.GkContext;
	import modulecommon.net.msg.attrbufferCmd.stAddBufferToUserUserCmd;
	import modulecommon.net.msg.attrbufferCmd.stBufferData;
	import modulecommon.net.msg.attrbufferCmd.stRemoveOneBufferUserCmd;
	import modulecommon.net.msg.attrbufferCmd.stUserBufferListUserCmd;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TAttrBufferItem;
	import modulecommon.scene.prop.table.TObjectBaseItem;
	/**
	 * ...
	 * @author ...
	 * 人物属性加成Buffer
	 */
	public class AttrBufferMgr 
	{
		//buffer表中未定义的buffer在此定义临时id
		public static const BufferID_Woxinchangdan:uint = 1001; //卧薪尝胆(三国战场中出现)
		
		//buffer类型
		public static const TYPE_NONE:int = 0;
		public static const TYPE_YAOSHUI:int = 1;		//属性加成药水:"竞技场"、"紫将宝物抢夺"无效
		public static const TYPE_WORLDBOSS:int = 2;		//世界boss-鼓舞、激励
		
		public static const TYPE_SANGGUOZHANCHANG:int = 100;	//三国战场--卧薪尝胆
		
		
		//buffer赋值未buffer表中ID:用于判断不同buffer
		public static const Buffer_Guwu:uint = 101;	//鼓舞(世界boss)
		public static const Buffer_Jili:uint = 201;	//激励(世界boss)
		
		
		//加成属性描述
		public static const BPT_ARMYFORCE:int = 1;	//全军武力
		public static const BPT_ARMYIQ:int = 2;		//全军智力
		public static const BPT_ARMYCHIEF:int = 3;	//全军统率
		public static const BPT_ARMYHP:int = 4;		//全军兵力
		public static const BPT_ARMYATTACK:int = 5;	//全军攻击
		public static const BPT_ARMYDEF:int = 6;	//全军防御
		public static const BPT_ARMYSPEED:int = 7;	//全军速度
		public static const BPT_ARMYATTACKPER:int = 8;	//全军攻击百分比
		public static const BPT_ARMYDEFPER:int = 9;		//全军防御力百分比
		public static const BPT_ARMYHPPER:int = 10;		//全军兵力百分比
		public static const BPT_ARMYSPEEDPER:int = 11;	//全军速度百分比
		
		private var m_gkContext:GkContext;
		private var m_bufferList:Array;
		
		public function AttrBufferMgr(gk:GkContext) 
		{
			m_gkContext = gk;
			m_bufferList = new Array();
		}
		
		public static function getBufferIconPath(icon:String):String
		{
			return "bufficon/" + icon + ".png";
		}
		
		public function get bufferList():Array
		{
			return m_bufferList;
		}
		
		public function getBuffer(bufferid:uint):ItemBuffer
		{
			for each(var item:ItemBuffer in m_bufferList)
			{
				if (item.bufferID == bufferid)
				{
					return item;
				}
			}
			
			return null;
		}
		
		//获得buffer数据信息
		public function createBuffer(data:stBufferData):ItemBuffer
		{
			var ret:ItemBuffer;
			var bufferbase:TAttrBufferItem = m_gkContext.m_dataTable.getItem(DataTable.TABLE_ATTRBUFFER, data.m_bufferid) as TAttrBufferItem;
			
			if (null == bufferbase)
			{
				return null;
			}
			
			ret = getBuffer(data.m_bufferid);
			if (null == ret)
			{
				ret = new ItemBuffer();
				ret.m_bufferBase = bufferbase;
				m_bufferList.push(ret);
			}
			ret.m_leftTime = data.m_lefttime;
			ret.m_coef = data.m_coef;
			ret.m_objID = data.m_extra;
			
			var effectbuffer:EffectBuffer;
			ret.m_vecEffect.length = 0;
			for (var i:int = 0; i < bufferbase.m_effectList.length; i++)
			{
				effectbuffer = new EffectBuffer();
				effectbuffer.m_type = bufferbase.m_effectList[i].m_type;
				effectbuffer.m_value = bufferbase.m_effectList[i].m_value * ret.m_coef;
				
				ret.m_vecEffect.push(effectbuffer);
			}
			
			if (TYPE_YAOSHUI == ret.m_bufferBase.m_type)
			{
				var objBase:TObjectBaseItem = m_gkContext.m_dataTable.getItem(DataTable.TABLE_OBJECT, ret.m_objID) as TObjectBaseItem;
				if (objBase)
				{
					ret.m_name = objBase.m_name;
					ret.m_level = objBase.m_iLevel;
				}
			}
			else if (TYPE_WORLDBOSS == ret.m_bufferBase.m_type)
			{
				ret.m_level = data.m_coef;
			}
			
			return ret;
		}
		
		//玩家buff列表
		public function processUserBufferListUserCmd(msg:ByteArray):void
		{
			var rev:stUserBufferListUserCmd = new stUserBufferListUserCmd();
			rev.deserialize(msg);
			
			var i:int;
			var bufferData:stBufferData;
			for (i = 0; i < rev.m_bufferList.length; i++)
			{
				bufferData = rev.m_bufferList[i];
				createBuffer(bufferData);
			}
		}
		
		//人物身上添加buffer
		public function processAddBufferToUserUserCmd(msg:ByteArray):void
		{
			var rev:stAddBufferToUserUserCmd = new stAddBufferToUserUserCmd();
			rev.deserialize(msg);
			
			var item:ItemBuffer = createBuffer(rev.m_buffer);
			
			if (m_gkContext.m_UIs.hero && item)
			{
				if (rev.m_action)
				{
					m_gkContext.m_UIs.hero.updateBufferIcon(item.type, item.bufferID);
				}
				else
				{
					m_gkContext.m_UIs.hero.addBufferIcon(item.type, item.bufferID);
				}
			}
		}
		
		//删除人物身上一个buffer
		public function processRemoveOneBufferUserCmd(msg:ByteArray):void
		{
			var rev:stRemoveOneBufferUserCmd = new stRemoveOneBufferUserCmd();
			rev.deserialize(msg);
			
			removeOneBufferByID(rev.m_bufferid);
		}
		
		//删除一个buffer
		public function removeOneBufferByID(id:uint):void
		{
			if (m_gkContext.m_UIs.hero)
			{
				m_gkContext.m_UIs.hero.removeBufferIcon(id);
			}
			
			var i:int;
			var buffer:ItemBuffer;
			for (i = 0; i < m_bufferList.length; i++)
			{
				buffer = m_bufferList[i];
				if (buffer.bufferID == id)
				{
					m_bufferList.splice(i, 1);
					break;
				}
			}
		}
		
		//加成属性描述
		public function getAttrDesc(bpt:int, value:uint):String
		{
			var ret:String;
			
			switch(bpt)
			{
				case BPT_ARMYFORCE:
					ret = "  全军武力增加" + value + "点";
					break;
				case BPT_ARMYIQ:
					ret = "  全军智力增加" + value + "点";
					break;
				case BPT_ARMYCHIEF:
					ret = "  全军统率增加" + value + "点";
					break;
				case BPT_ARMYHP:
					ret = "  全军兵力增加" + value + "点";
					break;
				case BPT_ARMYATTACK:
					ret = "  全军攻击增加" + value + "点";
					break;
				case BPT_ARMYDEF:
					ret = "  全军防御增加" + value + "点";
					break;
				case BPT_ARMYSPEED:
					ret = "  全军速度增加" + value + "点";
					break;
				case BPT_ARMYATTACKPER:
					ret = "  全军攻击增加" + value + "%";
					break;
				case BPT_ARMYDEFPER:
					ret = "  全军防御增加" + value + "%";
					break;
				case BPT_ARMYHPPER:
					ret = "  全军兵力增加" + value + "%";
					break;
				case BPT_ARMYSPEEDPER:
					ret = "  全军速度增加" + value + "%";
					break;
				default:
					ret = "";
			}
			
			return ret;
		}
	}

}