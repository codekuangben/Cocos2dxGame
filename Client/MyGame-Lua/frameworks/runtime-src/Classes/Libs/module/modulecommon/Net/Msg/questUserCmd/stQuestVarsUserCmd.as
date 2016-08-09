package modulecommon.net.msg.questUserCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import common.net.endata.EnNet;

	public class stQuestVarsUserCmd extends stQuestUserCmd
	{
		public var vars:Dictionary;
		public function stQuestVarsUserCmd()
		{
			byParam = QuestUserParam.QUEST_VARS_PARA;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);	
			vars = new Dictionary();
			var cout:uint = byte.readUnsignedByte();
			var i:uint = 0;
			var name:String;
			var value:String;
			for (i = 0; i < cout; i++)
			{
				name = byte.readMultiByte(EnNet.MAX_NSIZE, EnNet.UTF8);
				value = byte.readMultiByte(EnNet.MAX_VSIZE, EnNet.UTF8);
				vars[name] = value;
			}
		}		
	}
	
	/*
	 * const BYTE QUEST_VARS_PARA = 2;
	struct stQuestVarsUserCmd : public stQuestUserCmd
	{
		enum {
			MAX_NSIZE = 32,
			MAX_VSIZE = 128,
		};

		stQuestVarsUserCmd()
		{
			byParam = QUEST_VARS_PARA;  
		}
		BYTE count; //变量数量
		struct Var {
			BYTE name[MAX_NSIZE];
			BYTE value[MAX_VSIZE];  
		} vars_list[0]; //变量列表
	};
	*/

}