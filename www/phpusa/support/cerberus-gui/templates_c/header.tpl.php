<?php /* Smarty version 2.5.0, created on 2007-01-15 11:11:29
         compiled from header.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('modifier', 'cer_href', 'header.tpl.php', 166, false),
array('modifier', 'lower', 'header.tpl.php', 167, false),
array('modifier', 'truncate', 'header.tpl.php', 176, false),
array('modifier', 'short_escape', 'header.tpl.php', 176, false),)); ?><script language="Javascript" type="text/javascript">
sid = "sid=<?php echo $this->_tpl_vars['session_id']; ?>
";
show_sid = <?php echo $this->_tpl_vars['track_sid']; ?>
;
error_nan = "<?php echo @constant('LANG_CERB_ERROR_TICKET_NAN'); ?>
";

sid = "sid=<?php echo $this->_tpl_vars['session_id']; ?>
";
show_sid = <?php echo $this->_tpl_vars['track_sid']; ?>
;

<?php if (isset ( $this->_tpl_vars['new_pm'] ) && $this->_tpl_vars['new_pm'] !== false): ?>
new_pm = <?php echo $this->_tpl_vars['new_pm']; ?>
;
<?php else: ?>
new_pm = false;
<?php endif; ?>

<?php echo '
function cer_upload_win()
{
	url = "upload.php";
	if(show_sid) {
		window.open( url + "?" + sid,"uploadWin","width=600,height=300,status=yes");
	}
	else {
		window.open( url,"uploadWin","width=600,height=300,status=yes");
	}
}

function toggleDiv(div,state) {
	var eDiv = document.getElementById(div);
	
	if(null != eDiv) {
		if(eDiv.style.display == "block" || 0==state) {
			eDiv.style.display = "none";
		} else {
			eDiv.style.display = "block";
		}
	}
}
function toggleDivInline(div,state) {
	var eDiv = document.getElementById(div);
	
	if(null != eDiv) {
		if(eDiv.style.display == "inline" || 0==state) {
			eDiv.style.display = "none";
		} else {
			eDiv.style.display = "inline";
		}
	}
}

function getCacheKiller() {
	var date = new Date();
	return date.getTime();
}

function formatURL(url)
{
	if(show_sid) { url = url + "&" + sid; }
	return(url);
}

function printTicket(url)
{
	window.open(url,\'print_ticket\',\'width=700,height=500,scrollbars=yes\');
}

function pmCheck()
{
	if(new_pm != false)
	{
		url = "message_popup.php?mid=" + new_pm;
		window.open(formatURL(url),"pm_notify_wdw","width=200,height=175");
	}
}

function load_init()
{
	pmCheck();
}

function jumpNav(link)
{
	if(link != null) {
		link_id = link;
	}
	else
		link_id = parseInt(document.headerForm.jump_nav.value);
		
	switch(link_id)
	{
		case 0:
		url = "my_cerberus.php?mode=dashboard";
		break;
		case 1:
		url = "my_cerberus.php?mode=tasks";
		break;
		case 2:
		url = "my_cerberus.php?mode=messages";
		break;
		case 3:
		url = "my_cerberus.php?mode=preferences";
		break;
		case 4:
		url = "my_cerberus.php?mode=assign";
		break;
		case 5:
		url = "my_cerberus.php?mode=notification";
		break;
	}

//	if(show_sid) { url = url + "&" + sid; } document.location = url;
	document.location = formatURL(url);
}

function findX(o)
{
	var left = 0;
	if (o.offsetParent)
	{
		while (o.offsetParent)
		{
			left += o.offsetLeft
			o = o.offsetParent;
		}
	}
	else if (o.x)
	{
		left += obj.x;
	}
	return left;
}

function findY(o)
{
	var top = 0;
	if (o.offsetParent)
	{
		while (o.offsetParent)
		{
			top += o.offsetTop
			o = o.offsetParent;
		}
	}
	else if (o.y) {
		top += o.y;
	}
	return top;
}	

'; ?>



</script>
<?php if (( ! empty ( $this->_tpl_vars['errorcode'] ) )): ?>
<font color="red"><center><?php echo $this->_tpl_vars['errorcode']; ?>
</center></font>
<?php endif; ?>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td colspan="2" valign="bottom" bgcolor="#FFFFFF"> 
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td width="99%"><img alt="Cerberus Logo" src="logo.gif"></td>
          <td width="1%" align="right" valign="bottom" nowrap><span class="cer_footer_text">
          		<?php echo @constant('LANG_HEADER_LOGGED'); ?>

              <b><?php echo $this->_tpl_vars['user_login']; ?>
</b> 
     				<img src="includes/images/icone/16x16/flag_red.gif" width="16" height="16" border="0" title="My Flagged Tickets"><a href="<?php echo $this->_run_mod_handler('cer_href', true, 'ticket_list.php?override=h0'); ?>
" class="cer_maintable_text" title="My Flagged Tickets"><?php echo $this->_tpl_vars['header_flagged']; ?>
</a> <img src="includes/images/icone/16x16/hand_paper.gif" width="16" height="16" border="0" title="Tickets Suggested to Me"><a href="<?php echo $this->_run_mod_handler('cer_href', true, 'ticket_list.php?override=h1'); ?>
" class="cer_maintable_text" title="Tickets Suggested to Me"><?php echo $this->_tpl_vars['header_suggested']; ?>
</a>
              [ <a href="<?php echo $this->_tpl_vars['urls']['logout']; ?>
" class="cer_maintable_text"><?php echo $this->_run_mod_handler('lower', true, @constant('LANG_WORD_LOGOUT')); ?>
</a> ]</span>
              <?php if ($this->_tpl_vars['unread_pm']): ?>
	            <br>
              	<a href="<?php echo $this->_tpl_vars['urls']['mycerb_pm']; ?>
" class="cer_configuration_updated"><?php echo $this->_tpl_vars['unread_pm']; ?>
 <?php echo @constant('LANG_HEADER_UNREAD_MESSAGES'); ?>
!</a>
              <?php endif; ?>
              
			<span class="cer_footer_text">
			<?php if (! empty ( $this->_tpl_vars['session']->vars['login_handler']->ticket_id )): ?>
				<br>
				<B>[</B> <?php echo @constant('LANG_HEADER_LAST_VIEWED'); ?>
: <a href="<?php echo $this->_tpl_vars['session']->vars['login_handler']->ticket_url; ?>
" class="cer_maintable_text"><?php echo $this->_run_mod_handler('short_escape', true, $this->_run_mod_handler('truncate', true, $this->_tpl_vars['session']->vars['login_handler']->ticket_subject, 45, "...")); ?>
</a> <B>]</B>
			<?php endif; ?>
				</span>
            <br>
            <form name="headerForm" action="ticket_list.php" method="post" OnSubmit="this.override.value=this.category.value+this.search.value;" style="margin:0px;padding-top:3px;"><span class="cer_footer_text"><b>Quick Find:</b> </span><input type="hidden" name="override" value=""><select name="category" class="cer_footer_text">
            	<option value="i" <?php if ($this->_tpl_vars['session']->vars['override_type'] == 'i'): ?>selected<?php endif; ?>>Ticket ID/Mask
            	<option value="r" <?php if ($this->_tpl_vars['session']->vars['override_type'] == 'r'): ?>selected<?php endif; ?>>Requester
            	<option value="s" <?php if ($this->_tpl_vars['session']->vars['override_type'] == 's'): ?>selected<?php endif; ?>>Subject
            	<option value="c" <?php if ($this->_tpl_vars['session']->vars['override_type'] == 'c'): ?>selected<?php endif; ?>>Content</select><input type="text" name="search" size="15" value="" class="cer_footer_text"><input type="submit" class="cer_button_face" value="<?php echo @constant('LANG_WORD_SEARCH'); ?>
"></form>
            <img alt="" src="includes/images/spacer.gif" height="3" width="1"></td>
        </tr>
      </table>
</td>
  </tr>
  <tr> 
    <td colspan="2" valign="bottom" bgcolor="#FFFFFF" class="headerMenu"><img alt="" src="includes/images/spacer.gif" width="1" height="5"></td>
  </tr>
  <tr> 
    <td width="99%" valign="bottom" bgcolor="#888888"> 
      <table border="0" cellpadding="0" cellspacing="0">
        <tr> 
          <td><img alt="" src="includes/images/spacer.gif" width="15" height="8" align="middle"></td>
          
          <td valign="bottom"><img alt="" src="includes/images/menuSep.gif" width="1" height="10" align="middle"></td>
          <td nowrap <?php if ($this->_tpl_vars['page'] == "index.php"): ?>bgcolor="#FF6600"<?php else: ?>onMouseover="this.style.backgroundColor='#AAAAAA';" onMouseout="this.style.backgroundColor='#888888';"<?php endif; ?>><img alt="" src="includes/images/spacer.gif" width="15" height="8" align="middle"><a href="<?php echo $this->_tpl_vars['urls']['home']; ?>
" class="<?php if ($this->_tpl_vars['page'] == "index.php"): ?>headerMenuActive<?php else: ?>headerMenu<?php endif; ?>"><?php echo $this->_run_mod_handler('lower', true, 'dashboard'); ?>
</a><img alt="" src="includes/images/spacer.gif" width="15" height="8" align="middle"></td>
          
          <td valign="bottom"><img alt="" src="includes/images/menuSep.gif" width="1" height="10" align="middle"></td>
          <td nowrap <?php if ($this->_tpl_vars['page'] == "getwork.php"): ?>bgcolor="#FF6600"<?php else: ?>onMouseover="this.style.backgroundColor='#AAAAAA';" onMouseout="this.style.backgroundColor='#888888';"<?php endif; ?>><img alt="" src="includes/images/spacer.gif" width="15" height="8" align="middle"><a href="<?php echo $this->_run_mod_handler('cer_href', true, "getwork.php"); ?>
" class="<?php if ($this->_tpl_vars['page'] == "getwork.php"): ?>headerMenuActive<?php else: ?>headerMenu<?php endif; ?>"><?php echo $this->_run_mod_handler('lower', true, 'teamwork'); ?>
</a><img alt="" src="includes/images/spacer.gif" width="15" height="8" align="middle"></td>
          
       	<td valign="bottom"><img alt="" src="includes/images/menuSep.gif" width="1" height="10" align="middle"></td>
       	<td nowrap <?php if ($this->_tpl_vars['page'] == "ticket_list.php"): ?>bgcolor="#FF6600"<?php else: ?>onMouseover="this.style.backgroundColor='#AAAAAA';" onMouseout="this.style.backgroundColor='#888888';"<?php endif; ?>><img alt="" src="includes/images/spacer.gif" width="15" height="1"><a href="<?php echo $this->_tpl_vars['urls']['search_results']; ?>
" class="<?php if ($this->_tpl_vars['page'] == "ticket_list.php"): ?>headerMenuActive<?php else: ?>headerMenu<?php endif; ?>"><?php echo @constant('LANG_HEADER_RESULTS'); ?>
</a><img alt="" src="includes/images/spacer.gif" width="15" height="8"></td>
          
          <?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_KB'))): ?>
	          <td valign="bottom"><img alt="" src="includes/images/menuSep.gif" width="1" height="10" align="middle"></td>
    	      <td nowrap <?php if ($this->_tpl_vars['page'] == "knowledgebase.php"): ?>bgcolor="#FF6600"<?php else: ?>onMouseover="this.style.backgroundColor='#AAAAAA';" onMouseout="this.style.backgroundColor='#888888';"<?php endif; ?>><img alt="" src="includes/images/spacer.gif" width="15" height="1"><a href="<?php echo $this->_tpl_vars['urls']['knowledgebase']; ?>
" class="<?php if ($this->_tpl_vars['page'] == "knowledgebase.php"): ?>headerMenuActive<?php else: ?>headerMenu<?php endif; ?>"><?php echo @constant('LANG_HEADER_KB'); ?>
</a><img alt="" src="includes/images/spacer.gif" width="15" height="1"></td>
          <?php endif; ?>
          
          <?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_CONFIG'))): ?>
	          <td valign="bottom"><img alt="" src="includes/images/menuSep.gif" width="1" height="10" align="middle"></td>
    	      <td nowrap <?php if ($this->_tpl_vars['page'] == "configuration.php"): ?>bgcolor="#FF6600"<?php else: ?>onMouseover="this.style.backgroundColor='#AAAAAA';" onMouseout="this.style.backgroundColor='#888888';"<?php endif; ?>><img alt="" src="includes/images/spacer.gif" width="15" height="1"><a href="<?php echo $this->_tpl_vars['urls']['configuration']; ?>
" class="<?php if ($this->_tpl_vars['page'] == "configuration.php"): ?>headerMenuActive<?php else: ?>headerMenu<?php endif; ?>"><?php echo @constant('LANG_HEADER_CONFIG'); ?>
</a><img alt="" src="includes/images/spacer.gif" width="15" height="1"></td>
          <?php endif; ?>
          
          <?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_CONTACT_CHANGE')) || $this->_tpl_vars['acl']->has_priv(@constant('PRIV_COMPANY_CHANGE'))): ?>
	          <td valign="bottom"><img alt="" src="includes/images/menuSep.gif" width="1" height="10" align="middle"></td>
    	      <td nowrap <?php if ($this->_tpl_vars['page'] == "clients.php"): ?>bgcolor="#FF6600"<?php else: ?>onMouseover="this.style.backgroundColor='#AAAAAA';" onMouseout="this.style.backgroundColor='#888888';"<?php endif; ?>><img alt="" src="includes/images/spacer.gif" width="15" height="1"><a href="<?php echo $this->_tpl_vars['urls']['clients']; ?>
" class="<?php if ($this->_tpl_vars['page'] == "clients.php"): ?>headerMenuActive<?php else: ?>headerMenu<?php endif; ?>"><?php echo @constant('LANG_HEADER_CONTACTS'); ?>
</a><img alt="" src="includes/images/spacer.gif" width="15" height="8"></td>
    	  <?php endif; ?>
          
          <?php if ($this->_tpl_vars['acl']->has_priv(@constant('PRIV_REPORTS'))): ?>
	    	  <td valign="bottom"><img alt="" src="includes/images/menuSep.gif" width="1" height="10" align="middle"></td>
    	      <td nowrap <?php if ($this->_tpl_vars['page'] == "reports.php"): ?>bgcolor="#FF6600"<?php else: ?>onMouseover="this.style.backgroundColor='#AAAAAA';" onMouseout="this.style.backgroundColor='#888888';"<?php endif; ?>><img alt="" src="includes/images/spacer.gif" width="15" height="8"><a href="<?php echo $this->_tpl_vars['urls']['reports']; ?>
" class="<?php if ($this->_tpl_vars['page'] == "reports.php"): ?>headerMenuActive<?php else: ?>headerMenu<?php endif; ?>"><?php echo @constant('LANG_HEADER_REPORTS'); ?>
</a><img alt="" src="includes/images/spacer.gif" width="15" height="8"></td>
    	  <?php endif; ?>
          
         <td valign="bottom"><img alt="" src="includes/images/menuSep.gif" width="1" height="10" align="middle"></td>
 	      <td nowrap <?php if ($this->_tpl_vars['page'] == "my_cerberus.php"): ?>bgcolor="#FF6600"<?php else: ?>onMouseover="this.style.backgroundColor='#AAAAAA';" onMouseout="this.style.backgroundColor='#888888';"<?php endif; ?>><img alt="" src="includes/images/spacer.gif" width="15" height="8"><a href="<?php echo $this->_tpl_vars['urls']['preferences']; ?>
" class="<?php if ($this->_tpl_vars['page'] == "my_cerberus.php"): ?>headerMenuActive<?php else: ?>headerMenu<?php endif; ?>"><?php echo $this->_run_mod_handler('lower', true, @constant('LANG_MYCERBERUS')); ?>
</a><img alt="" src="includes/images/spacer.gif" width="15" height="8"></td>
          
          <td valign="bottom"><img alt="" src="includes/images/menuSep.gif" width="1" height="10" align="middle"></td>
          <td><img alt="" src="includes/images/spacer.gif" width="1" height="20" align="middle"></td>
        </tr>
      </table>
    </td>
    <td width="1%" nowrap bgcolor="#666666" valign="bottom" align="right">
<table border="0" cellspacing="0" cellpadding="0" width="100%">
        <tr> 
          <td nowrap><img alt="" src="includes/images/spacer.gif" width="1" height="20" align="middle"></td>

          <?php if ($this->_tpl_vars['urls']['save_layout']): ?>  
          	<td nowrap><img alt="" src="includes/images/spacer.gif" width="15" height="8" align="middle"><a href="<?php echo $this->_tpl_vars['urls']['save_layout']; ?>
" class="headerMenu"><?php echo $this->_run_mod_handler('lower', true, @constant('LANG_HEADER_SAVE_PAGE_LAYOUT')); ?>
</a><img alt="" src="includes/images/spacer.gif" width="15" height="8"></td>
          <?php endif; ?>
          
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td colspan="2" bgcolor="#003399" class="headerMenu"><table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr> 
          <td bgcolor="#FF6600"><img alt="" src="includes/images/spacer.gif" width="1" height="5"></td>
        </tr>
      </table></td>
  </tr>
</table>