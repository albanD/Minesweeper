package 
{
	import flash.display.Sprite;
	import view.*;
	import controller.*;
	import model.*;
	
	public class Main extends Sprite 
	{
		private var _model:MSModel;
		private var _controller:MSController;
		private var _view:MSView;
		
		
		public function Main():void 
		{
			_model = new MSModel();
			_controller = new MSController(_model);
			_view = new MSView(_model, _controller);
			addChild(_view);
			_view.starting_screen();
		}
				
	}
	
}