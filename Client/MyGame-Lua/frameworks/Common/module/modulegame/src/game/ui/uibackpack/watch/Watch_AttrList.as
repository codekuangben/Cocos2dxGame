package game.ui.uibackpack.watch 
{
	import com.bit101.components.Component;
	import ui.player.PlayerResMgr;
	import modulecommon.scene.wu.WuProperty;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author 
	 */
	public class Watch_AttrList extends Component 
	{
		protected static var s_propertyList:Array;
		protected var m_wu:WuProperty;
		
		protected var m_contrlClass:Class;
		protected var m_list:Vector.<Watch_NameValue>;
		protected var m_zongZhanli:Watch_NameValue;		
		
		public function Watch_AttrList(parent:DisplayObjectContainer, xpos:Number, ypos:Number, contrlClass:Class)
		{
			super(parent, xpos, ypos);
			m_contrlClass = contrlClass;
			if (s_propertyList == null)
			{
				s_propertyList = [WuProperty.PROPTYPE_NAME_ZHANLI, WuProperty.PROPTYPE_NAME_HPLIMIT, WuProperty.PROPTYPE_NAME_PHYDAM,WuProperty.PROPTYPE_NAME_PHYDEF,WuProperty.PROPTYPE_NAME_STRATEGYDEF,WuProperty.PROPTYPE_NAME_BAOJI,WuProperty.PROPTYPE_NAME_BJDEF,WuProperty.PROPTYPE_NAME_POJI,WuProperty.PROPTYPE_NAME_LUCK,WuProperty.PROPTYPE_NAME_ATTACKSPEED];
			}
			
			m_list = new Vector.<Watch_NameValue>(s_propertyList.length);
			
			
			
			var i:int;
			var item:Watch_NameValue;
			var top:int =0 ;
			for (i = 0; i < s_propertyList.length; i++)
			{
				item = new m_contrlClass(this);
				item.y = top;
				m_list[i] = item;
				top += 20;
			}
			top += 12;
			m_zongZhanli = new m_contrlClass(this);
			m_zongZhanli.y = top;
		}
		public function switchToWu(wu:WuProperty, wuCompare:WuProperty=null):void
		{
			m_wu = wu;		
			var i:int;
			var item:Watch_NameValue;
			var name:String;
			var valueCompare:uint;
			for (i = 0; i < s_propertyList.length; i++)
			{
				item = m_list[i];
				name = s_propertyList[i];
				if (name == WuProperty.PROPTYPE_NAME_PHYDAM)
				{
					name = s_PROPTYPE_NAME(m_wu);
				}
				if (wuCompare)
				{
					valueCompare = wuCompare[name]
				}
				item.set(WuProperty.s_PropertyNameToName(name), m_wu[name],valueCompare);
			}
			
			if (wu.isMain)
			{
				
				name = WuProperty.PROPTYPE_NAME_ZONGZHANLI;
				valueCompare = uint.MAX_VALUE;
				if (wuCompare && wuCompare.isMain)
				{
					valueCompare = wuCompare[name];
				}
				
				m_zongZhanli.set("队伍战力", m_wu[name],valueCompare);
				m_zongZhanli.visible = true;
			}
			else
			{
				m_zongZhanli.visible = false;
			}
		}		
		public static function s_PROPTYPE_NAME(wu:WuProperty):String
		{
			if (PlayerResMgr.JOB_JUNSHI == wu.m_uJob)
			{
				return WuProperty.PROPTYPE_NAME_STRATEGYDAM;;
			}
			else
			{
				return WuProperty.PROPTYPE_NAME_PHYDAM;
			}
		}
		public function get wu():WuProperty
		{
			return m_wu;
		}
	}

}