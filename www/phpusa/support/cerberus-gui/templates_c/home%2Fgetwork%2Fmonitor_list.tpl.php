<?php /* Smarty version 2.5.0, created on 2007-01-19 08:28:58
         compiled from home/getwork/monitor_list.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('modifier', 'cat', 'home/getwork/monitor_list.tpl.php', 22, false),
array('modifier', 'cer_href', 'home/getwork/monitor_list.tpl.php', 22, false),
array('modifier', 'htmlentities', 'home/getwork/monitor_list.tpl.php', 22, false),
array('modifier', 'date_format', 'home/getwork/monitor_list.tpl.php', 27, false),)); ?><?php if (count ( $this->_tpl_vars['tickets'] )): ?>
<?php if (isset($this->_foreach['tickets'])) unset($this->_foreach['tickets']);
$this->_foreach['tickets']['name'] = 'tickets';
$this->_foreach['tickets']['total'] = count((array)$this->_tpl_vars['tickets']);
$this->_foreach['tickets']['show'] = $this->_foreach['tickets']['total'] > 0;
if ($this->_foreach['tickets']['show']):
$this->_foreach['tickets']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['tickets'] as $this->_tpl_vars['ticket']):
        $this->_foreach['tickets']['iteration']++;
        $this->_foreach['tickets']['first'] = ($this->_foreach['tickets']['iteration'] == 1);
        $this->_foreach['tickets']['last']  = ($this->_foreach['tickets']['iteration'] == $this->_foreach['tickets']['total']);
?>
<div id="getwork<?php echo $this->_tpl_vars['ticket']->id; ?>
">
<table width="100%" border="0" cellpadding="1" cellspacing="0">
   <tr>
     <td width="0%" nowrap rowspan="2" valign="top">
	     <?php if ($this->_tpl_vars['ticket']->priority <= 0): ?>
		     	<img src="includes/images/spacer.gif" alt="*" width="16" height="16" align="middle" title="None" alt="No Priority" />
	     <?php elseif ($this->_tpl_vars['ticket']->priority <= 25): ?>
		     	<img src="includes/images/icone/16x16/star_grey.gif" alt="*" width="16" height="16" align="middle"  title="Lowest" alt="Lowest Priority" />
	     <?php elseif ($this->_tpl_vars['ticket']->priority <= 50): ?>
		     	<img src="includes/images/icone/16x16/star_blue.gif" alt="*" width="16" height="16" align="middle" title="Low" alt="Low Priority" />
	     <?php elseif ($this->_tpl_vars['ticket']->priority <= 75): ?>
		     	<img src="includes/images/icone/16x16/star_green.gif" alt="*" width="16" height="16" align="middle" title="Moderate" alt="Moderate Priority" />
	     <?php elseif ($this->_tpl_vars['ticket']->priority <= 90): ?>
		     	<img src="includes/images/icone/16x16/star_yellow.gif" alt="*" width="16" height="16" align="middle" title="High" alt="High Priority" />
	     <?php else: ?>
		     	<img src="includes/images/icone/16x16/star_red.gif" alt="*" width="16" height="16" align="middle" title="Highest" alt="Highest Priority" />
	     <?php endif; ?>
     </td>
     <td width="100%" style="background-color:#fff">
     	<a href="<?php echo $this->_run_mod_handler('cer_href', true, $this->_run_mod_handler('cat', true, "display.php?ticket=", $this->_tpl_vars['ticket']->id)); ?>
" class="text_ticket_subject"><?php echo $this->_run_mod_handler('htmlentities', true, $this->_tpl_vars['ticket']->subject); ?>
</a> <span class="box_text">#<?php echo $this->_tpl_vars['ticket']->mask; ?>
</span>
     </td>
   </tr>
   <tr>
     <td style="background-color:#fff">
     <span class="box_text"><?php echo $this->_run_mod_handler('date_format', true, $this->_tpl_vars['ticket']->action_timestamp, "%d-%b-%y %I:%M%p"); ?>
:</span> <?php echo $this->_tpl_vars['ticket']->action; ?>

     </td>
   </tr>
   <tr>
     <td colspan="2"><table cellpadding="0" cellspacing="0" border="0" width="100%"><tr><td bgcolor="#eeeeee"><img src="includes/images/spacer.gif" width="1" height="1" alt=""></td></tr></table></td>
   </tr>
</table>
</div>
<?php endforeach; endif; ?>
<?php endif; ?>