Huom! Kaikki testit on toteuttu seuraavanlaisella koneella: Windows 10 OS:llä, Google Chrome selaimella ja koneena on toiminut Legion 5 kannettava. 16Gt RAM, AMD Ryzen 7 5800H, NVIDIA Geforce 3070 ja 200GB vapaata levytilaa SSD-levyasemalla.
# H7 - This one ugly baby

Tarkoituksena olisi saada RSS-aineiston lukija tai sen mahdollistava moduulikokonaisuus aikaiseksi.

Masteriin .sls-muodostettavaa koodia

Tarvitaan python sekä pip
    sudo apt-get install python3
    sudo apt install -y python3-pip

Pipin asentuminen antaa mahdollisuudet asentaa feedparserin tarvitsemia osio pythonista.
Rawdog sivun mukaan tarvittaisiin 


Tarvitaan pytidylib ilman sls:ää: pip3 install pytidylib
Tarvitaan feedparser ilman sls:ää: pip3 install feedparser
Tarvitaan rawdog

Voi olla ajallisesti ja tämän hetkisen osaamisen valossa parempi toteuttaa python ohjelmoinnin mahdollistava toteutus.
Erikoisemmaksi sen tekisi, jos onnistuisin toteuttamaan oletuksellisen "Environments" kansion tai koodin, jota käyttäjä voi muokata, johon oletuksellinen ensimmäinen tila asetetaan.

## Tavoitteet

## Tarvittavat ohjelmat

Jotta loppu tulemaan päästäisiin tarvitset Windowsilla Powershellin, jonka voit ajaa admin-oikeuksilla.
Vagrant-ohjelmistopaketin
Salt-ohjelmistopaketin

## Aloitetaan alusta

Kun tarvittavat ohjelmat ovat asennettuna, voidaan muodostaa kansiorakenteellinen polku, jonne aloitetaan muodostamaan aineistoa.
Tämä voidaan totettaa manuaalisesti tai Powershellillä. Powershellillä muodostaminen onnistuu komennolla mkdir C:/Users/käyttäjän_nimi/kansion_nimi

    mkdir C:/Users/An2/Omaprojekti_kansio_esimerkki

Kun kansiollinen rakenne on muodostattu, tulee käyttäjän siirtyä sen sisälle Powershellissä komennolla cd C:/Users/käyttäjän_nimi/kansion_nimi tai Set-Location C:/Users/käyttäjän_nimi/kansion_nimi.

    cd C:/Users/An2/Omaprojekti_kansio_esimerkki
    Set-Location C:/Users/An2/Omaprojekti_kansio_esimerkki

Halutussa polussa voidaan aloittaa Vagrantfilen muodostaminen komennolla vagrant init debian/bullseye64. Powershell ilmoittaa tiedoston muodostumisen onnistumisesta, mutta voit tarkistaa sen vielä komennolla: ls.
Vagrantfile muodostuu siihen kansioon, jossa käyttäjä on polussa, komennon syöttämisen aikana. Varo siis mahdollisia päällekkäisyyksiä, kun olet muodostanut enemmän testiympäristöjä ja käyttäjärakenteita.

    vagrant init debian/bullseye64
    ls

Vagrantfilen muodostumisen jälkeen voidaan sille asettaa muodostettavien VM-koneiden määritykset esim. notepadin kautta.
Tässä voi käyttää myös muita editoreita, mutta ne saattavat vaatia erillisen asennuksen.

    notepad Vagrantfile

Tällä hetkellä listatut tiedot voidaan korvata Tero Karvisen esimerkillä, joka tarjoaa hyvän pohjan omalle yrittämiselle ja toistettavalle useiden koneiden muodostukselle.

    # -*- mode: ruby -*-
    # vi: set ft=ruby :
    # Copyright 2019-2021 Tero Karvinen http://TeroKarvinen.com
    
    $tscript = <<TSCRIPT
    set -o verbose
    apt-get update
    apt-get -y install tree
    echo "Done - set up test environment - https://terokarvinen.com/search/?q=vagrant"
    TSCRIPT
    
    Vagrant.configure("2") do |config|
    	config.vm.synced_folder ".", "/vagrant", disabled: true
    	config.vm.synced_folder "shared/", "/home/vagrant/shared", create: true
    	config.vm.provision "shell", inline: $tscript
    	config.vm.box = "debian/bullseye64"
    
    	config.vm.define "t001" do |t001|
    		t001.vm.hostname = "t001"
    		t001.vm.network "private_network", ip: "192.168.88.101"
    	end
    
    	config.vm.define "t002", primary: true do |t002|
    		t002.vm.hostname = "t002"
    		t002.vm.network "private_network", ip: "192.168.88.102"
    	end
    	
    end

Useamman uuden koneen lisääminen voidaan toteuttaa syöttämällä uusia kenttiä jo muodostettujen t001 ja t002 jälkeen.
Korvaa kentät joissa on x- nimellisesti halutun mukaisilla tiedoilla ja IP-osoitteen xxx-osio tai koko IP-osoite halutun mukaisella, ei päällekkäisellä IP-osoite tiedolla.

        config.vm.define "x", primary: true do |x|
    		x.vm.hostname = "x"
    		x.vm.network "private_network", ip: "192.168.88.xxx"
    	end

## 
