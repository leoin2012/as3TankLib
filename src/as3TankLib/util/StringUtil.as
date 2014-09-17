package as3TankLib.util
{
	import flash.text.TextField;

	/**
	 * 字符串处理工具
	 * @author Leo
	 */
	public class StringUtil
	{
		public function StringUtil()
		{
		}
		
		private static var tf:TextField = new TextField();
		
		/**
		 * 移除字符串html标记
		 * @param str
		 * @return 
		 */		
		public static function removeHtml(str:String):String
		{
			tf.htmlText = str;
			return tf.text;
		}
		
		/**
		 * 替换字符串
		 * @param targetString
		 * @param oldString
		 * @param newString
		 */		
		public static function replace(targetString:String, oldString:String, newString:String):String
		{
			return targetString.split(oldString).join(newString);
		}
		
		/** 用字符串填充数组，并返回数组 */
		public static function toArray(str:String, type:Class = null):Array
		{
			var temp:Array = [];
			if(Boolean(str))
			{
				str = trim(str);
				var a:Array = str.split(",");
				var value:String;
				for (var i:int = 0; i < a.length; i++) 
				{
					value = a[i];
					temp[i] = (value == "true" ? true : (value == "false" ? false: value));
					if(type != null)
						temp[i] = type(value);
				}
			}
			return temp;
		}
		
		/**
		 * 删除字符串左边空格
		 * @param targetString
		 * @return 
		 */		
		public static function trimLeft(targetString:String):String
		{
			for (var i:int = 0; i < targetString.length; i++) 
			{
				if(targetString.charAt(i) != " ")break;
			}
			return targetString.substr(i);
		}
		/**
		 * 删除字符串右边空格
		 * @param targetString
		 * @return 
		 */		
		public static function trimRight(targetString:String):String
		{
			for (var i:int = targetString.length-1; i >= 0; i--)
			{
				if(targetString.charAt(i) != " ")break;
			}
			return targetString.substring(0, i + 1);
		}
		/**
		 * 删除字符串前后空格
		 * @param targetString
		 * @return 
		 */		
		public static function trim(targetString:String):String
		{
			return trimLeft(trimRight(targetString));
		}
		
		/** 检查字符串targetString是否以指定字符串subString开头 */
		public static function startsWith(targetString:String, subString:String):Boolean
		{
			return (targetString.indexOf(subString) == 0);
		}
		
		/** 检查字符串targetString是否以指定字符串subString结尾 */
		public static function endsWith(targetString:String, subString:String):Boolean
		{
			return (targetString.lastIndexOf(subString) == (targetString.length - subString.length));
		}
		
		/** 字符串是否为字母 */
		public static function isLetter(chars:String):Boolean
		{
			if(chars == null || chars == "")
			{
				return false;
			}
			for (var i:int = 0; i < chars.length; i++) 
			{
				var code:uint = chars.charCodeAt(i);
				if(code < 65 || code > 122 || (code > 90 && code < 97))
					return false;
			}
			return true;
		}
	}
}