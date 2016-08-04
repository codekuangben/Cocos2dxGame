package game.ui.uiHero.bufferIcon 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.GkContext;
	import modulecommon.scene.hero.AttrBufferMgr;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	/**
	 * ...
	 * @author ...
	 * 卧薪尝胆(三国战场中出现)
	 */
	public class SanguoBuffer extends BufferBase
	{
		
		public function SanguoBuffer(gk:GkContext, parent:DisplayObjectContainer) 
		{
			super(gk, parent);
		}
		
		public function setData(bufferid:uint):void
		{
			this.initData(bufferid, "woxinchangdan", AttrBufferMgr.TYPE_SANGGUOZHANCHANG);
		}
		
		override protected function onRollOver(event:MouseEvent):void
		{
			var str:String;
			var level:int = m_gkContext.m_sanguozhanchangMgr.m_woxinchangdanLevel;
			var percent:int = 5 * level;
			
			UtilHtml.beginCompose();
			str = UtilHtml.formatBold("卧薪尝胆 "+level.toString()+"级");
			UtilHtml.add(str, UtilColor.BLUE, 14);
			
			var nameList:Array = ["增加全军攻击", "增加全军防御", "增加全军兵力", "增加全军速度"];
			var i:int;
			
			for (i = 0; i < nameList.length; i++)
			{
				UtilHtml.breakline();
				UtilHtml.add(nameList[i], 0xdFa600, 12);
				UtilHtml.add("  +" + percent+"%", 0xdFa600, 12);
			}
			
			UtilHtml.breakline();
			UtilHtml.add("在三国战场中, 每死亡一次提升1级，胜利一次消失", UtilColor.WHITE_B, 12);		
			
			var pt:Point = this.localToScreen(new Point(25, -2));
			m_gkContext.m_uiTip.hintHtiml(pt.x, pt.y, UtilHtml.getComposedContent(), 230);
		}
	}

}