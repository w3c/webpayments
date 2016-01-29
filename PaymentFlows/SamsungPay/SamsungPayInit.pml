@startuml
Autonumber

participant User
participant "SamsungPay App" as SPA
participant "SamsungPay Server" as SPS
participant "Token Service Provider" as CI
participant "Card Issuer (Bank)" as B

title SamsungPay Initialization Process (unofficial)

opt User Registration
User<->SPA: launch SamsungPay App
SPA<->SPS: login with SamsungPay Account
end
opt Adding Card
User<->SPA: launch SamsungPay App
opt OCR read via Camera
SPA->SPA: OCR read credit card via Camera
end
SPA->SPA: key-in/confirm Card Info
SPA->SPA: set user's fingerprint
SPA->SPS: send credit card info as encrypted
SPS->SPS: decrypt card info
SPS->CI: send credit card info as re-encrypted

CI<->B: Tokenization Auth Request


CI->CI: generate token
CI->SPS: send token
SPS->SPA: send token
SPA->SPA: store card token into trust zone \nof Knox Sandbox\n (can be active or inactive)

opt auth user (e.g. via OTP)/ activate token
CI->CI: generate activation code
CI->B: activ code
B->User: send token activation code
User->SPA: input code
SPA->SPS:
SPS->CI:
CI->CI: validate activation code
CI->CI: activate token
CI->SPS: notify token status change
SPS->SPA: notify token status change

end

end






@enduml
