package  
{
	
	/**
	 * ...
	 * @author Bryan Elliott
	 */
	public interface Storage 
	{
		function getItem(key:String):Object;
		function setItem(key:String, data:Object):void;
		function removeItem(key:String):void;
		function clear():void;
		function getLength():Number;
		function key(index:Number):String;
	}
	
}