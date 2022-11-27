wrk.method = "POST"
wrk.body = '{}'
wrk.headers["Content-Type"] = "application/json"
wrk.headers["example-token"] = "Bearer xxxxxxx---xxxx---xxxrRxcbS0FrZo_vnzysg"

function request()
  return wrk.format('POST', nil, nil, body)
end
