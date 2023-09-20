--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3 (Debian 15.3-1.pgdg120+1)
-- Dumped by pg_dump version 15.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: corsi_di_laurea; Type: TABLE DATA; Schema: unimia; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE unimia.corsi_di_laurea DISABLE TRIGGER ALL;

INSERT INTO unimia.corsi_di_laurea VALUES ('L-31', 'Triennale', 'Informatica', 'Pura');
INSERT INTO unimia.corsi_di_laurea VALUES ('CU-01', 'Magistrale a ciclo unico', 'Medicina', 'Curatemi da PHP');


ALTER TABLE unimia.corsi_di_laurea ENABLE TRIGGER ALL;

--
-- Data for Name: utenti; Type: TABLE DATA; Schema: unimia; Owner: -
--

ALTER TABLE unimia.utenti DISABLE TRIGGER ALL;

INSERT INTO unimia.utenti VALUES ('4aff5fea-231b-4aed-8777-fb87782ef39f', '$2a$06$tkLjzAXHDDhMBUkgmD.bM.qFsBiDiCzXyerZQRvK6x9sFIjqAyzHq', 'Seg', 'Retario', 'segretario', 'seg.retario@segretario.superuni.it');
INSERT INTO unimia.utenti VALUES ('df04f7d1-16bf-4473-b3cc-38cee8732065', '$2a$06$5ngjIvGFahZugW6ik.dID.bB7xKU6yz26lZ11vzVm1Jx2cKZ5BiSG', 'Sebastiano', 'Vigna', 'docente', 'sebastiano.vigna@docente.superuni.it');
INSERT INTO unimia.utenti VALUES ('b07f8b6c-d1ba-4368-b454-097ed904dd61', '$2a$06$tHWR0h5MKgI6KN9tmqht2.D/ajbfc12.q3RA8GFcfkCXNqLgppZMm', 'Luca', 'Favini', 'studente', 'luca.favini@studente.superuni.it');
INSERT INTO unimia.utenti VALUES ('3a9443db-aa00-4f1b-ab96-ececcc2fb270', '$2a$06$NiPwLAXDLGPDh6qBeNKgPeaq6Tr7lw63Drm9HnbN2MC5rYr/snYVq', 'Andrea', 'Sacchi', 'studente', 'andrea.sacchi@studente.superuni.it');
INSERT INTO unimia.utenti VALUES ('1463aecc-24a8-4427-8217-8edb668fe2bb', '$2a$06$HdatuPrpFKMBF2fnv0tDgu0XY7s01svI4DgpGXNwbbvAcVReQ1LHK', 'Daniele', 'Deluca', 'studente', 'daniele.deluca@studente.superuni.it');
INSERT INTO unimia.utenti VALUES ('285a3d68-cb83-4454-82b7-837e6b46c0ca', '$2a$06$vjsxoptd.j9W5d4zvVQ0FedO2R6XknMpgGpfZ1ZT8vXOspJLacgYS', 'Alberto', 'Borghese', 'docente', 'alberto.borghese@docente.superuni.it');
INSERT INTO unimia.utenti VALUES ('db016eea-1f52-41d8-9419-94aa2d9ebf73', '$2a$06$LifG5j7AswftA5m3nc8V9ed0idKFsUk1WyEeENuNqDaBfsLsp2I.C', 'Gianfranco', 'Parmigiano', 'docente', 'gianfranco.parmigiano@docente.superuni.it');
INSERT INTO unimia.utenti VALUES ('cb8b9046-54bc-4a17-a479-78ef19590305', '$2a$06$QI4KpWqti70VkhEEo6fvMu1sqmDObLPwDoH6GUSAe7oFL47IENvgO', 'Giacomo', 'Comitani', 'ex_studente', 'giacomo.comitani@studente.superuni.it');
INSERT INTO unimia.utenti VALUES ('3e947ea3-105b-45db-8e86-3fb55450d589', '$2a$06$YUb0ychQ7RpA6//vaWyhBuDhiU1ACdqLwqhR2UGl0eXo9p/1sPpCy', 'Matteo', 'Zagheno', 'ex_studente', 'matteo.zagheno@studente.superuni.it');
INSERT INTO unimia.utenti VALUES ('566abb05-b5a9-48e6-b28b-dccee104bd3b', '$2a$06$zZgiADiiZaDBZPtLoS514.RErbogYKpcVN49AZFdPUOiCKLuUzNN6', 'Michele', 'Bolis', 'studente', 'michele.bolis@studente.superuni.it');


ALTER TABLE unimia.utenti ENABLE TRIGGER ALL;

--
-- Data for Name: docenti; Type: TABLE DATA; Schema: unimia; Owner: -
--

ALTER TABLE unimia.docenti DISABLE TRIGGER ALL;

INSERT INTO unimia.docenti VALUES ('df04f7d1-16bf-4473-b3cc-38cee8732065');
INSERT INTO unimia.docenti VALUES ('285a3d68-cb83-4454-82b7-837e6b46c0ca');
INSERT INTO unimia.docenti VALUES ('db016eea-1f52-41d8-9419-94aa2d9ebf73');


ALTER TABLE unimia.docenti ENABLE TRIGGER ALL;

--
-- Data for Name: insegnamenti; Type: TABLE DATA; Schema: unimia; Owner: -
--

ALTER TABLE unimia.insegnamenti DISABLE TRIGGER ALL;

INSERT INTO unimia.insegnamenti VALUES ('MED-01', 'CU-01', 'Infermieristica', 'Infermieri', '1', 'db016eea-1f52-41d8-9419-94aa2d9ebf73');
INSERT INTO unimia.insegnamenti VALUES ('MED-02', 'CU-01', 'Cervellogia', 'Cervelli', '4', 'db016eea-1f52-41d8-9419-94aa2d9ebf73');
INSERT INTO unimia.insegnamenti VALUES ('INF-P1', 'L-31', 'Programmazione 1', 'Programmazione in Golang', '1', 'df04f7d1-16bf-4473-b3cc-38cee8732065');
INSERT INTO unimia.insegnamenti VALUES ('INF-A1', 'L-31', 'Architettura degli elaboratori 1', 'Archi1', '1', '285a3d68-cb83-4454-82b7-837e6b46c0ca');
INSERT INTO unimia.insegnamenti VALUES ('INF-P2', 'L-31', 'Programmazione 2', 'OOP in Java', '2', 'df04f7d1-16bf-4473-b3cc-38cee8732065');
INSERT INTO unimia.insegnamenti VALUES ('INF-A2', 'L-31', 'Architettura degli elaboratori 2', 'Archi2', '2', '285a3d68-cb83-4454-82b7-837e6b46c0ca');


ALTER TABLE unimia.insegnamenti ENABLE TRIGGER ALL;

--
-- Data for Name: appelli; Type: TABLE DATA; Schema: unimia; Owner: -
--

ALTER TABLE unimia.appelli DISABLE TRIGGER ALL;

INSERT INTO unimia.appelli VALUES ('28d6e069-febe-46d1-a2cf-19555793e140', 'MED-01', '2023-10-18', '08:30:00', 'Aula 303');
INSERT INTO unimia.appelli VALUES ('773b9723-2fb6-434b-bd6f-e5b6337cd86b', 'MED-01', '2023-06-08', '12:00:00', 'Aula 303');
INSERT INTO unimia.appelli VALUES ('1770a34d-4f92-4a88-8da4-4f0e72345ab5', 'MED-02', '2023-10-22', '09:00:00', 'Aula Magna');
INSERT INTO unimia.appelli VALUES ('38a68858-d662-401f-bb1a-72a9f962a0be', 'MED-02', '2023-06-12', '16:00:00', 'Aula 603');
INSERT INTO unimia.appelli VALUES ('13de1fab-e62d-4f65-9ac9-71cd9b667907', 'MED-01', '2023-07-19', '10:00:00', 'Aula 109');
INSERT INTO unimia.appelli VALUES ('3466dcde-5d8c-4d99-8f93-c796df9e2e4d', 'MED-02', '2023-07-11', '10:40:00', 'Aula 501');
INSERT INTO unimia.appelli VALUES ('43737545-3661-4c66-8555-97f7ba1a2667', 'INF-P1', '2023-10-17', '10:30:00', 'Aula Delta');
INSERT INTO unimia.appelli VALUES ('d6f99f30-0be1-4bde-85fa-fe36027d5fd0', 'INF-P1', '2023-06-07', '10:30:00', 'Aula Delta');
INSERT INTO unimia.appelli VALUES ('92345c24-9497-4cf0-9143-88d214b6564f', 'INF-P1', '2023-07-19', '14:30:00', 'Aula Gamma');
INSERT INTO unimia.appelli VALUES ('c26c03ce-da36-4d8e-b14c-08285cfda29e', 'INF-P2', '2023-10-25', '10:30:00', 'Aula Delta');
INSERT INTO unimia.appelli VALUES ('242b19d3-4b07-4b2f-a1cb-487793ed14af', 'INF-A1', '2023-06-15', '12:00:00', 'Silab');
INSERT INTO unimia.appelli VALUES ('9d2b64d6-5219-4eb8-932d-ba1a012092a7', 'INF-A1', '2023-07-03', '09:00:00', 'Aula V3');
INSERT INTO unimia.appelli VALUES ('0f136460-3a97-4a80-be33-484a18915f34', 'INF-A1', '2023-10-11', '09:00:00', 'Aula V1');
INSERT INTO unimia.appelli VALUES ('dc43fa69-8a9d-4b2e-888d-48d5eded680e', 'INF-A2', '2023-10-16', '08:00:00', 'Aula G10');
INSERT INTO unimia.appelli VALUES ('304f6bbb-53ac-42e8-a760-5e445cefe218', 'INF-A2', '2023-06-16', '08:00:00', 'Aula G15');
INSERT INTO unimia.appelli VALUES ('e4b5e725-ff8a-4fa1-93d5-c0745ff52ece', 'INF-A2', '2023-07-12', '08:00:00', 'Aula V1');
INSERT INTO unimia.appelli VALUES ('de1d286b-8133-498a-b653-3b24e4c63396', 'INF-P2', '2023-07-13', '10:30:00', 'Aula Tau');
INSERT INTO unimia.appelli VALUES ('206670a8-ecd1-4475-bd94-6374fbc803a1', 'INF-P2', '2023-09-12', '11:30:00', 'Aula Tau');


ALTER TABLE unimia.appelli ENABLE TRIGGER ALL;

--
-- Data for Name: archivio_studenti; Type: TABLE DATA; Schema: unimia; Owner: -
--

ALTER TABLE unimia.archivio_studenti DISABLE TRIGGER ALL;

INSERT INTO unimia.archivio_studenti VALUES ('cb8b9046-54bc-4a17-a479-78ef19590305', '695986', 'CU-01', 'Laurea');
INSERT INTO unimia.archivio_studenti VALUES ('3e947ea3-105b-45db-8e86-3fb55450d589', '370004', 'L-31', 'Rinuncia agli studi');


ALTER TABLE unimia.archivio_studenti ENABLE TRIGGER ALL;

--
-- Data for Name: archivio_iscrizioni; Type: TABLE DATA; Schema: unimia; Owner: -
--

ALTER TABLE unimia.archivio_iscrizioni DISABLE TRIGGER ALL;

INSERT INTO unimia.archivio_iscrizioni VALUES ('773b9723-2fb6-434b-bd6f-e5b6337cd86b', 'cb8b9046-54bc-4a17-a479-78ef19590305', 14);
INSERT INTO unimia.archivio_iscrizioni VALUES ('3466dcde-5d8c-4d99-8f93-c796df9e2e4d', 'cb8b9046-54bc-4a17-a479-78ef19590305', 24);
INSERT INTO unimia.archivio_iscrizioni VALUES ('13de1fab-e62d-4f65-9ac9-71cd9b667907', 'cb8b9046-54bc-4a17-a479-78ef19590305', 27);
INSERT INTO unimia.archivio_iscrizioni VALUES ('d6f99f30-0be1-4bde-85fa-fe36027d5fd0', '3e947ea3-105b-45db-8e86-3fb55450d589', 24);


ALTER TABLE unimia.archivio_iscrizioni ENABLE TRIGGER ALL;

--
-- Data for Name: studenti; Type: TABLE DATA; Schema: unimia; Owner: -
--

ALTER TABLE unimia.studenti DISABLE TRIGGER ALL;

INSERT INTO unimia.studenti VALUES ('b07f8b6c-d1ba-4368-b454-097ed904dd61', '819857', 'L-31');
INSERT INTO unimia.studenti VALUES ('3a9443db-aa00-4f1b-ab96-ececcc2fb270', '141133', 'L-31');
INSERT INTO unimia.studenti VALUES ('1463aecc-24a8-4427-8217-8edb668fe2bb', '948749', 'CU-01');
INSERT INTO unimia.studenti VALUES ('566abb05-b5a9-48e6-b28b-dccee104bd3b', '602591', 'L-31');


ALTER TABLE unimia.studenti ENABLE TRIGGER ALL;

--
-- Data for Name: iscrizioni; Type: TABLE DATA; Schema: unimia; Owner: -
--

ALTER TABLE unimia.iscrizioni DISABLE TRIGGER ALL;

INSERT INTO unimia.iscrizioni VALUES ('773b9723-2fb6-434b-bd6f-e5b6337cd86b', '1463aecc-24a8-4427-8217-8edb668fe2bb', 18);
INSERT INTO unimia.iscrizioni VALUES ('13de1fab-e62d-4f65-9ac9-71cd9b667907', '1463aecc-24a8-4427-8217-8edb668fe2bb', 25);
INSERT INTO unimia.iscrizioni VALUES ('3466dcde-5d8c-4d99-8f93-c796df9e2e4d', '1463aecc-24a8-4427-8217-8edb668fe2bb', NULL);
INSERT INTO unimia.iscrizioni VALUES ('1770a34d-4f92-4a88-8da4-4f0e72345ab5', '1463aecc-24a8-4427-8217-8edb668fe2bb', NULL);
INSERT INTO unimia.iscrizioni VALUES ('d6f99f30-0be1-4bde-85fa-fe36027d5fd0', 'b07f8b6c-d1ba-4368-b454-097ed904dd61', 29);
INSERT INTO unimia.iscrizioni VALUES ('0f136460-3a97-4a80-be33-484a18915f34', '3a9443db-aa00-4f1b-ab96-ececcc2fb270', NULL);
INSERT INTO unimia.iscrizioni VALUES ('92345c24-9497-4cf0-9143-88d214b6564f', '3a9443db-aa00-4f1b-ab96-ececcc2fb270', 30);
INSERT INTO unimia.iscrizioni VALUES ('9d2b64d6-5219-4eb8-932d-ba1a012092a7', '3a9443db-aa00-4f1b-ab96-ececcc2fb270', 10);
INSERT INTO unimia.iscrizioni VALUES ('c26c03ce-da36-4d8e-b14c-08285cfda29e', '3a9443db-aa00-4f1b-ab96-ececcc2fb270', NULL);
INSERT INTO unimia.iscrizioni VALUES ('242b19d3-4b07-4b2f-a1cb-487793ed14af', 'b07f8b6c-d1ba-4368-b454-097ed904dd61', 24);
INSERT INTO unimia.iscrizioni VALUES ('c26c03ce-da36-4d8e-b14c-08285cfda29e', 'b07f8b6c-d1ba-4368-b454-097ed904dd61', NULL);
INSERT INTO unimia.iscrizioni VALUES ('dc43fa69-8a9d-4b2e-888d-48d5eded680e', 'b07f8b6c-d1ba-4368-b454-097ed904dd61', NULL);
INSERT INTO unimia.iscrizioni VALUES ('242b19d3-4b07-4b2f-a1cb-487793ed14af', '566abb05-b5a9-48e6-b28b-dccee104bd3b', 30);
INSERT INTO unimia.iscrizioni VALUES ('d6f99f30-0be1-4bde-85fa-fe36027d5fd0', '566abb05-b5a9-48e6-b28b-dccee104bd3b', 27);
INSERT INTO unimia.iscrizioni VALUES ('e4b5e725-ff8a-4fa1-93d5-c0745ff52ece', '566abb05-b5a9-48e6-b28b-dccee104bd3b', 31);
INSERT INTO unimia.iscrizioni VALUES ('de1d286b-8133-498a-b653-3b24e4c63396', '566abb05-b5a9-48e6-b28b-dccee104bd3b', 23);
INSERT INTO unimia.iscrizioni VALUES ('206670a8-ecd1-4475-bd94-6374fbc803a1', '566abb05-b5a9-48e6-b28b-dccee104bd3b', NULL);


ALTER TABLE unimia.iscrizioni ENABLE TRIGGER ALL;

--
-- Data for Name: propedeuticita; Type: TABLE DATA; Schema: unimia; Owner: -
--

ALTER TABLE unimia.propedeuticita DISABLE TRIGGER ALL;

INSERT INTO unimia.propedeuticita VALUES ('INF-P2', 'INF-P1');
INSERT INTO unimia.propedeuticita VALUES ('INF-A2', 'INF-A1');
INSERT INTO unimia.propedeuticita VALUES ('INF-A2', 'INF-P1');


ALTER TABLE unimia.propedeuticita ENABLE TRIGGER ALL;

--
-- Data for Name: segretari; Type: TABLE DATA; Schema: unimia; Owner: -
--

ALTER TABLE unimia.segretari DISABLE TRIGGER ALL;

INSERT INTO unimia.segretari VALUES ('4aff5fea-231b-4aed-8777-fb87782ef39f');


ALTER TABLE unimia.segretari ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

