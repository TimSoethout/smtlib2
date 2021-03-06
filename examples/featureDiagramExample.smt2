(declare-const car_automatic Bool)
(declare-const car_pulls Bool)
(declare-const car_mediumPower Bool)
(declare-const car_electric Bool)
(declare-const car_Car Bool)
(declare-const car_Transmission Bool)
(declare-const car_manual Bool)
(declare-const car_HorsePower Bool)
(declare-const car_highPower Bool)
(declare-const car_lowPower Bool)
(declare-const car_combustion Bool)
(declare-const car_Engine Bool)
(declare-const car_body Bool)

(assert (=> car_Car (and car_body car_Engine car_Transmission car_HorsePower )))
(assert (=> car_Engine (or car_combustion car_electric)))
(assert (=> car_Transmission (or (and car_manual (not car_automatic)) (and (not car_manual) car_automatic))))
(assert (=> car_HorsePower (or (and car_lowPower (not car_mediumPower) (not car_highPower)) (and (not car_lowPower) car_mediumPower (not car_highPower)) (and (not car_lowPower) (not car_mediumPower) car_highPower))))

(assert (=> car_pulls car_highPower))

(assert car_pulls)
(assert car_Car)

(check-sat)
(get-model)