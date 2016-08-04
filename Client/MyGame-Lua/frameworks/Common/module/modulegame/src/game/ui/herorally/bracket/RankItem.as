package game.ui.herorally.bracket 
{
	import com.bit101.components.controlList.CtrolVHeightComponent;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.dgrigg.image.Image;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.GkContext;
	import com.util.UtilColor;
	
	/**
	 * ...
	 * @author 
	 */
	public class RankItem extends CtrolVHeightComponent 
	{
		private var m_gkcontext:GkContext;
		private var m_parent:BracketComponent;
		private var m_rankLabel:Label;
		private var m_serverLabel:Label;
		private var m_nameLabel:Label;
		private var m_scoreLabel:Label;
		private var m_itembg:Panel;
		private var m_box:Panel;
		private var m_id:uint;
		public function RankItem(param:Object) 
		{
			super();
			m_gkcontext = param.gk;
			m_parent = param.parent;
			m_itembg = new Panel(this, 0, 0);
			m_itembg.setSize(244, 28);
			m_itembg.autoSizeByImage = false;
			m_itembg.setPanelImageSkinMirror("commoncontrol/panel/sanguozhanchang/decorateLeft.png", Image.MirrorMode_LR);
			m_rankLabel = new Label(this, 24, 8, "", UtilColor.WHITE_Yellow);
			m_rankLabel.align = CENTER;
			m_serverLabel = new Label(this, 132, 8, "", UtilColor.WHITE_Yellow);
			m_serverLabel.setLetterSpacing(1);
			m_serverLabel.align = RIGHT;
			m_nameLabel = new Label(this, 132, 8, "", UtilColor.WHITE_Yellow);
			m_nameLabel.setLetterSpacing(1);
			m_nameLabel.align = LEFT;
			m_scoreLabel = new Label(this, 214, 8);
			m_scoreLabel.align = CENTER;
			m_box = new Panel(this, 228, 8);
			m_box.setPanelImageSkin("commoncontrol/panel/box.png");
			m_box.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			m_box.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}
		override public function setData(_data:Object):void 
		{
			super.setData(_data);
			m_id = _data.m_id;
			m_rankLabel.text = _data.m_id.toString();
			m_serverLabel.text = m_gkcontext.m_context.m_platformMgr.getZoneName(_data.m_serverId, _data.m_serverNo);
			m_nameLabel.text = _data.m_name;
			m_scoreLabel.text = _data.m_score.toString();
			
		}
		private function onRollOver(e:MouseEvent):void
		{
			m_box.filtersAttr(true);
			var str:String = m_parent.m_curGroupInfo.m_rankBoxTip[m_id];
			if (str)
			{
				var pt:Point = m_box.localToScreen();
				pt.x += 21;
				m_gkcontext.m_uiTip.hintHtiml(pt.x, pt.y, str,180);
			}
			
		}
		private function onRollOut(e:MouseEvent):void
		{
			m_gkcontext.m_uiTip.hideTip();
			m_box.filtersAttr(false);
		}
		override public function dispose():void 
		{
			if (m_box)
			{
				m_box.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				m_box.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			}
			super.dispose();
		}
		
	}

}