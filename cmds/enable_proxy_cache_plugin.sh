curl "http://127.0.0.1:9080/apisix/admin/routes/1" -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" -X PUT -d ' 
{
 "name": "Route for API Caching",
 "methods": ["GET"], 
 "uri": "/get", 
 "plugins": {
 "proxy-cache": {
 "cache_key": ["$uri", "-cache-id"],
 "cache_bypass": ["$arg_bypass"],
 "cache_method": ["GET"],
 "cache_http_status": [200],
 "hide_cache_headers": true,
 "no_cache": ["$arg_test"]
 }
 }, 
 "upstream_id": 1
}'

# Test the plugin
curl http://localhost:9080/get -i

# The response looks like as below:
HTTP/1.1 200 OK
…
Apisix-Cache-Status: MISS

# When you do the next call to the service, the route responds to the request with a cached response since it has already cached in the previous request:

HTTP/1.1 200 OK
…
Apisix-Cache-Status: HIT