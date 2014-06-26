<table width="100%" border="0">
<tr>
<td width="95%" align="left" valign="top">
<form name="formulario">
    <table cellpadding="0" cellspacing="0" border="0">
        <tr><td nowrap="nowrap"><span class="mapaweb" style="font-size:18px"><b>MapaWeb</b> <img src="img/list.gif" align="absmiddle" /></span></td></tr>
        <tr><td><img src="../../img/transp.gif" height="5px" /></td></tr>
    </table>
    <!--Opciones-->
    <table cellpadding="0" cellspacing="0" class=" texto tabla" width="98%">
        <tr>
            <td class="celda">
                <table border="0" cellpadding="3" cellspacing="0" width="100%">
                  <tr>
                   <!--Opciones-->
                    <td align="left" valign="top"><b>&raquo;&nbsp;Opciones <img src="img/icon_note.gif" width="16" height="14" align="absmiddle" /></b></td>
                    <td align="right">
                    <img src="img/new_page.gif" style="cursor:pointer;" align="absmiddle" onClick="javascript:getPage(document.formulario,'actionMapa','nuevoMapa','contenido','&mode=show');" alt="<!--{$smarty.const._NUEVO_}-->" />
                    <img src="img/edit_page.gif" style="cursor:pointer;" align="absmiddle" onClick="javascript:feditar(document.formulario,'actionMapa','editarMapa','elemento','&mode=show');" alt="<!--{$smarty.const._EDITAR_}-->" />
                    <img src="img/delete_record.gif" style="cursor:pointer;" align="absmiddle" onClick="javascript:feliminar(document.formulario,'actionMapa','eliminarMapa','contenido','');" alt="<!--{$smarty.const._ELIMINAR_}-->" />
                    </td>
                  </tr>
    			  <tr><td colspan="2"><hr width="100%" style="border-top:dotted 1px #666666; margin:0 auto;" size="0" /></td></tr>	                  
                   <!--Buscador-->
                  <tr>
					<td align="left" valign="top"><b>&raquo;&nbsp;Buscar <img src="img/zoom.gif" align="absmiddle" /></b></td>
                    <td align="left">
						<div class="ldiv">Niv_1<br /><input name="map_niv_1" type="text" size="2" maxlength="3" value="<!--{$map_niv_1}-->" <!--{$_UPPER_}--> /></div>
                        <div class="ldiv">Niv_2<br /><input name="map_niv_2" type="text" size="2" maxlength="3" value="<!--{$map_niv_2}-->" <!--{$_UPPER_}--> /></div>
                        <div class="ldiv">Niv_3<br /><input name="map_niv_3" type="text" size="2" maxlength="3" value="<!--{$map_niv_3}-->" <!--{$_UPPER_}--> /></div>
                        <div class="ldiv">Niv_4<br /><input name="map_niv_4" type="text" size="2" maxlength="3" value="<!--{$map_niv_4}-->" <!--{$_UPPER_}--> /></div>
                        <div class="ldiv">Niv_5<br /><input name="map_niv_5" type="text" size="2" maxlength="3" value="<!--{$map_niv_5}-->" <!--{$_UPPER_}--> /></div>
                        <div class="ldiv">Niv_6<br /><input name="map_niv_6" type="text" size="2" maxlength="3" value="<!--{$map_niv_6}-->" <!--{$_UPPER_}--> /></div>
                        <div class="ldiv"><br />
                        <img src="img/zoom.gif" style="cursor:pointer;" align="absmiddle" onClick="javascript:getPage(document.formulario,'actionMapa','listarMapa','contenido','');" alt="<!--{$smarty.const._BUSCAR_}-->" />
                        </div>
                    </td>					                  	
                  </tr>
                </table>
            </td>
        </tr>
    </table>
    <!--Listado-->
        <!--{if $_RESULT_ eq ""}-->
	        <hr width="98%" style="border-top:dotted 1px #666666" size="0" />
            <!--{$smarty.const._CERO_}-->
        <!--{else}-->
        <br>
        P&aacute;g. <span class="paginado"><!--{$_PAGINAS_}--></span><br /><br />    
        <table width="98%" cellpadding="0" cellspacing="2">
        <tr>
            <td>&nbsp;<br /><img src="../../img/transp.gif" height="1" width="100%" style="border-top:solid 1px #000000" /></td>
            <td><b>Niveles</b><br /><img src="../../img/transp.gif" height="1" width="100%" style="border-top:solid 1px #000000" /></td>
            <td><b>Titulo</b><br /><img src="../../img/transp.gif" height="1" width="100%" style="border-top:solid 1px #000000" /></td>
            <td><b>Ruta</b><br /><img src="../../img/transp.gif" height="1" width="100%" style="border-top:solid 1px #000000" /></td>
            <td><b>Visible</b><br /><img src="../../img/transp.gif" height="1" width="100%" style="border-top:solid 1px #000000" /></td>
        </tr>           
        <!--{foreach key=key item=item from=$_RESULT_}-->
        <tr>
            <td><input type="radio" name="sel_row" value="<!--{$item.map_id}-->" style="border:0px;color:#00f;background-color:#ddd;" /></td>
            <td><!--{$item.map_niv_1}-->,<!--{$item.map_niv_2}-->,<!--{$item.map_niv_3}-->,<!--{$item.map_niv_4}-->,<!--{$item.map_niv_5}-->,<!--{$item.map_niv_6}--></td>
            <td><!--{$item.map_tit}--></td>
            <td><!--{$item.map_ruta}--></td>            
            <td><!--{$item.map_vis}--></td>
        </tr>
		<tr><td colspan="5"><img src="../../img/transp.gif" height="1" width="100%" style="border-top:dotted 1px #000000" /></td></tr>        
        <!--{/foreach}-->
        </table>
        <!--{/if}-->    
	<input type="hidden" name="page" value="<!--{$smarty.request.page}-->" />    
</form>    
</td>
<td width="5%" style="border-left:dotted 1px #666666" align="left" valign="top">
	&nbsp;
</td>
</tr>
</table>