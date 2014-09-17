package as3TankLib.util.box2D
{
	import flash.events.Event;

	/**
	 *@author Leo
	 */
	public class CollisionEvent extends Event
	{
		public static const COLLISION_START:String = "collision_start";
		public static const COLLISION_END:String = "collision_end";
		public static const COLLISION_PRE_SOLVE:String = "collision_pre_solve";
		public static const COLLISION_POST_SOLVE:String = "collision_post_solve";
		
		public var bodyAData:B2UserData;
		public var bodyBData:B2UserData;
		
		
		public function CollisionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}