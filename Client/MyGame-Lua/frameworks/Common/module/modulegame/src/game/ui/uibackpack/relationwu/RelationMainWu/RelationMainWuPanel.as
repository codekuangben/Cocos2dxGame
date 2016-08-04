package game.ui.uibackpack.relationwu.RelationMainWu 
{
	import com.ani.AniPosition;
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import game.ui.uibackpack.UIBackPack;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.xml.DataXml;
	import com.util.UtilColor;
	/**
	 * ...
	 * @author ...
	 * 主角关系激活--我的三国关系
	 */
	public class RelationMainWuPanel extends Component
	{
		//关系激活等级
		public static const ActLevel_None:int = 0;		//无激活
		public static const ActLevel_General:int = 1;	//普通激活
		public static const ActLevel_Gui:int = 2;		//鬼激活
		public static const ActLevel_Xian:int = 3;		//仙激活
		public static const ActLevel_Shen:int = 4;		//神激活
		public static const ActLevel_Max:int = ActLevel_Shen;
		
		private var m_gkContext:GkContext;
		private var m_ui:UIBackPack;
		private var m_closeBtn:PushButton;
		private var m_ani:AniPosition;
		private var m_bShow:Boolean;
		private var m_btnList:BtnList;
		private var m_dicAttrActWus:Dictionary;	//加成属性、关系武将
		
		public function RelationMainWuPanel(gk:GkContext, ui:UIBackPack, parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			m_ui = ui;
			
			this.setSize(320, 527);
			this.setPanelImageSkin("commoncontrol/panel/backpack/mainwurelation/back.png");
			
			m_dicAttrActWus = new Dictionary();
			
			m_btnList = new BtnList(m_gkContext, this, this, 5, 35);
			m_btnList.setDatas();
			
			m_closeBtn = new PushButton(this, this.width - 29, 6, onCloseBtnClick);
			m_closeBtn.setSkinButton1Image("commoncontrol/button/closebtn1.png");
			
			m_ani = new AniPosition();
			m_ani.sprite = this;
			m_ani.duration = 0.5;
		}
		
		public function showAttrActWus(groupid:uint):void
		{
			var attrActWus:AttrActWus = m_dicAttrActWus[groupid] as AttrActWus;
			if (null == attrActWus)
			{
				attrActWus = new AttrActWus(m_gkContext, m_ui, this, 132, 40);
				attrActWus.setData(groupid);
				
				m_dicAttrActWus[groupid] = attrActWus;
			}
			
			if (attrActWus)
			{
				attrActWus.show();
			}
		}
		
		public function get bShow():Boolean
		{
			return m_bShow;
		}
		
		public function setShowPos(isShow:Boolean):void
		{
			m_bShow = isShow;
			//m_relationWuList.hideNextList();
			
			if (m_bShow)
			{
				this.setPos(446, 0);
			}
			else
			{
				this.setPos(126, 0);
			}
		}
		
		public function updateShowPos():void
		{
			if (m_ani.bRun)
			{
				return;
			}
			
			m_ani.setBeginPos(this.x, this.y);
			if (m_bShow)
			{
				m_ani.setEndPos(this.x - 320, this.y);
				//m_relationWuList.hideNextList();
			}
			else
			{
				m_ani.setEndPos(this.x + 320, this.y);
				
			}
			m_ani.begin();
			
			m_bShow = !m_bShow;
		}
		
		//关系激活成功
		public function actSuccessUAR(groupid:uint):void
		{
			var attrActWus:AttrActWus = m_dicAttrActWus[groupid] as AttrActWus;
			if (attrActWus)
			{
				attrActWus.updateData();
				
				m_gkContext.m_systemPrompt.prompt("我的三国关系 之 " + attrActWus.data.m_desc + " 激活成功！");
			}
		}
		
		//更新关系武将状态
		public function updateWuState(heroid:uint):void
		{
			for each(var item:AttrActWus in m_dicAttrActWus)
			{
				item.updateWuState(heroid);
			}
		}
		
		private function onCloseBtnClick(event:MouseEvent):void
		{
			if (event.currentTarget as PushButton)
			{
				if (m_bShow)
				{
					updateShowPos();
				}
			}
		}
		
		override public function dispose():void
		{
			m_ani.dispose();
			
			for each(var attractwus:AttrActWus in m_dicAttrActWus)
			{
				if (attractwus && (null == attractwus.parent))
				{
					attractwus.dispose();
					attractwus = null;
				}
			}
			
			super.dispose();
		}
	}

}