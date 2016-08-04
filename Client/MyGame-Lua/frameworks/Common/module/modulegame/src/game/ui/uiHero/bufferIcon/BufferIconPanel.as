package game.ui.uiHero.bufferIcon 
{
	import com.bit101.components.Component;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import modulecommon.net.msg.attrbufferCmd.stBufferData;
	import modulecommon.scene.hero.AttrBufferMgr;
	import modulecommon.scene.hero.ItemBuffer;
	/**
	 * ...
	 * @author ...
	 * 人物buffer显示:属性加成药水、卧薪尝胆...
	 */
	public class BufferIconPanel extends Component
	{
		private var m_gkContext:GkContext;
		private var m_list:Array;
		private var m_bufferList:Vector.<BufferBase>;
		
		public function BufferIconPanel(gk:GkContext, parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			
			m_bufferList = new Vector.<BufferBase>();
		}
		
		public function initData():void
		{
			m_list = m_gkContext.m_attrBufferMgr.bufferList;
			
			var item:ItemBuffer;
			for (var i:int = 0; i < m_list.length; i++)
			{
				item = m_list[i];
				addBufferIcon(item.type, item.bufferID);
			}
			
			updateIconPos();
		}
		
		public function updateIconPos():void
		{
			var buffer:BufferBase;
			var i:int;
			var j:int = 0;
			var k:int = 0;
			for (i = 0; i < m_bufferList.length; i++)
			{
				buffer = m_bufferList[i];
				
				if (AttrBufferMgr.TYPE_WORLDBOSS == buffer.type)
				{	
					buffer.setPos(320 + k * 110, -110);
					k++;
				}
				else
				{
					buffer.setPos(j * 28, 0);
					j++;
				}
			}
		}
		
		public function addBufferIcon(type:int, bufferid:uint):void
		{
			var buffer:BufferBase;
			if (AttrBufferMgr.TYPE_SANGGUOZHANCHANG == type)
			{
				buffer = createSanguoBuffer(bufferid);
			}
			else if (AttrBufferMgr.TYPE_YAOSHUI == type)
			{
				buffer = createYaoshuiBuffer(bufferid);
			}
			else if (AttrBufferMgr.TYPE_WORLDBOSS == type)
			{
				//不在世界BOSS地图或者不在精英boss地图，不显示鼓舞、激励
				if (m_gkContext.m_worldBossMgr.m_bInWBoss)
				{
					buffer = createWorldbossBuffer(bufferid);
				}
				else if (m_gkContext.m_elitebarrierMgr.m_bInJBoss)
				{
					if (getBufferIcon(AttrBufferMgr.BufferID_Woxinchangdan))
					{
						removeBufferIcon(AttrBufferMgr.BufferID_Woxinchangdan);
					}
					buffer = createJbossBuffer(bufferid);
				}
				else
				{
					return;
				}
			}
			
			if (null == getBufferIcon(bufferid))
			{
				m_bufferList.push(buffer);
			}
			
			updateIconPos();
		}
		
		//创建卧薪尝胆Buffer(三国战场)
		public function createSanguoBuffer(bufferid:uint):BufferBase
		{
			var ret:SanguoBuffer = getBufferIcon(bufferid) as SanguoBuffer;
			if (null == ret)
			{
				ret = new SanguoBuffer(m_gkContext, this);
			}
			ret.setData(bufferid);
			
			return ret;
		}
		
		//创建属性加成药水buffer:武力、智力、统率、兵力
		public function createYaoshuiBuffer(bufferid:uint):BufferBase
		{
			var ret:YaoshuiBuffer = getBufferIcon(bufferid) as YaoshuiBuffer;
			var buffer:ItemBuffer = m_gkContext.m_attrBufferMgr.getBuffer(bufferid);
			
			if (null == ret)
			{
				ret = new YaoshuiBuffer(m_gkContext, this);
			}
			
			if (buffer)
			{
				ret.setData(buffer);
			}
			
			return ret;
		}
		
		//创建世界BOSS中buffer:鼓舞、激励
		public function createWorldbossBuffer(bufferid:uint):BufferBase
		{
			var ret:WorldbossBuffer = getBufferIcon(bufferid) as WorldbossBuffer;
			var buffer:ItemBuffer = m_gkContext.m_attrBufferMgr.getBuffer(bufferid);
			
			if (null == buffer)
			{
				var stbufferdata:stBufferData = new stBufferData();
				stbufferdata.m_bufferid = bufferid;
				buffer = m_gkContext.m_attrBufferMgr.createBuffer(stbufferdata);
				
				if (null == buffer)
				{
					return null;
				}
			}
			
			if (null == ret)
			{
				ret = new WorldbossBuffer(m_gkContext, this);
				ret.setData(buffer);
			}
			else
			{
				ret.updateData(buffer);
			}
			
			return ret;
		}
		/**
		 * 创建精英BOSS中buffer:vip加成
		 */
		private function createJbossBuffer(bufferid:uint):BufferBase
		{
			var ret:JbossBuffer = getBufferIcon(bufferid) as JbossBuffer;
			var buffer:ItemBuffer = m_gkContext.m_attrBufferMgr.getBuffer(bufferid);
			
			if (null == buffer)
			{
				var stbufferdata:stBufferData = new stBufferData();
				stbufferdata.m_bufferid = bufferid;
				buffer = m_gkContext.m_attrBufferMgr.createBuffer(stbufferdata);
				
				if (null == buffer)
				{
					return null;
				}
			}
			
			if (null == ret)
			{
				ret = new JbossBuffer(m_gkContext, this);
				ret.setData(buffer);
			}
			else
			{
				ret.updateData(buffer);
			}
			
			return ret;
		}
		public function removeBufferIcon(bufferid:uint):void
		{
			var i:int;
			var item:BufferBase;
			
			for (i = 0; i < m_bufferList.length; i++)
			{
				item = m_bufferList[i];
				if (bufferid == item.bufferID)
				{
					m_bufferList.splice(i, 1);
					this.removeChild(item);
					item.dispose();
					break;
				}
			}
			
			updateIconPos();
		}
		
		public function updateBufferIcon(type:int, bufferid:uint):void
		{
			var buffer:ItemBuffer = m_gkContext.m_attrBufferMgr.getBuffer(bufferid);
			var buffericon:BufferBase = getBufferIcon(bufferid);
			if (buffericon)
			{
				if (AttrBufferMgr.TYPE_YAOSHUI == type)
				{
					(buffericon as YaoshuiBuffer).setData(buffer);
				}
				else if (AttrBufferMgr.TYPE_WORLDBOSS == type)
				{
					(buffericon as WorldbossBuffer).updateData(buffer);
				}
			}
			else
			{
				addBufferIcon(type, bufferid);
			}
		}
		
		//更新buffer图标显示状态:有效(亮态)、无效(灰态)  bEnabled:是否有效
		public function updateBufferEnabled(type:int, bEnabled:Boolean):void
		{
			var i:int;
			var item:BufferBase;
			
			for (i = 0; i < m_bufferList.length; i++)
			{
				item = m_bufferList[i];
				if (item.type == type)
				{
					if (bEnabled)
					{
						item.becomeUnGray();
					}
					else
					{
						item.becomeGray();
					}
				}
			}
		}
		
		private function getBufferIcon(bufferid:uint):BufferBase
		{
			for each(var item:BufferBase in m_bufferList)
			{
				if (item.bufferID == bufferid)
				{
					return item;
				}
			}
			
			return null;
		}
		/**
		 * Jboss的buf的levelupVip时用
		 */
		public function updataJbossBuf(bufferid:uint):void
		{
			var icon:JbossBuffer = getBufferIcon(bufferid) as JbossBuffer;
			if (icon)
			{
				icon.updataVipLevel();
			}
		}
		
		public function updateLeftTimes(bufferid:uint, value:uint):void
		{
			var bufferbase:BufferBase = getBufferIcon(bufferid);
			
			if (bufferbase && AttrBufferMgr.TYPE_WORLDBOSS == bufferbase.type)
			{
				(bufferbase as WorldbossBuffer).updateLeftTimes(value);
			}
		}
	}

}