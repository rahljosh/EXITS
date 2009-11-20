<?php
/***********************************************************************
| Cerberus Helpdesk (tm) developed by WebGroup Media, LLC.
|-----------------------------------------------------------------------
| All source code & content (c) Copyright 2005, WebGroup Media LLC
|   unless specifically noted otherwise.
|
| This source code is released under the Cerberus Public License.
| The latest version of this license can be found here:
| http://www.cerberusweb.com/license.php
|
| By using this software, you acknowledge having read this license
| and agree to be bound thereby.
|
| Developers involved with this file:
|		Mike Fogg			(mike@webgroupmedia.com)		[mdf]
| ______________________________________________________________________
|	http://www.cerberusweb.com	  http://www.webgroupmedia.com/
***********************************************************************/

require_once(FILESYSTEM_PATH . "cerberus-api/xml/xml.class.php");
require_once(FILESYSTEM_PATH . "gateway-api/classes/general/users.class.php");
include_once(FILESYSTEM_PATH . "cerberus-api/workstation/CerWorkstationTeams.class.php");
include_once(FILESYSTEM_PATH . "cerberus-api/workstation/CerWorkstationTickets.class.php");

if(!defined('VALID_INCLUDE') || VALID_INCLUDE != 1) exit();

/**
 * This class handles getting a list of teams
 *
 */
class get_team_loads_handler extends xml_parser
{
   /**
    * XML data packet from client GUI
    *
    * @var object
    */
   var $xml;


   /**
    * Class constructor
    *
    * @param object $xml
    * @return get_list_handler
    */
   function get_team_loads_handler(&$xml) {
      $this->xml =& $xml;
   }

   /**
    * main() function for this class. 
    *
    */
   function process() {
      $users_obj =& new general_users();
      if($users_obj->check_login() === FALSE) {
         xml_output::error(0, 'Not logged in. Please login before proceeding!');
      }

      	$cerTeams = CerWorkstationTeams::getInstance(); /* @var $cerTeams CerWorkstationTeams */		
		$teams = $cerTeams->getTeams();
		//$cerTickets = new CerWorkstationTickets();

		
//		$acl = CerACL::getInstance();
////		if($acl->has_priv(PRIV_VIEW_UNASSIGNED,BITGROUP_1)) {
//			$numUnassigned = $cerTickets->getUnassignedTicketsCount();
//			$tagsUnassigned = CerWorkstationTickets::getUnassignedTags();
////		}
////		else {
////			$tagsUnassigned = NULL;//don't show unassigned tickets if the user doesn't have the privilege
////		}

		$user_id = general_users::get_user_id();
		
		$xml =& xml_output::get_instance();
		$data =& $xml->get_child("data", 0);
		
		$teams_elm =& $data->add_child("teams", xml_object::create("teams"));
		if(is_array($teams)) 
		foreach($teams AS $teamId=>$team) {
			if (isset($team->agents[$user_id])) {
				//print_r($team);exit();
				$team_elm =& $teams_elm->add_child("team", xml_object::create("team", NULL, array("id"=>$teamId)));
				$team_elm->add_child("name", xml_object::create("name", $team->name));
				$team_elm->add_child("workload_hits", xml_object::create("workload_hits", $team->workload_hits));
				$tags_elm =& $team_elm->add_child("tags", xml_object::create("tags"));
				
//				if (is_array($team->tags)) {
//					foreach ($team->tags AS $tagId=>$tag) {
//						//print_r($tag);exit();
//						$tag_elm =& $tags_elm->add_child("tag", xml_object::create("tag", NULL, array("id"=>$tagId)));
//						$tag_elm->add_child("name", xml_object::create("name", $tag->name));
//						$tag_elm->add_child("hits", xml_object::create("hits", $tag->hits));
//					}
//				}
			}
		}

		if(is_array($tagsUnassigned)) {
			$team_elm =& $teams_elm->add_child("team", xml_object::create("team", NULL, array("id"=>0)));
			$team_elm->add_child("name", xml_object::create("name", "Unassigned"));
			$team_elm->add_child("workload_hits", xml_object::create("workload_hits", $numUnassigned));
			$tags_elm =& $team_elm->add_child("tags", xml_object::create("tags"));					
			foreach ($tagsUnassigned AS $tagId=>$tag) {
				$tag_elm =& $tags_elm->add_child("tag", xml_object::create("tag", NULL, array("id"=>$tagId)));
				$tag_elm->add_child("name", xml_object::create("name", $tag->name));
				$tag_elm->add_child("hits", xml_object::create("hits", $tag->hits));
			}
		}

		xml_output::success();

   }
   
   function output_xml() {
   		
   	
   }
}