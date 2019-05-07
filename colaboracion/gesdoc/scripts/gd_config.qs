/***************************************************************************
                 gd_config.qs  -  description
                             -------------------
    begin                : vie jul 21 2006
    copyright            : (C) 2006 by InfoSiAL S.L.
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
	var ctx;
	function interna( context ) { this.ctx = context; }
	function main() {
		this.ctx.interna_main();
	}
	function init() {
		this.ctx.interna_init();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	function oficial( context ) { interna( context ); }
	function cambiarExp() {
		return this.ctx.oficial_cambiarExp();
	}
	function cambiarCopia() {
		return this.ctx.oficial_cambiarCopia();
	}
	function cambiarDirLocal() {
		return this.ctx.oficial_cambiarDirLocal();
	}
	function cambiarCodificacion(valor) {
		return this.ctx.oficial_cambiarCodificacion(valor);
	}
	function bufferChanged(fN) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function habilitaPorTipoRepositorio() {
		return this.ctx.oficial_habilitaPorTipoRepositorio();
	}
	function habilitaPorBdLocal() {
		return this.ctx.oficial_habilitaPorBdLocal();
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

////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_definition interna */
//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////

function interna_main()
{
	var f = new FLFormSearchDB("gd_config");
	var cursor = f.cursor();

	cursor.select();
	if (!cursor.first())
		cursor.setModeAccess(cursor.Insert);
	else
		cursor.setModeAccess(cursor.Edit);
	f.setMainWidget();
	if (cursor.modeAccess() == cursor.Insert)
		f.child("pushButtonCancel").setDisabled(true);
	cursor.refreshBuffer();
	var commitOk = false;
	var acpt;
	cursor.transaction(false);
	while (!commitOk) {
		acpt = false;
		f.exec("urlrepositorio");
		acpt = f.accepted();
		if (!acpt) {
			if (cursor.rollback())
				commitOk = true;
		} else {
			if (cursor.commitBuffer()) {
				cursor.commit();
				commitOk = true;
			}
		}
		f.close();
	}
}

function interna_init()
{
	var _i = this.iface;
	var cursor = this.cursor();
	
	this.child("lblExp").text = AQUtil.readSettingEntry("scripts/flcolagedo/explorador");
	this.child("lblDirLocal").text = AQUtil.readSettingEntry("scripts/flcolagedo/dirLocal");
	this.child("lblCopia").text = AQUtil.readSettingEntry("scripts/flcolagedo/comandocp");
	this.child("lineEditCodificacion").text = AQUtil.readSettingEntry("scripts/flfacturac/encodingLocal");

	connect(this.child("pbnCambiarExp" ), "clicked()", _i, "cambiarExp");
	connect(this.child("pbnCambiarCopia" ), "clicked()", _i, "cambiarCopia");
	connect(this.child("pbnCambiarDirLocal" ), "clicked()", _i, "cambiarDirLocal");
	connect(cursor, "bufferChanged(QString)", _i, "bufferChanged");
	connect(this.child("lineEditCodificacion"), "textChanged(QString)", _i, "cambiarCodificacion()");

	_i.habilitaPorTipoRepositorio();
	_i.habilitaPorBdLocal();
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \C
Cambia el nombre o la ruta de acceso al explorador de archivos
\end */
function oficial_cambiarExp()
{
	var explorador = Input.getText( "Nombre del explorador de archivos o ruta de acceso" );
	
	this.child("lblExp").text = explorador;
	AQUtil.writeSettingEntry("scripts/flcolagedo/explorador", explorador);
}

/** \C
Cambia el nombre del comando usado para copiar archivos
\end */
function oficial_cambiarCopia()
{
	var comandoCP = Input.getText( "Nombre del comando para realizar la copia de archivos" );
	
	this.child("lblCopia").text = comandoCP;
	AQUtil.writeSettingEntry("scripts/flcolagedo/comandocp", comandoCP);
}

/** \C
Cambia el directorio local de documentación para el usuario
\end */
function oficial_cambiarDirLocal()
{
	var ruta = FileDialog.getExistingDirectory(sys.translate(""), sys.translate("RUTA AL DIRECTORIO LOCAL DE DOCUMENTOS"));
	
	if (!File.isDir(ruta)) {
		sys.infoMsgBox(sys.translate("Ruta errónea"));
		return;
	}
	this.child("lblDirLocal").text = ruta;
	AQUtil.writeSettingEntry("scripts/flcolagedo/dirLocal", ruta);
}

function oficial_cambiarCodificacion(valor)
{
	AQUtil.writeSettingEntry("scripts/flfacturac/encodingLocal", valor);
}

function oficial_bufferChanged(fN)
{
	var _i = this.iface;
	var cursor = this.cursor();

	switch (fN) {
		case "tiporepositorio": {
			_i.habilitaPorTipoRepositorio();
			_i.habilitaPorBdLocal();
			break;
		}
		case "usarbdlocal": {
			_i.habilitaPorBdLocal();
			if (cursor.valueBuffer("usarbdlocal")) {
				cursor.setNull("idconexion");
			}
			break;
		}
	}
}

function oficial_habilitaPorTipoRepositorio()
{
	var _i = this.iface;
	var cursor = this.cursor();

	if (cursor.valueBuffer("tiporepositorio") == "Base de datos")
		this.child("gbxBD").setEnabled(true);
	else
		this.child("gbxBD").enabled = false;
}

function oficial_habilitaPorBdLocal()
{
	var _i = this.iface;
	var cursor = this.cursor();
	
	if (cursor.valueBuffer("tiporepositorio") == "Base de datos" && !cursor.valueBuffer("usarbdlocal"))
		this.child("gbxDatosCx").enabled = true;
	else
		this.child("gbxDatosCx").enabled = false;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////



//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
