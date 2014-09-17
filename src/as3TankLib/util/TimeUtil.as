package as3TankLib.util
{
	/**
	 * 日期时间类
	 * @author Leo
	 */
	public class TimeUtil
	{
		private static var d:Date;
		
		public static const SILENT:int = 0;
		public static const SECONDS:int = 1;
		public static const MINUTES:int = 2;
		public static const HOURS:int = 3;
		public static const DAYS:int = 4;
		
		public function TimeUtil()
		{
		}
		
		/** 格式化Date对象，返回格式为：年-月-日(YYYY-MM-DD)*/		
		public static function formatDate(date:Date = null):String
		{
			d = date || new Date();
			var dateStr:String = String(d.fullYear) + "-" + ((d.month + 1) < 10 ? "0":"") + String(d.month + 1) + "-" + ((d.date < 10) ? "0":"") + String(d.date);
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
		
		/** 格式化一个倒计时，返回格式为  分:秒(MM:SS)
		 * @param time 倒计时数（秒）
		 */
		public static function formatTimerCount(time:Number, range:int = MINUTES):String
		{
			var hours:Number = Math.floor(time / 3600);
			var minutes:Number = Math.floor((time /60) % 60);
			var seconds:Number = Math.floor(time % 60);
			var timeStr:String = (range >= HOURS ? twoCharacterTimeFormat(hours) + ":" : "") +
							(range >= MINUTES ? twoCharacterTimeFormat(minutes) + ":" : "") +
							(range >= SECONDS ? twoCharacterTimeFormat(seconds) : "");
			return timeStr;
		}
		
		/**
		 * 格式化一个倒计时数，返回格式为：  x天x小时x分钟x秒
		 * @param time 倒计时数（秒）
		 * @return
		 */
		public static function formatedTimeIntoCN(time:Number, range:uint = MINUTES):String
		{
			var temp:Number = time;
			var days:Number = Math.floor(temp / 86400);
			temp -= days * 86400;
			var hours:Number = Math.floor(temp / 3600);
			temp -= hours * 3600;
			var minutes:Number = Math.floor(temp / 60);
			temp -= minutes * 60;
			var seconds:Number = Math.floor(temp % 60);
			var timeStr:String = ((range >= DAYS && days > 0) ? days + "天":"") + ((range >= HOURS && hours > 0) ?hours + "小时" : "") + ((range >= MINUTES && minutes > 0) ?minutes+ "分钟" : "") + (range >= SECONDS ?seconds + "秒": "");
			return timeStr;
		}
		
		/** 把数字转换成字符串，保持两位（若小于10，则在前面加0，保持两个字符）  */
		private static function twoCharacterTimeFormat(num:Number):String
		{
			return (num < 10 ? "0" : "") + String(num);
		}
		
	}
}