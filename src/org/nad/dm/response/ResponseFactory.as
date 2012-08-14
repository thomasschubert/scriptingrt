package org.nad.dm.response
{
	import flash.utils.Timer;
	
	import org.nad.dm.AbstractChainLink;
	import org.nad.dm.Application;

	public final class ResponseFactory
	{
		public function ResponseFactory(){
		}
		
		public static function build(dir:String, type:String, callback:Function) : AbstractResponse{
			var types:Array = type.split('.'),
				input:String = (types.shift() as String).toLowerCase(),
				typ:Object;
			switch(dir){
				case 'positive': typ = {value: 1}; break;
				case 'negative': typ = {value:-1}; break;
				case 'noresponse': typ = {value:null}; break;
				default: typ = {value:0};
			}
			trace(input);
			switch(input){
				case 'mouse': return new MouseResponse(typ, types, callback);
				case 'keyboard': return new KeyboardResponse(typ, types, callback);
				case 'time': return new TimerResponse(typ, types, callback);
			}
			return null;
		}
	}
}