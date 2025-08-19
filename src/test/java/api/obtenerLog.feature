@obtenerLogEstaciones
Feature: Obtener logs de estaciones mediante el endpoint GET /api/v1/estaciones/log-estaciones

  Background:
    # 1. LOGIN PARA OBTENER TOKEN
    * def loginBody = read('classpath:JsonRequest/loginTokenRequest.json')
    * def loginResponse = call read('classpath:api/loginToken.feature') { request: loginBody }
    * def authToken = loginResponse.response.token

    # 2. CONFIGURANDO HEADERS
    * def headers = headersEstacionesConToken(authToken)
    * configure headers = headers
    * print 'HEADERS usados:', headers
    * print 'TOKEN obtenido:', authToken

    # 3. CONFIGURANDO VALIDACION DE SCHEMA
    * def schemaUtil = Java.type('util.JsonSchemaUtil')
    * def errorSchema = karate.readAsString('classpath:Schema/sc_errorResponse.json')

  @obtenerLog
  Scenario: Obtener logs de estaciones con parámetros válidos
    Given url baseUrl
    And param correlationId = '1445|ve.com.telefonica.StationGrpcService/Search|TNS01|1744033106208'
    And param createdStartDate = '2025-08-01T08:00:00'
    And param createdEndDate = '2025-08-19T13:00:00'
    And param limit = 10
    And param page = 1
    When method GET
    Then status 200
    And match response.success == true
    And print 'Total de logs encontrados:', response.data.data.length
    And print '=== TIEMPO DE RESPUESTA ===', responseTime / 1000, 's'
