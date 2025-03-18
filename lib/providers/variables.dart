//Vaiable de entrega
//final String url = "http://192.168.10.25:8013"; //Calidad
final String url = "https://impuestos.cordoba.gov.co"; //Productivo
//final String url = "http://192.168.90.114:8080"; //Prodcutivo prueba
//final String url = "http://192.168.15.250:8080"; //desarrollo

// ignore: non_constant_identifier_names
final String Url_Global = "$url/WSRI_CORDOBA_ISVA/ProcesosPago?wsdl";

// ignore: non_constant_identifier_names
final String Url_Global_REC = "$url/WSRI_CORDOBA_ISVA/Liquidar?";

// ignore: non_constant_identifier_names
final String Url_CONV = "$url/WSRI_CORDOBA_ISVA/ReciboConvenio?";
// ignore: non_constant_identifier_names
final String Url_EST = "$url/WSRI_CORDOBA_ISVA/ReporteEC?";
// ignore: non_constant_identifier_names
final String Url_DEC = "$url/WSRI_CORDOBA_ISVA/ReportDeclaracion?";

final String urlvalidarplaca = "$url/WSRI_CORDOBA_ISVA/ConsultaValidaPlaca";
final String urlPazYsalvo = "$url/WSRI_CORDOBA_ISVA/ValidaSolicitudPazySalvo";

final String urlreimprimirpaz =
    "$url/WSRI_CORDOBA_ISVA/ReimprimirCertificadoPazSalvo?";

final String certificadospazysalvo = "$url/CORDOBA/CERTIFICADO_PAZ_Y_SALVO";

final String certificadosestampilla = "$url/CORDOBA/ESTAMPILLA_PAZ_Y_SALVO";

const String footer_row1 =
    "Gobernación de Córdoba \nSecretaría de Hacienda \nNit. 800-103.935-G cordoba.gov.co";

const String dialog =
    'SEÑOR CONTRIBUYENTE LO INVITAMOS A ACERCARSE A NUESTRAS OFICINAS EN EL CENTRO COMERCIAL SURICENTRO, CALLE 10 NO. 25 - 105 LOCAL 153, CON SU TARJETA DE PROPIEDAD PARA REALIZAR LA ACTUALIZACIÓN REQUERIDA O ENVIAR AL CORREO ELECTRÓNICO RECAUDO.IMPUESTOS@CORDOBA.GOV.CO LA SOLICITUD DE ACTUALIZACIÓN CON LOS SIGUIENTES DOCUMENTOS ADJUNTOS: TARJETA DE PROPIEDAD O LICENCIA DE TRÁNSITO.';
const String liquiValida =
    'SEÑOR CONTRIBUYENTE POR FALTA DE INFORMACIÓN ESTA VIGENCIA NO SE ENCUENTRA LIQUIDADA FAVOR ENVIAR LA TARJETA DE PROPIEDAD O LICENCIA DE TRÁNSITO ESCANEADA AL CORREO ELECTRÓNICO RECAUDO.IMPUESTOS@CORDOBA.GOV.CO PARA REALIZAR LA ACTUALIZACIÓN NECESARIA.';
