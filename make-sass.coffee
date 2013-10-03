fs = require "fs"

webkit = fs.readFileSync("webkit.txt").toString().split("\n")
opera  = fs.readFileSync("opera.txt").toString().split("\n")
moz    = fs.readFileSync("mozilla.txt").toString().split("\n")
ms     = fs.readFileSync("microsoft.txt").toString().split("\n")

webkit_regex = /^-webkit-(.*)$/
opera_regex  = /^-o-(.*)$/
moz_regex    = /^-moz-(.*)$/
ms_regex     = /^-ms-(.*)$/

prop = {}

for p in webkit
  m = webkit_regex.exec(p)
  prop[m[1]] ?= []
  prop[m[1]].push("-webkit-")

for p in opera
  m = opera_regex.exec(p)
  prop[m[1]] ?= []
  prop[m[1]].push("-o-")

for p in moz
  m = moz_regex.exec(p)
  prop[m[1]] ?= []
  prop[m[1]].push("-moz-")

for p in ms
  m = ms_regex.exec(p)
  prop[m[1]] ?= []
  prop[m[1]].push("-ms-")

output = ""

for key, val of prop
  s =  "@mixin #{key}($arguments...) {\n"
  for prefix in val
    s += "  #{prefix}#{key}: $arguments;\n"
  s += "  #{key}: $arguments;\n"
  s += "}\n\n"
  output += s

fs.writeFileSync("vendor.scss", output, "utf-8")

output = ""

for key, val of prop
  s =  ".#{key}() {\n"
  for prefix in val
    s += "  #{prefix}#{key}: @arguments;\n"
  s += "  #{key}: @arguments;\n"
  s += "}\n\n"
  output += s

console.log output

fs.writeFileSync("vendor.less", output, "utf-8")

output = ""

for key, val of prop
  s =  "#{key}()\n"
  for prefix in val
    s += "  #{prefix}#{key}: @arguments\n"
  s += "  #{key}: @arguments\n"
  s += "\n\n"
  output += s

fs.writeFileSync("vendor.styl", output, "utf-8")

