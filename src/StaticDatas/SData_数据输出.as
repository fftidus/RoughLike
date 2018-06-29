package StaticDatas
{
	import com.MyClass.Tools.Base64;
	import com.MyClass.Tools.Tool_StringBuild;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	public class SData_数据输出
	{
		//后台数据输出
		public static const Type任务:String="任务";
		public static const Type道具:String="道具";
		public static const Type关卡:String="关卡";
		public static const Type番:String="番";
		public static function onCreatData(...arg):void
		{
			while(arg.length>0)
			{
				var name:String=arg[0];arg.shift();
				var str:String;
				var sd:SData_数据输出=new SData_数据输出();
				if(name==Type番){
//					str=sd.addObject(new SData_Fan().Dic);
				}
				else
				{
					trace("暂未支持的输出类型:",name);
					continue;;
				}
				//
				var file:File	= File.desktopDirectory.resolvePath(name+"数据.txt");
				var myFileStream:FileStream = new FileStream();
				myFileStream.open(file, FileMode.WRITE);
				myFileStream.writeUTFBytes(str);
				myFileStream.close();
			}
		}
		/*****************************************************************************/
		
		public	var Str输出:String;
		private var strList:Array = new Array();
		public	var KeyAlwaysString:Boolean=false;
		public function SData_数据输出()
		{
		}
		/***************************输出给JAVA******************************/
		public function addObject(obj:Object):String
		{
			this.write(obj);
			this.toString();
			return Str输出;
		}
		private function write(obj:*):void
		{
			if(obj is int){
				this.writeInt(int(obj));
			}else if(obj is Number){
				this.writeDouble(Number(obj));
			}else if(obj is Boolean){
				this.writeBoolean(Boolean(obj));
			}else if(obj is String){
				this.writeUTF(String(obj));
			}else if(obj is Array){
				this.writeArray(obj as Array);
			}else if(obj is Dictionary){
				this.writeDict(obj as Dictionary);
			}else if(obj == null){
				this.writeNull();
			}
			else if(obj is ByteArray)
			{
				writeByteArray(obj);
			}
			else if(obj is Class)
			{
				var str:String	= getQualifiedClassName(obj);
				this.writeUTF(str);
			}
			else
			{
				writeDict(obj);
			}
		}
		private function writeInt(num:int):void
		{
			this.strList.push("int");
			this.strList.push(num);
		}
		private function writeDouble(num:Number):void
		{
			this.strList.push("double");
			this.strList.push(num);
		}
		private function writeUTF(str:String):void
		{
			this.strList.push("utf");
			str=Tool_StringBuild.replaceSTR(str,"\n","\\n");
			this.strList.push(str.replace("&", "＆"));
		}
		private function writeBoolean(b:Boolean):void
		{
			this.strList.push("bool");
			this.strList.push(b ? "1":"0");
		}
		private function writeArray(arr:Array):void
		{
			this.strList.push("array");
			this.write(arr.length);
			for(var m:int=0;m<arr.length;m++){
				this.write(arr[m]);
			}
		}
		private function writeDict(dict:*):void
		{
			this.strList.push("dict");
			var keys:Array = new Array();
			var values:Array = new Array();
			for(var key:* in dict){
				keys.push(key);
				values.push(dict[key]);
			}
			this.write(keys.length);
			for(var m:int=0;m<keys.length;m++){
				if(KeyAlwaysString)
				{
					this.write(String(keys[m]));
				}
				else	this.write(keys[m]);
				this.write(values[m]);
			}
		}
		private function writeNull():void
		{
			this.strList.push("null");
		}
		private function writeByteArray(b:ByteArray):void
		{
			strList.push("bytes");
			var str:String=Base64.encodeByteArray(b);
			this.write(str);
		}
		private function toString():void
		{
			Str输出= "";
			for(var m:int=0;m<this.strList.length;m++){
				if(Str输出==""){
					Str输出 += this.strList[m];
				}else{
					Str输出 += "&" + this.strList[m];
				}
			}
		}
		/************************ 输入给AS3******************************/
		public function on解析String(str:String):*
		{
			if(str==null || str.length==0)return null;
			//array&int&3&int&1&utf&2&dict&int&1&int&1&utf&111
			var arr:Array=str.split("&");
			if(arr.length<=1)return null;
			return readNext();
			function readNext():*
			{
				var type:String=arr[0];
				arr.shift();
				var tmp:*;
				if(type=="array")
				{
					tmp=[];
					var length:int=readNext();
					while(length>0)
					{
						tmp.push(readNext());
						length--;
					}
				}
				else if(type=="dict")
				{
					tmp=new Dictionary();
					length=readNext();
					while(length>0)
					{
						tmp[readNext()]=readNext();
						length--;
					}
				}
				else if(type=="int")
				{
					tmp=int(arr[0]);
					arr.shift();
				}
				else if(type=="double")
				{
					tmp=Number(arr[0]);
					arr.shift();
				}
				else if(type=="utf")
				{
					tmp=arr[0];
					arr.shift();
				}
				else if(type=="bool")
				{
					tmp=arr[0];
					arr.shift();
					tmp=tmp=="1"?true:false;
				}
				else if(type=="null")
				{
					tmp=null;
				}
				else if(type=="bytes")
				{
					var str:String=String(readNext());
					return str;
				}
				return tmp;
			}
		}
		public function toObject(str:String):*{
			//dict&int&3&utf&memoryClass&int&256&utf&设备号&utf&861069033245187&utf&型号&utf&MX6
			var out:*;
			var arr:Array=str.split("&");
			return getNextF();
			function getNextF():*{
				var str0:String=arr.shift();
				if(arr.length==0){
					trace("数据输出类：str0="+str0+"，arr长度为0");
					return null;
				}
				if(str0=="int"){
					return int(arr.shift());
				}
				else if(str0=="double"){
					return Number(arr.shift());
				}
				else if(str0=="utf"){
					return arr.shift();
				}
				else if(str0=="bool"){
					return arr.shift()=="0"?false:true;
				}
				else if(str0=="null"){
					return null;
				}
				else if(str0=="array"){
					var arrout:Array=[];
					var len:int=getNextF();
					while(len-- > 0){
						arrout.push(getNextF());
					}
					return arrout;
				}
				else if(str0=="dict"){
					var dic:* ={};
					len=getNextF();
					while(len-- > 0){
						var key:* =getNextF();
						var val:* =getNextF();
						dic[key]=val;
					}
					return dic;
				}
				else{
					trace("未知的str0=="+str0);
					return null;
				}
			}
		}
		
	}
}