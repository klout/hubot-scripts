# Description:
#   ElasticSearch Operations
#
# Dependencies:
#
# Configuration:
#
# Commands:
#   hubot elasticsearch status - Lists status of all clusters
#   hubot elasticsearch list locks - Lists all current locks
#   hubot elasticsearch list overrides - Lists current shuffler overrides
#   hubot elasticsearch lock - Lock HBase for maintenance. No loads during this time
#   hubot elasticsearch unlock - Unlock HBase maintenance lock
#   hubot elasticsearch override <cluster|delete> - Overrides shuffler to cluster, or deletes override
# 
# Author:
#   Gaurav Ragtah @gragtah

user = process.env.SEXY_API_USER
password = process.env.SEXY_API_PASSWORD || ''

module.exports = (robot) ->
  robot.respond /elasticsearch list locks/i, (msg) ->
    msg.http("http://api.internal.klout.com/elasticsearch.json/locks").auth(user, password).get() (err, res, body) ->
      msg.send body
