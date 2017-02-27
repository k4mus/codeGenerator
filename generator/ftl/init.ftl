<?php
/*
Plugin Name: Transportes
Description: ${titulo}
Version: 1
Author: ${autor}
Author URI: http://
*/
// function to create the DB / Options / Defaults					
function ${tableName}_options_install() {

    global $wpdb;
	
    $table_name = $wpdb->prefix ."${tableName}";
    $charset_collate = $wpdb->get_charset_collate();
    $sql = "
	DROP TABLE IF EXISTS `$table_name`;
	
	CREATE TABLE $table_name (
            `${indice.name}` MEDIUMINT NOT NULL AUTO_INCREMENT,
            <#list foraneas as for>
			`${for.name}` MEDIUMINT NOT NULL,
			</#list>
			<#list columnas as col>
            	`${col.name}` ${col.sqlType} CHARACTER SET utf8 NOT NULL ,
            </#list>
            PRIMARY KEY (`${indice.name}`),
            UNIQUE KEY `ix_` (`${unique}`)
          ) AUTO_INCREMENT=0 $charset_collate; ";

    require_once( ABSPATH . 'wp-admin/includes/upgrade.php' );
    dbDelta($sql);
}

// run the install scripts upon plugin activation
register_activation_hook(__FILE__, '${tableName}_options_install');

//menu items
add_action('admin_menu','${tableName}_modifymenu');

function ${tableName}_modifymenu() {
	
	//this is the main item for the menu
	add_submenu_page("menu_transportes",
	'${titulo}', //page title
	'${titulo}', //menu title
	'manage_options', //capabilities
	'${schema}_${tableName}_list', //menu slug
	'${schema}_${tableName}_list' //function
	);

	//this submenu is HIDDEN, however, we need to add it anyways
	add_submenu_page(null, //parent slug
	'Update ${titulo}', //page title
	'Update', //menu title
	'manage_options', //capability
	'${schema}_${tableName}_update', //menu slug
	'${schema}_${tableName}_update'); //function

	//this is a submenu
	add_submenu_page(null, //parent slug
	'New ${titulo}', //page title
	'New', //menu title
	'manage_options', //capability
	'${schema}_${tableName}_create', //menu slug
	'${schema}_${tableName}_create'); //function
	
}
define('ROOTDIR', plugin_dir_path(__FILE__));
require_once(ROOTDIR . '${schema}/${tableName}/${schema}_${tableName}_list.php');
require_once(ROOTDIR . '${schema}/${tableName}/${schema}_${tableName}_create.php');
require_once(ROOTDIR . '${schema}/${tableName}/${schema}_${tableName}_update.php');
