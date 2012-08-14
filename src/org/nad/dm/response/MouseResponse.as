package org.nad.dm.response
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;

	
	import org.nad.dm.AbstractResponseTarget;

	public class MouseResponse extends AbstractResponse
	{
		private var event:String;
		private var name:String;
		
		public function MouseResponse(dir:Object, types:Array, callback:Function){
			super(dir, callback);
			this.response = 'mouse.'+types.join('.');
			this.name = types.pop();
			var type:String = types.pop() as String;
			switch(type.toUpperCase()){
				case 'RELEASE': this.event = MouseEvent.MOUSE_UP; break;
				case 'PRESS': this.event = MouseEvent.MOUSE_DOWN; break;
				case 'DBLCLICK': this.event = MouseEvent.DOUBLE_CLICK; break;
				case 'OVER': this.event = MouseEvent.MOUSE_OVER; break;
				case 'OUT': this.event = MouseEvent.MOUSE_OUT; break;
				case 'ROLLOVER': this.event = MouseEvent.ROLL_OVER; break;
				case 'ROLLOUT': this.event = MouseEvent.ROLL_OUT; break;
				default: this.event = MouseEvent.CLICK; break;
			}
			trace(this.event + ' on ' + this.name);
		}

		override public function remove(responter:AbstractResponseTarget):void{
			for(var i:uint = 0; i < responter.numChildren; i++){
				if((responter.getChildAt(i) as DisplayObject).name == this.name){
					(responter.getChildAt(i) as DisplayObject).removeEventListener(this.event, this.call);
				}
			}
		}
		
		override public function acivate(responter:AbstractResponseTarget):AbstractResponse{
			trace('adding ' + this.event + ' on ' + this.name);
			for(var i:uint = 0; i < responter.numChildren; i++){
				if((responter.getChildAt(i) as DisplayObject).name == this.name){
					(responter.getChildAt(i) as DisplayObject).addEventListener(this.event, this.call);
				}
			}
			Mouse.show();
			return this;
		}
	}
}