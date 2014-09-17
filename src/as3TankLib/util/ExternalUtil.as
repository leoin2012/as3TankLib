package as3TankLib.util
{
	import flash.external.ExternalInterface;

	/**
	 * 外部交互类
	 * @author Leo
	 */
	public class ExternalUtil
	{
		public function ExternalUtil()
		{
		}
		/** 是否容许调用js函数 */
		public static var jsEnable:Boolean = true;
		/** 调用js函数 */
		public static function jsCall(functionName:String, ...args):*
		{
			if(jsEnable)
				ExternalInterface.call(functionName, args);
		}
	}
}