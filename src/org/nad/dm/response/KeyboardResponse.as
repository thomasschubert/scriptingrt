package org.nad.dm.response
{
	//import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.KeyLocation;
	import flash.ui.Mouse;
	
	import mx.collections.ArrayCollection;
	import mx.controls.TextInput;
	import mx.core.Application;
	import mx.core.FlexGlobals;
	import mx.managers.FocusManager;
	
	import org.nad.dm.AbstractResponseTarget;
	import org.nad.dm.Application;

	public class KeyboardResponse extends AbstractResponse{
		private var event:String;
		private var anyKey:Boolean;
		private var keyCode:uint;
		private var keyLocation:uint;
		public static var KEYCODES:Object = {
										ENTER:			13,
										'RETURN':		13,
										STRG:			17,
										CTRL:			17,
										SPACE:			32,
										CURSORUP:		38,
										CURSORDOWN:		40,
										CURSORLEFT:		37,
										CURSORRIGHT:	39,
										CU:				38,
										CL:				37,
										CD:				40,
										CR:				39,
										CAPS_LOCK:		20,
										SHIFT:			16,
										PAGEUP:			33,
										PAGEDOWN:		34,
										PU:				33,
										PD:				34,
										POS1:			36,
										HOME:			36,
										END:			35,
										NUMPAD0:		96,
										NUMPAD1:		97,
										NUMPAD2:		98,
										NUMPAD3:		99,
										NUMPAD4:		100,
										NUMPAD5:		101,
										NUMPAD6:		102,
										NUMPAD7:		103,
										NUMPAD8:		104,
										NUMPAD9:		105,
										A:65,
										B:66,
										C:67,
										D:68,
										E:69,
										F:70,
										G:71,
										H:72,
										I:73,
										J:74,
										K:75,
										L:76,
										M:77,
										N:78,
										O:79,
										P:80,
										Q:81,
										R:82,
										S:83,
										T:84,
										U:85,
										V:86,
										W:87,
										X:88,
										Y:89,
										Z:90,
										'+':221,
										'#':220
		};
		
		public function KeyboardResponse(dir:Object, arr:Array, callback:Function){
			super(dir, callback);
			this.response = 'keyboard.'+arr.join('.');
			var type:String = arr.pop(),
				key:String = arr.pop(),
				keyparts:Array = key.split('-'),
				keyname:String = (keyparts.pop() as String).toUpperCase();
			this.keyLocation = KeyLocation.STANDARD;
			trace('keyname: ',keyname);
			if(keyname == 'ANY'){
				this.anyKey = true;
			}else{
				this.anyKey = false;
				if(isNaN(parseInt(keyname))){
					this.keyCode = KEYCODES[keyname];
					trace('kein keycode ' + this.keyCode + ' ' + this.keyLocation);
				}else{
					this.keyCode = parseInt(keyname);
				}
				
				if(keyparts.length > 0){
					var L:String = (keyparts.pop() as String).toUpperCase();
					trace('L: ', L);
					if(L == 'L'){
						this.keyLocation = KeyLocation.LEFT;
					}else if(L == 'R'){
						this.keyLocation = KeyLocation.RIGHT;
					}
				}
			}
			this.event = type.toUpperCase() == 'RELEASE' ?  KeyboardEvent.KEY_UP : KeyboardEvent.KEY_DOWN;
			trace(this.keyLocation,this.keyCode);
		}

		override protected function call(se:Event=null) : void {
			var e:KeyboardEvent = se as KeyboardEvent;
			if((e.keyCode == this.keyCode && e.keyLocation == this.keyLocation) || this.anyKey){
				super.call(e);
			}
		} 
		override public function remove(responter:AbstractResponseTarget):void{
			(FlexGlobals.topLevelApplication as org.nad.dm.Application).requestFocus().removeEventListener(this.event, this.call);
		}
		
		override public function acivate(responter:AbstractResponseTarget):AbstractResponse{
			Mouse.hide();
			(FlexGlobals.topLevelApplication as org.nad.dm.Application).requestFocus().addEventListener(this.event, this.call); 
			trace('activated: ' + this.event + '/' + this.keyCode + ' mouse is hidden');
			return this;
		}
	}
}