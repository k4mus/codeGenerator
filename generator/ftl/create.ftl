<?php

function ${schema}_${tableName}_create() {
	<#list foraneas as for>    
	$${for.name} = $_GET["${for.name}"];
	</#list>
	<#list columnas as col>
	$${col.name} = $_POST["${col.name}"];
	</#list>
	
	//volver
	<#list foraneas as for>
	if($${for.name}) $page_volver= "${schema}_${for.table}_update&${for.name}=".$${for.name};
	else
	</#list>
	$page_volver= "${schema}_${tableName}_list";
	 //insert
	global $wpdb;
	
	<#list columnas as col> 
	<#switch col.clase>
	  <#case "combobox">
	$rows_${col.table} = $wpdb->get_results("SELECT id_${col.table}, name_${col.table} from ".$wpdb->prefix ."${col.table}");  
		 <#break>
	  <#default>
	</#switch>
	</#list>
    if (isset($_POST['insert'])) {
		<#list foraneas as for>
		$${for.name}= $_POST["${for.name}"];
		</#list>
		
        
        $table_name = $wpdb->prefix ."${tableName}";

        $wpdb->insert(
                $table_name, //table
                array(<#list foraneas as for>'${for.name}'=>$${for.name} ,</#list> <#list columnas as col> '${col.name}' => $${col.name} <#if col_has_next>,</#if></#list> ), //data
                array('%s', '%s') //data format	 		
        );
        $message.="${titulo} inserted";
    }
    ?>
    <link type="text/css" href="<?php echo WP_PLUGIN_URL; ?>/${plugin}/style-admin.css" rel="stylesheet" />
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">
	<script src="//code.jquery.com/jquery-1.12.4.js"></script>
	<script src="//code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	<script src="<?php echo WP_PLUGIN_URL; ?>/transportes-plugin/js/combobox.js"></script>
    
    <div class="wrap">
        <h2>Add New ${titulo}</h2>
        <?php if (isset($message)): ?><div class="updated"><p><?php echo $message; ?></p></div><?php endif; ?>
        <form method="post" action="<?php echo $_SERVER['REQUEST_URI']; ?>">
            <p> </p>
            <table class='wp-list-table widefat fixed'>
				<#list foraneas as for>
				<tr>
                    <th class="ss-th-width">${for.alias}</th>
                    <td><input type="text" name="${for.name}" value="<?php echo $${for.name}; ?>" <?php if ($${for.name}) echo readonly  ?> class="ss-field-width " /></td>
                </tr>
				</#list>
				<#list columnas as col>
				<tr>
                    <th class="ss-th-width">${col.alias}</th>
                    <#switch col.clase>
						<#case "combobox">
					<td><select type="text" id= "${col.name}" name="${col.name}" value="<?php echo $${col.name}; ?>  " class="${col.clase}">
						<option value="">Select one...</option>
						<?php foreach ($rows_${col.table} as $row_${col.table}) { ?>
						<option value="<?php echo $row_${col.table}->id_${col.table}; ?>"><?php echo $row_${col.table}->name_${col.table}; ?></option>
						<?php } ?>
						</select>
					</td>
						<#break>
						<#case "radio">
					<td>
						<#list col.opcion as op>
						<input type="radio" name="${col.name}" value="${op}"/>${op}
						</#list>
					</td>
						<#break>
						<#default>
					<td><input type="text" name="${col.name}" value="<?php echo $${col.name}; ?>" class="ss-field-width ${col.clase}" /></td>
					</#switch>
                </tr>
				</#list>
            </table>
            <input type='submit' name="insert" value='Save' class='button'>
        </form>
		<a href="<?php echo admin_url('admin.php?page='.$page_volver) ?>">&laquo; Volver</a>
    </div>
	<#assign icont = 2/> 
	<#list tabs as tab>	
	<div id="tabs-${icont}">
		<?php	${tab.fun};?>
	</div>
	<#assign icont = icont+1/> 
	</#list>
	
    <script>
		$( ".datetime" ).datepicker();
		$( ".int" ).spinner();
		
	</script>
    <?php
}