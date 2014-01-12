package view 
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import model.*;
	import controller.*;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	
	public class MSView extends Sprite
	{
		private var _model:MSModel;
		private var _controller:MSController;
		private var _gameInstance:MovieClip;
		private var _rect:Shape;
		
		public function MSView(model:MSModel, controller:MSController) 
		{
			_model = model;
			_controller = controller;
			trace("view created");
			starting_screen();
			
			/*
			_gameInstance = new MovieClip();
			addChild(_gameInstance);
			
			_rect = new Shape;
			_rect.graphics.beginFill(0x777777);
			_rect.graphics.drawRoundRect(60, 60, 100, 100, 10);
			_rect.graphics.endFill();
			addChild(_rect);	
			*/			
		}
		
		
		private function starting_screen():void 
		{
			var rules:TextField = new TextField;
			rules.x = 10;
			rules.y = 20;
			rules.width = 200;
			rules.height = 200;
			rules.text = "The rules:\n"
				+ "click to discover a mine\n"
				+ "Ctrl click to mark a mine\n\n"
				+ "Choose your level";
			addChild(rules);
			
		}
	}

}