package org.nad.dm
{
	import com.hurlant.eval.ast.ProtectedNamespace;
	
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	

	public class Protocol{
		
		private static var instance:Protocol;
		private var protocol:Array;
		
		public function Protocol(object:Object){
			if(!object is Checks){
				throw new Error('this is a singleton class, call getInstance() statically');
			}
			this.protocol = [];
		}
		
		
		public static function getInstance() : Protocol{
			if(instance == null){
				instance = new Protocol(new Checks());
				(FlexGlobals.topLevelApplication as Application ).protocol = 'new proto:------' + instance.protocol.length;
			}
			return instance;
		}
		
		public function write(proto:Object) : String {
			var ps:String = '';
			ps += (FlexGlobals.topLevelApplication as org.nad.dm.Application).protocolFormatItem;
			//var p:ProtocolItem = new ProtocolItem(proto );
			for(var n:String in proto){
				var r:RegExp = new RegExp('%'+n+'%','g');
				ps = ps.replace(r, proto[n]);
			}
			this.protocol.push( proto );
			(FlexGlobals.topLevelApplication as Application ).protocol = 'written proto:------' + instance.last();
			return ps;
		}
		public function last() : Object {
			return this.protocol.length > 0 ? this.protocol[this.protocol.length - 1] : null;
		}
		
		public function flush(url:String, formatHead:String, formatItem:String) : void{
			//Alert.show(url);
			try{
				var loader:URLLoader = new URLLoader(),
					vars:Array = url.split('?'),
					results:Array = [],
					ps:String = (FlexGlobals.topLevelApplication as org.nad.dm.Application).protocolFormatItem,
					params:URLVariables = new URLVariables(),
					request:URLRequest = new URLRequest( vars.shift() );
				vars = vars.join('?').split('&');
				request.method = URLRequestMethod.POST;
				for(var i:uint = 0, l:uint = vars.length; i < l; i++){
					var p:Array = vars[i].split('=');
					params[p[0]] = p[1];
				}
				var time:Date = new Date();
				params['vpn'] = formatHead.replace(/\%clientUploadTime\%/g, time.getFullYear()+'-'+time.getMonth()+'-'+time.getDate()+' '+time.getHours()+':'+time.getMinutes()+':'+time.getSeconds());
				l = this.protocol.length;
				for(i = 0; i < l; i++){
					var proto:Object = this.protocol[i],
						protoString:String = ps;
					for(var n:String in proto){
						var r:RegExp = new RegExp('%'+n+'%','g');
						protoString = protoString.replace(r, proto[n]);
					}
					results.push(protoString);
				}
				
				params['results'] = results.join('\n');
				
				
				
				request.data = params;
				loader.addEventListener(Event.COMPLETE, function(event:Event):void{
					if(loader.data == 'ok'){
						Alert.show('Data was submitted to server');
					}else{
						Alert.show(loader.data);
					}
				});
			
				loader.load(request);
			}catch(error:Error){
				Alert.show('IOError: Connection to Server refused.');
			}
		}
	}
}
class Checks{
	public function Checks(){
		;
	}
}