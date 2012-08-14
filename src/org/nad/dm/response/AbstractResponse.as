package org.nad.dm.response
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	
	import org.nad.dm.AbstractChainLink;
	import org.nad.dm.AbstractResponseTarget;
	
	public class AbstractResponse
	{
		protected var callback:Function;
		protected var response:String;
		public var direction:Object;
		
		public function AbstractResponse(dir:Object, callback:Function){
			trace('AbstractResponse.contruct: ' + dir);
			this.callback = callback;
			this.direction = dir;
		}
		protected function call(e:Event=null) : void {
			//trace('wrapper called by ' + e.toString());
			this.callback(this);
			
		} 
		public function remove(responter:AbstractResponseTarget):void{
			throw new IllegalOperationError('AbstractResponse.remove() is not implemented and will never... its abstract');
		}
		
		public function acivate(responter:AbstractResponseTarget):AbstractResponse{
			throw new IllegalOperationError('AbstractResponse.acivate() is not implemented and will never... its abstract');
		}
		
		public function toString() : String{
			return this.direction +'/'+ this.response;
		}
	}
}