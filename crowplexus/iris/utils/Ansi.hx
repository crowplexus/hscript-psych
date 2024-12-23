package crowplexus.iris.utils;

#if (haxe_ver < 4.3) @:enum #else enum #end

abstract AnsiColor(Int) {
	final BLACK = 0;
	final RED = 1;
	final GREEN = 2;
	final YELLOW = 3;
	final BLUE = 4;
	final MAGENTA = 5;
	final CYAN = 6;
	final WHITE = 7;
	final DEFAULT = 9;
	final ORANGE = 216;
	final DARK_ORANGE = 215;
	final ORANGE_BRIGHT = 208;
}

#if (haxe_ver < 4.3) @:enum #else enum #end

abstract AnsiTextAttribute(Int) {
	/**
	 * All colors/text-attributes off
	 */
	final RESET = 0;

	final INTENSITY_BOLD = 1;

	/**
	 * Not widely supported.
	 */
	final INTENSITY_FAINT = 2;

	/**
	 * Not widely supported.
	 */
	final ITALIC = 3;

	final UNDERLINE_SINGLE = 4;

	final BLINK_SLOW = 5;

	/**
	 * Not widely supported.
	 */
	final BLINK_FAST = 6;

	final NEGATIVE = 7;

	/**
	 * Not widely supported.
	 */
	final HIDDEN = 8;

	/**
	 * Not widely supported.
	 */
	final STRIKETHROUGH = 9;

	/**
	 * Not widely supported.
	 */
	final UNDERLINE_DOUBLE = 21;

	final INTENSITY_OFF = 22;

	final ITALIC_OFF = 23;

	final UNDERLINE_OFF = 24;

	final BLINK_OFF = 25;

	final NEGATIVE_OFF = 27;

	final HIDDEN_OFF = 28;

	final STRIKTHROUGH_OFF = 29;
}

class Ansi implements crowplexus.iris.IrisUsingClass {
	/**
	 * ANSI escape sequence header
	 */
	public static inline final ESC = "\x1B[";

	inline public static function reset(str: String): String
		return str + ESC + "0m";

	/**
	 * sets the given text attribute
	 */
	inline public static function attr(str: String, attr: AnsiTextAttribute): String
		return ESC + (attr) + "m" + str;

	/**
	 * set the text background color
	 *
	 * <pre><code>
	 * >>> Ansi.bg(RED) == "\x1B[41m"
	 * </code></pre>
	 */
	inline public static function bg(str: String, color: AnsiColor): String
		return ESC + "4" + color + "m" + str;

	/**
	 * Clears the screen and moves the cursor to the home position
	 */
	inline public static function clearScreen(): String
		return ESC + "2Jm";

	/**
	 * Clear all characters from current position to the end of the line including the character at the current position
	 */
	inline public static function clearLine(): String
		return ESC + "Km";

	/**
	 * set the text foreground color
	 *
	 * <pre><code>
	 * >>> Ansi.fg(RED) == "\x1B[31m"
	 * </code></pre>
	 */
	inline public static function fg(str: String, color: AnsiColor): String
		return ESC + "38;5;" + color + "m" + str;

	private static var colorSupported: Null<Bool> = null;

	public static function stripColor(output: String): String {
		#if sys
		if (colorSupported == null) {
			var term = Sys.getEnv("TERM");

			if (term == "dumb") {
				colorSupported = false;
			} else {
				if (colorSupported != true && term != null) {
					colorSupported = ~/(?i)-256(color)?$/.match(term)
						|| ~/(?i)^screen|^xterm|^vt100|^vt220|^rxvt|color|ansi|cygwin|linux/.match(term);
				}

				if (colorSupported != true) {
					colorSupported = Sys.getEnv("TERM_PROGRAM") == "iTerm.app"
						|| Sys.getEnv("TERM_PROGRAM") == "Apple_Terminal"
						|| Sys.getEnv("COLORTERM") != null
						|| Sys.getEnv("ANSICON") != null
						|| Sys.getEnv("ConEmuANSI") != null
						|| Sys.getEnv("WT_SESSION") != null;
				}
			}
		}

		if (colorSupported) {
			return output;
		}
		#end
		return ~/\x1b\[[^m]*m/g.replace(output, "");
	}
}
