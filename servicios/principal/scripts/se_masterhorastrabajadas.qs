/***************************************************************************
                 se_mastersubproyectos.qs  -  description
                             -------------------
    begin                : lun jun 20 2005
    copyright            : (C) 2005 by InfoSiAL S.L.
    email                : mail@infosial.com
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

/** @file */
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_declaration interna */
//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna {
    var ctx:Object;
    function interna( context ) { this.ctx = context; }
    function init() { this.ctx.interna_init(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna 
{
	var chkYo:Object;
	var chkHoy:Object;
	var tableDBRecords:Object;
    function oficial( context ) { interna( context ); } 
	function filtroHoras() {
		return this.ctx.oficial_filtroHoras();
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial {
    function head( context ) { oficial ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
    function ifaceCtx( context ) { head( context ); }
}

const iface = new ifaceCtx( this );
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////

function interna_init()
{
	var cursor:FLSqlCursor = this.cursor();

	this.iface.chkYo = this.child("chkYo");
	this.iface.chkHoy = this.child("chkHoy");
	this.iface.tableDBRecords = this.child("tableDBRecords")

	connect(this.iface.chkYo, "clicked()", this, "iface.filtroHoras");
	connect(this.iface.chkHoy, "clicked()", this, "iface.filtroHoras");
	connect(this.child("pbnRefrescar"), "clicked()", this, "iface.filtroHoras");
	
	this.iface.chkHoy.checked = true;
	this.iface.chkYo.checked = true;
	this.iface.filtroHoras();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_filtroHoras():String
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var filtro:String;
	if (this.iface.chkYo.checked) {
// 		var codUsuario = util.readSettingEntry("scripts/flservppal/codusuario");
		var codUsuario = sys.nameUser();
		if (!codUsuario) {
			MessageBox.information( util.translate( "scripts", "No se ha definido usuario actual"), MessageBox.Ok, MessageBox.NoButton);
			return;
		}
		if (filtro != "") {
			filtro += " AND ";
		}
		filtro += " codusuario = '" + codUsuario + "'";
	}

	var hoy:String = new Date();

	if (this.iface.chkHoy.checked) {
		if (filtro != "") {
			filtro += " AND ";
		}
		filtro += "fecha = '" + hoy + "'";
	}

	var horas:Number = util.sqlSelect("se_horastrabajadas", "sum(horas)", filtro);
	if (horas)
		this.child("leInfo").text = "Horas: " + horas;
	
	cursor.setMainFilter(filtro);
	this.iface.tableDBRecords.refresh();
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
