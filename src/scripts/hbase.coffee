# Description:
#   HBase Operations
#
# Dependencies:
#
# Configuration:
#
# Commands:
#   hubot hbase list locks - Lists all current locks
#   hubot hbase list overrides - Lists current shuffler overrides
#   hubot hbase list clusters - Lists discovered clusters
#   hubot hbase list queue <cluster> - Lists a clusters task queue
#   hubot hbase list <cluster> nodes - Lists discovered nodes in a cluster
#   hubot hbase list <cluster> tables - Lists discovered tables in a cluster
#   hubot hbase list <cluster> <table> - Lists a clusters table status (compaction)
#   hubot hbase lock - Lock HBase for maintenance. No loads during this time
#   hubot hbase unlock - Unlock HBase maintenance lock
#   hubot hbase compact <cluster> <table> - Minor compacts table in cluster
#   hubot hbase compact <cluster> <table> major - Major compacts table in cluster
#   hubot hbase override <cluster|delete> - Overrides shuffler to cluster, or deletes override

module.exports = (robot) ->
  robot.respond /hbase list locks/i, (msg) ->
    msg.http("http://hbase-api.klout:9091/api/locks").get() (err, res, body) ->
        data = JSON.parse(body)
        msg.send JSON.stringify(data)

  robot.respond /hbase list clusters/i, (msg) ->
    msg.http("http://hbase-api.klout:9091/api/clusters").get() (err, res, body) ->
        data = JSON.parse(body)
        msg.send JSON.stringify(data)

  robot.respond /hbase list overrides$/i, (msg) ->
    try
      msg.http("http://hbase-api.klout:9091/api/override").get() (err, res, body) ->
          data = JSON.parse(body)
          msg.send JSON.stringify(data)
    catch error
      msg.send "Error: #{error}"

  robot.respond /hbase list ([^ ]+) nodes$/i, (msg) ->
    cluster = msg.match[1]
    msg.http("http://hbase-api.klout:9091/api/nodes/#{cluster}").get() (err, res, body) ->
        data = JSON.parse(body)
        msg.send JSON.stringify(data)

  robot.respond /hbase list tables ([^ ]+)/i, (msg) ->
    cluster = msg.match[1]
    msg.http("http://hbase-api.klout:9091/api/tables/#{cluster}").get() (err, res, body) ->
        table_list = ""
        tables = JSON.parse(body)
        for t in tables[cluster]
            table_list = table_list + t + "\n"
        msg.send "Tables for #{cluster}\n-----\n#{JSON.stringify(tables)}"

  robot.respond /hbase lock/i, (msg) ->
    msg.http("http://hbase-api.klout:9091/api/locks/create").get() (err, res, body) ->
        data = JSON.parse(body)
        msg.send JSON.stringify(data)

  robot.respond /hbase unlock/i, (msg) ->
    msg.http("http://hbase-api.klout:9091/api/locks/delete").get() (err, res, body) ->
        data = JSON.parse(body)
        msg.send JSON.stringify(data)

  robot.respond /hbase compact ([^ ]+) ([^ ]+$)/i, (msg) ->
    cluster = msg.match[1]
    table = msg.match[2]
    try
      msg.http("http://hbase-api.klout:9091/api/compact/#{cluster}/#{table}").get() (err, res, body) ->
          data = JSON.parse(body)
          msg.send JSON.stringify(data)
    catch error
      msg.send "Error: #{error}"

  robot.respond /hbase list queue ([^ ]+)$/i, (msg) ->
    cluster = msg.match[1]
    try
      msg.http("http://hbase-api.klout:9091/api/queue/#{cluster}").get() (err, res, body) ->
          data = JSON.parse(body)
          msg.send JSON.stringify(data)
    catch error
      msg.send "Error: #{error}"

  robot.respond /hbase compact ([^ ]+) ([^ ]+) major/i, (msg) ->
    cluster = msg.match[1]
    table = msg.match[2]
    try
      msg.http("http://hbase-api.klout:9091/api/compact/#{cluster}/#{table}/True").get() (err, res, body) ->
          data = JSON.parse(body)
          msg.send JSON.stringify(data)
    catch error
      msg.send "Error: #{error}"

  robot.respond /hbase override ([^ ]+)$/i, (msg) ->
    cluster = msg.match[1]
    try
      msg.http("http://hbase-api.klout:9091/api/override/#{cluster}").get() (err, res, body) ->
          data = JSON.parse(body)
          msg.send JSON.stringify(data)
    catch error
      msg.send "Error: #{error}"
