# Stellantis firewall REST API

This page describes the specifications for the Stellantis REST API needed to attach standalone networks to the Palo
Alto firewalls.

## Generalities

* API baseURL: `https://api-basic-preprod.groupe-psa.com/applications/toolbox-eoop/awspan/v1`
* Mandatory headers:
    * `Authorization: Basic ...`
    * `Content-Type: application/json`
    * `X-IBM-Client-ID: ...`

## Application resource

## Creation

This resource is used to retrieve an existing configuration in the Palo Alto FW.

* Request
   * POST to `{baseUrl}/endpoint`
   * Body:

      ```json
      {
        "id": "{RegionId},{AppId},{AWSAccountId},{ZoneId}",
        "vpce": "{vpce1},{vpce2},{vpce3}"
      }
      ```

* Response
   * Return code `201` 
   * `Location` header with the created object URL

## Read

This resource is used to retrieve an existing configuration from the Palo Alto FW.

* Request
   * GET from `{baseUrl}/endpoint/{id}`
      * `{id}` is the configuration id to retrieve (same id used for creation)
   * No body
* Response
   * Return code 
      * `200` if found
      * `404` if not found
   * Body

      ```json
      {
        "id": "{RegionId},{AppId},{AWSAccountId},{ZoneId}",
        "vpce": "{vpce1},{vpce2},{vpce3}"
      }
      ```

## Update

Not implemented at the moment

## Delete

This resource is used to delete an existing configuration in the Palo Alto FW.

* Request
   * DELETE to `{baseUrl}/endpoint/{id}`
     * `{id}` is the configuration id to delete
   * No body
* Response
   * Return code
      * `200` if found and deleted
      * `404` if not found
   * Body (if possible):

      ```json
      {
        "id": "{RegionId},{AppId},{AWSAccountId},{ZoneId}"
      }
      ```
