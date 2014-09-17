package as3TankLib.util.box2D
{
	import Box2D.Collision.b2Manifold;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.b2ContactListener;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * box2d物体碰撞监听器
	 *@author Leo
	 */
	public class CustomContactListener extends b2ContactListener
	{
		public function CustomContactListener()
		{
			eventDispatcher = new EventDispatcher();
		}
		
		public var eventDispatcher:EventDispatcher;
		
		override public function BeginContact(contact:b2Contact):void
		{
			var collisionEvent:CollisionEvent = new CollisionEvent(CollisionEvent.COLLISION_START);

			if(contact.GetFixtureA().GetBody().GetUserData() != null && contact.GetFixtureB().GetBody().GetUserData() != null)
			{
				collisionEvent.bodyAData = (contact.GetFixtureA().GetBody().GetUserData() as B2UserData);
				collisionEvent.bodyAData.body = contact.GetFixtureA().GetBody();
				
				collisionEvent.bodyBData = (contact.GetFixtureB().GetBody().GetUserData() as B2UserData);
				collisionEvent.bodyBData.body = contact.GetFixtureB().GetBody();
				
				eventDispatcher.dispatchEvent(collisionEvent);
			}
		}
		
		override public function EndContact(contact:b2Contact):void
		{
			var collisionEvent:CollisionEvent = new CollisionEvent(CollisionEvent.COLLISION_END);
			
			if(contact.GetFixtureA().GetBody().GetUserData() != null && contact.GetFixtureB().GetBody().GetUserData() != null)
			{
				collisionEvent.bodyAData = (contact.GetFixtureA().GetBody().GetUserData() as B2UserData);
				collisionEvent.bodyAData.body = contact.GetFixtureA().GetBody();
				
				collisionEvent.bodyBData = (contact.GetFixtureB().GetBody().GetUserData() as B2UserData);
				collisionEvent.bodyBData.body = contact.GetFixtureB().GetBody();
				
				eventDispatcher.dispatchEvent(collisionEvent);
			}
		}
		
		override public function PreSolve(contact:b2Contact, oldManifold:b2Manifold):void 
		{
			var collisionEvent:CollisionEvent = new CollisionEvent(CollisionEvent.COLLISION_PRE_SOLVE);
			
			if(contact.GetFixtureA().GetBody().GetUserData() != null && contact.GetFixtureB().GetBody().GetUserData() != null)
			{
				collisionEvent.bodyAData = (contact.GetFixtureA().GetBody().GetUserData() as B2UserData);
				collisionEvent.bodyAData.body = contact.GetFixtureA().GetBody();
				
				collisionEvent.bodyBData = (contact.GetFixtureB().GetBody().GetUserData() as B2UserData);
				collisionEvent.bodyBData.body = contact.GetFixtureB().GetBody();
				
				eventDispatcher.dispatchEvent(collisionEvent);
			}
		}
		
		override public function PostSolve(contact:b2Contact, impulse:b2ContactImpulse):void
		{
			var collisionEvent:CollisionEvent = new CollisionEvent(CollisionEvent.COLLISION_POST_SOLVE);
			
			if(contact.GetFixtureA().GetBody().GetUserData() != null && contact.GetFixtureB().GetBody().GetUserData() != null)
			{
				collisionEvent.bodyAData = (contact.GetFixtureA().GetBody().GetUserData() as B2UserData);
				collisionEvent.bodyAData.body = contact.GetFixtureA().GetBody();
				
				collisionEvent.bodyBData = (contact.GetFixtureB().GetBody().GetUserData() as B2UserData);
				collisionEvent.bodyBData.body = contact.GetFixtureB().GetBody();
				
				eventDispatcher.dispatchEvent(collisionEvent);
			}
		}
		
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return eventDispatcher.dispatchEvent(event);
		}
	}
}