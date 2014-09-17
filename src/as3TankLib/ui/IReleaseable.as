package as3TankLib.ui
{
	/**
	 * 资源控制接口
	 * @author Leo
	 * 
	 */	
	public interface IReleaseable
	{
		/**
		 * 恢复资源
		 */		
		function resume():void;
		
		/**
		 * 释放资源
		 */		
		function dispose():void;
		
	}
}