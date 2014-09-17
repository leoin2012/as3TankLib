package as3TankLib.util.box2D
{
	import Box2D.Dynamics.b2Body;
	
	import flash.display.Sprite;

	/**
	 * box2D的userData专用类型
	 *@author Leo
	 */
	public class B2UserData
	{
		public var name:String;
		public var sprite:Sprite;
		public var body:b2Body;
		
		public function B2UserData(name:String = "unanmed", sprite:Sprite = null, body:b2Body = null)
		{
			this.name = name;
			this.sprite = sprite;
			this.body = body;
		}
		
	}
}