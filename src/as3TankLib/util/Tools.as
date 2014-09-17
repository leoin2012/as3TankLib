package as3TankLib.util
{
	
	import as3TankLib.ui.CustomTextfield;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextFieldType;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	/**
	 * 一些常用的处理工具
	 * @author liudisong
	 *
	 */
	
	public class Tools
	{

		public static const GRAY_COLORMATRIXFILTER:ColorMatrixFilter = new ColorMatrixFilter([1/3,1/3,1/3,0,0,1/3,1/3,1/3,0,0,1/3,1/3,1/3,0,0,0,0,0,1,0]/*灰色*/);
		
		/**
		 * 对象考贝、数据对象、不能强制类型转换
		 * @param source
		 * @return 
		 */		
		public static function cloneObject(source:*):* {
			var copier:ByteArray = new ByteArray();
			copier.writeObject(source);
			copier.position = 0;
			var target:* = copier.readObject();
			copier = null;
			return target;
		}
		
		/**
		 * 拷贝显示对象
		 * @param source displayObject类型的对象
		 * @return bitmap类型对象
		 *
		 */
		public static function cloneDisplayObject(source:DisplayObject):Bitmap
		{
			if (source == null)
				return null;
			var bitmapData:BitmapData=new BitmapData(source.width, source.height);
			bitmapData.fillRect(new Rectangle(0, 0, source.width, source.height), 0);
			bitmapData.draw(source);
			var bitmap:Bitmap=new Bitmap(bitmapData);

			bitmapData=null;
			return bitmap;
		}
		
		/**
		 *拷贝对象并放大或缩小 
		 * @param source
		 * @return 
		 * 
		 */		
		public static function cloneBitmapData(source:BitmapData,drawRect:Rectangle):BitmapData
		{
			if (source == null)
				return null;
			
			var myMatrix:Matrix = new Matrix();
			myMatrix.a = (drawRect.width / source.width);
			myMatrix.d = (drawRect.height / source.height);
			
			var bitmapData:BitmapData=new BitmapData(drawRect.width, drawRect.height,true,0x00ffffff);
			bitmapData.draw(source,myMatrix);
			return bitmapData;
		}
		
		/** 获取指定窗口对应的bitmap拷贝  @param window @return  */		
		public static function getWindowScaleBitmap(window:DisplayObject):Bitmap
		{
			var bm:Bitmap = new Bitmap();
			
			var rect:Rectangle = window.getBounds(window);
			var bitmapData:BitmapData = new BitmapData(window.width, window.height, true, 0);
			bitmapData.draw(window, new Matrix(1, 0, 0, 1, -rect.x, -rect.y));
			bm.bitmapData = bitmapData;
			return bm;
		}
		
		
		public static function checkType(typeId:int):Boolean
		{
			if(typeId < 100000)
				return false;
			if(int(typeId%1000/100)>=1 && int(typeId%1000/100)<=6)
			    return true;
			return false;
		}

		/**
		 * 获得对象的类名
		 * @param object
		 * @return
		 *
		 */
		public static function getClassName(object:Object):String
		{
			var className:String=getQualifiedClassName(object);
			var index:int=className.lastIndexOf(":");
			if (index > -1)
			{
				className=className.substr(index + 1);
			}
			return className;
		}

		/**
		 * 获得对象继承类的类名
		 * @param object
		 * @return
		 *
		 */
		public static function getSuperClassName(object:Object):String
		{
			var className:String=getQualifiedSuperclassName(object);
			var index:int=className.lastIndexOf(":");
			if (index > -1)
			{
				className=className.substr(index + 1);
			}
			return className;
		}

		/**
		 * 秒转换时间
		 * @param timeStr 秒数
		 * @return 格式化时间
		 *
		 */
		public static function timeConversion(timeStr:String, type:String="date"):String
		{
			var date:Date=new Date(Number(timeStr) * 1000);
			var monthStr:String = date.month+1 < 10 ? "0"+(date.month+1) : String(date.month+1);
			var dateStr:String = date.date < 10 ? "0"+date.date : String(date.date);
			var hoursStr:String = date.hours < 10 ? "0"+date.hours : String(date.hours);
			var minutesStr:String = date.minutes < 10 ? "0"+date.minutes : String(date.minutes);
			var secondStr:String = date.seconds < 10 ? "0"+date.seconds : String(date.seconds);
			
			if (type == "date")
			{
				//2010-4-20
				return date.fullYear + "-" + monthStr + "-" + dateStr;
			} else if(type == "mm-dd hh-MM") {
				return monthStr + "-" + dateStr + "   " + hoursStr + ":" + minutesStr;
			} else if(type == "yyyy-mm-dd hh-MM") {
				return date.fullYear + "-" + monthStr + "-" + dateStr + " " + hoursStr + ":" + minutesStr;
			} else if(type == "yyyy-mm-dd") {
				return date.fullYear + "-" + monthStr + "-" + dateStr;
			} else if(type == "hh-MM") {
				return hoursStr + ":" + minutesStr;
			}
			else {
				//2//22 3:25
				return monthStr + "//" + date.day + " " + hoursStr + ":" + minutesStr;
			}
		}
		
		/**
		 * 秒数转换成时间格式  hh-MM-ss 
		 * @param time
		 * 
		 */	
		public static function timeConvert(second:int):String {
			var h:int = Math.floor(second / 3600);
			second = second - 3600 * h;
			var m:int;
			if (second > 0) {
				m = Math.floor(second / 60);
			} else {
				m = 0;
			}
			var s:int = second - 60 * m;
			return appendZero(h) + ":" + appendZero(m) + ":" + appendZero(s);
			
			function appendZero(v:int):String {
				var s:String = String(v);
				if (s.length == 1) {
					s = "0" + s;
				}
				return s;
			}
		}
		
		/**
		 *秒转换成时间格式 ，MM-ss 
		 * @param second
		 * 
		 */		
		public static function timeConvert2(second:int, split:String=":"):String
		{
			var h:int = Math.floor(second / 3600);
			second = second - 3600 * h;
			var m:int;
			if (second > 0) {
				m = Math.floor(second / 60);
			} else {
				m = 0;
			}
			var s:int = second - 60 * m;
			return appendZero(m) + split + appendZero(s);
			
			function appendZero(v:int):String {
				var s:String = String(v);
				if (s.length == 1) {
					s = "0" + s;
				}
				return s;
			}
		}
		
		/**
		 *秒转换成时间格式
		 * @param second
		 * 
		 */		
		public static function timeConvert3(second:int):String
		{
			var d:int = Math.floor(second/86400);
			second = second % 86400;
			var h:int = Math.floor(second / 3600);
			second = second - 3600 * h;
			var m:int;
			if (second > 0)
			{
				m = Math.floor(second / 60);
			}
			else
			{
				m = 0;
			}
			var s:int = second - 60 * m;
			if(d >0 )
				if(h > 0)
					return d + "天" + h + "小时";
				else
					return d + "天";
				else if (h > 0)
					return h + "小时";
				else if (m > 0)
					return m + "分钟";
				else
					return appendZero(s) + "秒";
			
			function appendZero(v:int):String
			{
				var s:String = String(v);
				if (s.length == 1)
				{
					s = "0" + s;
				}
				return s;
			}
		}
		
		/**
		 *秒转换成时间格式 xx时xx分xx秒
		 * @param second
		 * 
		 */		
		public static function timeConvert4(second:int):String
		{
			var h:int = Math.floor(second / 3600);
			second = second - 3600 * h;
			var m:int;
			if (second > 0) {
				m = Math.floor(second / 60);
			} else {
				m = 0;
			}
			var s:int = second - 60 * m;
			return appendZero(m) + "分" + appendZero(s) + "秒";
			
			function appendZero(v:int):String {
				var s:String = String(v);
				if (s.length == 1) {
					s = "0" + s;
				}
				return s;
			}
		}
		
		/**
		 * 秒数转换成时间格式  hh-MM-ss(如果hh小于等于0就转为MM-ss)
		 * @param time
		 * 
		 */	
		public static function timeConvert5(second:int):String {
			var h:int = Math.floor(second / 3600);
			second = second - 3600 * h;
			var m:int;
			if (second > 0) {
				m = Math.floor(second / 60);
			} else {
				m = 0;
			}
			var s:int = second - 60 * m;
			if(h>0)
			{
				return appendZero(h) + ":" + appendZero(m) + ":" + appendZero(s);
			}else
			{
				return appendZero(m) + ":" + appendZero(s);
			}
			
			
			function appendZero(v:int):String {
				var s:String = String(v);
				if (s.length == 1) {
					s = "0" + s;
				}
				return s;
			}
		}
		
		/**
		 * 将彩色图转换为黑白图 
		 * @param source
		 * @return 
		 * 
		 */		
		public static function grayFilter(source:BitmapData):BitmapData {
			var rLum:Number = 0.3086;
			var gLum:Number = 0.6094;
			var bLum:Number = 0.0820;

			var s:Bitmap = new Bitmap(source);
			s.filters = [new ColorMatrixFilter([rLum, gLum, bLum, 0, 0, rLum, gLum, bLum, 0, 0, rLum, gLum, bLum, 0, 0, 0, 0, 0, 1, 0])];
			var r:BitmapData = new BitmapData(s.width, s.height, true, 0x00ffffff);
			r.draw(s);
			return r;
		}
		
		 /**
		  * 判断字符串中是否含有反斜杠 
		  * @param str
		  * @return 
		  * 
		  */		 
		 public static function hasFanXieGang(str:String):Boolean
		 {
		 	if(str.indexOf("\\") > -1)
		 	{
		 		return true;
		 	}
		 	return false;
		 }
		 
		 public static function fmltime(s:int):String
		 {
			 var result:String="";
			 var m:int =Math.floor(s/3600)*60+ Math.floor((s%3600)/60);
			 var mm:String;
			 if(m < 10)
			 {
				 mm = "0"+m.toString();
			 }
			 else
			 {
				 mm = m.toString();
			 }
			 
			 s = s%60;
			 var ss:String;
			 if(s < 10)
			 {
				 ss = "0"+s.toString();
			 }
			 else
			 {
				 ss = s.toString();
			 }
			 result=mm+":"+ss
			 return result;
		 }
			
		/**
		* 时间比较，两个比较的时间的格式是 hh:mm
		 * 返回 t1 < t2 的值
		*/	
		public static function timeCompare(t1:String, t2:String):Boolean
		{
			var a1:Array = t1.split(":");
			var h1:int = int(a1[0]);
			var m1:int = int(a1[1]);
			var time1:int = h1*3600 + m1*60;
			var a2:Array = t2.split(":");
			var h2:int = int(a2[0]);
			var m2:int = int(a2[1]);
			var time2:int = h2*3600 + m2*60;
			return time1 <= time2;
		}
		
		private static var d:Date;
		/** 格式化Date对象，返回格式为：年-月-日(YYYY-MM-DD)*/		
		public static function formatDate(date:Date = null):String
		{
			d = date || new Date();
			var dateStr:String = String(d.fullYear) + "-" + ((d.month + 1) < 10 ? "0":"") + String(d.month + 1) + "-" + ((d.date < 10 ? "0":"") + String(d.date));
				return dateStr;
		}
		
		/** 格式化Date对象，返回格式为：时：分：秒(HH:MM:SS) */		
		public static function formatTime(date:Date = null):String
		{
			d = date || new Date();
			var timeStr:String = (d.hours < 10 ? "0":"") + String(d.hours) + ":" + (d.minutes < 10 ? "0":"")
				+ String(d.minutes) + ":" + (d.seconds < 10 ? "0":"") + String(d.seconds);
			return timeStr;
		}
		
		/** 格式化Date对象，返回格式为：年-月-日  时:分:秒(YYYY-MM-DD HH:MM:SS) */
		public static function formatDateTime(date:Date = null):String
		{
			var dateStr:String = formatDate(date) + " " + formatTime(date);
			return dateStr;
		}
		
		/**
		 *服务器时间  秒
		 */		
		private static var serTime:uint;
		/**
		 * 客户端启动时间
		 */		
		private static var startTime:uint;
		/**
		 *设置服务器时间
		 * 
		 */		
		public static function setSerTime(time:uint):void
		{
			serTime = (time);
			startTime = getTimer();
		}
		/**
		 *获取服务器时间 
		 * @return 
		 * 
		 */		
		public static function getSerTime():uint
		{
			return (serTime + (getTimer() - startTime)/1000);
		}
		
		public static function myUrlEncode(str:String, code:String):String {
			var result:String="";
			var byte:ByteArray=new ByteArray();
			byte.writeMultiByte(str, code);
			for (var i:int; i < byte.length; i++) 
				result=result.concat(escape(String.fromCharCode(byte[i])));
			return result;
		}
		
		public static function randRange(min:int,max:int):int {
			if (min > max) {
                max = min ^ max;
                min = max ^ min;
                max = max ^ min;
            }
            var gap:int = max - min + 1;
            return min + (Math.random() * gap >> 0);
            
//			var randomNum:int = Math.floor(Math.random() * (max - min + 1)) + min;
//			return randomNum
		}
		
		public static function drawBlackBG(x:int,y:int,w:int,h:int,parent:DisplayObjectContainer,ew:Number=12,alpha:Number=.35):void {
			var shape:Shape= new Shape();
			shape.x = x;
			shape.y = y;
			parent.addChild(shape);
			
			var g:Graphics = shape.graphics;
			g.beginFill(0x000000,alpha);
			g.drawRoundRect(0,0,w,h,ew);
			g.drawRoundRect(1,1,w-2,h-2,ew);
			g.endFill();
			
			g.beginFill(0x575a5c,1);
			g.drawRoundRect(1,1,w-2,h-2,ew);
			g.drawRoundRect(2,2,w-4,h-4,ew);
			g.endFill();
			
			g.beginFill(0x181c1e,alpha);
			g.drawRoundRect(2,2,w-4,h-4,ew);
			g.endFill();
		}
		
		/**
		 * 创建Bitmap对象
		 * @param source
		 * @param x
		 * @param y
		 * @return 
		 */		
		public static function createBitmap(source:String, x:Number = 0, y:Number = 0):Bitmap
		{
			var bmp:Bitmap = new Bitmap();
			bmp.bitmapData = Reflection.createBitmapDataInstance(source);
			bmp.x = x;
			bmp.y = y;
			return bmp;
		}
		
		public static function createTextField(str:String="label",x:Number=0, y:Number=0, w:Number=100, h:Number=20,parent:DisplayObjectContainer=null,color:uint=0xffffff,hasBG:Boolean=false,align:String=TextFormatAlign.LEFT,type:String=TextFieldType.DYNAMIC,leading:int=0):CustomTextfield {
			if(hasBG == true) {
				var shape:Shape = new Shape();
				shape.x = x-2;
				shape.y = y-2;
				
				var _w:int = w + 4;
				var _h:int = h + 4;
				shape.graphics.beginFill(0x050609);
				shape.graphics.drawRoundRect(0,0,_w,_h,7);
				shape.graphics.endFill();
				shape.graphics.beginFill(0x666863);
				shape.graphics.drawRoundRect(1,1,_w-2,_h-2,7);
				shape.graphics.endFill();
				shape.graphics.beginFill(0x090b12);
				shape.graphics.drawRoundRect(2,2,_w-4,_h-4,7);
				shape.graphics.endFill();

				if(parent != null) parent.addChild(shape);
			}
			var txt:CustomTextfield = new CustomTextfield();
			txt.color = color;
			txt.x = x;
			txt.y = y;
			txt.width = w;
			txt.height = h;
			txt.type = type;
			txt.align = align;
			txt.leading=leading;
			txt.htmlText = str;
			txt.mouseEnabled = type == TextFieldType.INPUT;
			if(parent != null) parent.addChild(txt);
			
			return txt;
		}
		
		/**
		 * 创建背景MC 
		 * @param w
		 * @param h
		 * @param style		可选style: 2,3,4
		 * @param hasLine	是否有条纹
		 * @return 
		 * 
		 */		
		public static function createBgMC(w:int,h:int,style:int=2,hasLine:Boolean = false):Sprite {
			var bgMC:Sprite = Reflection.createInstance("compS_MC_BackLayer" + style);
			bgMC.width = w;
			bgMC.height = h;
			if(hasLine == true) {
	
			}
			return bgMC;
		} 
		/**
		 * 创建sprite
		 * @param source
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 */		
		public static function createSprite(source:String, x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0):Sprite
		{
			var mc:Sprite = Reflection.createInstance(source);
			if(0 != width)
				mc.width = width;
			if(0 != height)
				mc.height = height;
			mc.x = x;
			mc.y = y;
			return mc;
		}
		
/**
		 * 获取 html text 
		 * @param text 显示文字
		 * @param color 显示颜色 uint|String
		 * @param size 文字大少
		 * @param bold 文字粗体
		 * @param underLine 文字下划线
		 * @param href 文字超链接
		 * @return html
		 * 
		 */		
		public static function parseHtml(text:*,color:*,size:int = 12,bold:Boolean = false,underLine:Boolean = false,href:Boolean = false, hrefData:String = null):String
		{
			var str:String="";
			if(color is uint)
			{
				str = "#"+color.toString(16);
			}
			else
			{
				str = String(color);
			}
			if(size == -1)
			{
				str ="<font color='"+ str +"'>"+text+"</font>";
			}
			else
			{
				str ="<font color='"+ str +"' size='"+size+"'>"+text+"</font>";
			}
			if(bold)
			{
				str = "<b>" + str + "</b>";
			}
			if(underLine)
			{
				str = "<u>" + str + "</u>";
			}
			if(href)
			{ 
				str = "<a href='event:" + hrefData + "'>" + str + "</a> ";
			}
			return str;
		}
		
		
		
		private static var maxMoneyCNArr:Array = ["零","壹","贰","叁","肆","伍","陆","柒","捌","玖","拾"];
		private static var minMoneyCNArr:Array = ["零","一","二","三","四","五","六","七","八","九","十"];
		/**
		 * 将阿拉伯数字转成大写汉字
		 * @param i
		 * @return
		 *
		 */
		public static function maxMoneyChinese(i:int):String
		{
			if(i < maxMoneyCNArr.length)
			{
				return maxMoneyCNArr[i];
			}
			return "";
		}
		
		/**
		 * 小写 
		 * @param i
		 * @return 
		 * 
		 */		
		public static function minMoneyChinese(i:int):String
		{
			if(i < minMoneyCNArr.length)
			{
				return minMoneyCNArr[i];
			}
			return "";
		}
		
		//匹解析一些字符文字
		public static function parseStr(str:String):String
		{
			var parseReg:RegExp = /\[(.*)\](.+?)?(\[\/\1\])/g;
			var newStr:String = str.replace(parseReg, replFN);
			if (newStr.search(parseReg) > -1)
			{
				newStr = parseStr(newStr);
			}
			return newStr;
		}
		
		private static function replFN():String
		{
			var type:String = arguments[1];
			var values:Array = arguments[2].split(":");
			
			if (type == "color")
			{
				var str:String;
				var list:Array = [];
				for (var i:int = 1; i < values.length; i++)
				{
					list.push(values[i]);
				}
				str = list.join(":");
				return "<font color='#" + values[0] + "'>" + str + "</font>";
			}
			return "";
		}
		
		/**
		 * 模拟线程休眠
		 * @param time 休眠时间 (毫秒)
		 * @param hander 唤起后的处理方法
		 * @param args  唤起吼所调用的方法 传递的参数
		 *
		 */
		public static function sleep(time:uint, hander:Function, ... args):int
		{
			if (time == 0)
			{
				closure();
			}
			else
			{
				var timeId:uint=setTimeout(closure, time);
			}
			return timeId;
			function closure():void
			{
				hander.apply(hander, args);
				clearTimeout(timeId);
			}
		}
		
		public static function removeFromParent(child:DisplayObject):void
		{
			if(child && child.parent)
				child.parent.removeChild(child);
		}
		
	}
}