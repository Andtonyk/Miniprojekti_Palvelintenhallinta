Huom! Kaikki testit on toteuttu seuraavanlaisella koneella: Windows 10 OS:llä, Google Chrome selaimella ja koneena on toiminut Legion 5 kannettava. 16Gt RAM, AMD Ryzen 7 5800H, NVIDIA Geforce 3070 ja 200GB vapaata levytilaa SSD-levyasemalla.
# H7 - This one ugly baby

## Lähtökohdat ja kylmärealismi

Aioin alkuun muodostaa RSSfeed-lukijan, mutta pitkään eri osien kanssa taisteltuani ja deadlinen tullessa vastaan voimalla, päätin siirtää toteutuksen yhteen osaan, joka oli monen feedereiden kanssa toimivilla tapetilla: Python.

Aloin siis lähestyä paketin muodostusta, joka mahdollistaisi python ympäristön perustamisen kohde koneella. 

Tässäkin ilmeni haasteita, mutta projektin haluttu versio tuli silti toteutuksellisesti tehtyä masterilla.
On siis mahdollista että esityksen jälkeen saan ohjeita, joilla saan toteutettua .sls-muutokset, jotka mahdollistavat projektin loppuunviennin halutussa mallissa.

Tein myös ongelmista johtuen ajettavan kokoelman hyviä perusohjelmia, jotta voisin osoittaa sillä aivan perusasioiden hallinnan, halutun projektin ongelmista johtuen.

## Tarkoitus

Projekti on tarkoitettu mahdollistamaan suhteelisen hyvältä vaikuttava python-ympäristöllinen aineiston muodostaminen myös graafisesti rajoitetussa ympäristössä

## Lisenssi

GNU General Public License v3.0 

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

![kansion lisääminen powershellillä](https://github.com/Andtonyk/h1---Debian/assets/149326156/4832aa47-500b-4b4e-af88-7215505d24f6)
    
    mkdir C:/Users/An2/Omaprojekti_kansio_esimerkki

Kun kansiollinen rakenne on muodostattu, tulee käyttäjän siirtyä sen sisälle Powershellissä komennolla cd C:/Users/käyttäjän_nimi/kansion_nimi tai Set-Location C:/Users/käyttäjän_nimi/kansion_nimi.

![Kansioon siirtymisen komennot Powershellissä 2](https://github.com/Andtonyk/h1---Debian/assets/149326156/c59b995a-ce8f-4ead-89b1-00626025015b)

    cd C:/Users/An2/Omaprojekti_kansio_esimerkki
    Set-Location C:/Users/An2/Omaprojekti_kansio_esimerkki

Halutussa polussa voidaan aloittaa Vagrantfilen muodostaminen komennolla vagrant init debian/bullseye64.
Powershell ilmoittaa tiedoston muodostumisen onnistumisesta, mutta voit tarkistaa sen vielä komennolla: ls.

HUOM! Vagrantfile muodostuu siihen kansioon, jossa käyttäjä on komennon syöttämisen aikana. Varo siis mahdollisia päällekkäisyyksiä, kun olet muodostanut enemmän testiympäristöjä ja käyttäjärakenteita.

    vagrant init debian/bullseye64

![Vagrantfilen muodostumisen tarkistus Powershellissä 3](https://github.com/Andtonyk/h1---Debian/assets/149326156/74e07e98-e4cc-4b30-925c-ec8c4de4c2da)
    
    ls

Vagrantfilen muodostumisen jälkeen voidaan sille asettaa muodostettavien VM-koneiden määritykset esim. notepadin kautta.
Tässä voi käyttää myös muita editoreita, mutta ne saattavat vaatia erillisen asennuksen.

![Powershellillä Vagrantfilen avaaminen halutussa editorissa 4](https://github.com/Andtonyk/h1---Debian/assets/149326156/58556523-d17c-477b-88fd-edc37747c587)

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

![Powershellillä vagrant upin aloittaminen](https://github.com/Andtonyk/h1---Debian/assets/149326156/626137b2-9df8-4ae5-b539-f02050f876b6)

    vagrant up

Kun Powershellin ajo on päättynyt, tarkista VM-ohjelmasta että Vagrantfilessä ilmoitettu määrä koneita näkyy aktiivisina.

![Vagrantin muodostuksen mukaiset VM-koneet 7](https://github.com/Andtonyk/h1---Debian/assets/149326156/b87a5888-02cd-46c5-b7a6-5d5220a55437)

Tämän jälkeen voit käydä hakemassa kahvia, rusauttaa rystyset ja jatkaa seuraavaan vaiheeseen. 

## Master-koneen muodostaminen

Kun koneet ovat muodostuneet ja aktiivisina, voit ottaa niihin etäyhteyden Powershellin kautta.
Ensimmäiseksi kannattaa ottaa yhteyttä siihen koneeseen, josta olet aikeissa tehdä isännän.

![Powershellillä vagrant ssh muodostus t001 8](https://github.com/Andtonyk/h1---Debian/assets/149326156/6dea9e2d-087e-46b7-9ed9-b6cef1aeb633)

    vagrant ssh koneen_nimi
    vagrant ssh t001

Kun olet onnistuneesti halutun koneen sisällä aja sille päivitykset.

![t001 sudo apt-get update 9](https://github.com/Andtonyk/h1---Debian/assets/149326156/9d49a727-6112-4a79-af99-8215cffeee10)

    sudo apt-get update

Päivityksien jälkeen voit aloittaa muodostamaan koneesta masteria.

![t001 sudo apt-get install salt-master 10](https://github.com/Andtonyk/h1---Debian/assets/149326156/14b286e9-05d4-43cb-8946-d2451ce7a7e2)

    sudo apt-get -y install salt-master

Kun asennus on päättynyt on hyvä tarkistaa että masterin tiedot vastaavat aiemmin ylös otettuja tietoja Vagrantfilestä.

![t001 hostname 11](https://github.com/Andtonyk/h1---Debian/assets/149326156/a02590e7-e9ea-43c9-a96f-cc39244ba38f)

    hostname -I

Tämän jälkeen voit poistua masterilta, takaisin Powershellin oletusnäkymään.

![t001 exit](https://github.com/Andtonyk/h1---Debian/assets/149326156/d7ec5ec3-1667-4435-8fc2-04dfcb622103)

    exit

Sinun pitäisi olla samassa polussa, kuin ennen "vagrant ssh koneen_nimi" komennon syöttämistä. Jos näin ei olisi, navigoi itsesi oikeaan sijaintiin ennen minionin perustamista.


## Minion-koneen muodostaminen

Syötä Powershelliin aiemman mukainen vagrant komento.

![Powershellillä vagrant ssh muodostus t002 13](https://github.com/Andtonyk/h1---Debian/assets/149326156/5b6212c3-5ba4-4e2a-b948-363cddb2c497)

    vagrant ssh kohteen_nimi
    vagrant ssh t002

Hae tulevalle alaiselle päivitykset

![t002 sudo apt-get update 14](https://github.com/Andtonyk/h1---Debian/assets/149326156/131e3c5f-a63b-4b83-9a41-b5476b2c48d2)

    sudo apt-get update

Tämän jälkeen voidaan ladata minioniuden mahdollistava paketti.

![t001 sudo apt-get install salt-minion 15](https://github.com/Andtonyk/h1---Debian/assets/149326156/2f8dc3d6-8db2-49f3-875d-f77c71ec64f9)

    sudo apt-get -y install salt-minion

Kun alaisuus paketti on ladattu, tulee yhteys isäntään määrittää minionille.

    sudoedit /etc/salt/minion

Muokkaa "#master: " pois kommenttikentästä, poistamalla sen alussa oleva #-merkki ja syötä sen jälkeen aiemmin ylösotettu masterin IP-osoite "master: xxx.xxx.xxx.xxx".

![sudoedit etc_salt_minion editoitava kenttä 16](https://github.com/Andtonyk/h1---Debian/assets/149326156/edd36cb8-26fe-4cfb-87fb-550c1cc336d4)

![sudoedit etc_salt_minion editoinnin jälkeinen kenttä 17](https://github.com/Andtonyk/h1---Debian/assets/149326156/4e68a584-3854-4096-a383-06a22c0fedf8)

Lisää myös "Explicitly declare the id"-kohtaan alaisena toimivan koneen nimi-tunniste ja poista sen edessä oleva #-merkki, että muutos ei jää kommentiksi.

![sudoedit etc_salt_minion editoinnin jälkeinen kenttä 18](https://github.com/Andtonyk/h1---Debian/assets/149326156/4dc31329-19f2-423a-a393-ac7ed313eccb)

Muista tallentaa muutokset!

Potkaise minionia, jotta muutokset aktivoituisivat.

    sudo systemctl restart salt-minion.service

Kun kyseiset muutokset on toteutettu ja mahdollisesti toistettu kaikilla minioneiksi haluavilla koneilla, voit palata Powershellin perusnäkymään.

    exit

## A good master leaves none out of the loot and bounty

Powershelliin palautumisen jälkeen, aktivoi masteriksi osoitettu koneesi.

    vagrant ssh t001

Nyt voit tarkistaa tulivatko kaikkien minioneiden yhdistymispyynnöt onnistuneesti.

![sudo salt-key näkymä 19](https://github.com/Andtonyk/h1---Debian/assets/149326156/1c538e97-8e88-4adc-90e6-f17a7a82d1d2)

    sudo salt-key

Jos kaikki minion-koneet näkyvät odottavissa koneissa, voit siirtyä hyväksymään ne.

![sudo salt-key näkymä, hyväksytysti 20](https://github.com/Andtonyk/h1---Debian/assets/149326156/931d5456-796a-4272-955b-db5d8cb2fc26)
    
    sudo salt-key -A

Tämän jälkeen on vielä hyvä varmistaa että hyväksytyt koneet vastaavat masterilta tuleviin salt-komentoihin.

![whoami minioneille](https://github.com/Andtonyk/h1---Debian/assets/149326156/198c9b38-a690-42ed-92f4-a73b66370839)

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

![esseential paketin sls 22](https://github.com/Andtonyk/h1---Debian/assets/149326156/bab23bcf-e14c-40cd-b605-46224e0e8acb)

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

![sudo salt-call --local state apply essentials komennon testaus, onnistui 22](https://github.com/Andtonyk/h1---Debian/assets/149326156/29db9eca-14e2-4afb-9b1b-54d02850bbe1)

    cd ..
    sudo salt-call --local state.apply essentials

...ja etene sitten ourpython-kansioon.

    cd ourpython/

Muodosta Ourpythoninkin sisälle init.sls-tiedosto.

    sudoedit init.sls

Syötä ourpython-kansion init.sls-tiedostoon alla oleva sisältö.
Huom! Koska toteutusjärjestys on listauksen mukainen, pidä kyseiset osiot niille osoitetuilla sijoituksilla.

![ourpythonin init sisältö](https://github.com/Andtonyk/h1---Debian/assets/149326156/2579af61-3a76-402d-a1da-c9905f06823f)

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

![sudo salt-call --local state apply ourpython komennon testaus, onnistui 23](https://github.com/Andtonyk/h1---Debian/assets/149326156/9f321c77-2403-4f56-9d93-33a35a3eeefb)

    cd ..
    sudo salt-call --local state.apply ourpython

Kun osat toimivat lokaalisti, voidaan ne sen jälkeen ajaa minioneille.
Muista ajaa komennot kahteen kertaan, jotta idempotenssillinen tila voidaan varmistaa.

![ourpython saltilla t002een 25](https://github.com/Andtonyk/h1---Debian/assets/149326156/e42fee5f-9bd8-46fe-a756-936864a0f0dc)

    sudo salt '*' state.apply ourpython

![ourpython saltilla t002een, idempotenssi 26](https://github.com/Andtonyk/h1---Debian/assets/149326156/d4e7c602-33fa-4fe1-9eaf-a27bf315b916)
    
    sudo salt '*' state.apply ourpython

Tämän jälkeen ajoin essentials-paketin, myös kahteen kertaan.

![essentials salt sudo onnistui 27](https://github.com/Andtonyk/h1---Debian/assets/149326156/b0577903-c7e6-4c63-a83b-e14fb3067951)

    sudo salt '*' state.apply essentials

![essentials salt sudo idempotenssi 28](https://github.com/Andtonyk/h1---Debian/assets/149326156/94b0f157-6a4b-4be3-82b6-2f9def421283)

    sudo salt '*' state.apply essentials



## Lopputulema masterilla, jonka toteuttaminen minioneille, periytyvästi, ei onnistunut

Kun ourpython-on onnistuneesti ladattuna, voidaan aloittaa python-ympäristön muodostaminen. Tee tai siirry haluttuun kansioon, jossa python-projekti haluttaisiin toteuttaa.
Valitsin omalle testilleni /home/-polun.

    cd /home
    sudo mkdir environments.pyth
    cd environments.pyth/

Kun pääsin haluttuun hakemistoon ajoin komennon, jolla haetaan pythonin sisältöä kansioon, joka toimii projektiympäristönä. 
Pythonin aktivaatio alueena pysyy pelkästään nämä kaksi muodostettavaa kansiota, muualla aktivaatiokomento ei toimi.

![python3 9 -m venv komento ja sen seuraukset](https://github.com/Andtonyk/h1---Debian/assets/149326156/ffe4d7f2-eda8-4bc8-9388-1c1794eeb047)

    /home/environments.pyth$sudo python3.9 -m venv tähän_tulee_projektiympäristön_nimi
    /home/environments.pyth$sudo python3.9 -m venv environments.pyth

Syöttämälläni nimellä muodostuvan kansion lopputulema oli hieman hämäävä, joten ympäristön nimi kannattaa erottaa halutun kohdekansion nimestä.

    cd tähän_tulee_äsken_muodostetun_projektiympäristön_nimi/
    cd environments.pyth/
    /home/environments.pyth/environments.pyth$

Kun olet päässyt muodostettuun kansioon tarkista sen sisältö.

![ympäristökansion sisältö](https://github.com/Andtonyk/h1---Debian/assets/149326156/8da5cd80-5ad4-4958-b972-de7c889d1f9d)

    ls
    bin include lib lib64 pyvenv.cfg share

Jos kansion sisältö on kunnossa, voit palata ylempään kansioon ja aktivoida python ympäristön kutsumalla sitä aiemmin muodostetun nimen avulla.

    cd ..

![pythonin aktivointi komento](https://github.com/Andtonyk/h1---Debian/assets/149326156/3056bb4c-7903-48c3-89f9-4fa24a6c9ec6)

    source tähän_tulee_äsken_muodostetun_projektiympäristön_nimi/bin/activate
    source environments.pyth/bin/activate

Komennon onnistuessa ilmestyy komentorivin vasempaan kenttään ympäristön nimi sulkeissa. 
HUOM! Tämä python-ympäristön aktiivisuus pysyy, kunnes syötetään komento: deactivate

![onnistunut pyth-aktivointi](https://github.com/Andtonyk/h1---Debian/assets/149326156/da0eb3b9-d68d-4caf-9f33-36868632ac14)

     (ympäristönnimi) vagrant@käyttäjä:/valittu_polku/kansio_jonka_sisälle_venv_aineisto_muodostui$
     (environments.pyth) vagrant@t001:/home/environments.pyth$

Kun python-ympäristö on aktivoituna, voidaan aloittaa ensimmäisen testi projektin muodostaminen.

![python tiedoston perustaminen microlla hello py](https://github.com/Andtonyk/h1---Debian/assets/149326156/1da65c68-63ea-4ad9-a519-d48b7b3bb8f5)

    micro hello.py

Tämä avaa MICRO-editorin, jonka latasimme essentials-paketin mukana ja mahdollistaa selvemmän tiedoston käsittelyn.
Lisätään editorissa hieman tekstiä ja talletetaan se.

![pythonilla toteutettu hello worls microlla](https://github.com/Andtonyk/h1---Debian/assets/149326156/7e2a9443-4865-44b7-a415-efadedde158b)

    print("Hello, World!")

Tallennetun tiedoston onnistuneesti muodostuminen voidaan tarkistaa ja jos se muodostui onnistuneesti, voidaan se ajaa.

![muodostuneen python tiedoston olevaisuuden tarkistus](https://github.com/Andtonyk/h1---Debian/assets/149326156/ed2ca662-5aed-41b1-a130-f78ede36d8a1)

    ls

![hello worldin tulostus ja  py tiedoston toiminnan varmistus](https://github.com/Andtonyk/h1---Debian/assets/149326156/5d4e03ec-f83a-4c6a-bc52-74d01ea66024)
    
    python hello.py

Nyt kun perustoiminnallisuus on osoitettu aktiiviseksi, voidaan pythonin aktiivisuus poistaa yksinkertaisella komennolla.

![python projektin deaktivointi](https://github.com/Andtonyk/h1---Debian/assets/149326156/8b2ea70a-8933-448a-9265-dc760dcf8f20)

    deactivate

...ja tarpeen tullen aktivoida uudelleen samalla tavalla kuin aiemminkin.

![pythin uudelleen aktivointi](https://github.com/Andtonyk/h1---Debian/assets/149326156/8f5f6148-81dd-44b7-b9ed-c99ab1bef983)

    source tähän_tulee_äsken_muodostetun_projektiympäristön_nimi/bin/activate
    source environments.pyth/bin/activate

## Minionin ohjelmistollinen tila

Pythonin toimintaa en pystynyt vielä testaamaan minionilla, mutta essentials-paketti oli asetettunut sinne ja mahdollisti muutoksien vahvistamisen gitin ajolla.

![git toimii minionilla](https://github.com/Andtonyk/h1---Debian/assets/149326156/4a09ab13-d036-4413-bcca-e1ee5b76826a)

    git

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
