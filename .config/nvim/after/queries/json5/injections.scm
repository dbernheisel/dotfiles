; extends

(member
  name: (string) @_scripts_key
  value: (object
    (member
      value: (string) @injection.content
      (#set! injection.language "bash")
      (#offset! @injection.content 0 1 0 -1)))
  (#eq? @_scripts_key "\"scripts\""))
