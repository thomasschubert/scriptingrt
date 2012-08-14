package org.nad.dm
{
	public class ProtocolItem{
		private var protocol:Object;
		private var protoString:String;
		
		public function ProtocolItem(object:Object){
			this.protocol = object;
		}
		
		public function toString() : String {
			if(this.protoString == null){
				this.protoString = '';
				for(var n:String in this.protocol){
					this.protoString += '/' + this.protocol[n]; 
				}
			}
			return this.protoString;
		}
	}
}