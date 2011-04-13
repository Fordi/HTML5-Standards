package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author Bryan Elliott
	 */
	public class Main extends Sprite implements Storage
	{
		private var Tank:SharedObject;
		private var keys:Array = [];
		private var stale:Boolean = true;
		
		private function log(msg:String):void {
			ExternalInterface.call('say', msg);
		}
		
		private function storageName():String {
			return new String(loaderInfo.parameters['storageName']) || 'local';
		}
		public function Main():void {
			loaderInfo.addEventListener(Event.ADDED_TO_STAGE, init);
			loaderInfo.addEventListener(Event.UNLOAD, cleanup);
		}
		 
		public function init(event:Event):void {
			Tank = SharedObject.getLocal(storageName());
		
			ExternalInterface.addCallback('getItem', getItem);
			ExternalInterface.addCallback('setItem', setItem);
			ExternalInterface.addCallback('removeItem', removeItem);
			ExternalInterface.addCallback('clear', clear);
			ExternalInterface.addCallback('getLength', getLength);
			ExternalInterface.addCallback('key', key);
			
			log('testing!');
			
			Tank.flush(0);
		
		}
		public function getItem(key:String):Object {
			return Tank.data[key];
		}
		public function setItem(key:String, data:Object):void {
			Tank.data[key] = data;
			stale = true;
		}
		public function removeItem(key:String):void {
			Tank.data[key] = null;
			stale = true;
		}
		public function clear():void {
			Tank.clear();
			stale = false;
			keys = [];
		}
		private function unstale():void {
			if (!stale) return;
			var i:String, ct:Number;
			keys = [];
			for (i in Tank.data) 
				keys.push(i);
			stale = false;
		}
		public function getLength():Number {
			unstale();
			return keys.length;
		}
		public function key(index:Number):String {
			unstale();
			return keys[index];
		}
		private function cleanup(event:Event):void {
			Tank.flush(0);
			loaderInfo.removeEventListener(Event.UNLOAD, cleanup);
		}
	}	
}