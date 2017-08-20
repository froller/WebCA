-- MySQL dump 10.13  Distrib 5.5.30, for Linux (x86_64)
--
-- Host: localhost    Database: webca
-- ------------------------------------------------------
-- Server version	5.5.30

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `certificates`
--

DROP TABLE IF EXISTS `certificates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `certificates` (
  `certificate_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `key_id` int(11) NOT NULL,
  `certificate_pem` text NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`certificate_id`),
  KEY `certificates_fk_1` (`user_id`),
  KEY `certificates_fk_2` (`key_id`),
  CONSTRAINT `certificates_fk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `certificates_fk_2` FOREIGN KEY (`key_id`) REFERENCES `key_pairs` (`key_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `certificates`
--

LOCK TABLES `certificates` WRITE;
/*!40000 ALTER TABLE `certificates` DISABLE KEYS */;
/*!40000 ALTER TABLE `certificates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `key_pairs`
--

DROP TABLE IF EXISTS `key_pairs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `key_pairs` (
  `key_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `key_type` enum('RSA','DSA') NOT NULL,
  `key_size` int(11) NOT NULL DEFAULT '1024',
  `key_name` varchar(255) NOT NULL,
  `private_pem` text NOT NULL,
  `public_pem` text NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`key_id`),
  KEY `key_pairs_fk_1` (`user_id`),
  CONSTRAINT `key_pairs_fk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `key_pairs`
--

LOCK TABLES `key_pairs` WRITE;
/*!40000 ALTER TABLE `key_pairs` DISABLE KEYS */;
INSERT INTO `key_pairs` (`key_id`, `user_id`, `key_type`, `key_size`, `key_name`, `private_pem`, `public_pem`, `timestamp`) VALUES (1,3,'RSA',1024,'rsa-test-1','-----BEGIN RSA PRIVATE KEY-----\nMIICWwIBAAKBgQC9P8Ki4EcFrEOZnjETtEZwU7FpeAkM28CE3jLY3tJ1YAQ+BfbZ\nco7650/3VwQbQcrc0RmBBaq/8ki3J6i5fjqHFfPW0OVs7frRueDKUmbE8Le1iZxa\nzMxsSPG0vIdcXkURrYIg3pJuii0QDym8APlgRByLuoTMFH2PJ/ICzJ/ftQIDAQAB\nAoGAaqfvgqnRfRH7uyzbTdaQyCdy2hTrTNLgakFr+KuDguENIwNrfltA14jbmXLx\n/oaS1OYHcJ6H/8uFTavNPFU2mAkSaIH+hDYnuEhNRzrtSu9TgcUiiJS5C287nHNm\nhOpDPpx8mlXYHQYv4b6YPwPaDETmYeRjq5yZbqRsAYZ8JFUCQQDggv4hy0Brr0Tm\nJvEKB7DFwuRB+JhXOQDCZvFg1Q0oUIEjM+05xqKKVTMeyW1mgAr1v03fkWlzop++\nkdTyN/wzAkEA18qtI9s7LWyhEpgTp6ubIDQALZjy9hhGL5ICIEiLr6Lzq68kKdsr\nw6W1yfF+0oZ5R2MUPFJgPDjrTzaXyNvMdwJAFlNQXCHvDQZHzq8upvWu0WuY8Sp8\nU6gaeDpuZFerUEf5H3wJagZjoWfphnU3SMsQy/EzGDlIiDQyuGueBlwk2wJAH4mF\naFof+fGIUNlc9gJEd55h8EgMKh8+ErG6EdHIaHDeP9cm598aNEvBl7PtnwL8Moyu\nZmp7mhGPglIuOLK23QJAGFGQC/w1dXPuhGSXYISA/Vnggkw2D2kftT+OVIc+LJp6\nLZgK+jGDUS8jAUvBY4flW2VWEv1yt0NppCETCOemZA==\n-----END RSA PRIVATE KEY-----\n','-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC9P8Ki4EcFrEOZnjETtEZwU7Fp\neAkM28CE3jLY3tJ1YAQ+BfbZco7650/3VwQbQcrc0RmBBaq/8ki3J6i5fjqHFfPW\n0OVs7frRueDKUmbE8Le1iZxazMxsSPG0vIdcXkURrYIg3pJuii0QDym8APlgRByL\nuoTMFH2PJ/ICzJ/ftQIDAQAB\n-----END PUBLIC KEY-----\n','2012-03-21 20:19:18');
/*!40000 ALTER TABLE `key_pairs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requests`
--

DROP TABLE IF EXISTS `requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `requests` (
  `request_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `key_id` int(11) NOT NULL,
  `c` char(2) DEFAULT NULL,
  `st` varchar(255) DEFAULT NULL,
  `l` varchar(255) DEFAULT NULL,
  `o` varchar(255) DEFAULT NULL,
  `ou` varchar(255) DEFAULT NULL,
  `cn` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `request_pem` text NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`request_id`),
  KEY `requests_fk_1` (`user_id`),
  KEY `requests_fk_2` (`key_id`),
  CONSTRAINT `requests_fk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `requests_fk_2` FOREIGN KEY (`key_id`) REFERENCES `key_pairs` (`key_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requests`
--

LOCK TABLES `requests` WRITE;
/*!40000 ALTER TABLE `requests` DISABLE KEYS */;
INSERT INTO `requests` (`request_id`, `user_id`, `key_id`, `c`, `st`, `l`, `o`, `ou`, `cn`, `email`, `request_pem`, `timestamp`) VALUES (1,3,1,'RU','1','2','3','4','5','6','Certificate Request:\n    Data:\n        Version: 0 (0x0)\n        Subject: C=RU, ST=1, L=2, O=3, OU=4, CN=5/emailAddress=6\n        Subject Public Key Info:\n            Public Key Algorithm: rsaEncryption\n                Public-Key: (1024 bit)\n                Modulus:\n                    00:bd:3f:c2:a2:e0:47:05:ac:43:99:9e:31:13:b4:\n                    46:70:53:b1:69:78:09:0c:db:c0:84:de:32:d8:de:\n                    d2:75:60:04:3e:05:f6:d9:72:8e:fa:e7:4f:f7:57:\n                    04:1b:41:ca:dc:d1:19:81:05:aa:bf:f2:48:b7:27:\n                    a8:b9:7e:3a:87:15:f3:d6:d0:e5:6c:ed:fa:d1:b9:\n                    e0:ca:52:66:c4:f0:b7:b5:89:9c:5a:cc:cc:6c:48:\n                    f1:b4:bc:87:5c:5e:45:11:ad:82:20:de:92:6e:8a:\n                    2d:10:0f:29:bc:00:f9:60:44:1c:8b:ba:84:cc:14:\n                    7d:8f:27:f2:02:cc:9f:df:b5\n                Exponent: 65537 (0x10001)\n        Attributes:\n            a0:00\n    Signature Algorithm: sha1WithRSAEncryption\n        56:c3:04:56:fc:ba:c7:bf:eb:16:27:0f:0e:a7:bc:90:ae:57:\n        e2:24:d3:3d:9e:e5:81:01:04:0d:ed:10:88:56:d2:5b:a6:dd:\n        40:8e:99:38:d9:f6:d7:59:46:14:42:a8:36:9d:75:3a:b1:89:\n        ff:cf:6f:80:85:54:b5:2f:c8:f2:a3:fe:dc:9c:30:6d:bf:cc:\n        d7:bf:a3:b0:ac:c5:a2:92:ac:08:16:43:8e:37:76:c9:89:e8:\n        fd:69:ab:de:cb:b6:1a:78:7a:d6:74:88:25:25:93:58:e0:6c:\n        f5:e9:d8:9d:e4:ab:37:de:e9:28:1b:d3:8e:ee:9c:ea:a0:f9:\n        50:17\n-----BEGIN CERTIFICATE REQUEST-----\nMIIBmzCCAQQCAQAwWzELMAkGA1UEBhMCUlUxCjAIBgNVBAgMATExCjAIBgNVBAcM\nATIxCjAIBgNVBAoMATMxCjAIBgNVBAsMATQxCjAIBgNVBAMMATUxEDAOBgkqhkiG\n9w0BCQEWATYwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAL0/wqLgRwWsQ5me\nMRO0RnBTsWl4CQzbwITeMtje0nVgBD4F9tlyjvrnT/dXBBtBytzRGYEFqr/ySLcn\nqLl+OocV89bQ5Wzt+tG54MpSZsTwt7WJnFrMzGxI8bS8h1xeRRGtgiDekm6KLRAP\nKbwA+WBEHIu6hMwUfY8n8gLMn9+1AgMBAAGgADANBgkqhkiG9w0BAQUFAAOBgQBW\nwwRW/LrHv+sWJw8Op7yQrlfiJNM9nuWBAQQN7RCIVtJbpt1Ajpk42fbXWUYUQqg2\nnXU6sYn/z2+AhVS1L8jyo/7cnDBtv8zXv6OwrMWikqwIFkOON3bJiej9aavey7Ya\neHrWdIglJZNY4Gz16did5Ks33ukoG9OO7pzqoPlQFw==\n-----END CERTIFICATE REQUEST-----\n','2012-03-21 20:25:57');
/*!40000 ALTER TABLE `requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `role_id` int(11) NOT NULL AUTO_INCREMENT,
  `role_name` varchar(255) NOT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` (`role_id`, `role_name`) VALUES (1,'admin');
INSERT INTO `roles` (`role_id`, `role_name`) VALUES (2,'root');
INSERT INTO `roles` (`role_id`, `role_name`) VALUES (3,'intermediate');
INSERT INTO `roles` (`role_id`, `role_name`) VALUES (4,'subject');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessions` (
  `session_id` varchar(72) NOT NULL,
  `data` text,
  `expires` int(11) DEFAULT NULL,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` (`session_id`, `data`, `expires`) VALUES ('session:5df74cbd178c2d9ac44dc9f1ee8c081527ab209e','BQgDAAAAAglRWWkhAAAACV9fY3JlYXRlZAlRWW9GAAAACV9fdXBkYXRlZA==\n',1364819397);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_roles` (
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `user_roles_fk_1` (`user_id`),
  KEY `user_roles_fk_2` (`role_id`),
  CONSTRAINT `user_roles_fk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_roles_fk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_roles`
--

LOCK TABLES `user_roles` WRITE;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
INSERT INTO `user_roles` (`user_id`, `role_id`) VALUES (1,1);
INSERT INTO `user_roles` (`user_id`, `role_id`) VALUES (2,2);
INSERT INTO `user_roles` (`user_id`, `role_id`) VALUES (3,3);
INSERT INTO `user_roles` (`user_id`, `role_id`) VALUES (4,4);
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` char(41) NOT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `users_uni_1` (`username`),
  KEY `users_idx_1` (`username`,`password`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`user_id`, `username`, `password`, `email`) VALUES (1,'admin','*4ACFE3202A5FF5CF467898FC58AAB1D615029441','froller@froller.net');
INSERT INTO `users` (`user_id`, `username`, `password`, `email`) VALUES (2,'rootca','*E6DB8B2E61116358A3D00BAE521F5E7FBFA1DDE2','froller@froller.net');
INSERT INTO `users` (`user_id`, `username`, `password`, `email`) VALUES (3,'interca','*926009C4262DBFAD09722367549747F2A154FDE7','froller@froller.net');
INSERT INTO `users` (`user_id`, `username`, `password`, `email`) VALUES (4,'subject','*69E4CD8082DCAD616E9CD8A514F5A56B91289D1F','froller@froller.net');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-04-01 15:30:34
