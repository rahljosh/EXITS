<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    	<cfparam name="client.hostid" default="80006">    
        <link rel="stylesheet" href="linked/css/colorbox2.css" />
       
       
        <script src="linked/js/jquery.colorbox.js"></script>
	<script>

        $(document).ready(function(){
            //Examples of how to assign the ColorBox event to elements
            
            $(".iframe").colorbox({width:"80%", height:"80%", iframe:true, 
                onClosed:function(){ location.reload(true); } });

            
        });

    </script>
    
    <script type="text/javascript">
    function zp(n){
    return n<10?("0"+n):n;
    }
    function insertDate(t,format){
    var now=new Date();
    var DD=zp(now.getDate());
    var MM=zp(now.getMonth()+1);
    var YYYY=now.getFullYear();
    var YY=zp(now.getFullYear()%100);
    format=format.replace(/DD/,DD);
    format=format.replace(/MM/,MM);
    format=format.replace(/YYYY/,YYYY);
    format=format.replace(/YY/,YY);
    t.value=format;
    }
    </script>
        <style type="text/css">
			.smlink         		{font-size: 11px;}
			.section        		{border-top: 1px solid #c6c6c6;; border-right: 2px solid #c6c6c6;border-left: 2px solid #c6c6c6;border-bottom: 0px; background: #ffffff;}
			.sectionFoot    		{border-bottom: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;font-size:2px;}
			.sectionBottomDivider 	{border-bottom: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;}
			.sectionTopDivider 		{border-top: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;}
			.sectionSubHead			{font-size:11px;font-weight:bold;}
			.alert{
				width:auto;
				height:55px;
				border:#666;
				background-color:#FF9797;
				text-align:center;
				-moz-border-radius: 15px;
				border-radius: 15px;
				vertical-align:center;
				}
			.clearfix {
				display: block;
				clear: both;
				height: 5px;
				width: 100%;
				}
		</style>
</head>
<body>
	<cfset listToDisplay = '#url.todo#'>
    

	<cfinclude template="#listToDisplay#.cfm">
</body>
</html>		