package as3TankLib.event
{
	import flash.events.Event;

	/**
	 * 带参数事件
	 *@author Leo
	 */
	public class ParamEvent extends Event
	{
		/**
		 * 参数 
		 */		
		public var param:Object;
		
		public function ParamEvent(type:String, newParam:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			param = newParam;
		}
	}
}