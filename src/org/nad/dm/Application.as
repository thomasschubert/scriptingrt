package org.nad.dm
{
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.ui.Mouse;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.TextInput;
	import mx.core.Application;
	import mx.events.FlexEvent;
	
	import spark.components.TextArea;
	

	public class Application extends mx.core.Application implements IChainLink{
		
		private var futureStack:Array;
		private var pastStack:Array;
		public var input:TextInput;
		public var outputURL:String;
		public var debug:Boolean = false;
		public var finishedButtonValue:String = 'End';
		public var protocolFormatItem:String = '%frameID%-%itemID%,%response%%responseTime%';
		public var protocolFormatHead:String = '%serverUploadTime% | %clientIP% | %clientUploadTime%';
		private var debugArea:TextArea;
		
		//protected var count:*, sum:*,avg:*,failures:*,goals:*;
		
		public function Application(){
			super();
			this.futureStack = [];
			this.pastStack = [];
			this.addEventListener(FlexEvent.CREATION_COMPLETE, this.chainAll);
		}
		
		public function fullscreen() : void {
			//this.stage.displayState = StageDisplayState.FULL_SCREEN;				
		}
		
		private function chainAll(e:FlexEvent) : void {
			this.chain();
			this.removeEventListener(FlexEvent.CREATION_COMPLETE, this.chainAll);
			if(debug){
				debugArea = new TextArea();
				debugArea.x = 0;
				debugArea.bottom = 0;
				debugArea.width = this.width;
				debugArea.height = 45;
				debugArea.alpha = .5;
				debugArea.setStyle('backgroundColor', 0xFFFFFF);
				this.addChild(debugArea);
			}
			input = new TextInput();
			input.height = 1; input.width = 1; input.alpha = .05;
			input.x = 0; input.y = 0; input.enabled = true;
			this.addChild(input);
		}
		public function set protocol(str:String) : void {
			if(debug){
				debugArea.appendText(str+'\n');
			}
		}
		
		public function chain(icl:IChainLink = null) : IChainLink {
			for(var i:int = 0, l:int = this.numChildren; i < l; i++){
				if(this.getChildAt(i) is Part && !(this.getChildAt(i) is WelcomeScreen)){
					var child:Part = this.getChildAt(i) as Part;
					trace('Application.chain: ' + child.id );
					this.futureStack.push( child.chain() );
					child.chainResponse('');
				}
			}
			return null;
		}
		public function start() : void {
			this.next(this);
		}
		
		
		public function next(caller : IChainLink, jumpto:Object = null) : void {
			try{
				var jumptoPath:Array = [];
					
				if(jumpto != null){
					var found:Boolean = false,
						i:uint, l:uint;
					trace('### Application.next with jumpto:',jumpto);
					// check the pastStack 
					// if found push all the past until jumpto into the future and start with jumpto
					for(i = 0, l = pastStack.length; i < l && !found;i++){
						if( (found = (pastStack[i] as AbstractChainLink).id == (jumpto as String) || (pastStack[i] as IChainLink).containsChild(jumpto as String, jumptoPath)) ){
							while(pastStack.length > i){
								futureStack.unshift(pastStack.pop());
							}
						}
					}
					// else put all the future until jumpto into the past 
					for(i = 0, l = futureStack.length; i < l && !found; i++){
						if( (found = (futureStack[i] as AbstractChainLink).id == (jumpto as String) || (futureStack[i] as IChainLink).containsChild(jumpto as String, jumptoPath)) ){
							while(futureStack.length > (l - i) ){
								pastStack.push(futureStack.shift());
							}
						}
					}
					// fill the jumptoPath with the hierarchy to the jumpto
					
				}
				trace('futureStack', this.futureStack.length, jumpto);
				if(this.futureStack.length > 0){
					var part:Part = this.futureStack.shift() as Part;
					this.pastStack.push(part);
					if(part.auto || jumpto != null){
						part.show(jumptoPath);
					}else{
						this.next(this);
					}
				}else{
					if(this.outputURL){
						var protocol:Protocol = Protocol.getInstance();
						protocol.flush(this.outputURL, this.protocolFormatHead, this.protocolFormatItem);
					}
					Alert.show(finishedButtonValue);
					Mouse.show();
				}
			}catch(e:Error){
				Alert.show(e.message + '\n');
				trace(e.getStackTrace());
				
			}
		}
		
		public function requestFocus() : TextInput {
			this.stage.focus = this.input;
			return this.input;
		}
		public function containsChild(s:String,a:Array):Boolean{return true;}
	}
}