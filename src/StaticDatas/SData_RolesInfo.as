package StaticDatas
{
	import com.MyClass.VertionVo;
	
	public class SData_RolesInfo
	{
		private static var instance:SData_RolesInfo;
		private static function getInstance():SData_RolesInfo
		{
			if(instance==null)instance=new SData_RolesInfo();
			return instance;
		}
		
		public var Dic:*;
		public function SData_RolesInfo()
		{
			Dic=VertionVo.getData(this);
			if(Dic==null)	_本地数据();
			else{
				trace("使用网络RolesInfo");
			}
		}
		
		private function _本地数据():void
		{
			Dic={};
			var id:int;
			var dic:*;
			var dicAct:*;
			//==================id=81;dic={};Dic[id]=dic;dicAct={};
dic["Name"]="狂战士";
dic["性别"]="男";
dic["种族"]="人";
//dic["spine"]="kuangzhanshi";
dic["基础属性"]={"命中":100,"物攻":80,"技能抵抗":30,"魔攻":80,"技能命中":100,"暴击率":30,"暴击值":150,"闪避":10,"魔防":44,"物防":44,"速度":14,"hp":429};
dic["buff"]=100000;
dic["skill"]=[1001,1002,1003,1004,1005,1006,1007,1008];
dic["AI"]=[null];
//dic["Action"]=dicAct;
//dicAct["站立"]={"url":"yuandi"};
//dicAct["前进"]={"url":"qianjin"};
//dicAct["后退"]={"url":"houtui"};
//dicAct["挨打"]={"url":"aida"};
dic["属性"]={"mc缩放":0.5,"显示属性":"怒气"};
//==================
id=83;dic={};Dic[id]=dic;dicAct={};
dic["Name"]="科学怪人";
dic["性别"]="男";
dic["种族"]="改造";
//dic["spine"]="kexueguairen";
dic["基础属性"]={"命中":80,"物攻":48,"技能抵抗":30,"魔攻":48,"技能命中":100,"暴击率":30,"暴击值":150,"闪避":5,"魔防":50,"物防":50,"速度":13,"hp":546};
dic["buff"]=120000;
dic["skill"]=[3001,3002,3003,3004,3005,3006,3007,3008];
dic["AI"]=[null];
dic["Action"]=dicAct;
//dicAct["站立"]={"url":"zhanli"};
//dicAct["前进"]={"url":"qianjin"};
//dicAct["后退"]={"url":"houtui"};
//dicAct["挨打"]={"url":"aida"};
dic["属性"]={"mc缩放":0.7,"显示属性":"激素"};
//==================
id=85;dic={};Dic[id]=dic;dicAct={};
dic["Name"]="猎魔人";
dic["性别"]="男";
dic["种族"]="改造";
//dic["spine"]="liemoren";
dic["基础属性"]={"命中":100,"物攻":96,"技能抵抗":30,"魔攻":96,"技能命中":100,"暴击率":30,"暴击值":150,"闪避":20,"魔防":38,"物防":38,"速度":18,"hp":312};
dic["buff"]=140000;
dic["skill"]=[5001,5002,5003,5004,5005,5006,5007,5008,5009];
dic["AI"]=[501,502,503,504,505,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528];
//dic["Action"]=dicAct;
//dicAct["站立"]={"url":"yuandi"};
//dicAct["前进"]={"url":"zoulu"};
//dicAct["后退"]={"url":"houtui"};
//dicAct["挨打"]={"url":"aida"};
dic["属性"]={"mc缩放":0.5,"显示属性":"mp"};
//==================
id=87;dic={};Dic[id]=dic;dicAct={};
dic["Name"]="黑魔法师";
dic["性别"]="女";
dic["种族"]="人";
//dic["spine"]="heimofashi";
dic["基础属性"]={"命中":100,"物攻":80,"技能抵抗":30,"魔攻":80,"技能命中":100,"暴击率":30,"暴击值":150,"闪避":10,"魔防":42,"物防":42,"速度":16,"hp":390};
dic["buff"]=140000;
dic["skill"]=[7001,7002,7003,7004,7005,7006,7007,7008];
dic["AI"]=[null];
//dic["Action"]=dicAct;
//dicAct["站立"]={"url":"yuandi"};
//dicAct["前进"]={"url":"qianjin"};
//dicAct["后退"]={"url":"houtui"};
//dicAct["挨打"]={"url":"aida"};
dic["属性"]={"mc缩放":0.5,"显示属性":"mp"};
dic["swf资源"]=["Role89_Skill"];
//==================
id=91;dic={};Dic[id]=dic;dicAct={};
dic["Name"]="祭祀";
dic["性别"]="女";
dic["种族"]="人";
//dic["spine"]="jisi";
dic["基础属性"]={"命中":100,"物攻":80,"技能抵抗":30,"魔攻":80,"技能命中":100,"暴击率":30,"暴击值":150,"闪避":10,"魔防":42,"物防":42,"速度":16,"hp":390};
dic["buff"]=140000;
dic["skill"]=[1101,1102,1103,1104,1105,1106,1107,1108];
dic["AI"]=[null];
//dic["Action"]=dicAct;
//dicAct["站立"]={"url":"yuandi"};
//dicAct["前进"]={"url":"qianjin"};
//dicAct["后退"]={"url":"houtui"};
//dicAct["挨打"]={"url":"aida"};
dic["属性"]={"mc缩放":0.5,"显示属性":"mp"};
dic["swf资源"]=["Role89_Skill"];
//==================
}
		
		
		
		
	}
}