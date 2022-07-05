curl http://127.0.0.1:9080/apisix/admin/routes/1 -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' -X PUT -d '
{
    "uri":"/get",
    "plugins":{
        "ext-plugin-pre-req":{
            "conf":[
                {
                    "name":"TokenValidator",
                    "value":"{\"validate_header\":\"token\",\"validate_url\":\"https://www.sso.foo.com/token/validate\",\"rejected_code\":\"403\"}"
                }
            ]
        }
    },
    "upstream_id": "1"
}'