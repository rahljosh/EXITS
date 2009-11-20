<?php /* Smarty version 2.5.0, created on 2007-01-15 11:11:31
         compiled from home/whos_online_box.tpl.php */ ?>
<span class="link_ticket"><?php echo @constant('LANG_FOOTER_WHOS_ONLINE'); ?>
: (<?php echo $this->_tpl_vars['cer_who']->who_user_count_string; ?>
)</span><br>
<table width="100%" border="0" cellspacing="0" cellpadding="0"><tr><td bgcolor="#DDDDDD"><img src="includes/images/spacer.gif" alt="" width="1" height="1" /></td></tr></table>

<?php if (isset($this->_sections['who_id'])) unset($this->_sections['who_id']);
$this->_sections['who_id']['name'] = 'who_id';
$this->_sections['who_id']['loop'] = is_array($this->_tpl_vars['cer_who']->who_users) ? count($this->_tpl_vars['cer_who']->who_users) : max(0, (int)$this->_tpl_vars['cer_who']->who_users);
$this->_sections['who_id']['show'] = true;
$this->_sections['who_id']['max'] = $this->_sections['who_id']['loop'];
$this->_sections['who_id']['step'] = 1;
$this->_sections['who_id']['start'] = $this->_sections['who_id']['step'] > 0 ? 0 : $this->_sections['who_id']['loop']-1;
if ($this->_sections['who_id']['show']) {
    $this->_sections['who_id']['total'] = $this->_sections['who_id']['loop'];
    if ($this->_sections['who_id']['total'] == 0)
        $this->_sections['who_id']['show'] = false;
} else
    $this->_sections['who_id']['total'] = 0;
if ($this->_sections['who_id']['show']):

            for ($this->_sections['who_id']['index'] = $this->_sections['who_id']['start'], $this->_sections['who_id']['iteration'] = 1;
                 $this->_sections['who_id']['iteration'] <= $this->_sections['who_id']['total'];
                 $this->_sections['who_id']['index'] += $this->_sections['who_id']['step'], $this->_sections['who_id']['iteration']++):
$this->_sections['who_id']['rownum'] = $this->_sections['who_id']['iteration'];
$this->_sections['who_id']['index_prev'] = $this->_sections['who_id']['index'] - $this->_sections['who_id']['step'];
$this->_sections['who_id']['index_next'] = $this->_sections['who_id']['index'] + $this->_sections['who_id']['step'];
$this->_sections['who_id']['first']      = ($this->_sections['who_id']['iteration'] == 1);
$this->_sections['who_id']['last']       = ($this->_sections['who_id']['iteration'] == $this->_sections['who_id']['total']);
?>
 	<span class="cer_whos_online_text">
 	<?php if (! empty ( $this->_tpl_vars['cer_who']->who_users[$this->_sections['who_id']['index']]->user_name )): ?>
 		<b><?php echo $this->_tpl_vars['cer_who']->who_users[$this->_sections['who_id']['index']]->user_name; ?>
</b>
 	<?php endif; ?>
 	<?php if (! empty ( $this->_tpl_vars['cer_who']->who_users[$this->_sections['who_id']['index']]->user_login )): ?>
 		(<?php echo $this->_tpl_vars['cer_who']->who_users[$this->_sections['who_id']['index']]->user_login; ?>
)
 	<?php endif; ?>
 	<?php echo $this->_tpl_vars['cer_who']->who_users[$this->_sections['who_id']['index']]->user_action_string; ?>
 
 	(ip: <?php echo $this->_tpl_vars['cer_who']->who_users[$this->_sections['who_id']['index']]->user_ip; ?>
 
 	idle: <?php echo $this->_tpl_vars['cer_who']->who_users[$this->_sections['who_id']['index']]->user_idle_secs; ?>
) 
 	<?php if ($this->_tpl_vars['cer_who']->who_users[$this->_sections['who_id']['index']]->user_pm_url != ""): ?>
 		(<a href="<?php echo $this->_tpl_vars['cer_who']->who_users[$this->_sections['who_id']['index']]->user_pm_url; ?>
" class="cer_whos_online_text"><?php echo @constant('LANG_FOOTER_SEND_PM'); ?>
</a>)
 	<?php endif; ?>
 	</span>
 	<br>
<?php endfor; endif; ?>