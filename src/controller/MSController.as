package controller 
{
	
	import model.*
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
		
	}

}