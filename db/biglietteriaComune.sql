-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Creato il: Mar 08, 2023 alle 11:50
-- Versione del server: 10.4.27-MariaDB
-- Versione PHP: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `biglietteriaComune`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `categorieBiglietti`
--

CREATE TABLE `categorieBiglietti` (
  `idCategoriaBiglietto` char(5) NOT NULL,
  `NomeCategoria` varchar(255) NOT NULL,
  `PrezzoCorrente` decimal(3,2) NOT NULL,
  `DataCambioPrezzo` date NOT NULL,
  `NuovoPrezzo` decimal(3,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `luoghi`
--

CREATE TABLE `luoghi` (
  `idLuogo` char(5) NOT NULL,
  `Nome` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `operazioni`
--

CREATE TABLE `operazioni` (
  `idOperazione` char(5) NOT NULL,
  `DescrizioneOperazione` varchar(255) NOT NULL,
  `DataOraOperazione` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `idUtente` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `registrazioni`
--

CREATE TABLE `registrazioni` (
  `idBigliettoIniziale` char(5) NOT NULL,
  `idCategoriaBiglietto` char(5) NOT NULL,
  `PrezzoBigliettoUnitario` decimal(3,2) NOT NULL,
  `Quantita` int(11) NOT NULL,
  `idLuogo` char(5) NOT NULL,
  `DataOraRegistrazione` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `idUtente` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `sqlLogs`
--

CREATE TABLE `sqlLogs` (
  `idSqlLog` char(5) NOT NULL,
  `Query` varchar(255) NOT NULL,
  `idOperazione` char(5) NOT NULL,
  `idRegistrazione` char(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `utenti`
--

CREATE TABLE `utenti` (
  `idUtente` int(11) NOT NULL,
  `Mail` varchar(255) NOT NULL,
  `Nome` varchar(255) NOT NULL,
  `Cognome` varchar(255) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Roulo` int(11) NOT NULL,
  `UtenteAttivo` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `categorieBiglietti`
--
ALTER TABLE `categorieBiglietti`
  ADD PRIMARY KEY (`idCategoriaBiglietto`);

--
-- Indici per le tabelle `luoghi`
--
ALTER TABLE `luoghi`
  ADD PRIMARY KEY (`idLuogo`);

--
-- Indici per le tabelle `operazioni`
--
ALTER TABLE `operazioni`
  ADD PRIMARY KEY (`idOperazione`),
  ADD KEY `associato` (`idUtente`);

--
-- Indici per le tabelle `registrazioni`
--
ALTER TABLE `registrazioni`
  ADD PRIMARY KEY (`idBigliettoIniziale`),
  ADD KEY `vieneRegistrato` (`idUtente`),
  ADD KEY `proviene` (`idLuogo`),
  ADD KEY `categorizzatoCome` (`idCategoriaBiglietto`);

--
-- Indici per le tabelle `sqlLogs`
--
ALTER TABLE `sqlLogs`
  ADD PRIMARY KEY (`idSqlLog`),
  ADD KEY `nOperazione` (`idOperazione`);

--
-- Indici per le tabelle `utenti`
--
ALTER TABLE `utenti`
  ADD PRIMARY KEY (`idUtente`);

--
-- AUTO_INCREMENT per le tabelle scaricate
--

--
-- AUTO_INCREMENT per la tabella `utenti`
--
ALTER TABLE `utenti`
  MODIFY `idUtente` int(11) NOT NULL AUTO_INCREMENT;

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `operazioni`
--
ALTER TABLE `operazioni`
  ADD CONSTRAINT `associato` FOREIGN KEY (`idUtente`) REFERENCES `utenti` (`idUtente`);

--
-- Limiti per la tabella `registrazioni`
--
ALTER TABLE `registrazioni`
  ADD CONSTRAINT `categorizzatoCome` FOREIGN KEY (`idCategoriaBiglietto`) REFERENCES `categorieBiglietti` (`idCategoriaBiglietto`),
  ADD CONSTRAINT `proviene` FOREIGN KEY (`idLuogo`) REFERENCES `luoghi` (`idLuogo`),
  ADD CONSTRAINT `vieneRegistrato` FOREIGN KEY (`idUtente`) REFERENCES `utenti` (`idUtente`);

--
-- Limiti per la tabella `sqlLogs`
--
ALTER TABLE `sqlLogs`
  ADD CONSTRAINT `nOperazione` FOREIGN KEY (`idOperazione`) REFERENCES `operazioni` (`idOperazione`),
  ADD CONSTRAINT `registraOperazione` FOREIGN KEY (`idOperazione`) REFERENCES `registrazioni` (`idBigliettoIniziale`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
