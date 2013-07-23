# Description:
#   ElasticSearch Operations
#
# Dependencies:
#
# Configuration:
#
# Commands:
#   hubot elasticsearch status - Lists status of all clusters (name, health, value)
#   hubot elasticsearch list locks - Lists all current locks
#   hubot elasticsearch lock - Lock ElasticSearch
#   hubot elasticsearch unlock - Remove ElasticSearch lock
#   hubot elasticsearch override <cluster|delete> - Overrides shuffler to cluster, or deletes override
# 
# Author:
#   Gaurav Ragtah @gragtah

user = process.env.SEXY_API_USER
password = process.env.SEXY_API_PASSWORD || ''

module.exports = (robot) ->
  robot.respond /elasticsearch status$/i, (msg) ->
    msg.http("http://api.internal.klout.com/elasticsearch.json/status").auth(user, password).get() (err, res, body) ->
      msg.send body

  robot.respond /elasticsearch list locks$/i, (msg) ->
    msg.http("http://api.internal.klout.com/elasticsearch.json/locks").auth(user, password).get() (err, res, body) ->
      msg.send body

  robot.respond /elasticsearch lock$/i, (msg) ->
    msg.http("http://api.internal.klout.com/elasticsearch.json/lock/create").auth(user, password).get() (err, res, body) ->
      msg.send body

  robot.respond /elasticsearch unlock$/i, (msg) ->
    msg.http("http://api.internal.klout.com/elasticsearch.json/lock/delete").auth(user, password).get() (err, res, body) ->
      msg.send body

  robot.respond /elasticsearch override ([^ ]+)$/i, (msg) ->
    overrideChoice = msg.match[1]
    msg.http("http://api.internal.klout.com/elasticsearch.json/setOverride/#{overrideChoice}").auth(user, password).get() (err, res, body) ->
      msg.send body
