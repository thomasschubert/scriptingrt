package org.nad.dm{
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.describeType;
	
	import mx.controls.Text;
	import mx.core.FlexGlobals;
	import mx.utils.ObjectUtil;
	
	import org.nad.dm.response.AbstractResponse;
	
	public class Feedback extends AbstractChainLink{
		
		private var _correct:Array;
		private var _incorrect:Array;
		private var _noresponse:Array;
		private var adds:Array;
		private var tmp:String;
		
		public function Feedback(){
			super();
		}
		
		public function set correct(childs:Array) : void {
			_correct = childs;
		}
		public function set incorrect(childs:Array) : void {
			_incorrect = childs;
		}
		public function set miss(childs:Array) : void {
			_noresponse = childs;
		}
		private function clone(o:DisplayObject):DisplayObject{
			var type:XML = describeType( o ),
				c:Class = Object(o).constructor,
				k:Object = new c();
			for each( var accessor:XML in type.accessor ){ 
				if( accessor.@access.toString().toUpperCase() == 'READWRITE' ){
					if( o[ accessor.@name ] != null){
						k[accessor.@name] = o[accessor.@name];
					}
				}
			}
			return k as DisplayObject;
			
			//return ObjectUtil.copy(o) as DisplayObject;
		}
		override public function show(jumptoPath : Array = null) : void{
			var proto:Object = Protocol.getInstance().last();
			//trace('FeedBack.as: show called for ' + this.id, proto);
			//(//FlexGlobals.topLevelApplication as Application ).protocol = 'show called for ' + this.id + ' ' + proto.response;
			if(proto != null){
				if(proto.response is String){
					adds = this._noresponse;
				}else if(proto.response < 0){
					adds = this._incorrect;
				}else if(proto.response >= 0){
					adds = this._correct;
				}
				if(adds != null){
					for(var i:uint = 0; i < adds.length; i++){
						if(adds[i] is DisplayObject){
							if(adds[i] is Text){
								if((adds[i] as Text).toolTip){
									(adds[i] as Text).text = (adds[i] as Text).toolTip;
								}else{
									(adds[i] as Text).toolTip = (adds[i] as Text).text;
								}
								(adds[i] as Text).text = (adds[i] as Text).text.replace(/%responseTime%/, proto.responseTime);
							}
							this.addChild(adds[i]);
							//trace('--------------------','displayObject:',adds[i]);
						}else{
							//trace('--------------------','kein displayObject:',adds[i]);
						}
					}
				}else{
					//(FlexGlobals.topLevelApplication as Application ).protocol = 'adds in Feedback is null';
				}
			}else{
				//FlexGlobals.topLevelApplication as Application ).protocol = 'proto is null in Feedback';
			}
			this.height = FlexGlobals.topLevelApplication.height;
			this.width = FlexGlobals.topLevelApplication.width;
			super.show(); // if there is a path, then it ends here
		}
		
		override protected function hide(response:Object = null) : void {
			this.removeAllChildren();
			super.hide();
		}
	}
}