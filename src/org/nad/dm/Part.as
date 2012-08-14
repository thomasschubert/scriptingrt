package org.nad.dm{
	
	import flash.errors.IllegalOperationError;
	
	public class Part extends AbstractChainLink{
				
		protected var intermezzo:Repeater;
		private var self:Part = this as Part;
		protected var stack : IChainLink;
		public var auto:Boolean;
		
		
		public function Part(){
			super();
			this.auto = true;
		}
		
		public function set repeat( objs: Array ) : void {
			this.intermezzo = new Repeater(objs, this.id);
		}
		
		override public function chain(icl:IChainLink = null) : IChainLink {
			if(this.intermezzo != null){ 
				this.intermezzo.chain();
				this.intermezzo.chainResponse('');
			}
			super.chain(icl);
			return this;
		}
		
		
		
		
		override public function next(caller: IChainLink, jumpto:Object = null) : void {
			if(jumpto != null){
				super.next(caller, jumpto);
				return;
			}
			if(caller == this.intermezzo){
				//trace('Part.next(): called from ' + this.intermezzo.id);
				//trace('Part.next(): remove this repeater');
				this.removeChild( this.intermezzo );
				//trace('Part.next(): call next instateof ' + (stack as AbstractChainLink).id);
				super.next(stack);
				stack = null;
			}else if(this.intermezzo != null){
				//trace('Part.next(): a child called and there is a repeater -> adding and calling intermezzo to show ');
				this.addChild( this.intermezzo );
				this.intermezzo.show();
				this.stack = caller;
			}else{
				super.next( caller );
			}
		}
		
		
		
	
		
		
		/** show its content if exists one after other or itself
		 *  repeatingPart then 1st -> the repeatingPart then 2nd -> repeatingPart ... n-th
		 *  at last calls next of the parent part
		 */
		override public function show(jumptoPath:Array = null) : void {
			// jetzt selber an app das commando schicken, mit dem dieser part beendet wird
			if(this.chainedChilds.length == 0){ // content anzeigen
				throw new IllegalOperationError('Part.show() on Part without content!');
			}else{
				trace('Part.as: showing ' + this.id +' by setting visibility to true');
				super.show(jumptoPath);
			}
		}
		
		


		
		
		
	}
}