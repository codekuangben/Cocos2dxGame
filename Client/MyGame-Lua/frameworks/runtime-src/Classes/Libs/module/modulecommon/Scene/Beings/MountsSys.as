package modulecommon.scene.beings
{
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.entity.IMountsSys;
	
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import modulecommon.GkContext;
	import modulecommon.net.msg.mountscmd.stMountData;
	import modulecommon.scene.beings.MountsEntity;
	
	import org.ffilmation.engine.core.fElementContainer;
	import org.ffilmation.engine.elements.fObject;
	import org.ffilmation.engine.helpers.fUtil;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9ElementRenderer;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9HorseSeqRender;

	/**
	 * @author 整个马匹系统
	 */
	public class MountsSys implements IMountsSys
	{
		protected var m_id2HorseDic:Dictionary;		// 马匹 id 到马匹数据的映射
		protected var m_mountsAttr:MountsAttr;		// 坐骑属性，主要是显示

		protected var m_curHorseID:uint;			// 当前骑乘的马匹 ID
		protected var m_horseHost:fObject;			// 马匹的主人
		
		protected var m_parentC:Sprite;				// parent ，为了兼容
		protected var m_elementC:fElementContainer;	// current ，为了兼容

		public function MountsSys(host:fObject, gk:GkContext) 
		{
			m_horseHost = host;
			m_id2HorseDic = new Dictionary();
			m_mountsAttr = new MountsAttr(gk);
			m_parentC = new Sprite();
			m_elementC = new fElementContainer();
		}
		
		// 释放整个资源
		public function dispose():void
		{
			var tmpid:uint;
			for(tmpid in m_id2HorseDic)
			{
				disposeOneMount(tmpid);
			}
		}
		
		// 放生一批坐骑
		public function disposeOneMount(tmpid:uint):void
		{
			if (m_id2HorseDic[tmpid])
			{
				m_id2HorseDic[tmpid].dispose();
				m_id2HorseDic[tmpid] = null;
				delete m_id2HorseDic[tmpid];
			}
		}
		
		public function get curHorseID():uint
		{
			return m_curHorseID;
		}
		
		public function set curHorseID(value:uint):void
		{
			m_curHorseID = value;
		}
		
		public function set curHorseIDByMountsData(mountsdata:stMountData):void
		{
			m_curHorseID = fUtil.mountsTblID(mountsdata.mountid, mountsdata.level);
		}
		
		// 获取当前的马匹数据
		public function get curHorseData():fObject
		{
			return m_id2HorseDic[m_curHorseID];
		}
		
		// 获取当前的马匹显示数据
		public function get curHorseRenderData():fFlash9ElementRenderer
		{
			if (m_id2HorseDic[m_curHorseID])
			{
				return m_id2HorseDic[m_curHorseID].customData.flash9Renderer as fFlash9ElementRenderer;
			}
			return null;
		}
		
		public function get mountsAttr():MountsAttr
		{
			return m_mountsAttr;
		}
		
		public function set mountsAttr(value:MountsAttr):void
		{
			m_mountsAttr = value;
		}
		
		// 创建一批马出来
		public function createHorse(horseid:uint, modelstr:String = ""):fObject
		{
			if (!m_id2HorseDic[horseid])
			{
				m_parentC.addChild(m_elementC);	// 放到空列表上去
				
				m_id2HorseDic[horseid] = new MountsEntity(horseid, m_horseHost, modelstr);
				m_id2HorseDic[horseid].customData.flash9Renderer = new fFlash9HorseSeqRender(null, m_elementC, m_id2HorseDic[horseid]);
			}
			
			return m_id2HorseDic[horseid];
		}
		
		// 骑马
		public function rideHorse(horseid:uint, modelstr:String = ""):void
		{
			curHorseID = horseid;
			createHorse(horseid, modelstr);
			m_horseHost.hasUpdateTagBounds2d = false;
			if (m_horseHost.subState != EntityCValue.TRide)
			{
				m_horseHost.subState = EntityCValue.TRide;
			}
			else	// 强制更新一遍，否则动画不能切换
			{
				m_horseHost.gotoAndPlay(m_horseHost.state2StateStr(m_horseHost.subState));
			}
		}
		
		// 下马
		public function unRideHorse():void
		{
			m_horseHost.hasUpdateTagBounds2d = false;
			curHorseID = 0;
			m_horseHost.subState = EntityCValue.STNone;
		}
		
		// 切换骑乘，上下切换
		public function toggleRideHorse(horseid:uint, modelstr:String = ""):void
		{
			if(m_horseHost.subState == EntityCValue.TRide)
			{
				unRideHorse();
			}
			else
			{
				rideHorse(horseid);
			}
		}
		
		// 换坐骑，在不同坐骑之间切换
		public function changeRideHorse(horseid:uint):void
		{
			if (m_horseHost.subState == EntityCValue.TRide)	// 如果当前已经有坐骑，就是换马
			{
				rideHorse(horseid);
			}
			else	// 就是骑乘
			{
				rideHorse(horseid);
			}
		}
	}
}