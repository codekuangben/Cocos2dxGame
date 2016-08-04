package game.ui.uiScreenBtn.subcom
{
	import com.bit101.components.Ani;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import modulecommon.uiinterface.IUIDaoJiShiWuJiang;
	import modulecommon.uiinterface.IUIRecruit;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	//import modulecommon.scene.saodang.SaodangMgr;
	import modulecommon.scene.screenbtn.ScreenBtnMgr;
	import com.util.UtilTools;
	import modulecommon.ui.UIFormID;
	
	//import uiScreenBtn.UIScreenBtn;

	/**
	 * ...
	 * @author "lingquzijiang.png"
	 */
	public class GiftPack extends FunBtnBase
	{
		private var m_TimeLable:Label;
		private var m_iconName:String;
		
		public function GiftPack(parent:DisplayObjectContainer=null)
		{
			super(ScreenBtnMgr.Btn_GiftPack, parent);
			m_TimeLable	= new Label(this, 38, 73, "00:00:00");
			m_TimeLable.align = Component.CENTER;
			m_iconName = "";
		}
		
		override public function onClick(e:MouseEvent):void 
		{
			if (m_gkContext.m_giftPackMgr.lingquType == 0)	// 领取礼包
			{
				// 显示在线礼包
				m_gkContext.m_giftPackMgr.showGiftPack(UIFormID.UIGPOnCntDw);
			}
			else
			{
				m_gkContext.m_giftPackMgr.showWuJiang();
			}
			
			hideEffectAni();
		}
		
		override public function initData(fileName:String):void
		{
			if (m_iconName != fileName)
			{
				super.initData(fileName);
			}
			
			m_iconName = fileName;
		}
		
		public function updateTimeLabel(time:uint):void
		{
			if (time > 0)
			{
				// 如果不可见
				if (m_TimeLable.visible == false)
				{
					m_TimeLable.visible = true;
				}
				m_TimeLable.text = UtilTools.formatTimeToString(time);
			}
			else
			{
				m_TimeLable.visible = false;
			}
		}
		override public function showEffectAni(path:String=null):void
		{
			if (null == m_effectAni)
			{
				m_effectAni = new Ani(m_gkContext.m_context);
				m_effectAni.centerPlay = true;
				m_effectAni.x = 37;
				m_effectAni.y = 44;
				//m_effectAni.setImageAni("ejhuodongjihuo.swf");
				m_effectAni.duration = 1.5;
				m_effectAni.repeatCount = 0;
				m_effectAni.mouseEnabled = false;
			}
			
			if (m_gkContext.m_giftPackMgr.lingquType == 1)
			{
				m_effectAni.setImageAni("ejhuodongteshu.swf");
			}
			else
			{
				m_effectAni.setImageAni("ejhuodongjihuo.swf");
			}
			
			m_effectAni.begin();
			
			if (!m_btn.contains(m_effectAni))
			{
				m_btn.addChild(m_effectAni);
			}
			
			m_bActing = true;
		}
	}
}