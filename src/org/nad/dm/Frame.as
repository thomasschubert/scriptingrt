package org.nad.dm{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	
	import org.nad.dm.response.AbstractResponse;

	public class Frame extends AbstractChainLink{
		
		
		protected var starttime:Number, stoptime:Number;
		protected var _protocol:Boolean;
		
		[Bindable] public var result:int;
		private var testPart:TestPart;
		
		
		public function Frame(){
			super();
			this._protocol = true;
		}
		public function set protocol(p:Boolean) : void {
			this._protocol = p;
		}
		public function get protocol() : Boolean {
			return this._protocol;
		}
		
		override public function chain(informationController:IChainLink = null) : IChainLink{
			if(informationController is TestPart){
				this.testPart = informationController as TestPart;
			}
			return super.chain(informationController);
		}
		
		override protected function hide(response:Object = null) : void {
			this.stoptime = (new Date()).getTime();
			if( (this.parent is Item) && this.protocol ){
				(this.parent as Item).setUserResponse(response as AbstractResponse, this.stoptime - this.starttime, this.id);
			}
			super.hide();
		}
		
		
		override public function show(jumptoPath : Array = null) : void{
			trace('Frame.as: show called for ' + this.id);
			super.show(); // if there is a path, then it ends here
			this.starttime = (new Date()).getTime();
		}
		
		
	}
}