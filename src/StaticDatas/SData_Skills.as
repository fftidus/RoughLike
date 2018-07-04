package StaticDatas
{
	import com.MyClass.VertionVo;
	import com.MyClass.Tools.Tool_Function;
	
	import Games.Fights.Fight_Action_SkillDefault;
	

	public class SData_Skills
	{
		public static const TypeSkill_Atk:String="攻击";
		public static const TypeSkill_Pure:String="辅助";
		public static const TypeSkill_Passive:String="被动";
		
		public static const TypeAtk_Physics:String="物理";
		public static const TypeAtk_Magic:String="魔法";
		
		public static const TypeAni_Nor:String="普通";
		public static const TypeAni_Fly:String="飞行";
		public static const TypeAni_movieClip:String="特效";
		
		public static const TypeArea_Single:String="单体";
		public static const TypeArea_Self:String="自身";
		
		private static var instance:SData_Skills;
		public static function getInstance():SData_Skills
		{
			if(instance==null){
				instance=new SData_Skills();
			}
			return instance;
		}
		public static function creatSkillF(role:*,sid:*,lv:int):*{
			var s:*;
			if(getInstance().Dic[sid]==null){
				trace("创造技能："+sid+"失败，没有数据");
				return null;
			}
			if(getInstance().Dic[sid]["class"]!=null){
				if(Tool_Function.isTypeOf(getInstance().Dic[sid]["class"],String) == true){
					var str:String=getInstance().Dic[sid]["class"];
					if(str.indexOf(".")==-1 && str.indexOf(":")==-1){
						s=Tool_Function.onNewClass("Games.Fights."+str,role);
					}else{
						s=Tool_Function.onNewClass(str,role);
					}
				}else{
					s=Tool_Function.onNewClass(getInstance().Dic[sid]["class"],role);
				}
			}else{
//				s=Tool_Function.onNewClass(Fight_Action_SkillDefault,role);
			}
			if(s==null){
				trace("创造技能："+sid+"失败");
				return s;
			}
			s.Lv=lv;
			s.setDefaultValueByDic(getInstance().Dic[sid]);
			return s;
		}
		
		public var Dic:*;
		public function SData_Skills()
		{
			Dic=VertionVo.getData(this);
			if(Dic==null){
				_本地数据();
			}else{
				trace("使用网络Skill");
			}
		}
		private function _本地数据():void
		{
			Dic={};
			var id:*;
			var dic:*;
			//==================id=3001;dic={"ID":id};Dic[id]=dic;
dic["Name"]="科学怪人普攻";
dic["介绍"]="null";
dic["Type"]="攻击";
dic["cd"]=0;
dic["手选"]=false;
dic["属性"]="魔法";
dic["范围"]="单体";
dic["攻击P"]=100;
dic["costValue"]="激素";
dic["cost"]=0;
dic["距离"]=70;
dic["动画类型"]="普通";
dic["攻击帧"]=20;
dic["击打光效swf"]="SWF_FightView";
dic["击打光效"]="mc_hit01";
}
}
}