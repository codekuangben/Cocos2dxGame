package game.logic
{
	import modulecommon.logicinterface.IMountsSysLogic;
	import modulecommon.GkContext;
	import modulecommon.scene.beings.MountsSys;
	import modulecommon.net.msg.mountscmd.stMountData;
	import modulecommon.scene.watch.WuMainProperty_Watch;
	import modulecommon.scene.wu.WuProperty;
	import modulecommon.net.msg.mountscmd.TypeValue;
	
	/**
	 * @brief 坐骑系统
	 */
	public class MountsSysLogic implements IMountsSysLogic
	{
		protected var m_gkContext:GkContext;
		protected var m_btnClkLoadModuleMode:Boolean;	// 按钮点击加载模块
		protected var m_otherLoadModuleMode:Boolean;	// 观察别人加载模块
		
		// 被人的坐骑
		protected var m_otherMountsSys:MountsSys;
		protected var m_otherTmpID:uint;		// 被观察的 tmpid

		public function MountsSysLogic(value:GkContext)
		{
			m_gkContext = value;
			m_otherMountsSys = new MountsSys(null, value);
		}
		
		public function get btnClkLoadModuleMode():Boolean
		{
			return m_btnClkLoadModuleMode;
		}
		
		public function set btnClkLoadModuleMode(value:Boolean):void
		{
			m_btnClkLoadModuleMode = value;
		}
		
		public function get otherLoadModuleMode():Boolean
		{
			return m_otherLoadModuleMode;
		}
		
		public function set otherLoadModuleMode(value:Boolean):void
		{
			m_otherLoadModuleMode = value;
		}
		
		public function psstViewOtherUserMountCmd(mountlist:Vector.<stMountData>, tplist:Vector.<TypeValue>):void
		{
			m_otherMountsSys.mountsAttr.baseAttr.mountlist = mountlist;
			m_otherMountsSys.mountsAttr.trainAttr.trainprops = tplist;
			m_otherMountsSys.mountsAttr.clearSubLst();
			m_otherMountsSys.mountsAttr.buildSubLst();
			m_otherMountsSys.mountsAttr.buildTJAttr();
		}
		
		public function get otherMountsSys():MountsSys
		{
			return m_otherMountsSys;
		}
		
		public function get otherTmpID():uint
		{
			return m_otherTmpID;
		}
		
		public function set otherTmpID(value:uint):void
		{
			m_otherTmpID = value;
		}
		
		public function hasOtherMountsData():Boolean
		{
			if (m_gkContext.m_contentBuffer.getContent("stViewOtherUserMountCmd", false))
			{
				var wu:WuMainProperty_Watch = m_gkContext.m_watchMgr.getWuByHeroID(WuProperty.MAINHERO_ID) as WuMainProperty_Watch;
				if (wu)
				{
					if (m_gkContext.m_mountsSysLogic.otherTmpID == wu.m_uHeroID)
					{
						return true;
					}
				}
			}
			
			return false;
		}
	}
}