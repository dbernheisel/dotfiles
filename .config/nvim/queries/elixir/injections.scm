; Comments
((comment) @injection.content
 (#set! injection.language "comment"))

; Documentation
(unary_operator
  operator: "@"
  operand: (call
    target: ((identifier) @_identifier (#any-of? @_identifier "moduledoc" "typedoc" "shortdoc" "doc"))
    (arguments [
      (string (quoted_content) @injection.content)
      (sigil (quoted_content) @injection.content)
    ])
    (#set! injection.language "markdown")))

; Sigils
(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
 (#eq? @_sigil_name "GQL")
 (#set! injection.language "graphql"))

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
 (#eq? @_sigil_name "SQL")
 (#set! injection.language "sql"))

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
 (#eq? @_sigil_name "YAML")
 (#set! injection.language "yaml"))

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
 (#eq? @_sigil_name "HTML")
 (#set! injection.language "html"))

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
 (#any-of? @_sigil_name "z" "Z")
 (#set! injection.language "zig"))

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
 (#any-of? @_sigil_name "E" "L")
 (#set! injection.language "eex"))

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
 (#eq? @_sigil_name "F")
 (#set! injection.language "surface"))

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
 (#any-of? @_sigil_name "R" "r")
 (#set! injection.language "regex"))

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
 (#any-of? @_sigil_name "LVN" "H")
 (#set! injection.language "heex"))

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
 (#any-of? @_sigil_name "j" "J" "JSON")
 (#set! injection.language "jsonc"))
