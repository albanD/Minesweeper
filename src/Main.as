package 
{
	import flash.display.Sprite;
	import view.*;
	import controller.*;
	import model.*;
	
	public class Main extends Sprite 
	{
		private var _model:MSModel;
		private var _view:MSView;
		private var _controller:MSController;
		
		
		public function Main():void 
		{
			_model = new MSModel();
			_view = new MSView(_model);
			_controller = new MSController(_model, _view);
			addChild(_view);
			_controller.start_game();
		}
				
	}
	
}