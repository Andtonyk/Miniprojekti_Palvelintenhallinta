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

## Lähttö avoitteet

## Realismi iskee, tavoitteiden uudelleen katsastus ja maalin orientointi

## Tarvittavat ohjelmat

Jotta loppu tulemaan päästäisiin tarvitset alla olevat tai vastaavat ohjelmat.
VM
VM:lle asetettava OS-paketti, jolla käynnistettävät master/minionit halutaan toimiviksi
Powershell, jossa Admin ajo ominaisuus.
Vagrant-ohjelmistopaketti
Salt-ohjelmistopaketti

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
Jo tässä vaiheessa on mahdollista ottaa ylös mahdollisen master-koneen nimi sekä IP-osoite tiedot, joihin muodostettavilla minion-koneilla alaisuus kohdistetaan.

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
     
Tallenna muutokset Vagrantfileen ja poistu editorista.
Tiedot voi tarkistaa Powershellistä komennolla cat + polku.

    cat C:/Users/An2/Omaprojekti_kansio_esimerkki/Vagrantfile

Kun Vagrantfile sisältää halutut muutokset, tulisi ennen seuraavaa vaihetta avata VM-ohjelma jos se ei ole vielä auki.

VM:n avaamisen jälkeen, voidaan Powershellissä syöttää komento joka aloittaa kyseisen Vagrantfilen pohjalta uusien koneiden muodostamisen.
Tässä voi mennä koneiden määrästä ja Vagrantfile-asetuksista riippuen useitakin minuutteja, ellei pidempäänkin.
Huom! Jos sijaitset jo halutussa kohteessa voit suorittaa komennon ilman polullista tarkennusta: vagrant up

    vagrant up

Kun Powershellin ajo on päättynyt, tarkista VM-ohjelmasta että Vagrantfilessä ilmoitettu määrä koneita näkyy aktiivisina.
Tämän jälkeen voit käydä hakemassa kahvia, rusauttaa rystyset ja jatkaa seuraavaan vaiheeseen. 

## Master-koneen muodostaminen

Kun koneet ovat muodostuneet ja aktiivisina, voit ottaa niihin etäyhteyden Powershellin kautta.
Ensimmäiseksi kannattaa ottaa yhteyttä siihen koneeseen, josta olet aikeissa tehdä isännän.

    vagrant ssh koneen_nimi
    vagrant ssh t001

Kun olet onnistuneesti halutun koneen sisällä aja sille päivitykset.

    sudo apt-get update

Päivityksien jälkeen voit aloittaa muodostamaan koneesta masteria.

    sudo apt-get -y install salt-master

Kun asennus on päättynyt on hyvä tarkistaa että masterin tiedot vastaavat aiemmin ylös otettuja tietoja Vagrantfilestä.

    hostname -I

Tämän jälkeen voit poistua masterilta, takaisin Powershellin oletusnäkymään.

    exit

Sinun pitäisi olla samassa polussa, kuin ennen "vagrant ssh koneen_nimi" komennon syöttämistä. Jos näin ei olisi, navigoi itsesi oikeaan sijaintiin ennen minionin perustamista.


## Minion-koneen muodostaminen

Syötä Powershelliin aiemman mukainen vagrant komento.

    vagrant ssh kohteen_nimi
    vagrant ssh t002

Hae tulevalle alaiselle päivitykset

    sudo apt-get update

Tämän jälkeen voidaan ladata minioniuden mahdollistava paketti.

    sudo apt-get -y install salt-minion

Kun alaisuus paketti on ladattu, tulee yhteys isäntään määrittää minionille.

    sudoedit /etc/salt/minion

Muokkaa "#master: " pois kommenttikentästä, poistamalla sen alussa oleva #-merkki ja syötä sen jälkeen aiemmin ylösotettu masterin IP-osoite "master: xxx.xxx.xxx.xxx".

Tähän kuva 18

Lisää myös "Explicitly declare the id"-kohtaan alaisena toimivan koneen nimi-tunniste ja poista sen edessä oleva #-merkki, että muutos ei jää kommentiksi.

Muista tallentaa muutokset!

Potkaise minionia, jotta muutokset aktivoituisivat.

    sudo systemctl restart salt-minion.service

Kun kyseiset muutokset on toteutettu ja mahdollisesti toistettu kaikilla minioneiksi haluavilla koneilla, voit palata Powershellin perusnäkymään.

    exit

## A good master leaves none out of the loot and bounty

Powershelliin palautumisen jälkeen, aktivoi masteriksi osoitettu koneesi.

    vagrant ssh t001

Nyt voit tarkistaa tulivatko kaikkien minioneiden yhdistymispyynnöt onnistuneesti.

    sudo salt-key

Jos kaikki minion-koneet näkyvät odottavissa koneissa, voit siirtyä hyväksymään ne.
    
    sudo salt-key -A
