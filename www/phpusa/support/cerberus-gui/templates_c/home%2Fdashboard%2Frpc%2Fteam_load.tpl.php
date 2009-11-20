<?php /* Smarty version 2.5.0, created on 2007-01-15 11:11:30
         compiled from home/dashboard/rpc/team_load.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('function', 'math', 'home/dashboard/rpc/team_load.tpl.php', 15, false),
array('function', 'assign', 'home/dashboard/rpc/team_load.tpl.php', 18, false),
array('modifier', 'cat', 'home/dashboard/rpc/team_load.tpl.php', 22, false),
array('modifier', 'cer_href', 'home/dashboard/rpc/team_load.tpl.php', 22, false),)); ?><?php if (is_array ( $this->_tpl_vars['dashboard_teams'] ) && ! empty ( $this->_tpl_vars['dashboard_teams'] )): ?>
<table border="0" cellpadding="0" cellspacing="0" class="table_orange" width="100%">
   <tr>
     <td class="bg_orange"><table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr>
           <td nowrap="nowrap"><span class="text_title_white"><img src="includes/images/icone/16x16/businessmen.gif" alt="A tag" width="16" height="16" /> Team Loads </span></td>
         </tr>
     </table></td>
   </tr>
   <tr>
     <td bgcolor="#F0F0FF"><span class="box_text">
			<table border="0" cellspacing="1" cellpadding="2" bgcolor="#FFFFFF" width="100%">
				<?php if (isset($this->_foreach['teams'])) unset($this->_foreach['teams']);
$this->_foreach['teams']['name'] = 'teams';
$this->_foreach['teams']['total'] = count((array)$this->_tpl_vars['dashboard_teams']);
$this->_foreach['teams']['show'] = $this->_foreach['teams']['total'] > 0;
if ($this->_foreach['teams']['show']):
$this->_foreach['teams']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['dashboard_teams'] as $this->_tpl_vars['teamId'] => $this->_tpl_vars['team']):
        $this->_foreach['teams']['iteration']++;
        $this->_foreach['teams']['first'] = ($this->_foreach['teams']['iteration'] == 1);
        $this->_foreach['teams']['last']  = ($this->_foreach['teams']['iteration'] == $this->_foreach['teams']['total']);
?>
					<?php if ($this->_tpl_vars['total_team_hits']): ?>
						<?php echo $this->_plugins['function']['math'][0](array('assign' => 'percent','equation' => "(x/y)*50",'x' => $this->_tpl_vars['team']->workload_hits,'y' => $this->_tpl_vars['total_team_hits'],'format' => "%0.0f"), $this) ; ?>

						<?php echo $this->_plugins['function']['math'][0](array('assign' => 'percenti','equation' => "50-x",'x' => $this->_tpl_vars['percent'],'format' => "%0.0f"), $this) ; ?>

					<?php else: ?>
						<?php echo $this->_plugins['function']['assign'][0](array('var' => 'percent','value' => '1'), $this) ; ?>

						<?php echo $this->_plugins['function']['assign'][0](array('var' => 'percenti','value' => '49'), $this) ; ?>

					<?php endif; ?>
				   <tr>
				     <td bgcolor="#F0F0FF" width="100%" align="left" nowrap="nowrap"><a href="<?php echo $this->_run_mod_handler('cat', true, $this->_run_mod_handler('cer_href', true, $this->_run_mod_handler('cat', true, "ticket_list.php?override=t", $this->_tpl_vars['teamId'])), "#results"); ?>
" class="text_ticket_links"><b><?php echo $this->_tpl_vars['team']->name; ?>
</b></a> <span class="cer_footer_text" title="Available Active Tickets">(<?php echo $this->_tpl_vars['team']->workload_hits; ?>
)</span></td>
	              <td bgcolor="#DDDDDD" width="0%" align="left" nowrap="nowrap"><img src="includes/images/cerb_graph.gif" width="<?php echo $this->_tpl_vars['percent']; ?>
" height="15" /><img src="includes/images/cer_graph_cap.gif" /><img src="includes/images/spacer.gif" width="<?php echo $this->_tpl_vars['percenti']; ?>
" height="1"></td>
					</tr>
				<?php endforeach; endif; ?>
		   </table>
		</td>
	</tr>
</table>
<br>
<?php endif; ?>