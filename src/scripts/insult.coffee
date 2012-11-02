# Description:
#   Tell hubot to insult a co-worker
#
# Dependencies:
#
# Configuration:
#
# Commands:
#   hubot insult <name> - Hubot insults this person. They then feel bad.

module.exports = (robot) ->
  robot.respond /insult (.*)/i, (msg) ->
    target = escape(msg.match[1])
    msg.http("http://quandyfactory.com/insult/json")
      .get() (err, res, body) ->
        data = JSON.parse(body)
        insult = data["insult"]
        msg.send "#{target} #{insult}"
