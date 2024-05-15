Huom! Kaikki testit on toteuttu seuraavanlaisella koneella: Windows 10 OS:llä, Google Chrome selaimella ja koneena on toiminut Legion 5 kannettava. 16Gt RAM, AMD Ryzen 7 5800H, NVIDIA Geforce 3070 ja 200GB vapaata levytilaa SSD-levyasemalla.
# H7 - This one ugly baby

## Lähtökohdat ja kylmärealismi

Aioin alkuun muodostaa RSSfeed-lukijan, mutta pitkään eri osien kanssa taisteltuani ja deadlinen tullessa vastaan voimalla, päätin siirtää toteutuksen yhteen osaan, joka oli monen feedereiden kanssa toimivilla tapetilla: Python.

Aloin siis lähestyä paketin muodostusta, joka mahdollistaisi python ympäristön perustamisen kohde koneella. 

Tässäkin ilmeni haasteita, mutta projektin haluttu versio tuli silti toteutuksellisesti tehtyä masterilla.
On siis mahdollista että esityksen jälkeen saan ohjeita, joilla saan toteutettua .sls-muutokset, jotka mahdollistavat projektin loppuunviennin halutussa mallissa.

Tein myös ongelmista johtuen ajettavan kokoelman hyviä perusohjelmia, jotta voisin osoittaa sillä aivan perusasioiden hallinnan, halutun projektin ongelmista johtuen.

## Tarvittavat ohjelmat alkuun pääsyssä

Jotta loppu tulemaan päästäisiin tarvitset alla olevat tai vastaavat ohjelmat.

- VM
- VM:lle asetettava OS-paketti, jolla käynnistettävät master/minionit halutaan toimiviksi
- Powershell, jossa Admin ajo ominaisuus.
- Vagrant-ohjelmistopaketti
- Salt-ohjelmistopaketti

## Aloitetaan alusta

Kun tarvittavat ohjelmat ovat asennettuna, voidaan muodostaa kansiorakenteellinen polku, jonne aloitetaan muodostamaan aineistoa.
Tämä voidaan totettaa manuaalisesti tai Powershellillä. Powershellillä muodostaminen onnistuu komennolla mkdir C:/Users/käyttäjän_nimi/kansion_nimi

    mkdir C:/Users/An2/Omaprojekti_kansio_esimerkki

Kun kansiollinen rakenne on muodostattu, tulee käyttäjän siirtyä sen sisälle Powershellissä komennolla cd C:/Users/käyttäjän_nimi/kansion_nimi tai Set-Location C:/Users/käyttäjän_nimi/kansion_nimi.

    cd C:/Users/An2/Omaprojekti_kansio_esimerkki
    Set-Location C:/Users/An2/Omaprojekti_kansio_esimerkki

Halutussa polussa voidaan aloittaa Vagrantfilen muodostaminen komennolla vagrant init debian/bullseye64.
Powershell ilmoittaa tiedoston muodostumisen onnistumisesta, mutta voit tarkistaa sen vielä komennolla: ls.

HUOM! Vagrantfile muodostuu siihen kansioon, jossa käyttäjä on komennon syöttämisen aikana. Varo siis mahdollisia päällekkäisyyksiä, kun olet muodostanut enemmän testiympäristöjä ja käyttäjärakenteita.

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

Tämän jälkeen on vielä hyvä varmistaa että hyväksytyt koneet vastaavat masterilta tuleviin salt-komentoihin.

    sudo salt '*' cmd.run 'whoami'

Jos kaikki toivotut minionit vastasivat kyselyyn, voidaan siirtyä muodostamaan masterilla ajettavia komentoja.

## Hear ye, hear ye!

Siirry masterilla polkuun /srv/salt/

    cd /srv/salt

Jos kyseistä polkua ei vielä olisi muodostettuna, siirry srv:lle ja muodosta siellä itsellesi salt-kansio

    $ cd /srv
    /srv$ sudo mkdir salt

Kun polkurakenne on muotoa /srv/salt, voidaan muodostaa kutsukomennolle kansio saltin alle.
Minä muodostan kaksi erillistä kansiota: ourpython ja essentials

    /srv/salt$ sudo mkdir essentials
    /srv/salt$ sudo mkdir ourpython

Tämän jälkeen siirryin muodostamaan ensin essentialin sisältöä.

    cd essentials

/srv/salt/essentials$ kansioon muodostin init.sls tiedoston, jonka sisään muodostin sen kutsunnalle olennaisia tunnisteita.

    sudoedit init.sls

Sisällöksi tuli init.sls:ssä alla olevan mukainen, ohjeellinen sisältö.

  #srv/salt/essentials/init.sls
    mypkgs:
      pkg.installed:
        - pkgs:
          - micro
          - curl
          - git
          - vlc

Essentials-kansion init.sls:n sisällön muodostamisen ja tallettamisen jälkeen voit vielä tarkistaa että sisältö vastaa ohjeellista sisältöä. 

    cat /srv/salt/essentials/init.sls

Palaa tarkistuksen jälkeen /srv/salt/ polkuun ja testaa muodostetun init.sls:n toimivuus, kutsumalla sitä saltilla paikallisesti. 

    cd ..
    sudo salt-call --local state.apply essentials

kuva 22

...ja etene sitten ourpython-kansioon.

    cd ourpython/

Muodosta Ourpythoninkin sisälle init.sls-tiedosto.

    sudoedit init.sls

Syörä ourpython-kansion init.sls-tiedostoon alla oleva sisältö.
Huom! Koska toteutusjärjestys on listauksen mukainen, pidä kyseiset osiot niille osoitetuilla sijoituksilla.

    #srv/salt/ourpython/init.sls
      mypkgs:
        pkg.installed:
          - pkgs:
            - python3
            - python3-pip
            - build-essential
            - libssl-dev
            - libffi-dev
            - python3-dev
            - python3-venv

Ourpython-kansion init.sls:n sisällön muodostamisen ja tallettamisen jälkeen voit vielä tarkistaa että sisältö vastaa ohjeellista sisältöä. 

    cat /srv/salt/essentials/init.sls

Palaa tarkistuksen jälkeen /srv/salt/ polkuun ja testaa muodostetun init.sls:n toimivuus, kutsumalla sitä saltilla paikallisesti..

    cd ..
    sudo salt-call --local state.apply ourpython

kuva 23

Kun osat toimivat lokaalisti, voidaan ne sen jälkeen ajaa minioneille.
Muista ajaa komennot kahteen kertaan, jotta idempotenssillinen tila voidaan varmistaa.

    sudo salt '*' state.apply ourpython
    sudo salt '*' state.apply ourpython


## Lopputulema masterilla, jonka toteuttaminen minioneille, periytyvästi, ei onnistunut

Kun ourpython-on onnistuneesti ladattuna, voidaan aloittaa python-ympäristön muodostaminen. Tee tai siirry haluttuun kansioon, jossa python-projekti haluttaisiin toteuttaa.
Valitsin omalle testilleni /home/-polun.

    cd /home
    sudo mkdir environments.pyth
    cd environments.pyth/

Kun pääsin haluttuun hakemistoon ajoin komennon, jolla haetaan pythonin sisältöä kansioon, joka toimii projektiympäristönä. 
Pythonin aktivaatio alueena pysyy pelkästään nämä kaksi muodostettavaa kansiota, muualla aktivaatiokomento ei toimi.

    /home/environments.pyth$sudo python3.9 -m venv tähän_tulee_projektiympäristön_nimi
    /home/environments.pyth$ python3.9 -m venv environments.pyth

Syöttämälläni nimellä muodostuvan kansion lopputulema oli hieman hämäävä, joten ympäristön nimi kannattaa erottaa halutun kohdekansion nimestä.

    cd tähän_tulee_äsken_muodostetun_projektiympäristön_nimi/
    cd environments.pyth/
    /home/environments.pyth/environments.pyth$

Kun olet päässyt muodostettuun kansioon tarkista sen sisältö.

    ls
    bin include lib lib64 pyvenv.cfg share

Jos kansion sisältö on kunnossa, voit palata ylempään kansioon ja aktivoida python ympäristön kutsumalla sitä aiemmin muodostetun nimen avulla.

    cd ..
    source tähän_tulee_äsken_muodostetun_projektiympäristön_nimi/bin/activate
    source environments.pyth/bin/activate

Komennon onnistuessa ilmestyy komentorivin vasempaan kenttään ympäristön nimi sulkeissa. 
HUOM! Tämä python-ympäristön aktiivisuus pysyy, kunnes syötetään komento: deactivate

     (ympäristönnimi) vagrant@käyttäjä:/valittu_polku/kansio_jonka_sisälle_venv_aineisto_muodostui$
     (environments.pyth) vagrant@t001:/home/environments.pyth$

Kun python-ympäristö on aktivoituna, voidaan aloittaa ensimmäisen testi projektin muodostaminen.

    micro hello.py

Tämä avaa MICRO-editorin, jonka latasimme essentials-paketin mukana ja mahdollistaa selvemmän tiedoston käsittelyn.
Lisätään editorissa hieman tekstiä ja talletetaan se.

    print("Hello, World!")

Tallennetun tiedoston onnistuneesti muodostuminen voidaan tarkistaa ja jos se muodostui onnistuneesti, voidaan se ajaa.

    ls
    python hello.py

tähän kuva tulostuvasta hello world näkymästä

Nyt kun perustoiminnallisuus on osoitettu aktiiviseksi, voidaan pythonin aktiivisuus poistaa yksinkertaisella komennolla.

    deactivate

...ja tarpeen tullen aktivoida uudelleen samalla tavalla kuin aiemminkin.

    source tähän_tulee_äsken_muodostetun_projektiympäristön_nimi/bin/activate
    source environments.pyth/bin/activate

## Minionin ohjelmistollinen tila



## Lähteet

Salt Project, 
    Luettavissa: https://docs.saltproject.io/en/latest/ref/states/all/salt.states.file.html#salt.states.file.managed

Karvinen T. 2023, Salt Vagrant - automatically provision one master and two slaves
    Luettavissa: https://terokarvinen.com/2023/salt-vagrant/#infra-as-code---your-wishes-as-a-text-file

Karvinen T. 2024, Hello Salt Infra-as-Code
    Luettavissa: https://terokarvinen.com/2024/hello-salt-infra-as-code/

Karvinen T. 2018, Pkg-File-Service – Control Daemons with Salt – Change SSH Server Port
    Luettavissa: https://terokarvinen.com/2018/04/03/pkg-file-service-control-daemons-with-salt-change-ssh-server-port/?fromSearch=karvinen%20salt%20ssh

Karvinen T. 2018, I Want My Computer Like This
    Luettavissa: https://terokarvinen.com/2018/salt-states-i-want-my-computers-like-this/

Karvinen T. 2018, Salt Quickstart – Salt Stack Master and Slave on Ubuntu Linux 
    Luettavissa: https://terokarvinen.com/2018/salt-quickstart-salt-stack-master-and-slave-on-ubuntu-linux/?fromSearch=salt%20quickstart%20salt%20stack%20master%20and%20slave%20on%20ubuntu%20linux

Garnett A. 2023, How To Install Python 3 and Set Up a Programming Environment on Debian 11
    Luettavissa: https://www.digitalocean.com/community/tutorials/how-to-install-python-3-and-set-up-a-programming-environment-on-debian-11
