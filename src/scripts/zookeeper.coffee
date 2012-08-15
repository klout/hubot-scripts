# Description:
#   Run ZooKeeper commands on the Harmony cluster
#
# Dependencies:
#   "zookeeper": ">= 3.4.0",
#
# Configuration:
#   HUBOT_ZOOKEEPER_URL
#
# Commands:
#   hubot harmony ls <path> - lists the path
#   hubot harmony get <path> - gets the path
#   hubot harmony set <path> <data> - Sets the value of the path to data
#   hubot harmony delete <path> - deletes the path
#   hubot harmony create <path> <data> - creates the path with data

ZooKeeper = require ("zookeeper");

module.exports = (robot) ->
  robot.respond /harmony (get|set|create|delete|ls|hbase) (.*)/i, (msg) ->
    quorum = process.env.HUBOT_ZOOKEEPER_URL
    action = escape(msg.match[1])
    args = escape(msg.match[2])

    if robot.Auth.hasRole(msg.message.user.name, 'zookeeper_admin')
      zk = new ZooKeeper(
        connect: quorum
        timeout: 200000
        debug_level: ZooKeeper.ZOO_LOG_LEVEL_WARNING
        host_order_deterministic: false
        data_as_buffer: false
      )

      zk.connect (err) ->
        msg.send "Unable to connect to Harmony" if err
        console.log "zk session established, id=%s", zk.client_id
        switch action
          when "get"
            zk.a_get "#{args}", false, (rc, error, stat, data) ->
              unless rc is 0
                msg.send "Harmony Result: #{error}"
              else
                msg.send "Harmony Result: #{data}"
                process.nextTick ->
                  zk.close()
          when "set"
            zk.a_set "#{args}", 1, (rc, error, stat) ->
              unless rc is 0
                msg.send "Harmony Result: #{error}"
              else
                msg.send "Harmony Result: #{stat}"
                process.nextTick ->
                  zk.close()
          when "create"
            opts = args.split('%20')
            if opts.length is not 2
              msg.send "Harmony Result: Error, please specify a path and value"
              return
            zk.a_create opts[0], opts[1], 0 , (rc, error, path) ->
              unless rc is 0
                msg.send "Harmony Result: #{error}"
              else
                msg.send "Harmony Result: Created zk node #{opts[0]}"
                process.nextTick ->
                  zk.close()
          when "delete"
            zk.a_delete_ args, 0, (rc, error) ->
              unless rc is 0
                msg.send "Harmony Result: #{error}"
              else
                msg.send "Harmony Result: Deleted zk node #{args}"
          when "ls"
            zk.a_get_children "#{args}", false, (rc, error, children) ->
              unless rc is 0
                msg.send "Harmony Result: #{error}"
              else
                msg.send "Harmony Result: #{children}"
                process.nextTick ->
                  zk.close()
          when "hbase"
            zk.a_get "/Health/HBase/#{args}", false, (rc, error, stat, data) ->
              unless rc is 0
                msg.send "#{args}: #{error}"
              else
                msg.send "#{args}: #{data}"
                process.nextTick ->
                  zk.close()
          when "delete"
            zk.a_delete_ args, 0, (rc, error) ->
              unless rc is 0
                msg.send "Harmony Result: #{error}"
              else
                msg.send "Harmony Result: Created zk node #{args}"
                process.nextTick ->
                  zk.close()
    else
      msg.send "Unauthorized"
