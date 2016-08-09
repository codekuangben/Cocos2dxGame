package modulecommon.headtop 
{
	import com.bit101.components.Ani;
	import com.bit101.components.Panel;
	import modulecommon.scene.beings.UserState;
	import modulecommon.scene.zhanchang.SanguoZhanChangMgr;
	/**
	 * ...
	 * @author ...
	 */
	public class DisplayForSanguoZhanChang extends DisplayControlBase
	{
		private var m_carrySignPanel:Panel;		//拉货状态
		private var m_battleSign:Ani;
		public function DisplayForSanguoZhanChang(headTop:HeadTopPlayerStateBase) 
		{
			super(headTop);			
		}
		override public function update():void
		{
			m_headTop.clearAutoData();
			var color:uint;
			if (m_gkContext.m_sanguozhanchangMgr.zhenying == m_player.m_zhenying)
			{
				color = 0x00e005;
			}
			else
			{
				color = 0xb90000;
			}
			if (m_gkContext.m_sanguozhanchangMgr.bInJinGongJianGe&&m_player.isHero)
			{
				m_headTop.addAutoData("下次战斗间隔 "+m_gkContext.m_sanguozhanchangMgr.remainedFightTime+" 秒", 0xdf0000, 14);
			}
			m_headTop.addNameWithZone(color);
			m_headTop.addAutoData("【"+SanguoZhanChangMgr.s_zhenyingName(m_player.m_zhenying)+"】"+SanguoZhanChangMgr.s_idToTitleName(m_player.m_titileInSanguozhanchang), color, 14);
			
			if (m_player.isSetWithArray([UserState.USERSTATE_ORE_GREEN, UserState.USERSTATE_ORE_BLUE, UserState.USERSTATE_ORE_PURPLE]))
			{
				showCarrySign();
			}
			else
			{
				removeCarrySign();
			}
			if (m_player.isUserSet(UserState.USERSTATE_FIGHTING))
			{
				showBattleSign();
			}
			else
			{
				removeBattleSign();
			}
		}
		
		private function showCarrySign():void
		{
			if (m_carrySignPanel == null)
			{
				m_carrySignPanel = new Panel(m_headTop, -25);
				m_headTop.recycleSkins = true;
			}
			m_carrySignPanel.y = m_headTop.curTop - 56;
			m_headTop.curTop = m_carrySignPanel.y;
			
			var str:String="";
			if (m_player.isUserSet(UserState.USERSTATE_ORE_GREEN))
			{
				str = "greenmine.png";
			}
			else if (m_player.isUserSet(UserState.USERSTATE_ORE_BLUE))
			{
				str = "bluemine.png";
			}
			else if (m_player.isUserSet(UserState.USERSTATE_ORE_PURPLE))
			{
				str = "purplemine.png";
			}
			str = "commoncontrol/panel/sanguozhanchang/" + str;
			m_carrySignPanel.setPanelImageSkin(str);
		}
		private function removeCarrySign():void
		{
			if (m_carrySignPanel)
			{
				if (m_carrySignPanel.parent)
				{
					m_carrySignPanel.parent.removeChild(m_carrySignPanel);
				}
				m_carrySignPanel.dispose();
				m_carrySignPanel = null;
			}
		}
		private function showBattleSign():void
		{
			if (m_battleSign == null)
			{
				m_battleSign = new Ani(m_gkContext.m_context);	
				m_headTop.addChild(m_battleSign);
				m_battleSign.centerPlay = true;				
				m_battleSign.setImageAni("ejjiaosezhandouzhong.swf");
				m_battleSign.duration = 0.6;
				m_battleSign.repeatCount = 0;
				m_battleSign.mouseEnabled = false;
				m_battleSign.mouseChildren = false;
			}
			m_battleSign.y = m_headTop.curTop - 25;
			m_headTop.curTop = m_battleSign.y;
			m_battleSign.begin();
		}
		private function removeBattleSign():void
		{
			if (m_battleSign)
			{
				if (m_battleSign.parent)
				{
					m_battleSign.parent.removeChild(m_battleSign);
				}
				m_battleSign.dispose();
				m_battleSign = null;
			}
		}
		
		override public function dispose():void 
		{
			removeCarrySign();
			removeBattleSign();
			super.dispose();
		}
		
	}

}