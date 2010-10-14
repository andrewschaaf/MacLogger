
MacLogger is a simple Mac app. Whenever you have it running, it logs data about how you're using your Mac.

![](http://github.com/andrewschaaf/MacLogger/raw/master/screenshot.png)

This is an app for collecting data, not viewing it. It logs the data in simple formats so you can easily write scripts to analyze stuff.

Note: for the front-window signal, you need to "Enable access for assistive devices" in the "Universal Access" System Preferences pane.

# Data Formats

There are four signals so far:

 - mouse-pos
 - input-idle
 - front-window
 - screenshot

All of a signal's data is logged to ~/Library/Application Support/MacLogger/&lt;signal name&gt; ("signalDir")

All signals except screenshot use the following system:

When MacLogger launches, a file signalDir/%Y-%m-%d-%H-%M-%S-&lt;ms&gt;-Z.signal is created.

When the signal logs a blob of data ("x"), it appends this to that file:

<blockquote>
<code>uvarint(milliseconds since last sample) + uvarint(len(x)) + x</code>
</blockquote>

uvarint = the same variable-length integer encoding used in [protobuf](http://code.google.com/p/protobuf/)

## mouse-pos

Data: uvarint(x) + uvarint(y)

Logged only if the position has changed since the last sample.

## input-idle

Data: uvarint(1)

Logged only if there was any HID activity (e.g. keyboard, mouse, ...) since the last sample.

## front-window

Data: JSON-encoded dictionary

Logged only when it differs from the last sample.

Examples:

<code>{"app":"com.apple.Xcode","docUrl":"file://localhost/Users/a/repos/MacLogger/MacLogger/MousePosSignal.m"}</code>

<code>{"app":"com.apple.Safari","webUrl":"http://www.eff.org/"}</code>

## screenshot

Simply saves a PNG of the main display to signalDir/%Y/%m/%d/%Y-%m-%d-%H-%M-%S.png

