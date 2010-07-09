<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">

<head>
<title>A CSS-based Form Template</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />

<style type="text/css">

/* General styles */
body { margin: 0; padding: 0; font: 80%/1.5 Arial,Helvetica,sans-serif; color: #111; background-color: #FFF; }
h2 { margin: 0px; padding: 10px; font-family: Georgia, "Times New Roman", Times, serif; font-size: 200%; font-weight: normal; color: #FFF; background-color: #CCC; border-bottom: #BBB 2px solid; }
p#copyright { margin: 20px 10px; font-size: 90%; color: #999; }

/* Form styles */
div.form-container { margin: 10px; padding: 5px; background-color: #FFF; border: #EEE 1px solid; }

p.legend { margin-bottom: 1em; }
p.legend em { color: #C00; font-style: normal; }

div.errors { margin: 0 0 10px 0; padding: 5px 10px; border: #FC6 1px solid; background-color: #FFC; }
div.errors p { margin: 0; }
div.errors p em { color: #C00; font-style: normal; font-weight: bold; }

div.form-container form p { margin: 0; }
div.form-container form p.note { margin-left: 170px; font-size: 90%; color: #333; }
div.form-container form fieldset { margin: 10px 0; padding: 10px; border: #DDD 1px solid; }
div.form-container form legend { font-weight: bold; color: #666; }
div.form-container form fieldset div { padding: 0.25em 0; }
div.form-container label, 
div.form-container span.label { margin-right: 10px; padding-right: 10px; width: 150px; display: block; float: left; text-align: right; position: relative; }
div.form-container label.error, 
div.form-container span.error { color: #C00; }
div.form-container label em, 
div.form-container span.label em { position: absolute; right: 0; font-size: 120%; font-style: normal; color: #C00; }
div.form-container input.error { border-color: #C00; background-color: #FEF; }
div.form-container input:focus,
div.form-container input.error:focus, 
div.form-container textarea:focus {	background-color: #FFC; border-color: #FC6; }
div.form-container div.controlset label, 
div.form-container div.controlset input { display: inline; float: none; }
div.form-container div.controlset div { margin-left: 170px; }
div.form-container div.buttonrow { margin-left: 180px; }

</style>

</head>

<body>

<div id="wrapper">

	<h2>A CSS-based Form Template</h2>

	<div class="form-container">

	<p>More information about this template could be found in <a href="http://nidahas.com/2006/12/06/forms-markup-and-css-revisited/" title="Nidahas: Forms markup and CSS - Revisited">this blog article</a>.</p>
	
	<div class="errors">
		<p><em>Oops... the following errors were encountered:</em></p>

		<ul>
			<li>Username cannot be empty</li>
			<li>Country cannot be empty</li>
		</ul>
		<p>Data has <strong>not</strong> been saved.</p>
	</div>

	<form action="#" method="post">
	
	<p class="legend"><strong>Note:</strong> Required fields are marked with an asterisk (<em>*</em>)</p>
	
	<fieldset>
		<legend>User Details</legend>
			<div><label for="uname" class="error">Username <em>*</em></label> <input id="uname" type="text" name="uname" value="" class="error" /></div>

			<div><label for="email">Email Address </label> <input id="email" type="text" name="email" value="" />
				<p class="note">We will never sell or disclose your email address to anyone. <strong>This is an example of a note for an input field.</strong></p>
			</div>
	
			<div><label for="fname">First Name <em>*</em></label> <input id="fname" type="text" name="fname" value="" size="50" /></div>
			<div><label for="lname">Last Name </label> <input id="lname" type="text" name="lname" value="" size="50" /></div>

	</fieldset>
	
	<fieldset>
		<legend>Contact Information</legend>
			<div><label for="address1">Address 1 <em>*</em></label> <input id="address1" type="text" size="50" /></div>
			<div><label for="address2">Address 2</label> <input id="address2" type="text" size="50" /></div>
			<div><label for="country" class="error">Country <em>*</em></label> <input id="country" type="text" name="country" value="" class="error" size="12" />

				<p class="note">Errors could be highlighted by giving an <code>error</code> class to the input field, as seen here.</p>
			</div>
			<div><label for="telephone">Telephone</label> <input id="telephone" type="text" size="3" /> - <input type="text" size="3" /> - <input type="text" size="4" />
				<p class="note">(###) - ### - ####</p>

			</div>
	</fieldset>
	
	<fieldset>
		<legend>Submission</legend>
			<div><label for="year">Year (YYYY) <em>*</em></label> <input id="year" type="text" name="year" value="" size="4" maxlength="4" /></div>
			<div><label for="date">Month (MM)</label> <input id="date" type="text" name="date" value="" size="4" maxlength="2" /></div>

	</fieldset>
	
	<fieldset>
		<legend>Preferences</legend>
			<div>
				<label for="type">Type <em>*</em></label>
				<select id="type">
					<optgroup label="Type of Whatever">

						<option>Corporate</option>
						<option>Individual</option>
					</optgroup>
				</select>
			</div>
			<div class="controlset">
				<span class="label">User Status <em>*</em></span>

				<input name="approved" id="approved" value="1" type="checkbox" /> <label for="approved">Approved</label>
				<input name="pending" id="pending" value="1" type="checkbox" /> <label for="pending">Pending Applications</label>
				<input name="actives" id="actives" value="1" type="checkbox" /> <label for="actives">Active Service</label>
			</div>			

			<div class="controlset">
				<span class="label">Preferred Location</span>

				<input name="radio1" id="radio1" value="1" type="radio" /> <label for="radio1">Option 1</label>
				<input name="radio1" id="radio2" value="1" type="radio" /> <label for="radio2">Option 2</label>
				<input name="radio1" id="radio3" value="1" type="radio" /> <label for="radio3">Option 3</label>
			</div>			

			<div class="controlset">
				<span class="label">Something Else <em>*</em></span>

				<div>
					<input name="approved" id="check1" value="1" type="checkbox" /> <label for="check1">Some Option 1</label> <br />
					<input name="pending" id="check2" value="1" type="checkbox" /> <label for="check2">Some Option 2</label> <br />
					<input name="actives" id="check3" value="1" type="checkbox" /> <label for="check3">Some Option 3</label> <br />

				</div>
			</div>			
	</fieldset>
	
	<fieldset>
		<legend>Profile</legend>
			<div>
				<label for="desc">Description <em>*</em></label>
				<textarea id="desc" name="desc" cols="30" rows="4"></textarea>

			</div>
			<div>
				<label for="info">Additional Info </label>
				<textarea id="info" name="info" cols="40" rows="5"></textarea>
			</div>
	</fieldset>
	
	<div class="buttonrow">
		<input type="submit" value="Save" class="button" />

		<input type="button" value="Discard" class="button" />
	</div>

	</form>
	
	</div><!-- /form-container -->
	
	<p id="copyright">Created by <a href="http://nidahas.com/">Prabhath Sirisena</a>. This stuff is in public domain.</p>
	
</div><!-- /wrapper -->

</body>
</html>

