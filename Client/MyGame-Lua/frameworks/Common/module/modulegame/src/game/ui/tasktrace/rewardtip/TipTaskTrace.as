package game.ui.tasktrace.rewardtip 
{	
	import com.bit101.components.Label;
	import com.util.CmdParse;
	import modulecommon.appcontrol.Name_ValueCtrol;
	import modulecommon.appcontrol.TipBase;
	import modulecommon.GkContext;
	import modulecommon.res.ResGrid9;
	import modulecommon.scene.prop.object.ZObjectDef;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TObjectBaseItem;
	import modulecommon.scene.task.TaskItem;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	
	/**
	 * ...
	 * @author 
	 */
	public class TipTaskTrace extends TipBase
	{		
		public static const WIDTH:int = 150;
		private var m_title:Label;
		private var m_exp:Name_ValueCtrol;
		private var m_yinbi:Name_ValueCtrol;
		private var m_jianghun:Name_ValueCtrol;
		private var m_contribution:Name_ValueCtrol;
		private var m_wubinLabel:Label;
		private var m_objLabelList:Vector.<Label>;
		private var m_reward:stReward;
		public function TipTaskTrace(gk:GkContext) 
		{
			super(gk);
			m_title = new Label(this, 10, 10);
			m_title.text = "任务奖励：";
			m_title.setFontColor(UtilColor.WHITE_Yellow);
			
			m_exp = new Name_ValueCtrol(this);
			m_exp.m_name.text = "经验";
			m_exp.m_name.setFontColor(UtilColor.WHITE_Yellow);
			m_exp.m_value.x = 35;
			
			m_yinbi = new Name_ValueCtrol(this);
			m_yinbi.m_name.text = "银币";
			m_yinbi.m_name.setFontColor(UtilColor.WHITE_Yellow);	
			m_yinbi.m_value.x = 35;
			
			m_jianghun = new Name_ValueCtrol(this);
			m_jianghun.m_name.text = "将魂";
			m_jianghun.m_name.setFontColor(UtilColor.WHITE_Yellow);	
			m_jianghun.m_value.x = 35;
			
			m_contribution = new Name_ValueCtrol(this);
			m_contribution.m_name.text = "军团贡献";
			m_contribution.m_name.setFontColor(UtilColor.WHITE_Yellow);	
			m_contribution.m_value.x = 60;
			
			m_wubinLabel = new Label(this,0,0,"物品", UtilColor.WHITE_Yellow);
			m_objLabelList = new Vector.<Label>();
			m_reward = new stReward();
			this.setSkinGrid9Image9(ResGrid9.StypeTip);
			this.width = WIDTH;
		}
		protected function hideAllCtrls():void
		{
			m_exp.visible = false;
			m_yinbi.visible = false;
			m_contribution.visible = false;
			m_wubinLabel.visible = false;
			m_jianghun.visible = false;
		}
		
		override public function dispose():void 
		{
			
		}
		public function disposeEx():void 
		{
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
			super.dispose();
		}
		public function setTask(taskItem:TaskItem):void
		{
			var left:Number = 10;
			var leftValue:Number = 40;
			var leftValue2:Number = 80;
			var top:Number = 30;			
			hideAllCtrls();
			if (taskItem.m_rewardList == null)
			{
				this.height = 0;
				return;
			}
			m_reward.parse(m_gkContext, taskItem);
		
			if (m_reward.exp)
			{
				m_exp.setPos(left, top);
				m_exp.m_value.text = m_reward.exp.toString();				
				top += 20;
				m_exp.visible = true;
			}
			
			if (m_reward.yinbi)
			{
				m_yinbi.setPos(left, top);
				m_yinbi.m_value.text = m_reward.yinbi.toString();
				top += 20;
				m_yinbi.visible = true;
			}			
			
			if (m_reward.contribution)
			{
				m_contribution.setPos(left, top);
				m_contribution.m_value.text = m_reward.contribution.toString();
				top += 20;
				m_contribution.visible = true;
			}
			if (m_reward.jianghun)
			{
				m_jianghun.setPos(left, top);
				m_jianghun.m_value.text = m_reward.jianghun.toString();
				top += 20;
				m_jianghun.visible = true;
			}
			if (m_reward.m_list.length)
			{
				m_wubinLabel.setPos(left, top);
				m_wubinLabel.visible = true;
				
				var i:int;				
				var label:Label;
				left = 45;
				var maxLen:int = 0;
				for (i = 0; i < m_reward.m_list.length; i++)
				{
					label = addUsedCtrol(Label) as Label;
					label.setPos(left, top);
					
					var base:TObjectBaseItem = m_gkContext.m_dataTable.getItem(DataTable.TABLE_OBJECT, m_reward.m_list[i].m_id) as TObjectBaseItem;
					if (base)
					{
						UtilHtml.beginCompose();
						UtilHtml.add("[" + base.m_name + "]", ZObjectDef.colorValue(base.m_iIconColor));
						UtilHtml.addStringNoFormat(" × " + m_reward.m_list[i].m_num.toString());
						label.htmlText = UtilHtml.getComposedContent();
						label.flush();
						if (maxLen < label.width)
						{
							maxLen = label.width;
						}
						//label.text="["+base.m_name+"] × "+m_reward.m_list[i].m_num.toString();
					}					
					top += 20;
				
				}
				
				maxLen += left+10;
				
			}
			top += 8;
			this.height = top;
			if (maxLen > WIDTH)
			{
				this.width = maxLen;
			}
		}
		
	}

}