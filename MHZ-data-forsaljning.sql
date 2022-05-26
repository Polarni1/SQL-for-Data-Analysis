
use mhzdata;

drop table if exists mhz_forsaljning_2021;

CREATE TABLE MHZ_forsaljning_2021 (
artnr INT NOT NULL PRIMARY KEY,
artikelnamn VARCHAR(80),
antal VARCHAR(80),
kalkylinkopspris float,
TB float,
TG FLOAT,
inkopspris int,
kategori varchar(30),
priskategori varchar(30)
);

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE "C:/Users/PC/Downloads/tb-rapport.csv" INTO TABLE mhzdata.mhz_forsaljning_2021
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
ignore 1 lines
(artnr, artikelnamn, antal, kalkylinkopspris, TB, TG, inkopspris, kategori, priskategori);

update MHZ_forsaljning_2021
set antal = kalkylinkopspris,
kalkylinkopspris = TB,
TB = TG,
TG = inkopspris,
inkopspris = kategori,
kategori = priskategori
where antal <= '_99999999999' or antal ='5tum H';

update MHZ_forsaljning_2021
SET TG = inkopspris,
inkopspris = kategori
where inkopspris = 100;

update MHZ_forsaljning_2021
SET kategori = 'barbar dator'
where artikelnamn like '%thinkpad%' or artikelnamn like '%Latitude%' or artikelnamn like '%macbook%' or 
artikelnamn like 'b' or artikelnamn like '%vostro%' or artikelnamn like '%elitebook%'
or artikelnamn like '%probook%' or artikelnamn like '%chromebook%' or artikelnamn like '%vmb b%'
or artikelnamn like '%thinkcentre%' or artikelnamn like '%lifebook%';

update MHZ_forsaljning_2021
set kategori = 'stationar dator'
where artikelnamn like '%optiplex%' or artikelnamn like '%poweredge%' or artikelnamn like '%precision%' or 
artikelnamn like '%thinkcenter%' or artikelnamn like '%compaq%' or artikelnamn like '%elite 8%' or 
artikelnamn like '%elitedesk%' or artikelnamn like '%hp pro%' or artikelnamn like '%workstation%' or 
artikelnamn like '%proliant%' or artikelnamn like '%veriton%' or artikelnamn like '%station%'
 or artikelnamn like '%standard%';

update MHZ_forsaljning_2021
set kategori = 'hyra'
where artikelnamn like '%hyra%' or artikelnamn like '%depostion f%';

update MHZ_forsaljning_2021
set kategori = 'frakt'
where artikelnamn like '%frakt%';

update MHZ_forsaljning_2021
set kategori = 'RAM minne'
where artikelnamn like '%DDR%' or artikelnamn like '%minne%';

update MHZ_forsaljning_2021
set kategori = 'Skarm'
where artikelnamn like 'sk';

update MHZ_forsaljning_2021
set kategori = 'tjanst'
where artikelnamn like 'tj';

update MHZ_forsaljning_2021
set kategori = 'server'
where artikelnamn like '%server%';

update MHZ_forsaljning_2021
set kategori = 'processor'
where artikelnamn like '%processor%' or artikelnamn like '%intel%' or artikelnamn like '%cpu%';

update MHZ_forsaljning_2021
set kategori = 'grafikkort'
where artikelnamn like '%grafikkort%';

update MHZ_forsaljning_2021
set kategori = 'ominstallation'
where artikelnamn like '%ominstallation%';

update MHZ_forsaljning_2021
set kategori = 'stromadapter'
where artikelnamn like '%laptop str%' or artikelnamn like '%adapter%';

update MHZ_forsaljning_2021
set kategori = 'dockstation'
where artikelnamn like '%dockstation%';

update MHZ_forsaljning_2021
set kategori = 'batteri'
where artikelnamn like '%batteri%';

update MHZ_forsaljning_2021
set kategori = 'Mus, t-bord & kabel'
where artikelnamn like 'paket%' or artikelnamn like '%tangentbord%' or artikelnamn like '%usb%';

update MHZ_forsaljning_2021
set kategori = 'harddisk/caddy/VTRAK'
where artikelnamn like '%sas%' or artikelnamn like 'h' or artikelnamn like '%ide%' or 
artikelnamn like '%sata%' or artikelnamn like '%ssd%' or artikelnamn like '%vmb h%' or
artikelnamn like '%vTRAK%';

update MHZ_forsaljning_2021
set kategori = 'batteri'
where artikelnamn like '%batteri%';

update MHZ_forsaljning_2021
set kategori = 'ovrigt'
where kategori regexp '[1-9]$' or kategori is null or kategori like '';

update MHZ_forsaljning_2021
set priskategori = '0-100'
where inkopspris/antal <= 100;

update MHZ_forsaljning_2021
set priskategori = '101-250'
where inkopspris/antal >= 101 and inkopspris/antal <= 250;

update MHZ_forsaljning_2021
set priskategori = '251-500'
where inkopspris/antal >= 251 and inkopspris/antal <= 500;

update MHZ_forsaljning_2021
set priskategori = '501-1000'
where inkopspris/antal >= 501 and inkopspris/antal <= 1000;

update MHZ_forsaljning_2021
set priskategori = '1001-2000'
where inkopspris/antal >= 1001 and inkopspris/antal <= 2000;

update MHZ_forsaljning_2021
set priskategori = '2001-4000'
where inkopspris/antal >= 2001 and inkopspris/antal <= 4000;

update MHZ_forsaljning_2021
set priskategori = '4001-8000'
where inkopspris/antal >= 4001 and inkopspris/antal <= 8000;

update MHZ_forsaljning_2021
set priskategori = '8000-12000'
where inkopspris/antal >= 8001 and inkopspris/antal <= 12000;

update MHZ_forsaljning_2021
set priskategori = '12001-20000'
where inkopspris/antal >= 12001 and inkopspris/antal <= 20000;

select * from MHZ_forsaljning_2021;

select mf.artnr, mf.artikelnamn, mf.antal, mf.inkopspris, mf.kategori, mf.priskategori
from MHZ_forsaljning_2021 mf;
