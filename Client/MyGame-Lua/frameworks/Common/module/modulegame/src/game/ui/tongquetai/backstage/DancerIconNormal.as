package game.ui.tongquetai.backstage
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.net.msg.wunvCmd.WuNvReap;
	import modulecommon.scene.tongquetai.DancerBase;
	import modulecommon.scene.tongquetai.NormalDancer;
	import com.util.UtilHtml;
	import com.util.UtilColor;
	
	/**
	 * ...
	 * @author
	 */
	public class DancerIconNormal extends DancerIconBase
	{
		
		public function DancerIconNormal(param:Object = null)
		{
			super(param);
		}
		
		override public function setData(data:Object):void
		{
			super.setData(data);
			
			if ((m_dancerData as NormalDancer).m_bOwn==false)
			{
				showLockIcon();	
			}
			else
			{
				showDancerIcon();
			}
		}
		private function showLockIcon():void
		{
			m_icon.setPos(14, 11);
			m_icon.setPanelImageSkin("commoncontrol/panel/tongquetai/lock.png");
			//m_iconName.visible = false;
			m_canSelected = false;	
			upIconName();
		}
		private function upIconName():void
		{
			if ((m_dancerData as NormalDancer).m_bOwn==false)
			{
				var wunvreap:int = m_gkContext.m_tongquetaiMgr.m_dicHasNum[m_dancerData.m_id];
				if (wunvreap!=0)//队列中有她的名字
				{
					if ((m_dancerData as NormalDancer).m_reqid==0)//收任意
					{
						m_iconName.text ="舞娘宴客"+((m_dancerData as NormalDancer).m_reqnum-wunvreap)+"次开";
					}
					else
					{
						m_iconName.text =(m_gkContext.m_tongquetaiMgr.m_dicIdToDancer[(m_dancerData as NormalDancer).m_reqid] as DancerBase).m_name+"宴客"+((m_dancerData as NormalDancer).m_reqnum-wunvreap)+"次开";
					}
				}
				else
				{
					if ((m_dancerData as NormalDancer).m_reqid==0)
					{
						m_iconName.text ="舞娘宴客"+((m_dancerData as NormalDancer).m_reqnum)+"次开";
					}
					else
					{
						m_iconName.text =(m_gkContext.m_tongquetaiMgr.m_dicIdToDancer[(m_dancerData as NormalDancer).m_reqid] as DancerBase).m_name+"宴客"+((m_dancerData as NormalDancer).m_reqnum)+"次开";
					}
				}
			}
		}
		private function showDancerIcon():void
		{
			m_icon.setPos(6, -31);
			m_icon.setPanelImageSkin("girlicon/" + m_dancerData.m_icon + ".png");
			//m_iconName.visible = true;
			m_iconName.text = m_dancerData.m_name;
			m_canSelected = true;
			buttonMode = true;
		}
		
		override protected function onMouseEnter(e:MouseEvent):void
		{
			/*var pt:Point = this.localToScreen();
			UtilHtml.beginCompose();*/
			if ((m_dancerData as NormalDancer).m_bOwn==false)
			{				
				/*var wunvreap:int = m_gkContext.m_tongquetaiMgr.m_dicHasNum[m_dancerData.m_id];
				if (wunvreap!=0)//队列中有她的名字
				{
					if ((m_dancerData as NormalDancer).m_reqid==0)//收任意
					{
						UtilHtml.add("收获任意舞女"+((m_dancerData as NormalDancer).m_reqnum-wunvreap)+"次开启", UtilColor.WHITE_Yellow,14);
					}
					else
					{
						UtilHtml.add("收获"+(m_gkContext.m_tongquetaiMgr.m_dicIdToDancer[(m_dancerData as NormalDancer).m_reqid] as DancerBase).m_name+((m_dancerData as NormalDancer).m_reqnum-wunvreap)+"次开启", UtilColor.WHITE_Yellow,14);
					}
				}
				else
				{
					if ((m_dancerData as NormalDancer).m_reqid==0)
					{
						UtilHtml.add("收获任意舞女"+((m_dancerData as NormalDancer).m_reqnum)+"次开启", UtilColor.WHITE_Yellow,14);
					}
					else
					{
						UtilHtml.add("收获"+(m_gkContext.m_tongquetaiMgr.m_dicIdToDancer[(m_dancerData as NormalDancer).m_reqid] as DancerBase).m_name+((m_dancerData as NormalDancer).m_reqnum)+"次开启", UtilColor.WHITE_Yellow,14);
					}
				}
				pt.x += 37;
				m_gkContext.m_uiTip.hintHtiml(pt.x,pt.y, UtilHtml.getComposedContent(),266, true,8);*/
			}
			else
			{
				super.onMouseEnter(e);			
			}
		}
		override public function onSelected():void 
		{
			super.onSelected();
		}
		//得到新的舞女时,调用此函数
		public function addDancer():void
		{
			showDancerIcon();
		}
		
		override public function update():void
		{
			super.update();
			upIconName();
		}
	}

}