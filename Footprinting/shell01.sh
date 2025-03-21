#!/bin/bash
echo "Entrez votre nom de domaine : "
read Domaine

if [ -z "$Domaine" ]; then
    echo "Aucun domaine entré. Veuillez recommencer."
    exit 1
fi

if ! ping -c 1 -W 2 "$Domaine" &> /dev/null; then
    echo "❌ Le domaine '$Domaine' n'existe pas ou ne répond pas."
    exit 1
fi

RechInfos="footprinting_$Domaine"
    mkdir -p "$RechInfos"

    chmod u+rwx "$RechInfos"

cmd_exists() {
    command -v "$1" &> /dev/null
}

footprink() {
    local cmd="$1"
    local file="$RechInfos/$2"
    local label="$3"

    if [ ! -w "$RechInfos" ]; then
        echo "Les permissions du répertoire $RechInfos ne permettent pas d'écrire dans les fichiers."
        exit 1
    fi

    if cmd_exists $(echo "$cmd" | awk '{print $1}'); then
        echo " $cmd"
        $cmd &> "$file"
        chmod u+rw "$file"
        local first_line=$(head -n 1 "$file" 2>/dev/null)
        printf "| %-15s | %-50s |\n" "$label" "$first_line"
    else
        printf "| %-15s | %-50s |\n" "$label" "❌ Commande non installée"
    fi
}

      # echo " recherche  en cours pour : $Domaine"
       echo "  -----------------------------------------------------"
       printf "| %-15s | %-50s  | \n" "Test" "description"
       echo "  -----------------------------------------------------"

      footprink "whois    $Domaine" "whois.txt" "WHOIS"
      footprink "nslookup $Domaine" "nslookup.txt" "NSLOOKUP"
      footprink "dig      $Domaine "ANY "dig.txt" "DIG"
      footprink "traceroute $Domaine" "traceroute.txt" "TRACEROUTE"
      footprink "host -a  $Domaine" "host.txt" "HOST"
      echo "-------------------------------------------------------"
      echo "✅ recheche  terminée !  vos information est enregistrées dans : $RechInfos"
