package broker.text.heaps;

#if heaps
import broker.object.Object;
import broker.color.ArgbColor;
import broker.color.RgbColor;
import broker.color.Alpha;

@:notNull @:forward(x, y, visible, rotation, scaleX, scaleY, scale, setScale, setPosition)
@:using(broker.object.ObjectExtension)
abstract Text(h2d.Text) from h2d.Text to h2d.Text to Object {
	static var defaultFont: Maybe<Font> = Maybe.none();
	static var defaultRgb = RgbColor.WHITE;

	/**
		Registers the default font.
	**/
	public static function setDefaultFont(font: Font): Void
		defaultFont = Maybe.from(font);

	/**
		Registers the default color in RGB.
	**/
	public static function setDefaultRgb(color: RgbColor): Void
		defaultRgb = color;

	/**
		`this` as the underlying type.
	**/
	public var data(get, never): h2d.Text;

	/**
		Text color in ARGB.
	**/
	public var textArgb(get, set): ArgbColor;

	/**
		Text color in RGB.
	**/
	public var textRgb(get, set): RgbColor;

	/**
		Alpha value.
	**/
	public var alpha(get, set): Alpha;

	public function new(
		s: String,
		align: Align = Left,
		?font: Font
	) {
		this = if (font != null) new h2d.Text(font) else {
			if (defaultFont.isNone()) throw "Default font not registered.";
			new h2d.Text(defaultFont.unwrap());
		};
		this.text = s;
		this.textAlign = switch align {
			case Left: Left;
			case Center: if (s.getIndexOf("\n").isSome()) MultilineCenter else Center;
			case Right: if (s.getIndexOf("\n").isSome()) MultilineRight else Right;
		};
		textRgb = defaultRgb;
	}

	extern inline function get_data()
		return this;

	extern inline function get_textArgb()
		return RgbColor.from(this.textColor).toArgb(this.color.a);

	extern inline function set_textArgb(color: ArgbColor) {
		this.color.setColor(color.int());
		return color;
	}

	extern inline function get_textRgb()
		return RgbColor.from(this.textColor);

	extern inline function set_textRgb(color: RgbColor) {
		this.textColor = color.int();
		return color;
	}

	extern inline function get_alpha()
		return Alpha.fromUnsafe(this.color.a);

	extern inline function set_alpha(alpha: Alpha) {
		this.color.a = alpha.float();
		return alpha;
	}
}
#end
