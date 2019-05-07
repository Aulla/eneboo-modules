/***************************************************************************
                 gd_documentos.qs  -  description
                             -------------------
    begin                : jue jul 20 2006
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

/** @class_declaration interna */
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna {
	var ctx;
	function interna( context ) { this.ctx = context; }
	function init() {
		this.ctx.interna_init();
	}
	function calculateField(fN) {
		return this.ctx.interna_calculateField(fN);
	}
	function validateForm() {
		return this.ctx.interna_validateForm();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var tdbVersiones;
	var vinculos;
	function oficial( context ) { interna( context ); }
	function actualizarVersion() {
		return this.ctx.oficial_actualizarVersion();
	}
	function bufferChanged(fN) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function subir() {
		return this.ctx.oficial_subir();
	}
	function cancelarSubida() {
		return this.ctx.oficial_cancelarSubida();
	}
	function actualizarUltimaVersion() {
		return this.ctx.oficial_actualizarUltimaVersion();
	}
	function bajar() {
		return this.ctx.oficial_bajar();
	}
	function bajarVersion() {
		return this.ctx.oficial_bajarVersion();
	}
	function estadoCorrecto(codDocumento, version) {
		return this.ctx.oficial_estadoCorrecto(codDocumento, version);
	}
	function ver(pathFichero) {
		return this.ctx.oficial_ver(pathFichero);
	}
	function bajar_clicked() {
		return this.ctx.oficial_bajar_clicked();
	}
	function cambiarFichero() {
		return this.ctx.oficial_cambiarFichero();
	}
	function cambiarRuta() {
		return this.ctx.oficial_cambiarRuta();
	}
	function cambiarRutaRepositorio() {
		return this.ctx.oficial_cambiarRutaRepositorio();
	}
	function refrescarVinculos() {
		return this.ctx.oficial_refrescarVinculos();
	}
	function calcularVinculos(idDocumento) {
		return this.ctx.oficial_calcularVinculos(idDocumento);
	}
	function objetoRaiz(xmlDoc, eActual) {
		return this.ctx.oficial_objetoRaiz(xmlDoc, eActual);
	}
	function infoObjeto(tipoObjeto, clave, ePadre) {
		return this.ctx.oficial_infoObjeto(tipoObjeto, clave, ePadre);
	}
	function rutaDoc() {
		return this.ctx.oficial_rutaDoc();
	}
	function rutaRepo() {
		return this.ctx.oficial_rutaRepo();
	}
	function obtenerPlantilla(codPlantilla, cursor) {
		return this.ctx.oficial_obtenerPlantilla(codPlantilla, cursor);
	}
	function componerPlantillaODT(cursor, fichPlantilla) {
		return this.ctx.oficial_componerPlantillaODT(cursor, fichPlantilla);
	}
	function valorCampoPlantilla(idDocumento, codTipo, campo) {
		return this.ctx.oficial_valorCampoPlantilla(idDocumento, codTipo, campo);
	}
	function comprobarAvisoPlantilla() {
		return this.ctx.oficial_comprobarAvisoPlantilla();
	}
	function componerPlantilla(cursor, pathFichero, extensionPlantilla) {
		return this.ctx.oficial_componerPlantilla(cursor, pathFichero, extensionPlantilla);
	}
	function crearVersionAutomatica() {
		return this.ctx.oficial_crearVersionAutomatica();
	}
	function damePathFicheroPlantilla(extension) {
		return this.ctx.oficial_damePathFicheroPlantilla(extension);
	}
	function componerFicheroPlantillaODT(cursor, fichPlantilla, fichXml) {
		return this.ctx.oficial_componerFicheroPlantillaODT(cursor, fichPlantilla,fichXml);
	}
	function valorTablaPlantilla(idDocumento, codTipo, campos) {
		return this.ctx.oficial_valorTablaPlantilla(idDocumento, codTipo, campos);
	}
	function reemplazarCaracteres(valor) {
		return this.ctx.oficial_reemplazarCaracteres(valor);
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
	var _i = this.iface;
	var cursor = this.cursor();

	_i.tdbVersiones = this.child("tdbVersiones");
	connect(_i.tdbVersiones.cursor(), "bufferCommited()", _i, "actualizarVersion");
	connect(this.child("pbnFichero"), "clicked()", _i, "cambiarFichero()");
	connect(this.child("pbnRuta"), "clicked()", _i, "cambiarRuta()");
	connect(this.child("pbnRutaRepositorio"), "clicked()", _i, "cambiarRutaRepositorio()");
	connect(this.child("pbnSubir"), "clicked()", _i, "subir()");
	connect(this.child("pbnBajar"), "clicked()", _i, "bajar_clicked()");
	connect(this.child("pbnVer"), "clicked()", _i, "ver()");
	connect(this.child("tbnBajarVersion"), "clicked()", _i, "bajarVersion()");
	connect(cursor, "bufferChanged(QString)", _i, "bufferChanged()");
	this.child("txtRuta").text = _i.rutaDoc();

	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			this.child("fdbCreadoPor").setValue(sys.nameUser());
			this.child("fdbRutaRepositorio").setValue(_i.rutaRepo());
			break;
		}
		case cursor.Edit: {
			_i.refrescarVinculos();
			break;
		}
		case cursor.Browse: {
			this.child("pbnSubir").enabled = false;
			_i.refrescarVinculos();
			break;
		}
	}

	var tipoRepo = flcolagedo.iface.pub_obtenerTipoRepositorio();
	if (tipoRepo != "Base de datos" || AQUtil.sqlSelect("gd_config", "usarbdlocal", "1 = 1")) {
		this.child("fdbIdConexion").close();
		this.child("fdbDescConexion").close();
	}
	else if(cursor.isNull("idconexion"))
		cursor.setValueBuffer("idconexion", AQUtil.sqlSelect("gd_config", "idconexion", "1 = 1"));

	switch (tipoRepo) {
		case "Distribuido": {
			break;
		}
		default: {
			this.child("fdbRutaRepositorio").setDisabled(true);
			this.child("pbnRutaRepositorio").enabled = false;
			break;
		}
	}
	

	// Tareas
	if (sys.isLoadedModule("flcolaproc")) {
		var datosS = {};
		datosS["tipoObjeto"] = "gd_documentos";
		datosS["idObjeto"] = cursor.valueBuffer("iddocumento");
		flcolaproc.iface.pub_seguimientoOn(this, datosS);
	} else {
		this.child("tbwDocumentos").setTabEnabled("tareas", false);
	}
	
	_i.comprobarAvisoPlantilla();
}

function interna_calculateField(fN)
{
	var _i = this.iface;
	var cursor = this.cursor();
	var valor;

	switch (fN) {
		/** \C La versión actual es la versión que está por subir al repositorio. Si todas las versiones están en el repositorio, la versión actual es la última que se subió.
		\end */
		case "idversionactual": {
			valor = AQUtil.sqlSelect("gd_versionesdoc", "idversion", "iddocumento = " + cursor.valueBuffer("iddocumento") + " AND versionrep IS NULL");
			if (!valor)
				valor = AQUtil.sqlSelect("gd_versionesdoc", "idversion", "iddocumento = " + cursor.valueBuffer("iddocumento") + " ORDER BY versionrep DESC");
			break;
		}
	}
	return valor;
}

function interna_validateForm()
{
	var cursor = this.cursor();
	
	var pathFichero = this.child("txtRuta").text + "/" + cursor.valueBuffer("fichero");
	if (!pathFichero) {
		return false;
	}

	if (!this.child("pbnSubir").on) {
		return true;
	}

	if (flcolagedo.iface.tipoRepositorio_ == "Base de datos" && !AQUtil.sqlSelect("gd_config", "usarbdlocal", "1 = 1") && (!cursor.valueBuffer("idconexion") || cursor.isNull("idconexion"))) {
		sys.warnMsgBox(sys.translate("Debe informar la conexión asociada al documento."));
		return false;
	}
		
	if (!flcolagedo.iface.pub_subirDocCursor(cursor, pathFichero)) {
		this.child("pbnSubir").on = false;
		return false;
	}
	return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \C Se planifica la actualización del repositorio escogiendo un fichero local como nueva versión del documento. La actualización se producirá al aceptar el formulario.<p/> Si el documento ya estaba elegido se cancela la actualización.
\end */
function oficial_subir()
{
	var _i = this.iface;
	var cursor = this.cursor()
	var codDocumento = cursor.valueBuffer("codigo");
	var tipoRepo = flcolagedo.iface.pub_obtenerTipoRepositorio();
	
	if (codDocumento == "0") {
		codDocumento = flcolagedo.iface.pub_obtenerCodigoDoc("general");
		if (!codDocumento)
			return;
		this.child("fdbCodigo").setValue(codDocumento);
	}
	
	if (this.child("pbnSubir").on) {
		var pathFichero = this.child("txtRuta").text + "/" + cursor.valueBuffer("fichero");
		if (!File.isFile(pathFichero) || cursor.valueBuffer("fichero") == "") {
			if (File.isDir(this.child("txtRuta").text))
				Dir.current = this.child("txtRuta").text;
			pathFichero = FileDialog.getOpenFileName("*", sys.translate("Seleccione documento"));
			if (!pathFichero) {
				this.child("pbnSubir").on = false;
				return false;
			}
			var fileAux = new File(pathFichero);
			this.child("txtRuta").text = fileAux.path;
			this.child("fdbFichero").setValue(fileAux.name);
		}
		if (this.child("rbnNuevaVersion").checked) {
			switch (tipoRepo) {
				case "Distribuido": {
					if (!_i.crearVersionAutomatica()) {
						return false;
					}
					break;
				}
				default: {
					this.child("tdbVersiones").insertRecord();
					break;
				}
			}
		} else {
			if (!_i.actualizarUltimaVersion()) {
				this.child("pbnSubir").on = false;
				return false;
			}
		}
		this.child("txtUpdate").text = sys.translate("El repositorio se actualizará al aceptar el formulario");
	} else {
		if (!_i.cancelarSubida())
			return false;
		this.child("txtUpdate").text = "";
	}
}

/** Crea un registro de versión asociado al documento actual. Se llama cuando el tipo de repositorio es distribuido para mantener la compatibilidad con el resto de tipos de repositorio
\end */
function oficial_crearVersionAutomatica()
{
	var _i = this.iface;
	var cursor = this.cursor();

	if (AQUtil.sqlSelect("gd_versionesdoc", "idversion", "iddocumento = " + cursor.valueBuffer("iddocumento"))) {
		return true;
	}
	var curVersion;
	if (cursor.modeAccess() == cursor.Insert) {
		curVersion = this.child("tdbVersiones").cursor();
		if (!curVersion.commitBufferCursorRelation()) {
			return false;
		}
	}
	var hoy = new Date();
	
	curVersion = new FLSqlCursor("gd_versionesdoc");
	curVersion.setModeAccess(curVersion.Insert);
	curVersion.refreshBuffer();
	curVersion.setValueBuffer("iddocumento", cursor.valueBuffer("iddocumento"));
	curVersion.setValueBuffer("version", "01");
	curVersion.setValueBuffer("fecha", cursor.valueBuffer("fechacreacion"));
	curVersion.setValueBuffer("fichero", cursor.valueBuffer("fichero"));
	curVersion.setValueBuffer("modificadopor", cursor.valueBuffer("creadopor"));
	curVersion.setValueBuffer("fechamodif", hoy.toString());
	curVersion.setValueBuffer("horamodif", hoy.toString().right(8));
	if (!curVersion.commitBuffer()) {
		return false;
	}
	_i.actualizarVersion();
	
	return true;
}

/** \D Cancela la subida del documento actual al repositorio. Si se creó una nueva versión, dicha versión se borra. El documento es revertido en el directorio local
@return	True si el documento es revertido correctamente, false en caso contrario
\end */
function oficial_cancelarSubida()
{
	var _i = this.iface;
	var cursor = this.cursor();

	var comando;
	var resComando;

	if (!AQUtil.sqlDelete("gd_versionesdoc", "iddocumento = " + cursor.valueBuffer("iddocumento") + " AND versionrep IS NULL"))
		return false;

	_i.actualizarVersion();
	/*
	if (!this.iface.revertirDocumento(cursor.valueBuffer("codigo")))
		return false;
	*/

	return true;
}

function oficial_actualizarVersion()
{
	var _i = this.iface;
	var cursor = this.cursor();

	cursor.setValueBuffer("idversionactual", _i.calculateField("idversionactual"));
}

function oficial_bufferChanged(fN)
{
	var cursor:FLSqlCursor = this.cursor();
	switch(fN) {
		case "codtipo": {
			this.iface.comprobarAvisoPlantilla();
			break;
		}
	}
}

/** \C Actualiza ciertos datos de la última versión del documento con los del propio documento
\end */
function oficial_actualizarUltimaVersion()
{
	var _i = this.iface;
	var cursor = this.cursor();

	var curVersion = this.child("tdbVersiones").cursor();
	curVersion.select("idversion = " + cursor.valueBuffer("idversionactual"));
	if (!curVersion.first())
		return false;
	curVersion.setModeAccess(curVersion.Edit);
	curVersion.refreshBuffer();
	curVersion.setValueBuffer("fichero", cursor.valueBuffer("fichero"));
	curVersion.setValueBuffer("comentarios", cursor.valueBuffer("comentarios"));
	if (!curVersion.commitBuffer())
		return false;

	return true;
}

function oficial_bajar_clicked()
{
	var _i = this.iface;
	var cursor = this.cursor();
	var tipoRepo = flcolagedo.iface.pub_obtenerTipoRepositorio();

	switch (tipoRepo) {
		case "Distribuido": {
			if (!_i.bajar()) {
				return false;
			}
			break;
		}
		default: {
			var version = AQUtil.sqlSelect("gd_versionesdoc", "version", "idversion = " + cursor.valueBuffer("idversionactual"));
			if (!version) {
				var idPlantilla = AQUtil.sqlSelect("gd_tiposdoc", "idplantilla", "codtipo = '" + cursor.valueBuffer("codtipo") + "'");
				if (!idPlantilla || idPlantilla == "") {
					return false;
				}
				if (!_i.obtenerPlantilla(idPlantilla, cursor)) {
					return false;
				}
			} else {
				if (!_i.bajar()) {
					return false;
				}
			}
			break;
		}
	}
	var res = MessageBox.information(sys.translate("Se ha guardado el fichero %1\n¿Desea visualizarlo?").arg(cursor.valueBuffer("fichero")), MessageBox.Yes, MessageBox.No);
	
	if (res == MessageBox.Yes) {
		if (!_i.ver()) {
			return false;
		}
	}
}

function oficial_bajar()
{
	var _i = this.iface;
	var cursor = this.cursor()

	var codDocumento = cursor.valueBuffer("codigo");
	var versionActual = AQUtil.sqlSelect("gd_versionesdoc", "version", "idversion = " + cursor.valueBuffer("idversionactual"));

	var tipoRepo = flcolagedo.iface.pub_obtenerTipoRepositorio();

	switch (tipoRepo) {
		case "Distribuido": {
			break;
		}
		default: {
			if (!_i.estadoCorrecto(codDocumento, versionActual)) {
				return false;
			}
			break;
		}
	}

	var pathFichero = this.child("txtRuta").text;
	if (!File.isDir(pathFichero)) {
		pathFichero = FileDialog.getExistingDirectory(Dir.home, sys.translate("Seleccione directorio"));
		if (!pathFichero)
			return false;
		this.child("txtRuta").text = pathFichero;
	}

	switch (tipoRepo) {
		case "Distribuido": {
			if (!flcolagedo.iface.pub_obtenerDocumento(cursor.valueBuffer("fichero"), pathFichero + "/" + cursor.valueBuffer("fichero"), false, false, cursor.valueBuffer("rutarepositorio"))) {
				return false;
			}
			break;
		}
		default: {
			if (!flcolagedo.iface.pub_obtenerDocumento(codDocumento, pathFichero + "/" + cursor.valueBuffer("fichero"), false, false, cursor.valueBuffer("rutarepositorio"))) {
				return false;
			}
			break;
		}
	}
	return true;
}

/** \D Verifica que el documento está listo para operar con él mediante las acciones del control de versiones
@param	codDocumento: Nombre del documento en el repositorio
@param	version: Versión del documento
@return	true si el estado es el correcto, false en caso contrario
\end */
function oficial_estadoCorrecto(codDocumento, version)
{
	var estado = flcolagedo.iface.pub_svnStatus(codDocumento, version);
	switch (estado) {
		case "C": {
			sys.warnMsgBox(sys.translate("Existe un conflicto entre la versión local del documento y la versión del repositorio"));
			break;
		}
		case "?":
		case "??":
		case "M": {
			var res = MessageBox.warning(sys.translate("El documento actual tiene modificaciones locales pendientes de subir al repositorio.\nSi baja el fichero del repositorio dichas modificaciones se perderán.\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
			if (res != MessageBox.Yes)
				return false;
			break;
		}
		case "X":
		case "XX":
		case "U": {
			break;
		}
		default: {
			return false;
		}
	}
	return true;
}

/** \D Baja la versión seleccionada del documento al directorio especificado
@return	True si la versión se baja correctamente, false en caso contrario
\end */
function oficial_bajarVersion()
{
	var _i = this.iface;	
	var cursor = this.cursor()
	var curVersion = this.child("tdbVersiones").cursor();

	var tipoRepo = flcolagedo.iface.pub_obtenerTipoRepositorio();
	var revision = curVersion.valueBuffer("versionrep");
	if (!revision && tipoRepo == "Repositorio Subversion")
		return false;
	var fichero = curVersion.valueBuffer("fichero");
	
	var codDocumento = cursor.valueBuffer("codigo");
	if (!_i.estadoCorrecto(codDocumento, revision))
		return false;
		
	/*
	var pathFichero:String = this.child("txtRuta").text;
	if (!File.isDir(pathFichero)) {
		pathFichero = FileDialog.getExistingDirectory(Dir.home, util.translate("scripts", "Seleccione directorio"));
		if (!pathFichero)
			return false;
		this.child("txtRuta").text = pathFichero;
	}
	*/
	var pathFichero = FileDialog.getSaveFileName("*", sys.translate("Seleccione el directorio y el nombre del documento a guardar"));
	if (!pathFichero)
		return false;
	
	if (!flcolagedo.iface.pub_obtenerDocumento(codDocumento, pathFichero, curVersion.valueBuffer("version"), revision))
		return false;
	/*
	if (!flcolagedo.iface.pub_obtenerDocumento(codDocumento, pathFichero + "/" + fichero, revision))
		return false;
	*/
	

	var res = MessageBox.information(sys.translate("Se ha guardado el fichero %1 en la ruta:\n%2\n¿Desea visualizarlo?").arg(fichero).arg(pathFichero), MessageBox.Yes, MessageBox.No);
	if (res == MessageBox.Yes) {
		_i.ver(pathFichero);
	}
	
	return true;
}

/** \D Ver el documento
*/
function oficial_ver(pathFichero)
{
	var _i = this.iface;
	var cursor = this.cursor()

	var comando;
	var resComando;
	if (!pathFichero)
		pathFichero = this.child("txtRuta").text + "/" + cursor.valueBuffer("fichero");

	if (!File.exists(pathFichero)) {
// 		var res:Number = MessageBox.warning(util.translate("scripts", "No existe documento en el directorio local:\n%1\n¿Desea obtenerlo del repositorio?").arg(pathFichero), MessageBox.Yes, MessageBox.No);
// 		if (res != MessageBox.Yes)
// 			return true;
		_i.bajar();
	}
	
//  	var explorador:String = util.readSettingEntry("scripts/flcolagedo/explorador");
	var pathAdaptado = flcolagedo.iface.pub_adaptarRuta(pathFichero);
// 	comando = [explorador, pathAdaptado];
// 	try {
// 		resComando = flcolagedo.iface.pub_ejecutarComandoAsincrono(comando);
// 	}
// 	catch (e) {
// 		MessageBox.critical(util.translate("scripts", "%1\n\nFalló la llamada al explorador.\nDebe especificar una ruta correcta al explorador en el formulario de configuración del módulo").arg(comando), MessageBox.Ok, MessageBox.NoButton);
// 		return false;
// 	}
	sys.openUrl(pathAdaptado);
	return true;
}

/** \D Permite al usuario cambiar el fichero actual
\end */
function oficial_cambiarFichero():Boolean
{
	var util:FLUtil = new FLUtil();
	var pathFichero:String = FileDialog.getOpenFileName("*", util.translate("scripts", "Seleccione documento"));
	if (!pathFichero) {
		return false;
	}
	var fileAux = new File(pathFichero);
	this.child("txtRuta").text = fileAux.path;
	this.child("fdbFichero").setValue(fileAux.name);
	this.child("fdbExtension").setValue(fileAux.extension);
	return true;
}

/** \D Permite al usuario cambiar la ruta actual
\end */
function oficial_cambiarRuta():Boolean
{
	var util:FLUtil = new FLUtil();
	var pathFichero:String = this.child("txtRuta").text;
	if (!File.isDir(pathFichero)) {
		pathFichero = FileDialog.getExistingDirectory(Dir.home, util.translate("scripts", "Seleccione directorio"));
	} else {
		pathFichero = FileDialog.getExistingDirectory(pathFichero, util.translate("scripts", "Seleccione directorio"));
	}
	if (!pathFichero) {
		return false;
	}
	
	this.child("txtRuta").text = pathFichero;
	return true;
}

/** \D Permite al usuario cambiar la ruta del documento en el repositorio
\end */
function oficial_cambiarRutaRepositorio():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var pathFichero:String = cursor.valueBuffer("rutarepositorio");
	if (!File.isDir(pathFichero)) {
		pathFichero = FileDialog.getExistingDirectory(Dir.home, util.translate("scripts", "Seleccione directorio"));
	} else {
		pathFichero = FileDialog.getExistingDirectory(pathFichero, util.translate("scripts", "Seleccione directorio"));
	}
	if (!pathFichero) {
		return false;
	}

	this.child("fdbRutaRepositorio").setValue(pathFichero);
	return true;
}

function oficial_refrescarVinculos()
{
	var _i = this.iface;
	var cursor = this.cursor();
	
	_i.vinculos = "";
	var idDocumento = cursor.valueBuffer("iddocumento");
	
	var xmlDoc = new FLDomDocument;
	xmlDoc = _i.calcularVinculos(idDocumento);

	this.child("txtVinculos").text = xmlDoc.toString(4);
	if (!xmlDoc.firstChild()) {
		return false;
	}
	return xmlDoc.firstChild().toElement();
}

function oficial_calcularVinculos(idDocumento)
{
	var _i = this.iface;

	if(!idDocumento)
		return false;
	
	var xmlDoc = new FLDomDocument;
	xmlDoc.setContent("<Documento IdDocumento='" + idDocumento + "' />");
	if (!_i.objetoRaiz(xmlDoc, xmlDoc.firstChild().toElement())) {
		return false;
	}

	return xmlDoc.firstChild().toElement();
}

/** \D Función recursiva que obtiene los objetos padre de un documento hasta dar con un objeto que no es de tipo documento. Estos objetos son almacenados en el string global "vinculos"
@param	idDocumento: String
@return	True si la función se comporta correctamente, false en caso contrario
\end */
function oficial_objetoRaiz(xmlDoc:FLDomDocument, eActual:FLDomElement):Boolean
{
	var util:FLUtil = new FLUtil();
	var res:String = "";
	var clave:String;
	var tipoObjeto:String;

	var idDocumento:String = eActual.attribute("IdDocumento");
	var qryVinculos:FLSqlQuery = new FLSqlQuery;
	with (qryVinculos) {
		setTablesList("gd_objetosdoc");
		setSelect("tipoobjeto, clave");
		setFrom("gd_objetosdoc");
		setWhere("iddocumento = " + idDocumento);
		setForwardOnly(true);
	}
	if (!qryVinculos.exec()) {
		return false;
	}
	
	var ePadre:FLDomElement;
	while (qryVinculos.next()) {
		clave = qryVinculos.value("clave");
		tipoObjeto = qryVinculos.value("tipoobjeto");
		if (tipoObjeto == "gd_documentos") {
			ePadre = xmlDoc.createElement("Documento");
			ePadre.setAttribute("IdDocumento", clave);
			ePadre.setAttribute("Nombre", util.sqlSelect("gd_documentos", "nombre", "iddocumento = " + clave));
			if (util.sqlSelect("gd_documentos d INNER JOIN gd_tiposdoc td ON d.codtipo = td.codtipo", "td.contenedor", "d.iddocumento = " + clave, "gd_documentos,gd_tiposdoc")) {
				ePadre.setAttribute("Contenedor", "true");
			} else {
				ePadre.setAttribute("Contenedor", "false");
			}
			eActual.appendChild(ePadre);
			if (!this.iface.objetoRaiz(xmlDoc, ePadre)) {
				return false;
			}
		} else {
			ePadre = xmlDoc.createElement("Objeto");
			if (!this.iface.infoObjeto(tipoObjeto, clave, ePadre)) {
				return false;
			}
			eActual.appendChild(ePadre);
		}
	}
	return true;
}

/** \D Informa un elemento con la información básica del objeto
@param	tipoObjeto: Tabla de la que proviene el objeto
@param	clave: Identificador único del objeto
@return	string si la función se ejecuta correctamente, false en caso contrario
\end */
function oficial_infoObjeto(tipoObjeto:String, clave:String, ePadre:FLDomElement):String
{
	var util:FLUtil = new FLUtil;
	var valor:String = "";

	ePadre.setAttribute("Tipo", tipoObjeto);
	ePadre.setAttribute("IdObjeto", clave);
	switch (tipoObjeto) {
		case "clientes": {
			ePadre.setAttribute("Nombre", util.sqlSelect("clientes", "nombre", "codcliente = '" + clave + "'"));
			break;
		}
		case "proveedores": {
			ePadre.setAttribute("Nombre", util.sqlSelect("proveedores", "nombre", "codproveedor = '" + clave + "'"));
			break;
		}
		case "gd_config": {
			ePadre.setAttribute("Nombre", util.translate("scripts", "Repositorio principal"));
			break;
		}
		default: {
		}
	}
	return ePadre;
}

/** \D Obtiene la ruta por defecto del directorio local del documento
\end */
function oficial_rutaDoc():String
{
	var r = AQUtil.readSettingEntry("scripts/flcolagedo/dirLocal");
	if (!r || r == "") {
		try {
			r = Dir.home + "/aqdocs"
			if (!File.exists(r)) {
				var dir = new Dir(Dir.home);
				dir.mkdir("aqdocs");
			}
			AQUtil.writeSettingEntry("scripts/flcolagedo/dirLocal", r);
		} catch (e) {
			MessageBox.information( sys.translate( "Error al crear el directorio %1" ).arg(r) + ": " + e, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return sys.translate("(RUTA NO DEFINIDA)");
		}
		
	}
	return r;
}

/** \D Obtiene la ruta del repositorio 
\end */
function oficial_rutaRepo():String
{
	var util:FLUtil = new FLUtil;
	return util.sqlSelect("gd_config", "urlrepositorio", "1 = 1");
}

function oficial_obtenerPlantilla(idPlantilla:String, cursor:FLSqlCursor):Boolean
{
debug("oficial_obtenerPlantilla");
	var util:FLUtil = new FLUtil;
	
	var codPlantilla:String = util.sqlSelect("gd_documentos", "codigo", "iddocumento = " + idPlantilla);
	var extensionPlantilla:String = util.sqlSelect("gd_documentos", "extension", "iddocumento = " + idPlantilla);
	if (!codPlantilla) {
		return false;
	}
debug("codPlantilla = " + codPlantilla);
	/// Bajar Plantilla
	if (!extensionPlantilla) {
		extensionPlantilla = "";
	}
	var pathFichero:String = this.iface.damePathFicheroPlantilla(extensionPlantilla);
	if (!pathFichero) {
		return false;
	}
	if (extensionPlantilla != "" && !pathFichero.endsWith(extensionPlantilla)) {
		pathFichero += "." + extensionPlantilla;
	}

	if (!flcolagedo.iface.pub_obtenerDocumento(codPlantilla, pathFichero)) {
		return false;
	}
	
debug("extensionPlantilla = " + extensionPlantilla);
	
	if (extensionPlantilla != "") {
		extensionPlantilla = extensionPlantilla.toLowerCase();
		if (!this.iface.componerPlantilla(cursor, pathFichero, extensionPlantilla)) {
			return false;
		}
	}
	
	var objetoFile = new File(pathFichero);
debug("name = " + objetoFile.name);
	this.child("fdbFichero").setValue(objetoFile.name);
	this.child("fdbExtension").setValue(objetoFile.extension);
debug("ruta = " + objetoFile.path);
	this.child("txtRuta").text = objetoFile.path;
	
// 	var res:Number = MessageBox.information( util.translate( "scripts", "Se creó el documento %1\n¿Desea abrirlo?" ).arg(pathFichero), MessageBox.Yes, MessageBox.No, MessageBox.NoButton );
// 	if (res == MessageBox.Yes) {
// 		if (!this.iface.ver(pathFichero)) {
// 			return false;
// 		}
// 	}
	
	return true;
}

function oficial_componerPlantilla(cursor:FLSqlCursor, pathFichero:String, extensionPlantilla:String):Boolean
{
	var util:FLUtil = new FLUtil;
	switch (extensionPlantilla) {
		case "odt": {
			if (!this.iface.componerPlantillaODT(cursor, pathFichero)) {
				return false;
			}
			break;
		}
	}
	return true;
}
function oficial_componerPlantillaODT(cursor:FLSqlCursor, fichPlantilla:String):Boolean
{
	if(!this.iface.componerFicheroPlantillaODT(cursor, fichPlantilla, "styles.xml"))
		return false;

	if(!this.iface.componerFicheroPlantillaODT(cursor, fichPlantilla, "content.xml"))
		return false;

	return true;
}

function oficial_componerFicheroPlantillaODT(cursor:FLSqlCursor, fichPlantilla:String,fichXml:String):Boolean
{
	var util:FLUtil = new FLUtil();

	var comando:String;
	var oSys:String = util.getOS();
	
	var objetoFile = new File(fichPlantilla);
	if (!objetoFile) {
		return;
	}
	var date = new Date();
	var dirTmp:String = util.sha1(sys.idSession());
	var pathTmp:String = objetoFile.path;
	var objetoDir = new Dir(pathTmp);
	
	if (File.exists(pathTmp + dirTmp)) {
		objetoDir.rmdirs(dirTmp);
	}
	
	if (!File.exists(pathTmp + dirTmp)) {
		objetoDir.mkdir(dirTmp);
	}
	pathTmp += "/" + dirTmp + "/";
	
	if (File.exists(pathTmp + fichXml)) {
		File.remove(pathTmp + fichXml);
	}
	var fichDestino:String = "temp.odt";
	if (File.exists(pathTmp + fichDestino)) {
		File.remove(pathTmp + fichDestino);
	}
		
	// Copiar la plantilla al temporal
	comando = new Array("cp", fichPlantilla, pathTmp + fichDestino);
	var proceso = new Process();
	proceso.arguments = comando;
  	proceso.workingDirectory = pathTmp;
 	try {
		proceso.start();
	}
	catch (e) {
		MessageBox.critical(util.translate("scripts", "Falló la ejecución del comando:\n\n%1").arg(comando), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	while(proceso.running) {
		continue;
	}

	// Obtener el content.xml de la plantilla odt mediante comando unzip
	comando = new Array("unzip", pathTmp + fichDestino, fichXml);
	var proceso = new Process();
	proceso.arguments = comando;
  	proceso.workingDirectory = pathTmp;
 	try {
		proceso.start();
	}
	catch (e) {
		MessageBox.critical(util.translate("scripts", "Falló la ejecución del comando:\n\n%1").arg(comando), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	while(proceso.running) {
		continue;
	}
	
	var contenido:String = File.read(pathTmp + fichXml);
	var codificacion = util.readSettingEntry("scripts/flfacturac/encodingLocal");
	var sistema:String = util.getOS();
	if (sistema == "LINUX" ) {
		contenido = sys.toUnicode( contenido, codificacion );
	}

	var xmlContenido:FLDomDocument = new FLDomDocument();
	if (!xmlContenido.setContent(contenido)) {
		MessageBox.critical(util.translate("scripts", "Falló la ejecución del comando:\n\n%1").arg(comando), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

//******** SUSTITUIR TABLAS *******************************************************
//*********************************************************************************
	var xmlTablas:FLDomNodeList = xmlContenido.elementsByTagName("table:table");
	var campos:String = "";
	var valores:Array = [];
	var nodoTabla;
	var arrayNodosRef:Array = [];
	var totalRefsTabla:Number = 0;
	var arrayNodosRefC:Array = [];
	var totalRefsCTabla:Number = 0;
	var nodoNuevo:FLDomNode;
	var xmlCeldas:FLDomNodeList;
	var nodoT:FLDomNode;

	var referencias:String;
	if (xmlTablas) {
		var totalTablas:Number = xmlTablas.length();
		for (var tbl:Number = 0; tbl < totalTablas; tbl++) {
			campos = "";
			nodoTabla = xmlTablas.item(tbl).toElement();
			if(!nodoTabla.attribute("table:name").startsWith("TablaReferencias"))
				continue;

			var xmlFilas:FLDomNodeList = xmlTablas.item(tbl).elementsByTagName("table:table-row");
			if(xmlFilas) {
				var totalFilas:Number = xmlFilas.length();
				if(totalFilas != 1)
					 return false;

				// Obtener campos
				var nodoFila:FLDomNode = xmlFilas.item(0);
				var xmlRefsTabla:FLDomNodeList = xmlTablas.item(tbl).elementsByTagName("text:reference-ref");
				if(xmlRefsTabla) {
					totalRefsTabla = xmlRefsTabla.length();
					for (var i:Number = 0; i < totalRefsTabla; i++) {
						arrayNodosRef[i] = xmlRefsTabla.item(i).toElement();
					}
					for (var ref:Number = 0; ref < totalRefsTabla; ref++) {
						if(campos != "")
							campos += ",";
						var aux = arrayNodosRef[ref].attribute("text:ref-name");
						campos += aux;
					}
				}

				if(campos && campos != "")
					valores = this.iface.valorTablaPlantilla(cursor.valueBuffer("iddocumento"), cursor.valueBuffer("codtipo"), campos);
						
				// Sustituir valores
				for(var fl=0;fl<valores.length;fl++) {
					nodoNuevo = nodoFila.cloneNode(true);
					xmlCeldas = nodoNuevo.childNodes();
					if(xmlCeldas)  {
						totalCeldas = xmlCeldas.length();
						for(var iC = 0; iC < totalCeldas; iC++) {
							if (!xmlCeldas.item(iC).hasChildNodes())
								continue;
							if (!xmlCeldas.item(iC).firstChild().hasChildNodes())
								continue;
							
							valores[fl][iC] = this.iface.reemplazarCaracteres(valores[fl][iC]);
							
							if (codificacion && codificacion.toUpperCase() != "UTF-8")
								valores[fl][iC] = util.utf8(valores[fl][iC]);
							
							var nodoT = xmlContenido.createTextNode(valores[fl][iC]);
							xmlCeldas.item(iC).firstChild().replaceChild(nodoT,xmlCeldas.item(iC).firstChild().firstChild());
						}
						nodoTabla.appendChild(nodoNuevo);
					}
				}
				nodoTabla.removeChild(nodoFila);
			}
		}
	}
//*********************************************************************************

//******** SUSTITUIR REFERENCIAS **************************************************
//*********************************************************************************
	var xmlReferencias:FLDomNodeList = xmlContenido.elementsByTagName("text:reference-ref");
	var xmlRef:FLDomNode;
	var campo:String;
	var valor:String;

	var arrayNodos:Array = [];
	if (xmlReferencias) {
		var totalRef:Number = xmlReferencias.length();
		for (var i:Number = 0; i < totalRef; i++) {
			arrayNodos[i] = xmlReferencias.item(i).toElement();
		}
		for (var i:Number = 0; i < totalRef; i++) {
			campo = arrayNodos[i].attribute("text:ref-name");
			valor = this.iface.valorCampoPlantilla(cursor.valueBuffer("iddocumento"), cursor.valueBuffer("codtipo"), campo);
			valor = this.iface.reemplazarCaracteres(valor);
			if (codificacion && codificacion.toUpperCase() != "UTF-8") {
				valor = util.utf8(valor);
			}
			var nodoT = xmlContenido.createTextNode(valor);
			arrayNodos[i].parentNode().replaceChild(nodoT, arrayNodos[i]);
		}
	}
	
	// Volcar el nuevo contenido a content_xxxxx.xml
	File.write(pathTmp + fichXml, xmlContenido.toString(4));
	
	comando = new Array("zip", "-uj", pathTmp + fichDestino, pathTmp + fichXml);
	proceso.arguments = comando;
	try {
		proceso.start();
	}
	catch (e) {
		MessageBox.critical(util.translate("scripts", "Falló la ejecución del comando:\n\n%1").arg(comando), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	while(proceso.running) {
		continue;
	}

	comando = new Array("mv", "-f", pathTmp + fichDestino, fichPlantilla);
	proceso.arguments = comando;
	try {
		proceso.start();
	}
	catch (e) {
		MessageBox.critical(util.translate("scripts", "Falló la ejecución del comando:\n\n%1").arg(comando), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	while(proceso.running) {
		continue;
	}

	comando = new Array("rm", "-rf", pathTmp);
	proceso.arguments = comando;
	try {
		proceso.start();
	}
	catch (e) {
		MessageBox.critical(util.translate("scripts", "Falló la ejecución del comando:\n\n%1").arg(comando), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	while(proceso.running) {
		continue;
	}
	
	return true;
}

function oficial_reemplazarCaracteres(valor:String):String
{
	var util:FLUtil;
	var sistema:String = util.getOS();
	if (sistema == "LINUX" )
	    return valor;
	if(!valor || valor == "")
	    return valor;
	
	var caracteres:Array = [];
	caracteres[0] = ["À","A"];
	caracteres[1] = ["È","E"];
	caracteres[2] = ["Ì","I"];
	caracteres[3] = ["Ò","O"];
	caracteres[4] = ["Ù","U"];
	caracteres[5] = ["Ñ","N"];
	caracteres[6] = ["É","E"];
	caracteres[7] = ["Ó","O"];
	caracteres[8] = ["Ú","U"];
	caracteres[9] = ["Ç","C"];
	caracteres[10] = ["Ü","U"];
	
	for(var c=0;c<caracteres.length;c++) {
		while(valor.find(caracteres[c][0]) != -1)
			valor = valor.replace(caracteres[c][0],caracteres[c][1]);
	}
	
	return valor;
}

function oficial_valorTablaPlantilla(idDocumento:String, codTipo:String, campos:String):Array
{
	var eDoc:FLDomElement = this.iface.calcularVinculos(idDocumento);
	var resultado:Array = flcolagedo.iface.pub_valorTablaPlantilla(codTipo, campos, eDoc);

	return resultado;
}
// function oficial_componerPlantillaODT(cursor:FLSqlCursor, fichPlantilla:String):Boolean
// {
// 	var util:FLUtil = new FLUtil();
// 
// 	var comando:String;
// 	var oSys:String = util.getOS();
// 	
// 	var objetoFile = new File(fichPlantilla);
// 	if (!objetoFile) {
// 		return;
// 	}
// 	var date = new Date();
// 	var dirTmp:String = util.sha1(sys.idSession());
// 	var pathTmp:String = objetoFile.path;
// 	var objetoDir = new Dir(pathTmp);
// 	
// 	if (File.exists(pathTmp + dirTmp)) {
// 		objetoDir.rmdirs(dirTmp);
// 	}
// 	
// 	if (!File.exists(pathTmp + dirTmp)) {
// 		objetoDir.mkdir(dirTmp);
// 	}
// 	pathTmp += "/" + dirTmp + "/";
// 	
// 	if (File.exists(pathTmp + "content.xml")) {
// 		File.remove(pathTmp + "content.xml");
// 	}
// 	var fichDestino:String = "temp.odt";
// 	if (File.exists(pathTmp + fichDestino)) {
// 		File.remove(pathTmp + fichDestino);
// 	}
// 		
// 	// Copiar la plantilla al temporal
// 	comando = new Array("cp", fichPlantilla, pathTmp + fichDestino);
// 	var proceso = new Process();
// 	proceso.arguments = comando;
//   	proceso.workingDirectory = pathTmp;
//  	try {
// 		proceso.start();
// 	}
// 	catch (e) {
// 		MessageBox.critical(util.translate("scripts", "Falló la ejecución del comando:\n\n%1").arg(comando), MessageBox.Ok, MessageBox.NoButton);
// 		return false;
// 	}
// 	while(proceso.running) {
// 		continue;
// 	}
// 
// 	// Obtener el content.xml de la plantilla odt mediante comando unzip
// 	comando = new Array("unzip", pathTmp + fichDestino, "content.xml");
// 	var proceso = new Process();
// 	proceso.arguments = comando;
//   	proceso.workingDirectory = pathTmp;
//  	try {
// 		proceso.start();
// 	}
// 	catch (e) {
// 		MessageBox.critical(util.translate("scripts", "Falló la ejecución del comando:\n\n%1").arg(comando), MessageBox.Ok, MessageBox.NoButton);
// 		return false;
// 	}
// 	while(proceso.running) {
// 		continue;
// 	}
// 	
// 	var contenido:String = File.read(pathTmp + "content.xml");
// 	var codificacion = util.readSettingEntry("scripts/flfacturac/encodingLocal");
// 	if (codificacion == "UTF-8") {
// 		contenido = sys.toUnicode( contenido, codificacion );
// 	}
// debug(contenido);
// 	
// 	var xmlContenido:FLDomDocument = new FLDomDocument();
// 	if (!xmlContenido.setContent(contenido)) {
// 		MessageBox.critical(util.translate("scripts", "Falló la ejecución del comando:\n\n%1").arg(comando), MessageBox.Ok, MessageBox.NoButton);
// 		return false;
// 	}
// 
// 	var xmlReferencias:FLDomNodeList = xmlContenido.elementsByTagName("text:reference-ref");
// 	var xmlRef:FLDomNode;
// 	var campo:String;
// 	var valor:String;
// 
// 	var arrayNodos:Array = [];
// 
// 	if (xmlReferencias) {
// 		var totalRef:Number = xmlReferencias.length();
// 		for (var i:Number = 0; i < totalRef; i++) {
// 			arrayNodos[i] = xmlReferencias.item(i).toElement();
// 		}
// 		for (var i:Number = 0; i < totalRef; i++) {
// 			campo = arrayNodos[i].attribute("text:ref-name");
// 			valor = this.iface.valorCampoPlantilla(cursor.valueBuffer("iddocumento"), cursor.valueBuffer("codtipo"), campo);
// 			if (codificacion && codificacion.toUpperCase() != "UTF-8") {
// 				valor = util.utf8(valor);
// 			}
// 
// 			var nodoT = xmlContenido.createTextNode(valor);
// 			arrayNodos[i].parentNode().replaceChild(nodoT, arrayNodos[i]);
// 		}
// 	}
// 
// 	// Volcar el nuevo contenido a content_xxxxx.xml
// 	File.write(pathTmp + "content.xml", xmlContenido.toString(4));
// 	
// 	comando = new Array("zip", "-uj", pathTmp + fichDestino, pathTmp + "content.xml");
// 	proceso.arguments = comando;
// 	try {
// 		proceso.start();
// 	}
// 	catch (e) {
// 		MessageBox.critical(util.translate("scripts", "Falló la ejecución del comando:\n\n%1").arg(comando), MessageBox.Ok, MessageBox.NoButton);
// 		return false;
// 	}
// 	while(proceso.running) {
// 		continue;
// 	}
// 	debug(pathTmp + fichDestino);
// 	comando = new Array("mv", "-f", pathTmp + fichDestino, fichPlantilla);
// 	proceso.arguments = comando;
// 	try {
// 		proceso.start();
// 	}
// 	catch (e) {
// 		MessageBox.critical(util.translate("scripts", "Falló la ejecución del comando:\n\n%1").arg(comando), MessageBox.Ok, MessageBox.NoButton);
// 		return false;
// 	}
// 	while(proceso.running) {
// 		continue;
// 	}
// 
// 	comando = new Array("rm", "-rf", pathTmp);
// 	proceso.arguments = comando;
// 	try {
// 		proceso.start();
// 	}
// 	catch (e) {
// 		MessageBox.critical(util.translate("scripts", "Falló la ejecución del comando:\n\n%1").arg(comando), MessageBox.Ok, MessageBox.NoButton);
// 		return false;
// 	}
// 	while(proceso.running) {
// 		continue;
// 	}
// 	
// 	return true;
// }

function oficial_valorCampoPlantilla(idDocumento:String, codTipo:String, campo:String):String
{
	var util:FLUtil = new FLUtil;
	var eDoc:FLDomElement = this.iface.calcularVinculos(idDocumento);

	var qryDatoPlantilla:FLSqlQuery = new FLSqlQuery;
	qryDatoPlantilla.setTablesList("gd_camposplantilla");
	qryDatoPlantilla.setSelect("funcion, funcionexterna");
	qryDatoPlantilla.setFrom("gd_camposplantilla");
	qryDatoPlantilla.setWhere("codtipo = '" + codTipo + "' AND nombre = '" + campo + "'");
	qryDatoPlantilla.setForwardOnly(true);
	
	if (!qryDatoPlantilla.exec()) {
		return false;
	}

	var resultado:String;
	if (!qryDatoPlantilla.first()) {
// 		MessageBox.warning(util.translate("scripts", "No existe el campo de plantilla %1 para el tipo de documento %2").arg(campo).arg(codTipo), MessageBox.Ok, MessageBox.NoButton);
		resultado = flcolagedo.iface.pub_valorCampoPlantilla(codTipo, campo, eDoc);
	}
	else {
		if (qryDatoPlantilla.value("funcionexterna")) {
			var textoFun:String = qryDatoPlantilla.value("funcion");
			if (!textoFun || textoFun == "") {
				MessageBox.warning(util.translate("scripts", "No se ha podido obtener la función de cálculo para el campo '%1' de la plantilla").arg(campo), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
			var funcionVal = new Function("eDoc", textoFun);
			resultado = funcionVal(eDoc);
		} else {
			resultado = flcolagedo.iface.pub_valorCampoPlantilla(codTipo, campo, eDoc);
		}
	}
	return resultado;
}

function oficial_comprobarAvisoPlantilla()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var mensaje:String = "";
	if (!util.sqlSelect("gd_versionesdoc", "iddocumento", "iddocumento = " + cursor.valueBuffer("iddocumento"))) {
		var idPlantilla:String = util.sqlSelect("gd_tiposdoc", "idplantilla", "codtipo = '" + cursor.valueBuffer("codtipo") + "'");
		if (idPlantilla && idPlantilla != "") {
			mensaje = util.translate("scripts", "Este tipo de documento dispone de una plantilla");
		}
	}
	this.child("txtUpdate").text = mensaje;
}

function oficial_damePathFicheroPlantilla(extension:String):String
{
	var util:FLUtil;
	var pathFichero:String;
// 	pathFichero = FileDialog.getSaveFileName("*." + extensionPlantilla, util.translate("scripts", "Indique el nombre del fichero"));
	pathFichero = this.iface.rutaDoc() + "/" + "bq_tmp_doc";
	if (extension != "") {
		pathFichero += "." + extension;
	}
	return pathFichero;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////




