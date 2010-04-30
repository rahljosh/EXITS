<!DOCTYPE html>
<html>
<head>
  <style>
  p { color:green; font-weight:bolder; margin:3px 0 0 10px; }
  div { color:blue; margin-left:20px; font-size:14px; }
  span { color:red; }
  </style>
  <script src="http://code.jquery.com/jquery-latest.js"></script>
</head>
<body>
	<p>Browser info:</p>
<script>
    jQuery.each(jQuery.browser, function(i, val) {
      $("<div>" + i + " : <span>" + val + "</span>")
                .appendTo(document.body);
    });</script>
</body>
</html>