local http = require "socket.http"
local https = require "ssl.https"
local cjson_safe = require "cjson.safe"
local urlmodule = require "socket.url"
local ltn12 = require "ltn12"
local socket = require "socket"

function get_cache_key(token_url, client_id, scope)
    return "upstream_oauth2_token_" .. token_url .. "_" .. client_id .. "_" .. (scope or "")
end

function get_access_token(url, client_id, client_secret, grant_type, scope)
    local parsed = urlmodule.parse(url)
    local request

    if parsed.scheme == "https" then
        request = https.request
    else
        request = http.request
    end

    local req_body =
        ngx.encode_args(
        {
            grant_type = grant_type,
            client_id = client_id,
            client_secret = client_secret,
            scope = scope
        }
    )

    local res_body = {}

    local ok, status =
        request(
        {
            method = "POST",
            source = ltn12.source.string(req_body),
            headers = {
                ["Content-Length"] = tostring(#req_body),
                ["Content-Type"] = "application/x-www-form-urlencoded"
            },
            url = url,
            port = parsed.port,
            sink = ltn12.sink.table(res_body)
        }
    )

    local res_body = table.concat(res_body)
    local res_json, err = cjson_safe.decode(res_body)

    if not res_json then
        return {
            status = status,
            error = "Can't get tokens: bad json response",
            response = res_body
        }
    end
    if status == 200 then
        return {
            access_token = res_json.access_token,
            expires_at = res_json.expires_in and tonumber(res_json.expires_in) + socket.gettime()
        }
    end
    return {status = status, error = "Can't get tokens: bad response code", response = res_json}
end

return {
    get_access_token = get_access_token,
    get_cache_key = get_cache_key
}
