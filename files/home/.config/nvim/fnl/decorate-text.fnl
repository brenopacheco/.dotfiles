(local M {})

; $ echo -e "\e[1m\e[0m" | xxd
; 00000000: 1b5b 316d 1b5b 306d 0a
;
; bold:         "\e[1m TEXT \e[0m"
; italic:       "\e[3m TEXT \e[0m"
; underscore    "\e[4m TEXT \e[0m"
; strikethrough "\e[9m TEXT \e[0m"

(fn merge [& args] ; args is [...]
  "usage: (merge [1 2] [3] [4 5])"
  (let [list []]
    (each [_ arg (ipairs args)]
      (each [_ v (ipairs arg)] (table.insert list v)))
    list))

(λ fmt [prefix_bytes suffix_bytes]
  (local map* (fn [list fun]
                (icollect [_ v (ipairs list)] (fun v))))
  (let [prefix_str (map* prefix_bytes string.char)
        suffix_str (map* prefix_bytes string.char)]
    (fn [msg]
      (table.concat (merge prefix_str [msg] suffix_str) ""))))

;; fnlfmt: skip
(do
  (tset M :bold (fmt [0x1b 0x5b 0x31 0x6d] [0x1b 0x5b 0x30 0x6d]))
  (tset M :italic (fmt [ 0x1b 0x5b 0x33 0x6d ] [ 0x1b 0x5b 0x30 0x6d ]))
  (tset M :underscore (fmt [ 0x1b 0x5b 0x34 0x6d ] [ 0x1b 0x5b 0x30 0x6d ]))
  (tset M :strikethrough (fmt [ 0x1b 0x5b 0x39 0x6d ] [ 0x1b 0x5b 0x30 0x6d ])))

; see: /usr/share/nvim/runtime/lua/vim/_editor.lua:605

M
