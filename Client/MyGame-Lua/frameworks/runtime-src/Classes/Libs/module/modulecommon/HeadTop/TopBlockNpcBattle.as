package modulecommon.headtop
{
	import modulecommon.GkContext;
	import modulecommon.scene.beings.Npc;

	/**
	 * @brief 战斗  Npc 头顶名字
	 * */
	public class TopBlockNpcBattle extends HeadTopBlockBase
	{		
		private var m_npc:Npc;
		public function TopBlockNpcBattle(gk:GkContext, npc:Npc) 
		{
			super(gk);
			m_npc = npc;
		}
		
		override public function update():void
		{
			this.clearAutoData();
			
			var content:String;
			var color:uint = 0x00ff0c;		
			
			content = "士气: " + m_npc.shiqi;
			addAutoData(content, color, 18);
		}
	}
}