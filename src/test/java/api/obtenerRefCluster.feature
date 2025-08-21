@obtenerRefCluster
Feature: Consultar Ref Clusters mediante el endpoint GET /estaciones/ref-cluster

  Background:
    # 1. LLAMANDO AL SERVICIO AUTHTOKEN PARA HACER LOGIN Y OBTENER EL TOKEN
    * configure logPrettyResponse = false
    * configure logPrettyRequest = false
    * def validBodyRequest = read('classpath:JsonRequest/loginTokenRequest.json')
    * def loginResponse = call read('classpath:api/loginToken.feature') { request: validBodyRequest }
    * def authToken = loginResponse.response.token

    # 2. USANDO LA FUNCIÓN DE HEADERS DEFINIDA EN karate-config.js
    * def headers = headersEstacionesConToken(authToken)
    * configure headers = headers

    # 3. CONFIGURANDO VALIDACIÓN DE SCHEMA
    * def schemaUtil = Java.type('util.JsonSchemaUtil')
    * def schemaText = karate.readAsString('classpath:Schema/sc_obtenerRefCluster.json')

  @refClustersConFiltro
  Scenario: Consultar Ref Clusters con parámetros válidos
    Given url baseUrl
    And param limit = 1000
    And param page = 1
    And param name = 'string'
    And param label = 'string'
    And param refClusterStatus = 0
    And param regionId = 0
    And param idCluster = 1
    When method GET
    Then status 200
    And match response.success == true
    And match response.data.data[0].name == 'string'
    And match response.data.data[0].label == 'string'
    * def responseText = karate.pretty(response)
    * def isValid = schemaUtil.isValid(schemaText, responseText)
    * match isValid == true
    And print 'Consulta exitosa de Ref Clusters:', response
    And print response
    And print '=== TIEMPO DE RESPUESTA ===', responseTime / 1000, 's'

  @refClustersValido
  Scenario: Obtener Ref Clusters sin filtros
    Given url baseUrl
    And param limit = 1000
    And param page = 1
    When method GET
    Then status 200
    And match response.success == true
    And match response.data.data == '#array'
    * def responseText = karate.pretty(response)
    * def isValid = schemaUtil.isValid(schemaText, responseText)
    * match isValid == true
    And print 'Consulta sin filtros exitosa:', response
    And print '=== TIEMPO DE RESPUESTA ===', responseTime / 1000, 's'
