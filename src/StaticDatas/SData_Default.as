package StaticDatas
{
	import com.MyClass.VertionVo;
	
	public class SData_Default
	{
		private static var instance:SData_Default;
		public static function getInstance():SData_Default
		{
			if(instance==null)instance=new SData_Default();
			return instance;
		}
		
		public	var Dic:*;
		public function SData_Default()
		{
			Dic=VertionVo.getData(this);
			if(Dic==null)on本地();
		}
		
		public static function get奖励文字(arr:Array):String
		{
			//[{"type":"金币","数量":100}],"战斗ID":1};
			var str:String="";
			for(var i:int=0;i<arr.length;i++)
			{
				if(i>0)str+="，";
				var type:String=arr[i]["type"];
				if(type=="文字")	str+=arr[i]["内容"];
				else if(type=="道具")
				{
//					var itemID:int=arr[i]["ID"];
//					var sd:SData_Item=SData_Item.getInstance();
//					str+=sd.Dic[itemID]["Name"]+" x"+arr[i]["数量"];
				}
				else	str+=type+" x"+arr[i]["数量"];
			}
			return str;
		}
		
		public static function isNeet百分比(vname:String):Boolean{
			if(instance && instance.Dic["百分比属性"].indexOf(vname) == -1){
				return false;
			}
			return true;
		}
		public static function getShowValueName(key:String):String{
			if(getInstance().Dic["属性名转化"][key]!=null){
				return getInstance().Dic["属性名转化"][key];
			}
			return key;
		}
		
		private function on本地():void
		{
			Dic={};
			Dic[SData_Strings.SD_Default_SaveLoginNum]=5;
			Dic["默认字体"]="微软雅黑";
			Dic["百分比属性"]=["命中","闪避","技能命中","技能抵抗","暴击率","暴击值","物理减免","魔法减免","物攻加成","魔攻加成","伤害加成"
			,"解锁隐藏","陷阱解除"];
			Dic["职业"]={81:"狂战士",83:"科学怪人",85:"猎魔人",87:"黑魔法师",91:"祭祀"};
			Dic["品质名"]={1:"普通",2:"魔法",3:"稀有",4:"史诗",5:"传说"};
			Dic["品质色"]={1:0x353535,2:0x1b89e7,3:0xbe27e9,4:0xfc720c,5:0xe92f13};
			Dic["部位名"]={1:"头盔",2:"衣服",3:"护腿",4:"鞋子",5:"项链"};
			Dic["属性名转化"]={"hp":"生命","mp":"魔法"};
			Dic["逃跑道具"]=301;
		}
		
		
	}
}