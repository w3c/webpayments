@startuml
Autonumber

participant User
participant "SamsungPay App" as SPA
participant "SamsungPay Server" as SPS
participant "Card Issuer" as CI
participant Bank as B

title SamsungPay Initialization Process (unofficial)

opt User Registration
User<->SPA: launch SamsungPay App
SPA<->SPS: login with SamsungPay Account
end
opt Adding Credit Card
User<->SPA: launch SamsungPay App
opt OCR read via Camera
SPA->SPA: OCR read credit card via Camera
end
SPA->SPA: key-in Credit Card Info
SPA->SPA: confirm card info
SPA->SPA: set user's fingerprint
SPA->SPS: send credit card info as encrypted
SPS->SPS: decrypt card info
SPS->CI: send credit card info as re-encrypted
SPA<->CI: get agreement
SPA<->CI: authenticate user
SPA<->CI: retrieve user signature
CI->SPS: send token auth code
SPS->SPS: store token auth code
CI->SPA: send card token
SPA->SPA: store card token into trust zone \nof Knox Sandbox
end
@enduml
