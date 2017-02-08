<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp "&#160;">
<!ENTITY bull "&#8226;">
<!ENTITY deg "&#176;">
<!ENTITY copy "&#169;">
<!ENTITY reg "&#174;">
<!ENTITY trade "&#8482;">
<!ENTITY mdash "&#8212;">
<!ENTITY ldquo "&#8220;">
<!ENTITY rdquo "&#8221;">
<!ENTITY pound "&#163;">
<!ENTITY yen "&#165;">
<!ENTITY euro "&#8364;">
<!ENTITY aacute "&#225;">
<!ENTITY Aacute "&#193;">
<!ENTITY eacute "&#233;">
<!ENTITY Eacute "&#201;">
<!ENTITY iacute "&#237;">
<!ENTITY Iacute "&#205;">
<!ENTITY oacute "&#243;">
<!ENTITY Oacute "&#211;">
<!ENTITY uacute "&#250;">
<!ENTITY Uacute "&#218;">
<!ENTITY ntilde "&#241;">
<!ENTITY Ntilde "&#209;">
<!ENTITY iquest "&#191;">
<!ENTITY br "<xsl:text disable-output-escaping='yes'>&lt;br&gt;</xsl:text>">
]>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:bnsc="http://whatever" xmlns:portal="http://whatever" >
    <xsl:decimal-format name="chilean" decimal-separator="," grouping-separator="."/>
    <xsl:output method="html" encoding="iso-8859-1" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
    <xsl:decimal-format name="rut_cl" decimal-separator="," grouping-separator="."/>
    <xsl:include href="{xsl_url}/import.xsl"/>
    <xsl:include href="{xsl_url}/funciones-regionalizacion.xsl"/>

    <xsl:template match="/documento">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                <title>Listar Usuarios</title>

                <link type="text/css" rel="stylesheet" href="/css/estilos.css"/>
                <link type="text/css" rel="stylesheet" href="/css/ui-lightness/jquery-ui-1.10.3.custom.css"/>
            
                <script language="javascript" type="text/javascript" src="/js/funciones.js"/>
                <script language="javascript" type="text/javascript" src="/js/jquery-1.9.1.js"/>
                <script language="javascript" type="text/javascript" src="/js/jquery-ui-1.10.3.custom.js"/>
                <script language="javascript" type="text/javascript" src="/js/dialog_messages_eftgroup.js"/>

                <script language="javascript" type="text/javascript">
                    function limpiar(){
                        document.formulario.doc_usr_emp.value="";
                        document.formulario.nom_usr_emp.value="";
                        <xsl:if test="/documento/header/sesion/esHoldingUsuarioEmpresa != 'false' and count(/documento/body/data/row/empresas/data/@count) != 0" >              
                            document.formulario.id_emp.selectedIndex=0;
                        </xsl:if>   
                        <xsl:if test="body/data/row/tiposdocumentos/data/@count &gt; 1">
                            document.formulario.id_tpo_doc.selectedIndex=0; 
                        </xsl:if>   
                        document.formulario.id_srv.selectedIndex=0;
                    }
            
                    function agregar(){
                        var idEmp = $("[name=id_emp]").val();
                        if(idEmp &lt;= 0){
                            msgError = "Favor seleccione una empresa para agregar el usuario.";
                            showAlertDialog("Creaci&oacute;n de Usuario", "Informaci&oacute;n", msgError, "", null, "Aceptar");
                            return;
                        }
                        document.formulario.action='UsrAdd';
                        document.formulario.accion.value = '';
                        document.formulario.submit();
                    }
            
                    function eliminar(){
                        var checkIdUsrEmp = false;
                        $("input[name='id_usr_emp']").each(function(){
                            var boo = $(this).prop("checked");
                            if(boo){
                                checkIdUsrEmp = true;
                            }
                        });
                        if(checkIdUsrEmp){
                            if(confirm('\u00BFEst\u00E1 seguro de eliminar el usuario seleccionado\u003F')){
                                document.formulario.action='UsrLst';
                                document.formulario.accion.value = 'eliminar';
                                document.formulario.submit();
                            }
                        }else{
                            msgError = "Por favor seleccione un usuario.";
                            showAlertDialog("Eliminaci&oacute;n de Usuario", "Advertencia", msgError, "", null, "Aceptar");
                        }
                    }
            
                    function buscar(param){
                        <xsl:if test="body/data/row/tiposdocumentos/data/row/dsc_tpo_doc = 'Rut'" >
                            
                            var rut = document.formulario.doc_usr_emp.value;
                            rut = rut.replace(/[.-]/gi,"");
                            document.formulario.doc_usr_emp.value = rut;
                        </xsl:if>
                        if(isText(document.formulario.doc_usr_emp,'Documento',true,false,true) &amp;&amp; isText(document.formulario.nom_usr_emp,'Nombre de Usuario',true,false,true)){
                            if(param=='buscar'){
                                document.formulario.pagina.value = "1";
                                document.formulario.action = "UsrLst";
                                document.formulario.accion.value = "buscar";
                            }else if(param=='excel'){
                                document.formulario.pagina.value = "";
                            //    document.formulario.action = "UsrLstExcel";
                                document.formulario.action = "/module/CoreAdmUsr/UsrLstExcel";
                            }else if(param=='pdf'){
                                document.formulario.pagina.value = "";
                                document.formulario.action = "/module/CoreAdmUsr/UsrLstPdf";
                            console.log(document.formulario.doc_usr_emp.value);
                            }

                            document.formulario.submit();

                            document.formulario.pagina.value = "1";
                            document.formulario.action = "UsrLst";
                        }
                    }
            
                    function editar(id, idEmpr){
                        $("input[name='id_usr_emp'][value="+id+"]").prop("checked", true);
                        document.formulario.action = "UsrUpd";
                        document.formulario.id_emp.value = idEmpr;
                        document.formulario.accion.value = 'view';
                        document.formulario.submit();
                    }
            
                    function msgErrors(coderror){
                        var msgError = "";
                        switch(coderror){
                            case "1":
                                msgError = "Se ha eliminado exitosamente el usuario.";
                                showAlertDialog("Eliminaci&oacute;n de Usuario", "Informaci&oacute;n", msgError, "", null, "Aceptar");
                                break;
                            case "2":
                                msgError = "Se ha creado la autorizaci\u00F3n "+'<xsl:value-of select="body/data/row/autorizacion/data/row/idaut"/>'+" para la eliminaci\u00F3n del usuario.&lt;br/&gt;Los cambios se ver\u00E1n reflejados al momento de ser autorizada.";
                                showAlertDialog("Eliminaci&oacute;n de Usuario", "Informaci&oacute;n", msgError, "", null, "Aceptar");
                                break;
                            case "-1":
                                msgError = "No se puede eliminar un usario con perfil de tipo est&aacute;ndar.";
                                showAlertDialog("Eliminaci&oacute;n de Usuario", "Error", msgError, "", null, "Aceptar");
                                break;
                            default:
                                msgError = "Error al tratar de eliminar el usuario, intente nuevamente.";
                                showAlertDialog("Eliminaci&oacute;n de Usuario", "Error", msgError, "", null, "Aceptar");
                                break;
                        }
                    }
            
                    $(document).ready(function(){
                        var coderror = '<xsl:value-of select="body/data/row/errors/data/row/coderror"/>';
                        var accion = '<xsl:value-of select="header/parametros/accion"/>';
                        if(accion == 'eliminar'){
                            msgErrors(coderror);
                        }
                       showFiltro();
                        
                    });
                </script>
            </head>
            <body class="bodycenter">
                <IFRAME src="{header/contexto}/updSession" frameborder="no" style="display:none; width:1px; height: 1px;"/>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td class="titulo">Listar Usuarios</td> <!-- Administraci&oacute;n de Usuarios -->
                    </tr>
                    <tr>
                        <td class="subtitulo">Consulta y Mantenimiento de Usuarios</td> <!-- Consulta y Mantenimiento de Usuarios -->
                    </tr>
                </table>
                <table border="0" cellpadding="0" cellspacing="0" class="central-obs1">
					<tr>
						<td> [descripcion funcion ]: <b>limpiar</b></td>
					</tr>
					
                </table>
                <xsl:sequence select="portal:xsl-editor(header/sesion/editorMode, header/sesion/urlXslEditor, header/pagina/@id, header/parametros/sessionid, header/pagina/@bloqueada)"/>
                <form name="formulario" action="UsrLst" method="post">
                    <input type="hidden" name="sessionid" value="{header/parametros/sessionid}"/>
                    <input type="hidden" name="accion" value="buscar"/>
                    <input type="hidden" name="pagina" value="{/documento/header/parametros/pagina}"/>
                    <input type="hidden" name="can_per_pag" value="{/documento/header/sesion/registrosPorPagina}"/>             
                    <input type="hidden" name="isGestionEmpresas" value="false"/>
					    <input type="hidden" name="id_id_cliente" value=""/>
					    <input type="hidden" name="id_fecha" value=""/>
                                        
                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                        <tr>
                            <td>
                                <table cellpadding="0" cellspacing="0" border="0" align="right">
                                    <tr>
                                        <td width="16">
                                            <div id="arrowFiltro" class="btn_arrowdown"/>
                                        </td>
                                        <td class="filtro_txtlink" onclick="showFiltro();">Filtros de b&uacute;squeda</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <div id="contenedor_filtros" style="display:none;">
                        <table class="tableborder" cellpadding="0" cellspacing="0">
                            <xsl:choose>                                
                                <xsl:when test="body/data/row/empresas/data/@count &gt; 1">
                                    <tr>    
                                        <!-- input type="hidden" name="id_emp" value="" / -->   
                                        <td class="hdr-i" width="250">Empresa:</td>
                                        <td class="td-t0">
                                            <select name="id_emp">
                                                <option value="-{/documento/header/sesion/idEmpresa}">Todos</option>
                                                <xsl:for-each select="body/data/row/empresas/data/row">
                                                    <option value="{id_emp}">
                                                        <xsl:if test="id_emp = /documento/header/parametros/id_emp">
                                                            <xsl:attribute name="selected">selected</xsl:attribute>
                                                        </xsl:if>
                                                        <xsl:value-of select="raz_soc_emp" />
                                                    </option>
                                                </xsl:for-each>
                                            </select>
                                        </td>
                                        <xsl:if test="/documento/header/sesion/idCliente=209">
                                            <td class="hdr-i" width="25%">Apellido Paterno:</td>
                                            <td class="td-t0">
                                                <input type="text" name="pat_usr_emp" value="{/documento/header/parametros/pat_usr_emp}" onBlur="this.value=this.value.toUpperCase();isText(this,'Apellido Paterno',true,false,true)"/>
                                            </td>
                                        </xsl:if>                                       
                                    </tr>
                                </xsl:when>
                                <xsl:otherwise>
                                    <input type="hidden" name="id_emp" value="{header/sesion/idEmpresa}" />
                                </xsl:otherwise>
                            </xsl:choose>
                            <tr>
                                <xsl:choose>
                                    <xsl:when test="body/data/row/tiposdocumentos/data/@count &gt; 1">
                                        <td class="hdr-i" style="text-transform:capitalize;">Identificador Tipo Documento:</td>
                                        <td class="td-t1">
                                            <select name="id_tpo_doc">
                                                <option value="0">Todos</option>
                                                <xsl:for-each select="body/data/row/tiposdocumentos/data/row">
                                                    <option value="{id_tpo_doc}">
                                                        <xsl:if test="id_tpo_doc = /documento/header/parametros/id_tpo_doc">
                                                            <xsl:attribute name="selected">selected</xsl:attribute>
                                                        </xsl:if>
                                                        <xsl:value-of select="dsc_tpo_doc" />
                                                    </option>
                                                </xsl:for-each>
                                            </select>
                          &nbsp;
                                            <input type="text" name="doc_usr_emp" style="text-transform: uppercase;"
                                    value="{/documento/header/parametros/doc_usr_emp}"
                                    onblur="this.value=this.value.toUpperCase(); isText(this,'Documento',true,false,true)" />
                                        </td>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <td class="hdr-i" style="text-transform:capitalize;">
                                            <xsl:value-of select="body/data/row/tiposdocumentos/data/row/dsc_tpo_doc" />:</td>
                                        <td class="td-t1">
                                            <xsl:choose>
                                                <xsl:when test="body/data/row/tiposdocumentos/data/row/dsc_tpo_doc = 'Rut'" >
                                                        <input type="text" name="doc_usr_emp" style="text-transform: uppercase;" value="{/documento/header/parametros/doc_usr_emp}" onblur="this.value=this.value.toUpperCase(); isDocument(this,'{body/data/row/tiposdocumentos/data/row/dsc_tpo_doc}',true,true,false, true)" />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                        <input type="text" name="doc_usr_emp" style="text-transform: uppercase;" value="{/documento/header/parametros/doc_usr_emp}" onblur="this.value=this.value.toUpperCase(); isText(this,'{body/data/row/tiposdocumentos/data/row/dsc_tpo_doc}',true,false,true)" />    
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </td>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:if test="/documento/header/sesion/idCliente=209">
                                    <td class="hdr-i" width="25%">Apellido Materno:</td>
                                    <td class="td-t0">
                                        <input type="text" name="mat_usr_emp" value="{/documento/header/parametros/mat_usr_emp}" onBlur="this.value=this.value.toUpperCase();isText(this,'Apellido Materno',true,false,true)"/>
                                    </td>
                                </xsl:if>
                            </tr>
                            <tr>
                                <td class="hdr-i">Nombre de Usuario:</td>
                                <td class="td-t0">
                                    <input type="text" name="nom_usr_emp" style="text-transform: uppercase;"
                            value="{/documento/header/parametros/nom_usr_emp}" onkeypress="this.value.toUpperCase();"
                            onblur="this.value=this.value.toUpperCase(); isText(this,'Nombre de Usuario',true,false,true)" />
                                </td>
                                
                                <xsl:if test="/documento/header/sesion/idCliente=209">
                                    <td class="hdr-i" width="25%">Perfil:</td>
                                    <td class="td-t0">
                                        <input type="text" name="dsc_prf" style="text-transform: uppercase;"        
                                        value="{/documento/header/parametros/dsc_prf}" onkeypress="this.value.toUpperCase();"
                                        onblur="this.value=this.value.toUpperCase(); isText(this,'Nombre de Usuario',true,false,true)" />
                                    </td>               
                                </xsl:if>
                                
                            </tr>
                            <tr>
                                <td class="hdr-i" width="25%">Funcionalidad (opci&oacute;n de men&uacute;):</td>
                                <td class="td-t1">                  
                                    <select name="id_srv">
                                        <option value="0">Todos</option>
                                        <xsl:for-each select="body/data/row/servicios/data/row">
                                            <xsl:if test="url_srv != ''">
                                                <option value="{id_srv}">                               
                                                    <xsl:if test="id_srv = /documento/header/parametros/id_srv">
                                                        <xsl:attribute name="selected">selected</xsl:attribute>
                                                    </xsl:if>
                                                    <xsl:value-of select="dsc_srv" />
                                                </option>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </select>                               
                                </td>
                                <xsl:if test="/documento/header/sesion/idCliente=209">
                                    <td class="hdr-i" width="25%">Estado:</td>
                                    <td class="td-t0">
                                        <input type="text" name="dsc_std_prf" value="{/documento/header/parametros/dsc_std_prf}" />
                                    </td>
                                </xsl:if>   
                            </tr>
                        </table>
            &br;
                        <table cellpadding="0" cellspacing="0" class="tablenormal">
                            <tr>
                                <td>
                                    <input type="submit" class="button" value="Buscar" onclick="buscar('buscar');" />
                                </td>
                                <td>&nbsp;</td>
                                <td>
                                    <input type="button" class="button" value="Limpiar Filtro" onclick="limpiar();" />
                                </td>
                            </tr>
                        </table>
            &br;
                    </div>
                    <table class="tableborder" cellpadding="0" cellspacing="0">
                        <tr>
                            <td class="hdr-i" colspan="9">
                            <table class="tablenormal" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td>Detalle Usuarios</td>                           
                                    <xsl:if test="body/data/row/usuarios/data/@count &gt; 0">
                                        <td align="right">Total registros: <xsl:value-of select="/documento/body/data/row/usuarios/data/row/tot_reg"/></td>
                                    </xsl:if>
                                </tr>
                            </table>
                            </td>
                        </tr>
                        <xsl:choose>
                            <xsl:when test="count(body/data/row/usuarios)=0 or body/data/row/usuarios/data/@count=0">
                                <tr>
                                    <td colspan="9" class="td-t">&nbsp No se han encontrado registros para su consulta. Establezca sus criterios de b&uacute;squeda e int&eacute;ntelo nuevamente.</td>
                                </tr>
                            </xsl:when>
                            <xsl:otherwise>
                                <tr>
                                    <td class="hdr-c">&nbsp;</td>
                                    <td class="hdr-c">Empresa</td>
                                    <td class="hdr-c" style="text-transform:capitalize; ">
                                        <xsl:choose>
                                            <xsl:when test="body/data/row/tiposdocumentos/data/@count &gt; 1">
                    Identificador
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="body/data/row/tiposdocumentos/data/row/dsc_tpo_doc"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </td>
                                    <td class="hdr-c">Nombre</td>
                                    <xsl:choose>
                                        <xsl:when test="header/acciones/row[id_axn=50]"/>
                                        <xsl:otherwise>
                                            <td class="hdr-c">Unidad de Negocio</td>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:choose>
                                        <xsl:when test="header/acciones/row[id_axn=51]"/>
                                        <xsl:otherwise>
                                            <td class="hdr-c">Perfil</td>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <td class="hdr-c">Fecha Creaci&oacute;n</td>
                                    <td class="hdr-c">Fecha &Uacute;ltima&br;Actualizaci&oacute;n</td>
                                    <td class="hdr-c">Estado Cuenta</td>
                                </tr>
                                <xsl:for-each select="body/data/row/usuarios/data/row">
                                    <tr>
                                        <xsl:choose>
                                            <xsl:when test="(cod_std_usr_emp = 'ELIMIN') or (cod_std_usr_emp = 'VISMOD') or (cod_std_usr_emp = 'VISCRE') or (cod_std_usr_emp = 'VISELI')">
                                                <td class="td-r{position() mod 2}">
                                                    <input type="radio" name="id_usr_emp" disabled="true"/>
                                                </td>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <td class="td-r{position() mod 2}">
                                                    <input type="radio" name="id_usr_emp" value="{id_usr_emp}" onclick="document.formulario.seleccion.value='si';document.formulario.seleccionId.value=this.value"/>
                                                </td>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <td class="td-t{position() mod 2}">
                                            <xsl:value-of select="raz_soc_emp"/>
                                        </td>
                                        <td class="td-t{position() mod 2}">
                                            <xsl:choose>
                                                <xsl:when test="body/data/row/tiposdocumentos/data/@count = 1">
                                                    <xsl:choose>
                                                        <xsl:when test="(cod_std_usr_emp = 'ELIMIN') or (cod_std_usr_emp = 'VISMOD') or (cod_std_usr_emp = 'VISCRE') or (cod_std_usr_emp = 'VISELI')">
                                                            <xsl:value-of select="doc_usr_emp"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <a href="javascript:editar({id_usr_emp},{id_emp})">
                                                                <xsl:value-of select="portal:formatDocument(id_tpo_doc, doc_usr_emp)"/>
                                                            </a>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:choose>
                                                        <xsl:when test="(cod_std_usr_emp = 'ELIMIN') or (cod_std_usr_emp = 'VISMOD') or (cod_std_usr_emp = 'VISCRE') or (cod_std_usr_emp = 'VISELI')">
                                                            <xsl:value-of select="dsc_tpo_doc"/>&nbsp;<xsl:value-of select="doc_usr_emp"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <a href="javascript:editar({id_usr_emp},{id_emp})">
                                                                <xsl:value-of select="dsc_tpo_doc"/>&nbsp;<xsl:value-of select="portal:formatDocument(id_tpo_doc, doc_usr_emp)"/>
                                                            </a>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </td>
                                        <td class="td-t{position() mod 2}">
                                            <xsl:value-of select="nom_usr_emp"/>&nbsp;<xsl:value-of select="pat_usr_emp"/>&nbsp;<xsl:value-of select="mat_usr_emp"/>
                                        </td>
                                        <xsl:choose>
                                            <xsl:when test="/documento/header/acciones/row[id_axn=50]"/>
                                            <xsl:otherwise>
                                                <td class="td-t{position() mod 2}">
                                                    <xsl:value-of select="dsc_uni_neg"/>
                                                </td>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:choose>
                                            <xsl:when test="/documento/header/acciones/row[id_axn=51]"/>
                                            <xsl:otherwise>
                                                <td class="td-t{position() mod 2}">
                                                    <xsl:value-of select="dsc_prf"/>
                                                </td>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <td class="td-f{position() mod 2}">
                                            <xsl:value-of select="bnsc:frmt-fecha(fec_add_usr_emp)"/>
                                        </td>
                                        <td class="td-f{position() mod 2}">
                                            <xsl:value-of select="bnsc:frmt-fecha(fec_upd_usr_emp)"/>
                                        </td>
                                        <td class="td-t{position() mod 2}">
                                            <xsl:value-of select="dsc_std_usr_emp"/>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                    </table>
                    <xsl:value-of select="portal:paginacion(/documento/header/parametros/pagina, ceiling((/documento/body/data/row/usuarios/data/row/tot_reg) div (/documento/header/sesion/registrosPorPagina)))"/>
                    <table cellpadding="0" cellspacing="0" class="tablenormal">
                        <tr>
                            <xsl:if test="header/acciones/row[cod_axn='add']">
                                <td>
                                    <input type="button" class="button" value="Agregar" onclick="agregar();" />
                                </td>
                                <td>&nbsp;</td>
                            </xsl:if>
                            <xsl:if test="count(body/data/row/usuarios) &gt; 0 or body/data/row/usuarios/data/@count &gt; 0">
                                <xsl:if test="header/acciones/row[cod_axn='upd']">
                                    <td>
                                        <input type="button" class="button" value="Eliminar" onclick="eliminar();" />
                                    </td>
                                    <td>&nbsp;</td>
                                </xsl:if>
                                <xsl:if test="header/acciones/row[cod_axn='xls']">
                                    <td>
                                        <input type="button" class="button" value="Exportar a Excel" onclick="buscar('excel');" />
                                    </td>
                                    <td>&nbsp;</td>
                                </xsl:if>
                                <xsl:if test="header/acciones/row[cod_axn='pdf']">
                                    <td>
                                        <input type="button" class="button" value="Exportar a PDF" onclick="buscar('pdf');" />
                                    </td>
                                    <td>&nbsp;</td>
                                </xsl:if>
                                <xsl:if test="header/acciones/row[cod_axn='prn']">
                                    <td>
                                        <input type="button" class="button" value="Imprimir" onclick="window.print();" />
                                    </td>
                                </xsl:if>
                            </xsl:if>
                        </tr>
                    </table>
                </form>
                <p>
                    <xsl:value-of select="footer/@contenido" disable-output-escaping="yes"/>
                </p>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>