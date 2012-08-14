package org.nad.dm
{
	public class Repeater extends AbstractChainLink{
		
		
		
		public function Repeater(parts:Array, parentID:String){
			super();
			
			this.id = 'repeater of ' + parentID;
			trace('Repeater.as: ' + this.id + ' : ' + parts.length);
			for(var i:int = 0, l:int = parts.length; i < l; i++){
				if(parts[i] is IChainLink){
					this.addChild(parts[i]);
				}
			}
		}
		
		
		
	}
}