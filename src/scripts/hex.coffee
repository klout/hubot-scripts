# Description:
#   Convert an ip adddress to hexidecimal
#
# Dependencies:
#
# Configuration:
#
# Commands:
#   hubot hex <ip_address> - converts ip address to hex

decimalToHex = (d, padding) ->
  hex = Number(d).toString(16)
  padding = (if typeof (padding) is "undefined" or padding is null then padding = 2 else padding)
  hex = "0" + hex  while hex.length < padding
  hex.toUpperCase()

module.exports = (robot) ->
  robot.respond /hex (.*)/i, (msg) ->
    ipaddress = escape(msg.match[1])

    ip = ipaddress.split "."
    msg.send decimalToHex(ip[0]) + decimalToHex([1]) + decimalToHex(ip[2]) + decimalToHex(ip[3])
