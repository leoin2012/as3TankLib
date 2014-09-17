package as3TankLib.util.box2D
{
	import com.greensock.data.VarsCore;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2EdgeShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Sweep;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;

	/**
	 * Box2d工厂
	 *@author Leo
	 */
	public class B2Factory
	{
		//像素单位转化为物理世界单位米
		public static const PIXEL_TO_METER:int = 30;
		
		private var world:b2World; 
		
		public function B2Factory()
		{
			if(instance)
				throw new Error("B2Factory is singleton class and allready exists!");
			instance = this;
		}
		/** 获取单例*/
		public static function get I():B2Factory
		{
			if(!instance)
				instance = new B2Factory();
			
			return instance;
		}
		
		//---------------------------------- 静态方法  ---------------------------------------
		/** 创建指定重力世界 */
		public static function creatWorld(g:Number):b2World
		{
			return getInstance().creatWorld(g);
		}
		/**
		 * 创建矩形刚体
		 * @param anchor 锚点（中心点）
		 * @param halfWidth 宽度的一半
		 * @param halfHeight 高度的一半
		 * @param friction 摩擦力
		 * @param restitution 反弹系数
		 * @param density 密度
		 */		
		public static function createRect(anchor:Point, halfWidth:Number, halfHeight:Number, type:uint = 0, filter:b2FilterData = null, friction:Number = 0.3, restitution:Number = 0.7, density:Number = 1, isSensor:Boolean = false):b2Body
		{
			return getInstance().createRect(anchor, halfWidth, halfHeight, type, filter, friction, restitution, density, isSensor);
		}
		
		/**
		 * 创建球形刚体
		 * @param anchor 锚点（中心点）
		 * @param radius 半径
		 * @param friction 摩擦力
		 * @param restitution 反弹系数
		 * @param density 密度
		 * @return 
		 */		
		public static function createCircle(anchor:Point, radius:Number, type:uint = 0, filter:b2FilterData = null, friction:Number = 0.3, restitution:Number = 0.7, density:Number = 1, isSensor:Boolean = false):b2Body
		{
			return getInstance().createCircle(anchor, radius, type, filter, friction, restitution, density, isSensor);
		}
		
		public static function createdebugDraw(container:Sprite):void
		{
			getInstance().createdebugDraw(container);
		}
		
		public static function aysncSprite():void
		{
			getInstance().aysncSprite();
		}
		
		//----------------------------------  ---------------------------------------
		/** 创建指定重力世界 */
		private function creatWorld(g:Number):b2World
		{
//			var world:b2World;
			var gravity:b2Vec2 = new b2Vec2(0, 10);//x,0,y-10, 世界里的所有单位都受此引力影响》？
			var doSpleep:Boolean = true;//物体停止移动的时候是否进去休眠 减少运算量
			world = new b2World(gravity, doSpleep);
			world.SetWarmStarting(true);//刚体初始化的时候是否受重力影响
			return world;
		}
		
		/**
		 * 创建矩形刚体
		 * @param anchor 锚点（中心点）
		 * @param halfWidth 宽度的一半
		 * @param halfHeight 高度的一半
		 * @param friction 摩擦力
		 * @param restitution 反弹系数
		 * @param density 密度
		 */		
		private function createRect(anchor:Point, halfWidth:Number, halfHeight:Number, type:uint = 0, filter:b2FilterData = null, friction:Number = 0.3, restitution:Number = 1, density:Number = 1, isSensor:Boolean = false):b2Body
		{
			filter = filter || createFilter();
			
			var rect:b2Body;
			var rectDef:b2BodyDef = new b2BodyDef();
			rectDef.type = type;
			//注册点是在中心点
			rectDef.position.Set(anchor.x / PIXEL_TO_METER, anchor.y / PIXEL_TO_METER);
			//工厂模式创建出刚体
			rect = world.CreateBody(rectDef); 
			//添加刚体装饰物
			var rectFixtureDef:b2FixtureDef = new b2FixtureDef();
			//密度
			rectFixtureDef.density = density;
			rectFixtureDef.friction = friction;
			rectFixtureDef.restitution = restitution;//弹力，反弹力
			rectFixtureDef.filter = filter;
			rectFixtureDef.isSensor = isSensor;
			
			//创建shape对象
			var rectShape:b2PolygonShape = new b2PolygonShape();
			rectShape.SetAsBox(halfWidth / PIXEL_TO_METER, halfHeight / PIXEL_TO_METER);//参数 宽度和高度的一半
			rectFixtureDef.shape = rectShape;
			rect.CreateFixture(rectFixtureDef);
			
			return rect;
		}
		
		/**
		 * 创建球形刚体
		 * @param anchor 锚点（中心点）
		 * @param radius 半径
		 * @param friction 摩擦力
		 * @param restitution 反弹系数
		 * @param density 密度
		 * @return 
		 */		
		private function createCircle(anchor:Point, radius:Number, type:uint = 0, filter:b2FilterData = null, friction:Number = 0.3, restitution:Number = 1, density:Number = 1, isSensor:Boolean = false):b2Body
		{
			filter = filter || createFilter();
			
			var ball:b2Body;
			var ballDef:b2BodyDef = new b2BodyDef();
			ballDef.type = type;
			ballDef.position.Set(anchor.x / PIXEL_TO_METER, anchor.y / PIXEL_TO_METER);
			ball = world.CreateBody(ballDef);
			var ballfixTureDef:b2FixtureDef = new b2FixtureDef();
			ballfixTureDef.density = density;
			ballfixTureDef.friction = friction;
			ballfixTureDef.restitution = restitution;
			ballfixTureDef.filter = filter;
			ballfixTureDef.isSensor = isSensor;
			
			
			var ballShape:b2CircleShape = new b2CircleShape();
			ballShape.SetRadius(radius / PIXEL_TO_METER);
			ballfixTureDef.shape = ballShape;
			ball.CreateFixture(ballfixTureDef);
			
			return ball;
		}
		
		//进行测试 因为上面都是抽象设定的概念 并不能显示
		private function createdebugDraw(container:Sprite):void
		{
//			var sprite:Sprite = new Sprite();//测试的几何物体可以放里面进行测试
//			addChild(sprite);
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			debugDraw.SetSprite(container);
			debugDraw.SetLineThickness(1.0);//边框厚度
			debugDraw.SetAlpha(1);//边框透明度
			debugDraw.SetFillAlpha(.5);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);//需要显示的格式 shape /关节
			debugDraw.SetDrawScale(PIXEL_TO_METER);//测试的尺寸单位
			world.SetDebugDraw(debugDraw);
		}
		
		/** 实现显示外观与刚体的同步 */
		private function aysncSprite():void
		{
			//遍历物理世界的所有刚体，此处为何如此遍历请参考Manual
			//如果你已经给外观指定了变量，就不用遍历，直接调用变量
			var body:b2Body = world.GetBodyList();
			while(body!=null)
			{
				if(body.GetDefinition().userData && body.GetDefinition().userData.sprite && body.GetDefinition().userData.sprite is Sprite)
				{
					var ballSprite:Sprite = body.GetDefinition().userData.sprite as Sprite;
					ballSprite.x = body.GetPosition().x * PIXEL_TO_METER;
					ballSprite.y = body.GetPosition().y * PIXEL_TO_METER;
					ballSprite.rotation = body.GetAngle() * (180 / Math.PI);
				}
				body = body.GetNext();
			}
		}
		
		public function createFilter(groupIndex:uint = 0, categoryBits:uint = 0, maskBits:uint = 0):b2FilterData
		{
			var filterData:b2FilterData = new b2FilterData();
			if(categoryBits != 0)filterData.categoryBits = categoryBits;
			if(groupIndex != 0)filterData.groupIndex = groupIndex;
			if(maskBits != 0)filterData.maskBits = maskBits;
			return filterData;
		}
		
		
		/** 单例*/
		private static var instance:B2Factory;
		/** 获取单例*/
		public static function getInstance():B2Factory
		{
			if(!instance)
				instance = new B2Factory();
			
			return instance;
		}
		
	}
}