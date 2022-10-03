package openfl.display;

import openfl.utils._internal.Lib;
#if lime
import lime.graphics.RenderContextAttributes;
import lime.app.Application;
import lime.ui.Window as LimeWindow;
import lime.ui.WindowAttributes;
#end

/**
	The Window class is a Lime Window instance that automatically
	initializes an OpenFL stage for the current window.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.LoaderInfo)
@:access(openfl.display.Stage)
@SuppressWarnings("checkstyle:FieldDocComment")
class Window #if lime extends LimeWindow #end
{
	#if !lime
	public var application:Application;
	@SuppressWarnings("checkstyle:Dynamic") public var context:Dynamic;
	@SuppressWarnings("checkstyle:Dynamic") public var cursor:Dynamic;
	@SuppressWarnings("checkstyle:Dynamic") public var display:Dynamic;
	public var frameRate:Float;
	public var fullscreen:Bool;
	public var height:Int;
	public var scale:Float;
	public var stage:Stage;
	public var textInputEnabled:Bool;
	public var width:Int;
	#end

	@SuppressWarnings("checkstyle:Dynamic")
	@:noCompletion private function new(application:Application)
	{
		#if lime
		super(application);
		#end
	}

	@SuppressWarnings("checkstyle:Dynamic")
	@:noCompletion public #if lime override #end function create(attributes:#if lime WindowAttributes #else Dynamic #end):Void
	{
		#if lime
		super.create(attributes);
		#end

		finishInit(attributes);
	}

	@SuppressWarnings("checkstyle:Dynamic")
	@:noCompletion public #if lime override #end function createFrom(foreignHandle:Int, attributes:#if lime RenderContextAttributes #else Dynamic #end):Void
	{
		#if lime
		super.createFrom(foreignHandle, attributes);
		#end

		finishInit({context: attributes});
	}

	@SuppressWarnings("checkstyle:Dynamic")
	private function finishInit(attributes:#if lime WindowAttributes #else Dynamic #end):Void
	{
		#if (!flash && !macro)
		#if commonjs
		if (Reflect.hasField(attributes, "stage"))
		{
			stage = Reflect.field(attributes, "stage");
			stage.window = this;
			Reflect.deleteField(attributes, "stage");
		}
		else
		#end
		stage = new Stage(this, Reflect.hasField(attributes.context, "background") ? attributes.context.background : 0xFFFFFF);

		if (Reflect.hasField(attributes, "parameters"))
		{
			try
			{
				stage.loaderInfo.parameters = attributes.parameters;
			}
			catch (e:Dynamic) {}
		}

		stage.__setLogicalSize(attributes.width, attributes.height);

		if (Reflect.hasField(attributes, "resizable") && !attributes.resizable)
		{
			stage.scaleMode = StageScaleMode.SHOW_ALL;
		}

		#if lime
		application.addModule(stage);
		#end
		#else
		stage = Lib.current.stage;
		#end
	}
}
