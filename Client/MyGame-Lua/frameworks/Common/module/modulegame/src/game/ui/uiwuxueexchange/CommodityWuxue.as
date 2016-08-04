package game.ui.uiwuxueexchange 
{
	import com.bit101.components.controlList.CtrolComponent;
	import com.bit101.components.label.Label2;
	import com.bit101.components.PushButton;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import game.ui.uiwuxueexchange.msg.stWuXueExchangeCmd;
	import modulecommon.GkContext;
	import modulecommon.net.msg.zhanXingCmd.stLocation;
	import modulecommon.scene.prop.object.ZObjectDef;
	import modulecommon.scene.zhanxing.WuxueData;
	import modulecommon.scene.zhanxing.WuXueIcon;
	import modulecommon.scene.zhanxing.ZStar;
	import com.util.UtilColor;
	
	/**
	 * ...
	 * @author 
	 */
	public class CommodityWuxue extends CtrolComponent 
	{
		private var m_gkcontext:GkContext;
		private var m_wuxuePanel:WuXueIcon
		private var m_nameLabel:Label2;
		private var m_buyBtn:PushButton;
		private var m_scoreLabel:Label2;
		private var wuxueData:WuxueData;
		public function CommodityWuxue(param:Object=null) 
		{
			super(param);
			m_gkcontext = param.gk;
			
		}
		override public function init():void 
		{
			if (!m_buyBtn)
			{
				this.setPanelImageSkin("commoncontrol/panel/zhanxing/exchangeitembg.png");
				m_nameLabel = new Label2(this, 90, 15);		
				m_scoreLabel = new Label2(this, 90, 40);
				m_buyBtn = new PushButton(this, 144, 63, onBuyClick);
				m_buyBtn.setSkinButton1Image("commoncontrol/button/buyBtn_yellow.png");
				m_wuxuePanel = new WuXueIcon(m_gkcontext, this, 22, 9);
				wuxueData = m_data as WuxueData;
				var wuxue:ZStar = ZStar.createClientStar(wuxueData.m_id);
				m_wuxuePanel.setZStar(wuxue);
				m_nameLabel.text = wuxue.m_base.m_name;
				m_nameLabel.setFontColor(wuxue.colorValue);
				m_scoreLabel.text = "积分：" + wuxueData.m_price.toString();
			}
		}
		override public function setData(_data:Object):void 
		{
			super.setData(_data);
		}
		private function onBuyClick(e:MouseEvent):void
		{
			if (m_gkcontext.m_zhanxingMgr.score < wuxueData.m_price)
			{
				m_gkcontext.m_systemPrompt.promptOnTopOfMousePos("积分不足",UtilColor.RED,-20);
				return;
			}
			if (m_gkcontext.m_zhanxingMgr.getPackage(stLocation.SBCELLTYPE_MIANPACK).numOfFreeGrids == 0)
			{
				m_gkcontext.m_systemPrompt.prompt("武学包裹空间不足");
				return;
			}
			var send:stWuXueExchangeCmd = new stWuXueExchangeCmd();
			send.m_wxid = wuxueData.m_id;		
			m_gkcontext.sendMsg(send);
		}	
	}

}