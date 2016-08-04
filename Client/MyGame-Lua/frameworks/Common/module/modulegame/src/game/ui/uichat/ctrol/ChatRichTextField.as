package game.ui.uichat.ctrol 
{
	import com.riaidea.text.GraphicBase;
	import com.riaidea.text.RichTextField;
	import com.util.CmdParse;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.object.T_Object;
	import modulecommon.scene.prop.object.ZObject;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ChatRichTextField extends RichTextField 
	{
		public static const GraphicBaseType_ZObject:String = "obj";
		public static const GraphicBaseType_Expression:String = "expression";
		public static const GraphicBaseType_Vip:String = "vippanel";
		
		private var m_gkContext:GkContext;
		private var m_dicZObject:Dictionary;
		private var m_bForInput:Boolean;
		
		public function ChatRichTextField(gk:GkContext, bForInput:Boolean) 
		{
			m_bForInput = bForInput;
			m_gkContext = gk;
			super();		
			m_dicZObject = new Dictionary();			
			
		}
		
		/*
		 * obj thisid=4343;		//道具
		 * expression id=2			//表情
		 * vippanel vipid=1-9		//名称前vip
		 */
		override protected function getSpriteFromObject(obj:Object):GraphicBase 
		{
			var param:String = obj as String;
			var parser:CmdParse = new CmdParse();
			parser.parse(param);
			var ret:GraphicBase;
			if (parser.cmd == GraphicBaseType_ZObject)
			{
				var id:uint = parser.getUintValue("thisid");
				var tObj:T_Object = m_dicZObject[id];
				ret = new ChatObject(m_gkContext, m_bForInput);
				(ret as ChatObject).setObject(tObj);
			}
			else if (parser.cmd == GraphicBaseType_Expression)
			{
				id = parser.getIntValue("id");
				ret = new ChatExpression(m_gkContext, id);
			}
			else if (parser.cmd == GraphicBaseType_Vip)
			{
				id = parser.getIntValue("vipid");
				ret = new ChatVip(m_gkContext, id);
			}
			return ret;			
		}
		
		override public function setSize(width:Number, height:Number):void 
		{
			if (_width == width && _height == height) return;
			_width = width;
			_height = height;
			_textRenderer.width = _width;
			_textRenderer.height = _height;			
			_spriteRenderer.render();
		}
		public function exhibitZObject(obj:ZObject):void
		{
			m_dicZObject[obj.thisID] = obj.m_object.clone();
			this.insertSprite(s_formatZObject(obj));
		}
		
		public function addExpression(id:int):void
		{			
			this.insertSprite(s_formatExpression(id));
		}
		
		public static function s_formatZObject(obj:ZObject):String
		{
			return ChatRichTextField.GraphicBaseType_ZObject + " thisid=" + obj.thisID;
		}
		
		public static function s_formatExpression(id:int):String
		{
			return ChatRichTextField.GraphicBaseType_Expression + " id=" + id;
		}
		
		public static function s_formatVipPanel(id:int):String
		{
			return ChatRichTextField.GraphicBaseType_Vip + " vipid=" + id;
		}
		
		public function getRecord():ChatRecord
		{
			var ret:ChatRecord = new ChatRecord();
			ret.setDicObject(m_dicZObject);
			ret.m_data = this.exportXML();
			return ret;
		}
		public function setRecord(rec:ChatRecord):void
		{
			clear();
			m_dicZObject = rec.dicObject;
			this.importXML(rec.m_data);
		}
		
		public function setObjectList(list:Vector.<T_Object>):void
		{
			var tObject:T_Object;
			for each(tObject in list)
			{
				m_dicZObject[tObject.thisID] = tObject;
			}
		}
		override public function clear():void 
		{
			super.clear();
			m_dicZObject = new Dictionary();
		}
		
		public function getObjectSize():int
		{
			var ret:int = 0;
			var tObject:T_Object;
			for each(tObject in m_dicZObject)
			{
				ret++;
			}
			return ret;
		}
		
		
	}

}