# Naamgeving
- De naam van de servers bestaat uit de `best-server-[1]`
- De naam van de container moet hetzelfde zijn als in de `variables.env` file `[containernaam]service`

## Aanmaken van instances
- Gebruik de EC2-service om de instances aan te maken.
- Maak 4 instances aan waarop telkens maximaal 3 services mogen runnen.
- Kies als OS Amazon Linux 2023.
- Gebruik als hardware t2.micro.
- Maak een nieuwe security groep aan en noem deze `best-security` voor extra veiligheid.
- Maak een nieuwe security key aan. Kies voor een `.pem`-bestand met RSA-encryptie en noem het `best-key`.
- Bij het netwerkgedeelte kies je de default VPC en enable je SSH. In plaats van 'from anywhere' kies je 'my IP'.
- Maak de instances.

## Namen van servers aanpassen
- Geef elke server een unieke naam zoals gespecificeerd in het stuk Naamgeving.

## Inbound rules security group aanpassen
- Voeg de volgende regels toe:
  - HTTP voor poort 8080 van alle IP-adressen.
  - Alle verkeer is toegestaan voor de security groep.

## SSH naar server
- Pas de rechten aan van je `.pem`-bestand.
  - `chmod 400 naam_key`.
  - Het is een best practice om alleen de eigenaar van de key leesrechten te geven. Dit verhoogt de veiligheid.
- Gebruik de publieke DNS om verbinding te maken met de instance.
  - `ssh -i "vockey.pem" ec2-user@ec2-54-221-150-146.compute-1.amazonaws.com`.
  - Vul 'yes' in.

## Configuratie server
- Clone eerst deze GitHub repo naar je lokale machine.
  - `git clone https://github.com/NielsVerhoevenPXL/online-boutique.git`.
- Kopieer nu de `scripts` directory naar iedere instance.
  - `scp -r -i "vockey.pem" ./scripts ec2-user@ec2-54-221-150-146.compute-1.amazonaws.com:~`.
- Run nu het `general-config` script.
  - `sudo ./general-config.sh`.
  - Als het script klaar is, typ je `logout`.
  - SSH nu terug naar de instance.
- Pas de inhoud van de `ips` file aan.
  - In deze file zitten de private IP-adressen van servers.
  - Volgorde is belangrijk (server1 op de eerste regel, enz.).
  - Zorg dat de file eindigt in een blanco lijn, anders werkt het niet.
- Run het `best-server[1-4]-config.sh` script op de correcte server.
  - **BELANGRIJK**: Zorg dat je in de scripts-folder staat als je een `best-server`-script runt. Dit is nodig zodat het `variables.env`-bestand en `ips`-bestand gevonden kunnen worden.
  - **BELANGRIJK**: Enkel het script met `best-server4-config` moet met `sudo` gerund worden. Dit komt omdat hier nog git geïnstalleerd moet worden om de loadgenerator te bouwen.
  - `./best-server1-config.sh`.
  - Het script runt de containers en voegt de IP-adressen en servicenamen toe aan de `/etc/hosts` file van de container. Hierdoor kan de container communiceren met containers die zich bevinden op andere instances.
