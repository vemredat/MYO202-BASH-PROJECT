#!/bin/bash
# İsim Soyisim: Vedat Emre KESKİN
# Öğrenci Numarası:2420171020
# Docker Temelleri : https://www.btkakademi.gov.tr/portal/certificate/validate?certificateId=qKrhe9Ee8j
# Siber Güvenlikte Linux İşletim Sistemleri : https://www.btkakademi.gov.tr/portal/certificate/validate?certificateId=mKEhkMAgkE
# Linux Bash Script Eğitimi : https://credsverse.com/credentials/7d0d9036-f1e2-452f-a992-4007a266f455


#!/bin/bash

#!/bin/bash

LOG_DOSYASI="report.log"

date +"%Y-%m-%dT%H:%M:%S%z" > "$LOG_DOSYASI"
echo "----------------------------------------" >> "$LOG_DOSYASI"

OS_TYPE="$(uname -s)"
case "${OS_TYPE}" in
    MINGW*|CYGWIN*|MSYS*|Linux*)
        echo "--- Windows Donanim Bilgileri ---" >> "$LOG_DOSYASI"
        
        echo "Islemci:" >> "$LOG_DOSYASI"
        wmic cpu get name 2>&1 | grep -v "^$" | tr -d '\r' >> "$LOG_DOSYASI"
        
        echo "RAM:" >> "$LOG_DOSYASI"
        wmic memorychip get capacity 2>&1 | grep -v "^$" | tr -d '\r' >> "$LOG_DOSYASI"
        
        echo "Anakart:" >> "$LOG_DOSYASI"
        wmic baseboard get product,Manufacturer 2>&1 | grep -v "^$" | tr -d '\r' >> "$LOG_DOSYASI"
        
        echo "Disk UUID:" >> "$LOG_DOSYASI"
        wmic csproduct get uuid 2>&1 | grep -v "^$" | tr -d '\r' >> "$LOG_DOSYASI"
        
        echo "MAC Adresi:" >> "$LOG_DOSYASI"
        getmac 2>&1 | grep -v "^$" | tr -d '\r' >> "$LOG_DOSYASI"
        ;;
    Darwin*)
        echo "--- macOS Donanim Bilgileri ---" >> "$LOG_DOSYASI"
        system_profiler SPHardwareDataType >> "$LOG_DOSYASI"
        system_profiler SPMemoryDataType | grep "Size" >> "$LOG_DOSYASI"
        ifconfig | grep "ether" >> "$LOG_DOSYASI"
        ;;
    *)
        echo "Bilinmeyen isletim sistemi: ${OS_TYPE}" >> "$LOG_DOSYASI"
        ;;
esac

echo ""
read -p "Şifreleme işlemini başlatmak için parolayı (MYO+202) tuşlayın: " PAROLA
echo ""

echo "$PAROLA" | gpg --batch --yes --passphrase-fd 0 --symmetric --cipher-algo AES256 -o report.log.gpg "$LOG_DOSYASI"

rm "$LOG_DOSYASI"

echo "Donanım verileri alındı ve başarıyla kriptolandı."