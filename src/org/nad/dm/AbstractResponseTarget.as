package org.nad.dm
{
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	import mx.containers.Canvas;
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	
	import org.nad.dm.Application;
	import org.nad.dm.response.AbstractResponse;
	import org.nad.dm.response.ResponseFactory;
	
	public class AbstractResponseTarget extends Canvas{
		
		
		protected var responseString:String;
		protected var responses:Array;
		
		public function set negative(resp:String) : void {
			var parts:Array = resp.split(',');
			for(var i:uint = 0; i < parts.length; i++){
				this.response = 'negative:' + parts[i];
			}
			//this.response = 'negative:' + parts.join(',negative:');
		}
		public function set positive(resp:String) : void {
			var parts:Array = resp.split(',');
			for(var i:uint = 0; i < parts.length; i++){
				this.response = 'positive:' + parts[i];
			}
			//this.response = 'positive:' + parts.join(',positive:');
		}
		public function set noresponse(resp:String) : void {
			var parts:Array = resp.split(',');
			for(var i:uint = 0; i < parts.length; i++){
				this.response = 'noresponse:' + parts[i];
			}
		}
		public function set response(resp:String) : void {
			var parts:Array = resp.split(',');
			if(parts.length > 1){
				for(var i:uint = 0; i < parts.length; i++){
					this.response = parts[i];
				}
				return;
			}
			resp = resp.indexOf(':') == -1 ? 'neutral:' + resp : resp;
			if(responseString == ''){
				this.responseString = resp;
			}else{
				this.responseString += ','+ resp;
			}
		}
			
		
		public function AbstractResponseTarget(){
			this.responseString = '';
			this.responses = [];
			this.visible = false;
			this.x = 0;
			this.y = 0;
			this.left = 0;
			this.top = 0;
			this.addEventListener(FlexEvent.SHOW, this.setShowStyles);
		}
		private function setShowStyles(e:Event = null):void{
			trace('AbstractReponseTarget('+this.id+').setShowStyles: called');
			var app:Application = FlexGlobals.topLevelApplication as Application;
			this.width = app.width;
			this.height = app.height;
		}
		protected function setHideStyles() : void {
			trace('AbstractReponseTarget('+this.id+').setHideStyles: called');
			this.setStyle('width', '1');
			this.setStyle('height', '1');
			this.visible = false;
		}
		
		
		public function chainResponse(response:String) : void {
			if(this.responseString == ''){ // cascading, if own responseString is empty
				trace('AbstractResponseTarget('+this.id+').chainResponse: ' + response);
				this.setResponse(response);
			}else{
				trace('AbstractReponseTarget('+this.id+').chainResponse: ' + this.responseString + ', ignoriere elternresponse');
				this.setResponse(responseString);
			}
		}
		private function setResponse(response:String) : void {
			if(response != ''){
				trace('AbstractReponseTarget('+this.id+').setResponse(befor): ' + response);
				var responseParts:Array = response.split(',');
				for(var i:uint = 0; i < responseParts.length; i++){
					var parts:Array = responseParts[i].split(':');
					this.responses.push(ResponseFactory.build(parts[0], parts[1], this.hide));
				}
				trace('AbstractResponseTarget('+this.id+').setResponse(after):', this.responses.join('|'));
			}
		}
		public function show(jumptoPath : Array = null) : void {
			trace('AbstractReponseTarget('+this.id+').show: called');
			this.visible = true;
			for(var i:int = 0, l:int = this.responses.length; i < l; i++){
				trace('AbstractReponseTarget('+this.id+').show: adding response ' + this.responses[i]);
				(this.responses[i] as AbstractResponse).acivate(this);
			}
		}
		
		protected function hide(object:Object = null) : void { // called by a response triggered by user interaction
			trace('AbstractReponseTarget('+this.id+').hide: called');
			for(var i:int = 0, l:int = this.responses.length; i < l; i++){
				(this.responses[i] as AbstractResponse).remove(this);
			}
			trace('AbstractReponseTarget('+this.id+').hide(after remove responses):', this.responses.join('|'),this.responses.length);
			this.setHideStyles();
		}
		
			
		override public function toString() : String{
			return this.id || 'AbstractResponseTarget';
		}
	}
}