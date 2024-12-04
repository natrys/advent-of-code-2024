(var flag true)

(def grammar1
  ~{:mul (replace (sequence "mul(" :num "," :num ")") ,*)
    :num (replace ':d+ ,parse)
    :main (sequence (some (choice :mul 1)) -1)
   })

(def grammar2
  ~{:mul (cmt (sequence "mul(" :num "," :num ")") ,(fn [a b] (and flag (* a b))))
    :num (replace ':d+ ,parse)
    :on (cmt "do()" ,|(do (set flag true) nil))
    :off (cmt "don't()" ,|(set flag false))
    :main (sequence (some (choice :on :off :mul 1)) -1)
   })

(defn run (input part)
  (let [grammar (peg/compile (if (= part 1) grammar1 grammar2))]
    (->> input
         (peg/match grammar)
         (sum)
         (printf "Part%d: %d" part))))

(defn main [&]
  (let [input (file/read stdin :all)]
    (run input 1)
    (run input 2)))
