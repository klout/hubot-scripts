# Maxwell Score load status
time = require("time")

module.exports = (robot) ->
  robot.respond /maxwell (.*)/i, (msg) ->
    action = escape(msg.match[1])
    user = "klout"
    pass = "pimpmyride"
    auth = 'Basic ' + new Buffer(user + ':' + pass).toString('base64')
    msg.http("http://beta.api.klout.com/maxwell.json/state")
      .headers(Authorization: auth, Accept: 'application/json')
      .get() (err, res, body) ->
        data = JSON.parse(body)
        epoch = parseInt(data["scoreTimestamp"])
        d = new time.Date(epoch)
        d.setTimezone "America/Los_Angeles"
        msg.send "Loaded: #{d.toString()}"
