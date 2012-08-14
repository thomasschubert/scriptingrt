package org.nad.dm
{
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	import mx.containers.Canvas;
	import mx.core.Application;
	import mx.events.FlexEvent;
	
	import org.nad.dm.response.AbstractResponse;
	import org.nad.util.ArrayUtil;

	public class AbstractChainLink extends AbstractResponseTarget implements IChainResponseTarget, IChainLink {
		
		protected var chainedChilds:Array;
		protected var parentLink:IChainLink;
		
		
		private var self:AbstractChainLink = this as AbstractChainLink;
		
		public function AbstractChainLink(){
			super();	
		}
		
		public function containsChild(idString:String, path:Array) : Boolean {
			var child:IChainLink = null;
			for(var i:uint = 0, l:uint = this.numChildren; i < l; i++){
				if(this.getChildAt(i) is AbstractChainLink && 
					(
						(this.getChildAt(i) as AbstractChainLink).id == idString || 
						(this.getChildAt(i) as AbstractChainLink).containsChild(idString, path ) 
					) 
				){
					path.push(this.id);
					return true;
				}
			}
			return false;
		}
		
		public function chain(informationController:IChainLink = null) : IChainLink { // if there is a part who collects some summary information
			chainedChilds = [];														  // leafs will pass this informationController the results
			trace('AbstractChainLink('+this.id+').chain: called ', informationController);
			for(var i:uint = 0, l:uint = this.numChildren; i < l; i++){
				if(this.getChildAt(i) is IChainLink){
					var child:IChainLink = (this.getChildAt(i) as IChainLink).chain( informationController );
					chainedChilds.push( child );		
				}
			}
			return this;
		}
		
		override public function show(jumptoPath : Array = null) : void {
			super.show(jumptoPath);
			this.next(this, jumptoPath);
		}
		
		/** 
		 * called by a response triggered by user interaction or
		 * called after next without a next child
		 */
		override protected function hide(jumpto:Object = null) : void {
			//trace('AbstractChainLink('+this.id+').hide:  verschwinde');
			super.hide(); // remove eventListeners and set the visibility of myself
			//trace('AbstractChainLink('+this.id+').hide: call next() for ' + this.parent);
			(this.parent as IChainLink).next(this, jumpto); // say the parent that i'm finished
		}
		
		public function next( caller: IChainLink, jumpto : Object = null) : void {
			if(caller == this){ // called by myself via show-method
				if(jumpto != null && jumpto is Array && (jumpto as Array).length > 0){ // and the jumpto is an anchestor of mine or myself
					var nextID:String = (jumpto as Array).shift();
					for(var i:uint = 0, l:uint = this.chainedChilds.length; i < l; i++){
						if((this.chainedChilds[i] as AbstractChainLink).id == nextID){
							(this.chainedChilds[i] as AbstractChainLink).show(jumpto as Array);
							return;
						}
					}
					trace('Autsch!!');
					throw new IllegalOperationError('AbstractChainLink.next of('+ this.className +') with insufficent parameters');
				}else{
					if(this.chainedChilds.length > 0){ // and we have to show the first child
						(this.chainedChilds[0] as AbstractChainLink).show();
					}else{// no childs? I'm the one. and show is already called and all is done well
						trace('AbstractChainedLinks('+this.id+').next: no childs -> show myself');
					}
				}
			}else{ // called by a child
				if(jumpto != null){ // breaks the chain just hide myself
					this.hide(jumpto);
				}else{
					var child:* = ArrayUtil.next(chainedChilds, caller); // check if there is a next child
					if(child != null){
						trace('AbstractChainLink('+this.id+').next: nextChild is ' + child.id);
						(child as AbstractChainLink).show(); // say that child that ...
					}else{ // no next child so i'm finished and i call myself to hide 
						trace('AbstractChainLink('+this.id+').next: '+this.id+' no nextChild');
						this.hide();
					}
				}
			}
		}

		override public function chainResponse(response:String) : void {
			trace('AbstractChainLink('+this.id+').chainResponse: called');
			if(this.chainedChilds.length == 0){ // only a leaf knows what to do after response
				super.chainResponse(response);
			}else{
				for(var i:uint = 0, l:uint = this.chainedChilds.length; i < l; i++){ // my response cascades
					(this.chainedChilds[i] as IChainResponseTarget).chainResponse( this.responseString || response );
				}
			}
		}
	}
}