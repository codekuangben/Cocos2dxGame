package modulecommon.net.msg.sceneHeroCmd 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.ByteArray;
	//import common.net.endata.EnNet;
	//import com.util.UtilTools;
	public class t_HeroData 
	{
		public var id:uint;			//合成id; id=tableID*10+加数
		public var tableID:uint;	//该武将在战斗npc表中的ID
		//public var name:String;
		public var job:uint;
		public var num:uint;
		public var hp:uint;		
		public var soldiertype:uint;
		public var fight:uint;
		public var trainlevel:uint;
		public var trainpower:uint;
		//public var color:uint;
		//public var activeHeros:Vector.<ActiveHero>;
		//public var tianfu:Vector.<uint>;
		//public var jinNang:Vector.<uint>;//锦囊id
		//public var zhanshu:uint;//技能id

		public function deserialize(byte:ByteArray):void
		{
			id = byte.readUnsignedInt();
			tableID = id / 10;
			//name = UtilTools.readStr(byte, EnNet.MAX_NAMESIZE);
			
			job = byte.readUnsignedShort();
			num = byte.readUnsignedShort();
			hp = byte.readUnsignedInt();			
			soldiertype = byte.readUnsignedInt();
			fight = byte.readUnsignedByte();			
			trainlevel = byte.readUnsignedShort();
			trainpower = byte.readUnsignedInt();
			//color = byte.readUnsignedByte();
			
			/*activeHeros = new Vector.<ActiveHero>();
			var i:int;
			var data:uint;
			var hero:ActiveHero;
			for (i = 0; i < 4; i++)
			{
				data = byte.readUnsignedInt();
				if (data > 0)
				{
					hero = new ActiveHero();
					hero.id = data;
					activeHeros.push(hero);
				}
			}*/
			/*tianfu = new Vector.<uint>();
			for (i = 0; i < 4; i++)
			{
				data = byte.readUnsignedInt();
				if (data > 0)
				{
					tianfu.push(data);
				}
			}
			jinNang = new Vector.<uint>();
			jinNang[0] = byte.readUnsignedInt();
			jinNang[1] = byte.readUnsignedInt();
			zhanshu = byte.readUnsignedInt();	*/			
		}
	}

}
/*
 * struct t_HeroData
    {   
        DWORD id; 
        //char name[MAX_NAMESIZE];
        WORD job;
		WORD num;	//数量
        DWORD hp;   //带兵量
        DWORD soldiertype;  //兵种
        BYTE fight;
		WORD trainlevel;    //当前培养等级
        DWORD trainpower;   //当前培养能量
		//BYTE color;
		//DWORD  activeHeros[4];	//激活武将
		//DWORD  tianfu[4];	//4个天赋
        //DWORD jinnang;  //锦囊id
        //DWORD zhanshu;  //技能id
    }; 
*/