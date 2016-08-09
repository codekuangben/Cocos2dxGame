package modulecommon.scene.beings 
{	
	import org.ffilmation.engine.core.fScene;
	import com.pblabs.engine.entity.BeingEntity;
	import com.util.UtilHtml;
	import org.ffilmation.engine.renderEngines.flash9RenderEngine.fFlash9SceneObjectSeqRenderer;
	import modulecommon.GkContext;		
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class Npc extends BeingEntity 
	{
		public function Npc(defObj:XML, scene:fScene) 
		{
			super(defObj, scene);
			//this.scene.engine.m_context.m_npcManager.addBeing(this);
		}				
		
		public function get gkcontext():GkContext
		{
			return this.context.m_gkcontext as GkContext;
		}
	}
}