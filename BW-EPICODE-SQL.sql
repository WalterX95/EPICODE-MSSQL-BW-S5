-- Creazione della tabella Anagrafica
--CREATE DATABASE ANAGRAFICAPOLIZIA;

USE ANAGRAFICAPOLIZIA;

CREATE TABLE Anagrafica (
    IDAnagrafica INT IDENTITY(1,1) PRIMARY KEY,
    Cognome NVARCHAR(100) NOT NULL,
    Nome NVARCHAR(100) NOT NULL,
    Indirizzo NVARCHAR(255) NOT NULL,
    Citta NVARCHAR(100) NOT NULL,
    CAP NVARCHAR(10) NOT NULL,
    Cod_Fisc NVARCHAR(16) NOT NULL UNIQUE
);

-- Creazione della tabella TipoViolazione
CREATE TABLE TipoViolazione (
    IDViolazione INT IDENTITY(1,1) PRIMARY KEY,
    Descrizione NVARCHAR(255) NOT NULL
);

-- Creazione della tabella Verbale
CREATE TABLE Verbale (
    IDVerbale INT IDENTITY(1,1) PRIMARY KEY,
    IDAnagrafica INT NOT NULL,
    IDViolazione INT NOT NULL,
    DataViolazione DATE NOT NULL,
    IndirizzoViolazione NVARCHAR(255) NOT NULL,
    Nominativo_Agente NVARCHAR(100) NOT NULL,
    DataTrascrizioneVerbale DATE NOT NULL,
    Importo DECIMAL(10,2) NOT NULL,
    DecurtamentoPunti INT NOT NULL,
    FOREIGN KEY (IDAnagrafica) REFERENCES Anagrafica(IDAnagrafica),
    FOREIGN KEY (IDViolazione) REFERENCES TipoViolazione(IDViolazione)
);

-- Popolamento delle tabelle
INSERT INTO Anagrafica (Cognome, Nome, Indirizzo, Citta, CAP, Cod_Fisc) VALUES 
('Rossi', 'Mario', 'Via Roma 1', 'Palermo', '90100', 'RSSMRA80A01H501Z'),
('Bianchi', 'Luca', 'Via Milano 5', 'Milano', '20100', 'BNCLCU85C01F205X');

INSERT INTO TipoViolazione (Descrizione) VALUES 
('Eccesso di velocità'),
('Sosta vietata');

INSERT INTO Verbale (IDAnagrafica, IDViolazione, DataViolazione, IndirizzoViolazione, Nominativo_Agente, DataTrascrizioneVerbale, Importo, DecurtamentoPunti) VALUES 
(1, 1, '2024-02-10', 'Via Roma 20', 'Agente Rossi', '2024-02-11', 150.00, 3),
(2, 2, '2024-02-12', 'Via Milano 10', 'Agente Bianchi', '2024-02-13', 50.00, 0);

-- Query richieste
-- 1. Conteggio dei verbali trascritti
SELECT COUNT(*) AS NumeroVerbali FROM Verbale;

-- 2. Conteggio dei verbali trascritti raggruppati per anagrafe
SELECT IDAnagrafica, COUNT(*) AS NumeroVerbali FROM Verbale GROUP BY IDAnagrafica;

-- 3. Conteggio dei verbali trascritti raggruppati per tipo di violazione
SELECT IDViolazione, COUNT(*) AS NumeroVerbali FROM Verbale GROUP BY IDViolazione;

-- 4. Totale dei punti decurtati per ogni anagrafe
SELECT IDAnagrafica, SUM(DecurtamentoPunti) AS TotalePunti FROM Verbale GROUP BY IDAnagrafica;

-- 5. Dati dei residenti a Palermo
SELECT A.Cognome, A.Nome, V.DataViolazione, V.IndirizzoViolazione, V.Importo, V.DecurtamentoPunti 
FROM Verbale V
JOIN Anagrafica A ON V.IDAnagrafica = A.IDAnagrafica
WHERE A.Citta = 'Palermo';

-- 6. Violazioni tra febbraio 2009 e luglio 2009
SELECT A.Cognome, A.Nome, A.Indirizzo, V.DataViolazione, V.Importo, V.DecurtamentoPunti
FROM Verbale V
JOIN Anagrafica A ON V.IDAnagrafica = A.IDAnagrafica
WHERE V.DataViolazione BETWEEN '2009-02-01' AND '2009-07-31';

-- 7. Totale importi per ogni anagrafico
SELECT IDAnagrafica, SUM(Importo) AS TotaleImporto FROM Verbale GROUP BY IDAnagrafica;

-- 8. Visualizzazione residenti a Palermo
SELECT * FROM Anagrafica WHERE Citta = 'Palermo';

-- 9. Violazioni per una certa data
DECLARE @DataCercata DATE = '2024-02-10';
SELECT DataViolazione, Importo, DecurtamentoPunti FROM Verbale WHERE DataViolazione = @DataCercata;

-- 10. Conteggio delle violazioni per agente
SELECT Nominativo_Agente, COUNT(*) AS NumeroViolazioni FROM Verbale GROUP BY Nominativo_Agente;

-- 11. Violazioni con decurtamento maggiore di 5 punti
SELECT A.Cognome, A.Nome, A.Indirizzo, V.DataViolazione, V.Importo, V.DecurtamentoPunti
FROM Verbale V
JOIN Anagrafica A ON V.IDAnagrafica = A.IDAnagrafica
WHERE V.DecurtamentoPunti > 5;

-- 12. Violazioni con importo maggiore di 400 euro
SELECT A.Cognome, A.Nome, A.Indirizzo, V.DataViolazione, V.Importo, V.DecurtamentoPunti
FROM Verbale V
JOIN Anagrafica A ON V.IDAnagrafica = A.IDAnagrafica
WHERE V.Importo > 400;
