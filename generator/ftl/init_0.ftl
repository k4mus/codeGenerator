<?php
/*
Plugin Name: Transportes
*/
// function to create the DB / Options / Defaults					

// run the install scripts upon plugin activation
<#list tablas as tab>
register_activation_hook(__FILE__, '${tab.tableName}_options_install');
</#list>
// run the install scripts upon plugin activation

//menu items
add_action('admin_menu','trans_modifymenu');
function trans_modifymenu() {
	
	//this is the main item for the menu
	add_menu_page('Transportes', //page title
	'Men&uacute; Transportes', //menu title
	'manage_options', //capabilities
	'menu_transportes', //menu slug
	'' //function
	);
}
define('ROOTDIR', plugin_dir_path(__FILE__));
<#list tablas as tab>
require_once(ROOTDIR . '${tab.schema}/${tab.tableName}/${tab.schema}_${tab.tableName}_init.php');
</#list>


