package as3TankLib.ui
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import as3TankLib.manager.RenderManager;
	import as3TankLib.util.Reflection;
	
	/**
	 * 自定义数字图片类
	 *  类型:1,2,3,4,5
	 * @author Leo
	 * 
	 */	
	public class CustomNumberImage extends Sprite
	{
		protected var numberContainer:Sprite;
		protected var numberBMList:Array;
		protected var nunberList:Array;
		protected var _currentNumber:int;
		private var _type:int;
		private var _gap:int;
		private var _lastTime:int;
		private var _delay:int;
		
		private var _preStr:String;
		
		public function CustomNumberImage(type:int=1,gap:int=1,preStr:String="number") {
			this.mouseChildren = false;
			this.mouseEnabled = false;
			this.numberBMList = new Array();
			this.nunberList = new Array();
			this._type = type;
			this._gap = gap;
			this._preStr = preStr;
			
			this.numberContainer = new Sprite();
			this.addChild(numberContainer);
			this.create();
			
			this.cacheAsBitmap = true;
		}
		
		public function create(number:int=0):void {
			this.clearNumber();
			
			this._currentNumber = number;
			var numberStr:String = _currentNumber.toString();
			this.createNumber(numberStr,_preStr);
		}
		
		public function createNumber(numberStr:String,preStr:String=null):void {
			this.clearNumber();
			
			if(preStr == null) {
				preStr = _preStr;
			}

			var numList:Array = String(numberStr).split("");
			var numBm:Bitmap = null;
			var offsetX:int = 0;
			for(var i:int=0; i < numList.length;i++) {
				var numStr:String = numList[i];
				numBm = new Bitmap(Reflection.createBitmapDataInstance(preStr+_type+"_BMD_num"+numStr));
				numBm.x = offsetX;
				numberContainer.addChild(numBm);
				numberBMList.push(numBm);
				offsetX += numBm.width + _gap;
			}
		}
		
		public function createDamageNum(number:int=0):void {
			this.clearNumber();
			
			this._currentNumber = number;
			var numberStr:String = _currentNumber.toString();
			var numList:Array = String(numberStr).split("");
			var numBm:Bitmap = null;
			var offsetX:int = 0;
			for(var i:int=0; i < numList.length;i++) {
				var numStr:String = numList[i];
				numBm = new Bitmap(Reflection.createBitmapDataInstance("damage"+_type+"_BMD_num"+numStr));
				numBm.x = offsetX;
				numberContainer.addChild(numBm);
				numberBMList.push(numBm);
				offsetX += numBm.width + _gap;
			}
		}
		
		public function createBloodNum(number:int=0):void {
			this.clearNumber();
			
			this._currentNumber = number;
			var numberStr:String = _currentNumber.toString();
			var numList:Array = String(numberStr).split("");
			var numBm:Bitmap = null;
			var offsetX:int = 0;
			for(var i:int=0; i < numList.length;i++) {
				var numStr:String = numList[i];
				numBm = new Bitmap(Reflection.createBitmapDataInstance("blood"+_type+"_BMD_num"+numStr));
				numBm.x = offsetX;
				numberContainer.addChild(numBm);
				numberBMList.push(numBm);
				offsetX += numBm.width + _gap;
			}
		}
		
		public function get currentNumber():int {
			return _currentNumber;
		}
		
		public function step():void {
			var nowTime:int = getTimer();
			if(nowTime - _lastTime < _delay) return;
			
			create(nunberList.shift());
			_lastTime = nowTime;
			
			if(nunberList.length == 0) {
				RenderManager.getInstance().remove(step);
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function changeTo(number:int,stepNum:int=0,delay:int=80):void {
			if(_currentNumber == number) return;
			
			if(number < 0) number = 0;
			
			if(stepNum <= 0) {
				create(number);
			} else {
				this._delay = delay;
				var cy:int = _currentNumber > number ? -1 : 1;
				var tempNum:int = _currentNumber;
				while(tempNum != number) {
					tempNum += stepNum * cy;
					if(cy == 1)
						tempNum = tempNum > number ? number : tempNum;
					else
						tempNum = tempNum < number ? number : tempNum;
					tempNum < 0 ? 0 : tempNum;
					nunberList.push(tempNum);
				}
				RenderManager.getInstance().add(step);
			}
		}
		
		public function dispose():void {
			RenderManager.getInstance().remove(step);
			clearNumber();
		}
		
		public function clearNumber():void {
			var numBm:Bitmap = null;
			while(numberBMList.length > 0) {
				numBm = numberBMList.shift() as Bitmap;
				if(numBm.parent != null) numBm.parent.removeChild(numBm);
				numBm.bitmapData = null;
				numBm = null;
			}
		}
	}
}