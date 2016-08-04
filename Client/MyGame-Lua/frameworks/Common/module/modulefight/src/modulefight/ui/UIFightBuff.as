package modulefight.ui
{
	//import com.bit101.components.Panel;
	//import com.bit101.components.VBox;
	//import com.pblabs.engine.entity.EntityCValue;
	
	//import modulecommon.scene.prop.table.DataTable;
	import modulecommon.ui.Form;
	import modulefight.scene.fight.FightDB;
	
	import modulefight.netmsg.stmsg.stEntryState;

	//import modulecommon.ui.FormStyleOne;
	/**
	 * ...
	 * @author 
	 * @brief buff 显示   
	 */
	public class UIFightBuff extends Form
	//public class UIFightBuff extends FormStyleOne
	{	
		protected var m_fightDB:FightDB;
		protected var m_addBuffList:Vector.<BufferPanel>;
		protected var m_debuffList:Vector.<BufferPanel>;
		
		public function UIFightBuff(fightDB:FightDB) 
		{
			m_fightDB = fightDB;
			m_addBuffList = new Vector.<BufferPanel>();
			m_debuffList = new Vector.<BufferPanel>();
		}
		public function addBuffer(entrystate:stEntryState):void
		{
			var panel:BufferPanel = new BufferPanel(m_gkcontext,m_fightDB);
			panel.setBufferState(entrystate);
			this.addChild(panel);
			var list:Vector.<BufferPanel>;
			
			if (entrystate.base.mode == 1)	//增益
			{
				list = m_addBuffList;				
			}
			else
			{
				list = m_debuffList;				
			}
			list.push(panel);
			addjustPos();			
		}
		public function deleteBuffer(entrystate:stEntryState):void
		{
			var list:Vector.<BufferPanel>;
			if (entrystate.base.mode == 1)	//增益
			{
				list = m_addBuffList;				
			}
			else
			{
				list = m_debuffList;				
			}
			var index:int = 0;
			for (index = 0; index < list.length; index++)
			{
				if (list[index].bufferState == entrystate)
				{
					break;
				}
			}
			if (index < list.length)
			{				
				this.removeChild(list[index]);
				list[index].dispose();
				list.splice(index, 1);
			}
			addjustPos();			
		}
		public function addjustPos():void
		{
			var left:int = 0;
			var top:int = 0;
			
			var i:int;
			for (i = 0; i < m_addBuffList.length; i++)
			{
				m_addBuffList[i].setPos(left, top);
				left += 50;
			}
			
			left = 0;
			if (m_addBuffList.length > 0)
			{
				top += 50;
			}
			for (i = 0; i < m_debuffList.length; i++)
			{
				m_debuffList[i].setPos(left, top);
				left += 50;
			}
		}	
		//去掉所有buffer
		public function disposeAllBuffer():void
		{
			var i:int;
			for (i = 0; i < m_addBuffList.length; i++)
			{
				this.removeChild(m_addBuffList[i]);
				m_addBuffList[i].dispose();
			}
			m_addBuffList.length = 0;
			for (i = 0; i < m_debuffList.length; i++)
			{
				this.removeChild(m_debuffList[i]);
				m_debuffList[i].dispose();
			}
			m_debuffList.length = 0;
		}
	}
}