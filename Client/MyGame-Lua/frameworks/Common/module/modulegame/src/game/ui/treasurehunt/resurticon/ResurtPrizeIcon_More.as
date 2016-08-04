package game.ui.treasurehunt.resurticon 
{
	import com.ani.AniPause;
	import com.bit101.components.controlList.ControlList;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import game.ui.treasurehunt.midPart;
	import game.ui.treasurehunt.midPartItemIcon;
	import game.ui.treasurehunt.msg.stHuntingRward;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.BeingProp;
	import modulecommon.scene.sysbtn.SysbtnMgr;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUIHero;
	import modulecommon.uiinterface.IUiSysBtn;
	
	/**
	 * ...
	 * @author 
	 */
	public class ResurtPrizeIcon_More
	{
		private var m_gkContext:GkContext;
		private var m_prizeIconList:Vector.<ResurtPrizeIcon_1time>;//这里存储仅仅为了让icon上移，不负责dispose
		private var m_delay:AniPause;//延时
		public var m_dissipation:Boolean;//为true处于从中心移向按钮的消散状态，在非消散状态下icon序列要上移
		private var m_parent:midPart;
		public function ResurtPrizeIcon_More(m_list:ControlList,vec:Vector.<stHuntingRward>,gk:GkContext,parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			m_prizeIconList = new Vector.<ResurtPrizeIcon_1time>();
			m_gkContext = gk;
			m_dissipation = false;
			m_parent = parent as midPart;
			var wuNum:uint = 0;
			var left:int = 196;
			for (var j:uint = 0; j < vec.length; j++ )//武将w56 物品w44 间距6 中线246
			{
				if (vec[j].rewardType == 2)
				{
					wuNum++;
					if (j == 0)
					{
						left -= 12;
					}
				}
			}
			left = left - wuNum * 6 - 247;//这样算位置简单 但是会显得武将icon偏右 
			
			for (var i:uint = 0; i < vec.length; i++ )
			{
				var data:stHuntingRward = vec[i];
				var icon:midPartItemIcon = m_list.findCtrl(midPart.findFunction, data.picNO) as midPartItemIcon;
				var pt:Point = icon.posInRelativeParent(m_parent);
				pt.x += 35;
				pt.y += 36;
				var prizeIcon_1time:ResurtPrizeIcon_1time;
				//(m_parent).showAniOnList(pt);//在icon出生处显示特效
				var typeno:uint = data.rewardType;
				var pos:Point = (m_parent).localToScreen(new Point(0, 0));
				if (typeno == 1)
				{
					prizeIcon_1time = new ResurtPrizeIcon_Obj(data, m_gkContext, m_parent, 186, 208);
					left += 50;
				}
				else if (typeno == 2)
				{
					prizeIcon_1time = new ResurtPrizeIcon_Hero(data, m_gkContext, m_parent, 186, 208);
					var form:IUiSysBtn = m_gkContext.m_UIMgr.getForm(UIFormID.UiSysBtn) as IUiSysBtn;
					if (form && form.getBtnPosInScreenByIdx(SysbtnMgr.SYSBTN_WuXiaye))
					{
						pos=((form  as IUiSysBtn).getBtnPosInScreenByIdx(SysbtnMgr.SYSBTN_WuXiaye) as Point).subtract(pos);
					}
					left += 62;
				}
				else if (typeno == 3)
				{
					data.id = m_gkContext.m_beingProp.tokenIconIDByType(data.upgrade);
					if (data.id != 0)
					{
						prizeIcon_1time = new ResurtPrizeIcon_Money(data, m_gkContext, m_parent, 186, 208);
					}
					var formhero:IUIHero = m_gkContext.m_UIMgr.getForm(UIFormID.UIHero) as IUIHero;
					if (formhero)
					{
						pos = ((formhero  as IUIHero).getButtonPosInScreen(SysNewFeatures.NFT_XINGMAI) as Point).subtract(pos);
						pos = pos.add(new Point( 20, 20));
						if (data.upgrade == BeingProp.SILVER_COIN)
						{
							pos = pos.add(new Point( -153, -13));
						}
					}
					left += 50;
				}
				if (pos.equals((m_parent).localToScreen(new Point(0, 0))))//默认走包裹路线
				{
					form = m_gkContext.m_UIMgr.getForm(UIFormID.UiSysBtn) as IUiSysBtn;
					if (form)
					{
						pos=((form  as IUiSysBtn).getBtnPosInScreenByIdx(SysbtnMgr.SYSBTN_BeiBao) as Point).subtract(pos);
					}
				}
				if (prizeIcon_1time)
				{
					prizeIcon_1time.setDesPos(pos.x, pos.y);
					prizeIcon_1time.setAutoPlayEndAni(false);
					m_prizeIconList.push(prizeIcon_1time);
					prizeIcon_1time.setMidPart((m_parent));
					prizeIcon_1time.setSorPos(pt.x, pt.y);
					prizeIcon_1time.setMidPos(left, 226);
					prizeIcon_1time.begin();
				}
			}
			
		}
		public function begin():void//延迟2s
		{
			m_delay = new AniPause()
			m_delay.delay = 2;
			m_delay.useFrames = false;
			m_delay.onEnd = flytoBtn;
			m_delay.begin();
		}
		private function flytoBtn():void//这里dispose掉anipause，每一个prizeicon依然由midpart负责管理与dispose(flyToPackageBtn中处理)
		{
			m_dissipation = true;
			m_delay.dispose();
			for (var i:uint = 0; i < m_prizeIconList.length; i++)
			{
				m_prizeIconList[i].flyToPackageBtn(new Point(m_prizeIconList[i].m_desPosX,m_prizeIconList[i].m_desPosY));
			}
			m_parent.moveoutItem(this);
		}
		public function moveup():void//上移60
		{
			if (!m_dissipation)
			{
				for each(var item:ResurtPrizeIcon_1time in m_prizeIconList)
				{
					item.m_midPosY -= 60;
					item.setMidPos(item.m_midPosX, item.m_midPosY);
					item.begin();
				}
			}
		}
	}

}