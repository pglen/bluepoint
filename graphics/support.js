///////////////////////////////////////////////////////////////////////////
// This function displays the time and logo on the status line.
// Invoke it once to activate the clock; it will call itself from then on.

function display_time_in_status_line()

{
var d = new Date(); // get current time;
var h = d.getHours(); // extract hours: 0 to 23
var m = d.getMinutes(); // extract minutes: 0 to 59
var s = d.getSeconds(); // extract seconds

var ampm = (h >= 12)?"PM":"AM"; // is it am or pm?
if (h > 12) h -= 12; // convert 24-hour format to 12-hour
if (h == 0) h = 12; // convert 0 o'clock to midnight
if (m < 10) m = "0" + m; // convert 0 minutes to 00 minutes, etc.
var t = h + ':' + m + ':' + s + " " + ampm; // put it all together
// display it in the status line
defaultStatus = 'Encryption test form by BluePoint (C) ' + t;

// Arrange to do it all again in 1 minute.
setTimeout("display_time_in_status_line()", 500); // second
// 60000 ms in 1 minute
}
