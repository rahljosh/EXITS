<?php /* Smarty version 2.5.0, created on 2007-01-15 18:59:10
         compiled from display/boxes/box_requesters.tpl.php */ ?>
<form action="#" name="frmRequesterAdd" id="frmRequesterAdd" style="margin:0px;" onsubmit="return false;">
<div id="divTicketRequesters"></div>
</form>
<script type="text/javascript">
	YAHOO.util.Event.addListener(document.body,"load",getRequesters(<?php echo $this->_tpl_vars['wsticket']->id; ?>
));
</script>