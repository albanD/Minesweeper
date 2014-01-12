package controller 
{
	
	import model.*;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	
	public class MSController 
	{
		private var _model:MSModel;
		
		public function MSController(model:MSModel) 
		{
			_model = model;
			trace("controller created");
		}
		
		
		public function start_game(mode:Number):void {
			var size:Number;
			if (mode == 1) {
				size = 5;
			}
			else if (mode == 2) {
				size = 10;
			}
			else if (mode == 3) {
				size = 15;
			}
			_model.init(size);
		}
		
	}

}