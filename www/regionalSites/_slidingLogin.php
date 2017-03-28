<script src="http://code.jquery.com/jquery-latest.js" type="text/javascript"></script>
<script type="text/javascript">
        $(document).ready(function() {

            $(".signin").click(function(e) {
                e.preventDefault();
                $("fieldset#signin_menu").toggle();
                $(".signin").toggleClass("menu-open");
            });

            $("fieldset#signin_menu").mouseup(function() {
                return false
            });
            $(document).mouseup(function(e) {
                if($(e.target).parent("a.signin").length==0) {
                    $(".signin").removeClass("menu-open");
                    $("fieldset#signin_menu").hide();
                }
            });            

        });
</script>
<script src="http://code.jquery.com/jquery-latest.j/jquery.tipsy.js" type="text/javascript"></script>
<script type='text/javascript'>
    $(function() {
      $('#forgot_username_link').tipsy({gravity: 'w'});
    });
 </script>


	<!-- stylesheets -->

	
  	<!-- PNG FIX for IE6 -->
  	<!-- http://24ways.org/2007/supersleight-transparent-png-in-ie6 -->
	<!--[if lte IE 6]>
		<script type="text/javascript" src="js/pngfix/supersleight-min.js"></script>
	<![endif]-->
	
	    <!-- jQuery - the core -->
	<script src="js/jquery-1.3.2.min.js" type="text/javascript"></script>
	<!-- Sliding effect -->
	<script src="js/slide.js" type="text/javascript"></script>

<!-- Panel -->
<div id="toppanel">
	<div id="panel">
		<div class="content clearfix">
			<div class="left">
				
					
					<p class="grey">If you would like to be a host family, but do not have an account:
 <Br />
                <a href="meet-our-students.cfm">Get started here</a></p>
                <br>
                <!----
                <p class="grey">Students, please contact an agent in your home country to get started on the path to becoming an exchange student. <Br />
                <a href="">Find an organization in your country</a></p>---->
                <p class="grey">Looking to travel abroad? Visit our Outbound site for more information <Br />
                <a href="mailto:tom@iseusa.com">Outbound Programs</a></p>
			
				
			</div>
			<div class="left">
				<!-- Staff Form -->
				
				<form class="clearfix" action="https://ise.exitsapplication.com/login.cfm" method="post">
                <input type="hidden" name="login_submitted" value=1>
					<h1>Students & Field Staff</h1>
					<label class="grey" for="log">Username:</label>
					<input class="field" type="text" name="username" id="log" value="" size="23" />
					<label class="grey" for="pwd">Password:</label>
					<input class="field" type="password" name="password" id="pwd" size="23" />
	            	<div class="clear"></div>
					<input type="submit" name="submit" value="Login" class="bt_login" />
					<a class="lost-pwd" href="https://ise.exitsapplication.com/login.cfm?forgot=1">Forgot your password?</a>
				</form>
			</div>
			<div class="left right">			
				<!-- Register Form -->
				<form class="clearfix" action="https://www.iseusa.com/hostApplication/index.cfm?section=login" method="post">
                <input type="hidden" name="submitted" value=1>
					<h1>Host Families</h1>
					<label class="grey" for="log">Email:</label>
					<input class="field" type="text" name="username" id="log" value="" size="23" />
					<label class="grey" for="pwd">Password:</label>
					<input class="field" type="password" name="password" id="pwd" size="23" />
	            	<div class="clear"></div>
					<input type="submit" name="submit" value="Login" class="bt_login" />
					<a class="lost-pwd" href="https://www.iseusa.com/hostApp">Forgot your password?</a>
                    
				</form>
			</div>
		</div>
</div> <!-- /login -->	

	<!-- The tab on top -->	
<div align="center">
	<div class="tab">
		<ul class="login">
			<li class="left">&nbsp;</li>
 			<li>Welcome!</li>
			<li class="sep">|</li>
			<li id="toggle">
            <a href="exits-login.php">Log In</a>
            <!---<a id="open" class="open" href="#">Log In</a>
				<a id="close" style="display: none;" class="close" href="#">Close Panel</a>--->
			</li>
			<li class="right">&nbsp;</li>
		</ul> 
	</div> <!-- / top -->
	
</div> <!--panel -->

</div>




