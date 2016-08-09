package modulecommon.headtop 
{
	import flash.events.MouseEvent;
	import modulecommon.GkContext;
	import modulecommon.scene.beings.NpcPlayerFake;
	import modulecommon.ui.UIFormID;
	//import com.util.UtilHtml;
	import org.ffilmation.engine.helpers.fUtil;
	import com.util.UtilColor;
	import com.bit101.components.PushButton;
	import modulecommon.uiinterface.IUICangbaoku;

	/**
	 * ...
	 * @author ...
	 */
	public class TopBlockNpcPlayerFake extends HeadTopBlockBase 
	{		
		private var m_npc:NpcPlayerFake;
		protected  var m_btnTX:PushButton;		// 向他投降按钮
		
		public function TopBlockNpcPlayerFake(gk:GkContext, npc:NpcPlayerFake) 
		{
			super(gk);
			m_npc = npc;
			
			//showTouXiangBtn();
		}
		
		override public function update():void
		{
			this.clearAutoData();
			
			var content:String;
			var color:uint = 0x00ff0c;		

			content = this.name +"(" + m_npc.m_charID.toString() + ", " + m_npc.level + ")";
			addAutoData(m_npc.name, color, 18);
			
			// 需要添加站立值
			//战力只有主角战力90%以下，显示菜鸟
			//91%~109% 显示旗鼓相当	
			//110%~125%显示危险
			//125%以上，显示大魔头
			// content = "战力 " + m_zhanli;
			var percent:Number = m_npc.m_zhanli/m_npc.gkcontext.playerMain.wuProperty.m_uZongZhanli * 100;
			var chengh:String = "";
			if(percent < 91)
			{
				chengh = "菜鸟";
			}
			else if(percent < 110)
			{
				chengh = "旗鼓相当";
			}
			else if(percent < 126)
			{
				chengh = "危险";
			}
			else
			{
				chengh = "大魔头";
			}
			// 加上第几层, 藏宝库从 3001 开始
			var lay:int = m_npc.gkcontext.m_mapInfo.m_servermapconfigID - 3000;
			content = "第" + fUtil.Arabic2CapitalDigit(lay) + "层 " + chengh;
			addAutoData(content, UtilColor.YELLOW, 18);
			
			updateTouXiangBtn();
		}
		
		// [向他投降]按钮
		public function showTouXiangBtn():void
		{
			if (null == m_btnTX)
			{
				m_btnTX = new PushButton(this, -65, this.curTop - 40, onBtnClkTX);
				m_btnTX.setSkinButton1Image("commoncontrol/button/cangbaoku/xiangtatouxiang.png");
			}
			
			if (m_btnTX.parent != this)
			{
				this.addChild(m_btnTX);
			}
		}
		
		// 更新位置信息
		protected function updateTouXiangBtn():void
		{
			if (m_btnTX)
			{
				// 必然更新一下位置
				m_btnTX.x = -65;
				m_btnTX.y = this.curTop - 40;
			}
		}
		
		// 释放向他投降按钮
		public function delXTTXBtn():void
		{
			if (m_btnTX)
			{
				this.removeChild(m_btnTX);
				m_btnTX.dispose();		// 手工调用释放资源
				m_btnTX = null;
			}
		}
		
		private function onBtnClkTX(event:MouseEvent):void
		{
			// 显示界面
			var uicbk:IUICangbaoku = m_npc.gkcontext.m_UIMgr.getForm(UIFormID.UICangbaoku) as IUICangbaoku;
			if (uicbk)
			{
				m_gkContext.m_contentBuffer.addContent("notifyTouXiangData", m_npc.cmd);
				uicbk.openGiveUp();
			}
			delXTTXBtn();
		}
	}
}