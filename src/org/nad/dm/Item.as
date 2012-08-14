package org.nad.dm
{
	import flash.errors.IllegalOperationError;
	import mx.core.FlexGlobals;
	
	import org.nad.dm.response.AbstractResponse;

	public class Item extends AbstractChainLink{
		
		protected var direction:int;
		protected var _protocol:Boolean;
		private var testPart:TestPart;
		
		public function Item(){
			super();
		}
		
		
		public function set type(str:String) : void {
			if(str == '+' || str == '-'){
				this.direction = parseInt(str + '1'); 
				return;
			}
			throw new IllegalOperationError('type of frame has to be + or -');
		}
		public function setUserResponse(response:AbstractResponse, timeDiff:Number, frameID:String) : void {
			var protocol:Object = {
				'response': response != null ? (response.direction.value == null ? 'miss' : this.direction * response.direction.value) : 0,
				'responseTime': timeDiff,
					'frameID': frameID,
					'itemID': this.id
			};
			
			
			var p:String = Protocol.getInstance().write(protocol);
			//if((FlexGlobals.topLevelApplication as org.nad.dm.Application).debug){
				(FlexGlobals.topLevelApplication as Application).protocol = p; 
			//}
			if(this.testPart != null){
				testPart.addResults(protocol);
			}
			
			
		}
		
		override public function chain(informationController:IChainLink = null) : IChainLink{
			if(informationController is TestPart){
				this.testPart = informationController as TestPart;
			}
			return super.chain(informationController);
		}
		
		override public function next(caller : IChainLink, jumpto : Object = null) : void {
			if(this.chainedChilds.length == 0){
				throw new IllegalOperationError('an item must have one frame at least');
			}
			super.next(caller);
		}
		override protected function hide(response:Object = null) : void {
			if(this.testPart != null){
				super.hide(this.testPart.branch());
			}else{
				super.hide();
			}
		}
		override public function toString() : String {
			return this.id+'/'+this.direction;
		}
	}
}