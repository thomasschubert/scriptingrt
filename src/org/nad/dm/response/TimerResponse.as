package org.nad.dm.response
{
	import flash.errors.IllegalOperationError;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import org.nad.dm.AbstractResponseTarget;

	public class TimerResponse extends AbstractResponse{
		
		private var delay:int;
		private var stopBefor:Number;
		
		
		public function TimerResponse(dir:Object, types:Array, callback:Function){
			super(dir, callback);
			this.response = 'timer.'+types.join('.');
			this.delay = parseInt(types[0] as String);
		}
		
		
		
		override public function acivate(responter:AbstractResponseTarget) : AbstractResponse {
			trace('set Timeout of ' + this.delay);
			this.stopBefor = setTimeout(this.call, this.delay);
			return this;
		}
		
		override public function remove(responter:AbstractResponseTarget):void{
			clearTimeout(this.stopBefor);
			trace('remove Timeout of ' + this.delay);
			// nothing to remove
		}
		override public function toString() : String{
			return this.direction+'/'+ this.response;
		}
	}
}