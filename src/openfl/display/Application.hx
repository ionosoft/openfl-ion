package openfl.display;

import openfl.utils._internal.Lib;
#if lime
import lime.graphics.RenderContextAttributes;
import lime.app.Application as LimeApplication;
import lime.ui.WindowAttributes;
#end

/**
	The Application class is a Lime Application instance that uses
	OpenFL Window by default when a new window is created.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.DisplayObject)
@:access(openfl.display.LoaderInfo)
@:access(openfl.display.Window)
@SuppressWarnings("checkstyle:FieldDocComment")
class Application #if lime extends LimeApplication #end
{
	#if !lime
	public static var current:Application;

	public var window:Window;
	#end

	public function new()
	{
		#if lime
		super();
		#end

		if (Lib.application == null || Lib.application != this)
		{
			Lib.application = this;
		}

		#if (!flash && !macro)
		if (Lib.current == null) Lib.current = new MovieClip();
		Lib.current.__loaderInfo = LoaderInfo.create(null);
		Lib.current.__loaderInfo.content = Lib.current;
		#end
	}

	#if lime
	public override function createWindow(attributes:WindowAttributes):Window
	{
		var window = new Window(this);
		window.create(attributes);
		if (window.id == -1) {
			@:privateAccess window.__created = false;
			return null;
		}

		initWindow(window);

		return window;
	}

	public override function createWindowFrom(foreignHandle:Int, attributes:RenderContextAttributes, maxTries:Int = 5):Window
	{
		var window = new Window(this);
		var tries:Int = 0;
		while (tries < maxTries) {
			window.createFrom(foreignHandle, attributes);
			if (window.id != -1) break;
			tries++;
		}
		if (window.id == -1) {
			//... Pump some helpful error here. Just a trace for now.
			trace('Could not create window');
			@:privateAccess window.__created = false;
			return null;
		} else {
			initWindow(window);
		}

		return window;
	}

	private function initWindow(window:Window):Void
	{
		__windows.push(window);
		__windowByID.set(window.id, window);

		window.onClose.add(__onWindowClose.bind(window), false, -10000);

		if (__window == null)
		{
			__window = window;

			window.onActivate.add(onWindowActivate);
			window.onRenderContextLost.add(onRenderContextLost);
			window.onRenderContextRestored.add(onRenderContextRestored);
			window.onDeactivate.add(onWindowDeactivate);
			window.onDropFile.add(onWindowDropFile);
			window.onEnter.add(onWindowEnter);
			window.onExpose.add(onWindowExpose);
			window.onFocusIn.add(onWindowFocusIn);
			window.onFocusOut.add(onWindowFocusOut);
			window.onFullscreen.add(onWindowFullscreen);
			window.onKeyDown.add(onKeyDown);
			window.onKeyUp.add(onKeyUp);
			window.onLeave.add(onWindowLeave);
			window.onMinimize.add(onWindowMinimize);
			window.onMouseDown.add(onMouseDown);
			window.onMouseMove.add(onMouseMove);
			window.onMouseMoveRelative.add(onMouseMoveRelative);
			window.onMouseUp.add(onMouseUp);
			window.onMouseWheel.add(onMouseWheel);
			window.onMove.add(onWindowMove);
			window.onRender.add(render);
			window.onResize.add(onWindowResize);
			window.onRestore.add(onWindowRestore);
			window.onTextEdit.add(onTextEdit);
			window.onTextInput.add(onTextInput);

			onWindowCreate();
		}

		onCreateWindow.dispatch(window);
	}
	#end
}
