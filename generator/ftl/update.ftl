<?php

function ${schema}_${tableName}_update() {
    global $wpdb;
    $table_name = $wpdb->prefix ."${tableName}";
    $${indice.name} = $_GET["${indice.name}"];
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
	
	<#list columnas as col> 
	<#switch col.clase>
		<#case "combobox">
	$rows_${col.table} = $wpdb->get_results("SELECT id_${col.table}, name_${col.table} from ".$wpdb->prefix ."${col.table}");  
		 <#break>
	  <#default>
	</#switch>
	</#list>
	
	<#list foraneas as for>
	$rows_${for.table} = $wpdb->get_results("SELECT id_${for.table}, name_${for.table} from ".$wpdb->prefix ."${for.table}");  
	</#list>
//update
    if (isset($_POST['update'])){
		<#list foraneas as for>
		$${for.name}= $_POST["${for.name}"];
		</#list>
		
        $wpdb->update(
                $table_name, //table
				array(<#list foraneas as for> '${for.name}' => $${for.name} ,</#list> <#list columnas as col> '${col.name}' => $${col.name}<#if col_has_next>,</#if></#list>), //data
                array('${indice.name}' => $${indice.name} ), //where
				array(<#list columnas as col>'%s'<#if col_has_next>,</#if></#list>), //data format
                array('%s') //where format
        );
    }
//delete
    else if (isset($_POST['delete'])) {
        $wpdb->query($wpdb->prepare("DELETE FROM $table_name WHERE ${indice.name} = %s", $${indice.name}));
    } else {//selecting value to update	
        $results = $wpdb->get_results($wpdb->prepare("SELECT ${indice.name} <#list foraneas as for> ,${for.name} </#list>,<#list columnas as col> ${col.name} <#if col_has_next>,</#if></#list> from $table_name where ${indice.name}=%s", $${indice.name}));
        foreach ($results as $r) {
            $${indice.name} = $r->${indice.name};
            <#list foraneas as for> 
			$${for.name} = $r->${for.name};
			</#list>			
			<#list columnas as col> 
			$${col.name} = $r->${col.name};
			</#list>			
        }
    }
    ?>
    
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/free-jqgrid/4.13.6/css/ui.jqgrid.min.css">
	<link type="text/css" href="<?php echo WP_PLUGIN_URL; ?>/${plugin}/style-admin.css" rel="stylesheet" />
	<script src="//code.jquery.com/jquery-1.12.4.js"></script>
	<script src="//code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/free-jqgrid/4.13.6/js/jquery.jqgrid.min.js"></script>
	<script src="<?php echo WP_PLUGIN_URL; ?>/${plugin}/js/combobox.js"></script>
    <div class="wrap">
        <h2></h2>

        <?php if ($_POST['delete']) { ?>
            <div class="updated"><p>${titulo} deleted</p></div>
        
        <?php } else if ($_POST['update']) { ?>
            <div class="updated"><p>${titulo} updated</p></div>
        
        <?php } else { ?>
		
		<div id="tabs">
		  <ul>
			<li><a href="#tabs-1">${titulo}</a></li>
			<#assign icont = 2/> 
			<#list tabs as tab>
			<li><a href="#tabs-${icont}" name=${tab.name}>${tab.titulo}</a></li>
			<#assign icont = icont+1/> 
			</#list>
		  </ul>
		  <div id="tabs-1">
			<form method="post" action="<?php echo $_SERVER['REQUEST_URI']; ?>">
                <table class='wp-list-table widefat fixed' id="tabla">
                    <tr>
						<th>${indice.alias}</th>
						<td><input type="text" name="${indice.name}" value="<?php echo $${indice.name}; ?>" disabled /></td>
					</tr>
					<#list foraneas as for>
					<tr>
						<th>${for.alias}</th>
						<td><select type="text" id= "${for.name}" name="${for.name}" value="<?php echo $${for.name}; ?>" <?php if ($${for.name}) echo readonly  ?> class="combobox">
							<option value="">Select one...</option>
							<?php foreach ($rows_${for.table} as $row_${for.table}) { ?>
							<option value="<?php echo $row_${for.table}->id_${for.table}; ?>"><?php if ($${for.name})echo $row_${for.table}->name_${for.table};  else $row_${for.table}->id_${for.table}; ?></option>
							<?php } ?>
							</select>
						</td>
					</tr>
					</#list>
                    
					<#list columnas as col>
					<th class="ss-th-width">${col.alias}</th> 
					<#switch col.clase>
						<#case "combobox">
					<td><select type="text" id= "${col.name}" name="${col.name}" value="<?php echo $${col.name}; ?>  " class="${col.clase}">
						<option value="">Select one...</option>
						<?php foreach ($rows_${col.table} as $row_${col.table}) { ?>
						<option value="<?php echo $row_${col.table}->id_${col.table}; ?>"><?php if ($${col.name})echo $row_${col.table}->name_${col.table};  else $row_${col.table}->id_${col.table}; ?></option>
						<?php } ?>
						</select>
					</td>
						<#break>
						<#case "radio">
					<td>
						<#list col.opcion as op>
						<input type="radio" name="${col.name}" value="${op}" <?php if ($${col.name}=="${op}") echo 'checked' ?> />${op}
						</#list>
					</td>
						<#break>
						<#default>
					<td><input type="text" name="${col.name}" value="<?php echo $${col.name}; ?>" class="ss-field-width ${col.clase}" /></td>
					</#switch>
					</tr>
					</#list>
                </table>
				<div id='pager'></div>
                <input type='submit' name="update" value='Save' class='button'> &nbsp;&nbsp;
                <input type='submit' name="delete" value='Delete' class='button' onclick="return confirm('&iquest;Est&aacute;s seguro de borrar este elemento?')">
            </form>
		</div>
		<#assign icont = 2/> 
		<#list tabs as tab>	
		<div id="tabs-${icont}">
			<?php	${tab.fun};?>
		</div>
		<#assign icont = icont+1/> 
		</#list>
        <?php } ?>
			<a href="<?php echo admin_url('admin.php?page='.$page_volver) ?>">&laquo; Volver</a>
			
    </div>
    <script>
		$( ".fecha" ).datepicker();
		$( "#tabs" ).tabs();
		$('.combobox').each( function( index, element ){
			$("option[value="+$(this).attr("value")+"]", this).attr('selected','selected');
		});
		$( ".numero" ).spinner();
		
	</script>
    <?php
}