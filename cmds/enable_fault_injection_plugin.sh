# Injecting an HTTP delay fault

# In the first example, we introduce a 5-second delay for every request 
# to the product service to test if we correctly set a connection timeout 
# for calls to the product service from the Catalog service.

curl http://127.0.0.1:9080/apisix/admin/routes/1 \
-H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' -X PUT -d '
{
  "name": "Route for Fault Injection with the delay",
  "methods": [
    "GET"
  ],
  "uri": "/get",
  "plugins": {
    "fault-injection": {
      "delay": {
        "duration": 5,
        "percentage": 100
      }
    }
  },
  "upstream_id": "1"
}'

# Below we confirm the rule was created by running another curl command with the time measurement:

time curl http://127.0.0.1:9080/get

# Injecting an HTTP abort fault

# Now we can enable abort injection with the following route settings.

curl http://127.0.0.1:9080/apisix/admin/routes/1 \
-H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' -X PUT -d '
{
  "name": "Route for Fault Injection with the abort",
  "methods": [
    "GET"
  ],
  "uri": "/get",
  "plugins": {
    "fault-injection": {
      "abort": {
        "http_status": 503,
        "body": "The product service is currently unavailable.",
        "percentage": 100
      }
    }
  },
  "upstream_id": "1"
}'

# If you run curl cmd to hit the APISIX route, now it quickly responds 
# with HTTP 503 error which in turn very comfortable 
# to test catalog service how it reacts to such kind of server errors from downstream services.

curl  http://127.0.0.1:9080/get -i

HTTP/1.1 503 Service Temporarily Unavailable
Content-Type: text/plain; charset=utf-8
Transfer-Encoding: chunked
Connection: keep-alive
Server: APISIX/2.13.1