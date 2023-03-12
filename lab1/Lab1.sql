SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;


CREATE TABLE `factory` (
  `ID` int(11) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `LOCATION` varchar(255) NOT NULL,
  `FLOOR_SIZE` float NOT NULL,
  `FK_MANAGER_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `factory` (`ID`, `NAME`, `LOCATION`, `FLOOR_SIZE`, `FK_MANAGER_ID`) VALUES
(0, 'aut magni in earum et ea repellat est', 'Bogan chester', 48.17, 14),
(1, 'accusamus exercitationem sed illo enim labore', 'Antone ton', 37.3, 16),
(2, 'veritatis eaque rem corrupti vero', 'Gottlieb shire', 79.07, 10),
(3, 'error maxime voluptatibus neque quo quo natus', 'Padberg view', 53.2, 8),
(4, 'perspiciatis ut incidunt laborum praesentium voluptatum a perspiciatis autem', 'Greenfelder bury', 24.26, 12),
(5, 'laboriosam impedit illo eveniet quis provident soluta rerum', 'Skiles town', 81.03, 11),
(6, 'debitis assumenda ad tenetur', 'Grant chester', 78.5, 9),
(7, 'ipsum libero animi dolore optio', 'Makenzie shire', 27.56, 5),
(8, 'quia possimus eaque eveniet', 'Waldo port', 52.13, 18),
(9, 'eum dolor dolorum', 'Sawayn view', 13.17, 2),
(10, 'voluptas deserunt quo ipsum incidunt voluptas autem doloremque minima', 'Daniel shire', 46.16, 13),
(11, 'totam omnis sit aut deserunt', 'Glover port', 44.17, 3),
(12, 'molestias nulla voluptatem et nihil repudiandae velit accusamus', 'South Leilani Balistreri berg', 63.92, 7),
(13, 'eaque voluptas repellendus officia', 'Mertz mouth', 17.12, 17),
(14, 'voluptatem impedit eos repudiandae', 'Cristina fort', 24, 0),
(15, 'rem velit voluptates non molestiae aut labore quis', 'McGlynn shire', 90.25, 15),
(16, 'excepturi consectetur numquam labore praesentium at autem impedit', 'Green burgh', 46.62, 19),
(17, 'quae beatae dolor omnis veniam dolores natus repellendus', 'Koss haven', 68.28, 6),
(18, 'et quis molestiae animi nam sapiente sed nihil omnis', 'Otilia bury', 55.74, 1),
(19, 'dignissimos modi et', 'Ryan town', 50.15, 4);

CREATE TABLE `factory_supports_processes` (
  `FK_PROCESS_ID` int(11) NOT NULL,
  `FK_FACTORY_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `factory_supports_processes` (`FK_PROCESS_ID`, `FK_FACTORY_ID`) VALUES
(0, 12),
(1, 9),
(2, 16),
(3, 4),
(4, 15),
(5, 14),
(6, 18),
(7, 17),
(8, 8),
(9, 1),
(10, 3),
(11, 0),
(12, 7),
(13, 10),
(14, 6),
(15, 11),
(16, 5),
(17, 19),
(18, 13),
(19, 2);

CREATE TABLE `ice_cream_product` (
  `ID` int(11) NOT NULL,
  `PRICE` decimal(10,0) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `DESCRIPTION` varchar(255) NOT NULL,
  `ICECREAM_AMOUNT` float NOT NULL,
  `FK_FACTORY_ID` int(11) NOT NULL,
  `FK_ICE_CREAM_RECIPE_ID` int(11) NOT NULL,
  `PACKAGING_TYPE` char(8) DEFAULT NULL CHECK (`PACKAGING_TYPE` in ('CONE','BOX','CUP','ON_STICK'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `ice_cream_product` (`ID`, `PRICE`, `NAME`, `DESCRIPTION`, `ICECREAM_AMOUNT`, `FK_FACTORY_ID`, `FK_ICE_CREAM_RECIPE_ID`, `PACKAGING_TYPE`) VALUES
(0, '2', 'Nina', 'accusantium et facere hic quas magni', 115.95, 3, 19, 'ON_STICK'),
(1, '0', 'Mckenna', 'omnis odio ipsa eos dolor quae modi aut', 90.63, 1, 5, 'CUP'),
(2, '2', 'Theodore', 'beatae et quis earum', 197.45, 10, 2, 'ON_STICK'),
(3, '0', 'Alanis', 'illum quibusdam est', 192.52, 17, 18, 'CONE'),
(4, '3', 'Maynard', 'ut rem dignissimos id libero', 147.98, 12, 0, 'CONE'),
(5, '1', 'Jodie', 'maxime labore iste', 155.6, 6, 17, 'CONE'),
(6, '0', 'Jamel', 'alias culpa fugit aperiam', 182.08, 15, 3, 'CONE'),
(7, '2', 'Nayeli', 'dolores consequatur iste corporis aut', 39.36, 11, 8, 'CUP'),
(8, '0', 'Walton', 'officiis aut qui eveniet inventore', 159.46, 16, 13, 'CUP'),
(9, '1', 'Eriberto', 'maxime laboriosam debitis', 111.41, 14, 7, 'BOX'),
(10, '1', 'Christophe', 'at totam quia debitis architecto qui alias ut voluptatem', 129.07, 19, 12, 'CONE'),
(11, '2', 'Tierra', 'amet consequatur exercitationem', 168.46, 9, 4, 'CUP'),
(12, '0', 'Lionel', 'fugit deleniti occaecati vero architecto iusto nostrum', 50.01, 13, 1, 'CUP'),
(13, '2', 'Bettie', 'odit iste illo', 141.82, 2, 11, 'BOX'),
(14, '3', 'Raoul', 'perferendis laboriosam rem vel officia vero', 143.75, 18, 6, 'ON_STICK'),
(15, '0', 'Kristofer', 'ut dolorem rerum beatae labore et hic et', 59.43, 5, 14, 'BOX'),
(16, '2', 'Gladyce', 'velit sunt aut porro ea qui ut nihil quis', 182.8, 7, 10, 'CUP'),
(17, '1', 'Jacquelyn', 'et ullam est dolore inventore tempora numquam', 162.2, 4, 9, 'BOX'),
(18, '2', 'Katarina', 'consectetur ullam minus rem nesciunt', 74.51, 8, 16, 'CUP'),
(19, '2', 'Janick', 'nihil sit et qui similique repudiandae quae eos', 167.62, 0, 15, 'ON_STICK');

CREATE TABLE `ice_cream_recipe` (
  `ID` int(11) NOT NULL,
  `PRICE` decimal(10,0) NOT NULL,
  `FLAVOUR_NAME` varchar(255) NOT NULL,
  `DESCRIPTION` varchar(255) NOT NULL,
  `TYPE` char(11) NOT NULL,
  `FK_NUTRIENT_ID` int(11) NOT NULL
) ;

INSERT INTO `ice_cream_recipe` (`ID`, `PRICE`, `FLAVOUR_NAME`, `DESCRIPTION`, `TYPE`, `FK_NUTRIENT_ID`) VALUES
(0, '6', 'voluptatem aliquam aut voluptas cumque praesentium neque', 'numquam quam cum', 'SORBET', 1),
(1, '6', 'assumenda necessitatibus et quia accusamus atque non voluptatibus repellat', 'quaerat iste nesciunt', 'DESSERT_ICE', 8),
(2, '1', 'qui quia facere accusantium et quasi atque', 'dolorem eos et minima non illo', 'DESSERT_ICE', 11),
(3, '2', 'totam et cumque illo', 'quos vel quidem cupiditate qui exercitationem ad minima', 'SORBET', 0),
(4, '5', 'necessitatibus voluptatem et aspernatur ipsum', 'repellendus sit aspernatur voluptates', 'WATER_ICE', 18),
(5, '5', 'non excepturi aliquid atque modi itaque amet velit', 'sit animi cumque odit tenetur recusandae', 'DESSERT_ICE', 13),
(6, '9', 'sequi velit eligendi aut hic alias doloribus velit', 'sed nisi et beatae', 'DESSERT_ICE', 9),
(7, '2', 'eligendi ea aperiam dolores totam perferendis sunt', 'aut rerum autem', 'ICE_CREAM', 14),
(8, '7', 'vel distinctio ipsa rem occaecati velit', 'nihil expedita possimus maxime praesentium perspiciatis rem est', 'WATER_ICE', 7),
(9, '10', 'autem hic nulla accusantium sint laborum', 'qui qui maiores voluptas eos dicta ut', 'DESSERT_ICE', 12),
(10, '2', 'quidem iure porro aliquam fugiat unde in et', 'vel voluptas perspiciatis rerum accusamus dolore', 'MILK_ICE', 2),
(11, '7', 'placeat nihil explicabo reiciendis et at unde nam', 'qui libero id quia fugiat a rem enim enim', 'ICE_CREAM', 4),
(12, '8', 'velit qui voluptas atque fuga nihil dolore esse', 'veniam distinctio voluptas unde est libero dolor', 'WATER_ICE', 3),
(13, '4', 'voluptatem quo et voluptas non', 'tempore incidunt ut ullam', 'WATER_ICE', 15),
(14, '8', 'quis et in fugit repellendus rem perferendis', 'sed distinctio nihil sit sapiente sunt iure nemo sint', 'MILK_ICE', 16),
(15, '5', 'ullam est laboriosam sint labore saepe molestiae', 'corporis repellat nobis', 'SORBET', 5),
(16, '1', 'natus rem et eius itaque magnam', 'ipsa nihil natus amet placeat', 'SORBET', 10),
(17, '4', 'minima ea saepe corrupti et eligendi omnis quia non', 'tenetur sapiente quaerat eaque voluptas sunt', 'SORBET', 19),
(18, '4', 'quia qui dignissimos rerum molestiae', 'maiores inventore aperiam laboriosam aspernatur', 'DESSERT_ICE', 6),
(19, '2', 'ad consequatur beatae laudantium explicabo nisi', 'veniam rerum consequatur hic', 'SHERBET', 17);

CREATE TABLE `ice_cream_recipe_ingredient` (
  `AMOUNT` float NOT NULL,
  `FK_INGREDIENT_ID` int(11) NOT NULL,
  `FK_ICE_CREAM_RECIPE_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `ice_cream_recipe_ingredient` (`AMOUNT`, `FK_INGREDIENT_ID`, `FK_ICE_CREAM_RECIPE_ID`) VALUES
(7.76, 0, 2),
(1.86, 1, 8),
(0.6, 2, 5),
(4.79, 3, 19),
(6.85, 4, 4),
(1.9, 5, 7),
(5.72, 6, 14),
(3.04, 7, 17),
(3.96, 8, 18),
(6.66, 9, 9),
(0.43, 10, 16),
(1.59, 11, 6),
(6.11, 12, 13),
(5.25, 13, 0),
(5.82, 14, 10),
(9.04, 15, 1),
(6.33, 16, 11),
(9.72, 17, 12),
(3.15, 18, 3),
(1.99, 19, 15);

CREATE TABLE `ice_cream_recipe_instruction` (
  `ORDERING` int(11) NOT NULL,
  `CONTENT` varchar(255) NOT NULL,
  `FK_ICE_CREAM_RECIPE_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `ice_cream_recipe_instruction` (`ORDERING`, `CONTENT`, `FK_ICE_CREAM_RECIPE_ID`) VALUES
(0, 'maiores aut itaque qui', 14),
(1, 'occaecati deserunt quam aspernatur vel amet enim', 12),
(2, 'exercitationem soluta enim', 4),
(3, 'facilis qui officiis hic assumenda eum quia officia', 17),
(4, 'voluptatem eum ipsa', 0),
(5, 'aut nisi enim maxime aut totam vero', 2),
(6, 'ipsum id et soluta debitis deleniti', 9),
(7, 'aut consectetur voluptatum', 7),
(8, 'fugiat ipsum expedita neque ducimus quaerat dolores enim', 15),
(9, 'qui deserunt nisi hic similique dicta et voluptate', 8),
(10, 'modi ut id cum magnam dolor numquam consectetur', 11),
(11, 'rerum rerum eaque', 6),
(12, 'saepe ut ipsam ea maxime et temporibus odio qui', 3),
(13, 'quidem qui incidunt iusto', 13),
(14, 'vero ipsa facere itaque sit et magni sit inventore', 5),
(15, 'ea et qui et harum rerum consequatur dolorem', 16),
(16, 'enim omnis rerum eum ut vero et culpa vitae', 1),
(17, 'quia fuga unde expedita recusandae', 10),
(18, 'occaecati exercitationem omnis', 19),
(19, 'corrupti non consequatur laboriosam quo repudiandae ut tempore', 18);

CREATE TABLE `ingredient` (
  `ID` int(11) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `MEASUREMENT_UNITS` char(8) NOT NULL,
  `FK_NUTRIENT_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `ingredient` (`ID`, `NAME`, `MEASUREMENT_UNITS`, `FK_NUTRIENT_ID`) VALUES
(0, 'et hic dolore ipsum sapiente delectus nesciunt nobis', 'repellat', 7),
(1, 'suscipit quis error id', 'dicta du', 12),
(2, 'et voluptatem nemo et laborum et eveniet et nihil', 'labore q', 17),
(3, 'natus hic quia quos est distinctio', 'debitis', 8),
(4, 'earum pariatur facilis molestias molestiae voluptate', 'at et vo', 16),
(5, 'pariatur tempore autem illum', 'tempora', 15),
(6, 'aut in quia enim', 'corporis', 10),
(7, 'maiores optio dolor', 'sit nobi', 5),
(8, 'explicabo voluptatibus dolorem consequatur alias magni in', 'voluptas', 2),
(9, 'aperiam dolor hic quia ut non asperiores et', 'quasi qu', 6),
(10, 'eos quia perferendis', 'sunt con', 1),
(11, 'odit voluptatem delectus reiciendis omnis ullam corporis', 'sit enim', 3),
(12, 'aspernatur aut optio', 'beatae d', 14),
(13, 'placeat ducimus natus quod', 'laudanti', 13),
(14, 'debitis aut dolor assumenda', 'aut arch', 0),
(15, 'aspernatur aut id illo quasi', 'et nam t', 18),
(16, 'id sunt vel nam nostrum', 'quasi au', 19),
(17, 'quae natus quo eius nihil et asperiores eligendi nemo', 'delectus', 4),
(18, 'exercitationem velit numquam pariatur odio facilis', 'adipisci', 9),
(19, 'est at consectetur iure ut omnis deserunt ea', 'ut quaer', 11);

CREATE TABLE `ingredient_provider` (
  `MONTHLY_PRICE` decimal(10,0) NOT NULL,
  `MONTHLY_SUPPLY` float NOT NULL,
  `FK_INGREDIENT_ID` int(11) NOT NULL,
  `FK_PROVIDER_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `ingredient_provider` (`MONTHLY_PRICE`, `MONTHLY_SUPPLY`, `FK_INGREDIENT_ID`, `FK_PROVIDER_ID`) VALUES
('862', 743.06, 0, 16),
('859', 76.8, 1, 0),
('166', 753.18, 2, 17),
('415', 70.83, 3, 11),
('999', 433.5, 4, 19),
('515', 56.42, 5, 6),
('249', 517.47, 6, 15),
('230', 512.64, 7, 1),
('119', 141.04, 8, 14),
('877', 505.73, 9, 4),
('172', 451.22, 10, 18),
('872', 467.81, 11, 2),
('982', 299.08, 12, 8),
('945', 770.66, 13, 3),
('609', 482.36, 14, 9),
('108', 759.37, 15, 13),
('463', 277.69, 16, 7),
('703', 761.15, 17, 12),
('811', 548.29, 18, 10),
('959', 639.18, 19, 5);

CREATE TABLE `manager` (
  `ID` int(11) NOT NULL,
  `FIRST_NAME` varchar(255) NOT NULL,
  `SURNAME` varchar(255) NOT NULL,
  `PHONE_NUMBER` varchar(255) DEFAULT NULL,
  `TITLE` varchar(255) NOT NULL,
  `EMAIL` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `manager` (`ID`, `FIRST_NAME`, `SURNAME`, `PHONE_NUMBER`, `TITLE`, `EMAIL`) VALUES
(0, 'Blair', 'Sawayn', '(390) 890-3833', 'fuga et alias ut', 'jovani_occaecati@hotmail.com'),
(1, 'Arlie', 'Sauer', '794.915.2395', 'officia illum quia ut explicabo dicta dolor eius', 'emily_quo@hotmail.com'),
(2, 'Freddie', 'Lakin', '1-460-760-0617', 'et perspiciatis aspernatur', 'eda_quo@yahoo.com'),
(3, 'Arthur', 'Ferry', '107.940.6419 x50983', 'vel quia assumenda', 'jermain_eius@yahoo.com'),
(4, 'Ole', 'Gorczany', '692.839.8491', 'possimus pariatur laudantium voluptas ut', 'germaine_sed@hotmail.com'),
(5, 'Zita', 'Swaniawski', '767-603-6428', 'ut autem qui quasi', 'fritz_at@gmail.com'),
(6, 'Lenny', 'OConner', '1-556-436-8613 x244', 'modi alias et accusantium veniam suscipit voluptate', 'hildegard_tempora@yahoo.com'),
(7, 'Royal', 'Emmerich', '1-507-785-1757 x405', 'labore voluptates libero', 'elisabeth_nobis@hotmail.com'),
(8, 'Yolanda', 'Wiegand', '(331) 807-3192 x214', 'quia culpa quae', 'myrtice_laboriosam@gmail.com'),
(9, 'Chet', 'Jones', '320.295.2273 x24098', 'voluptatem explicabo enim inventore quod sapiente accusamus', 'glenda_deserunt@yahoo.com'),
(10, 'Mabel', 'Casper', '1-516-229-7076 x343', 'voluptatem dolores nam excepturi consequatur quaerat rem dolorem', 'luigi_aliquam@yahoo.com'),
(11, 'Daisha', 'Kirlin', '(362) 773-9634 x44048', 'ut id libero explicabo', 'nannie_vel@gmail.com'),
(12, 'Lisandro', 'Bailey', '409.778.8477 x92878', 'impedit optio aut eum dolorem porro cum doloribus sed', 'brent_alias@hotmail.com'),
(13, 'Nigel', 'OConnell', '(604) 123-6270', 'consequatur quam quo expedita', 'jess_et@hotmail.com'),
(14, 'Sarah', 'Grimes', '(133) 407-0418 x2365', 'mollitia incidunt ut inventore omnis numquam qui rerum', 'stefan_dignissimos@hotmail.com'),
(15, 'Chelsey', 'Ullrich', '1-903-140-7781', 'dolor rem aut sint amet consequatur nam rem', 'antonia_natus@yahoo.com'),
(16, 'Pearline', 'Farrell', '115.350.0674 x416', 'officia tempore rerum dignissimos harum', 'elta_fuga@yahoo.com'),
(17, 'Ellsworth', 'Flatley', '751.766.0531 x92723', 'recusandae nam in dolores illo dolore qui doloribus nesciunt', 'dusty_excepturi@gmail.com'),
(18, 'Lorine', 'Durgan', '(664) 738-4165 x4794', 'laboriosam voluptas architecto sit autem molestiae possimus ab', 'isadore_sunt@gmail.com'),
(19, 'Loraine', 'Gutkowski', '963-630-0026 x2270', 'in laborum quasi qui placeat eaque voluptatem', 'russel_sit@yahoo.com');

CREATE TABLE `nutrient` (
  `ID` int(11) NOT NULL,
  `FAT` float NOT NULL,
  `CHOLESTEROL` float NOT NULL,
  `SODIUM` float NOT NULL,
  `CARBOHYDRATES` float NOT NULL,
  `PROTEIN` float NOT NULL,
  `CALORIES` float NOT NULL,
  `SERVING_SIZE` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `nutrient` (`ID`, `FAT`, `CHOLESTEROL`, `SODIUM`, `CARBOHYDRATES`, `PROTEIN`, `CALORIES`, `SERVING_SIZE`) VALUES
(0, 65.84, 88.21, 45.41, 88.2, 67.78, 23.74, 82.17),
(1, 66.61, 76.33, 75.57, 83.61, 38.75, 87.18, 52.16),
(2, 53.45, 94.19, 24.05, 7.22, 96.21, 59.97, 93.16),
(3, 89.08, 1.96, 4.66, 82.3, 18.84, 24.45, 67.51),
(4, 50.01, 59.42, 50.86, 6.69, 12.34, 50.42, 95.01),
(5, 83.29, 74.39, 62.97, 46.19, 70.07, 57.11, 32.91),
(6, 16.84, 28.32, 31.3, 30.83, 30.72, 36.45, 22.32),
(7, 2.07, 91.14, 59.36, 68.51, 28.82, 51.31, 98.56),
(8, 79.96, 97.31, 21.59, 55.25, 86.54, 37.95, 96.4),
(9, 70.11, 24.41, 29.83, 31.77, 66.84, 11.2, 56.65),
(10, 79.69, 38.05, 26.51, 4.74, 86.28, 5.39, 91.06),
(11, 30.34, 9.76, 31.3, 71.21, 66.85, 10.93, 95.19),
(12, 95.01, 69.67, 26.25, 21.57, 60.79, 55.65, 24.52),
(13, 69.18, 77, 18.21, 8.8, 80.01, 98.48, 73.25),
(14, 13.31, 5.01, 18.9, 87.62, 98.72, 84.29, 23.32),
(15, 22.04, 54.69, 97.9, 3.06, 57.41, 15.48, 66.29),
(16, 34.88, 13.08, 35.79, 12.71, 93.33, 6.89, 27.74),
(17, 26.15, 41.94, 12.44, 71.05, 5.53, 22.16, 39.27),
(18, 26.05, 97.7, 57.08, 9.84, 14.78, 2.2, 2.69),
(19, 82.41, 36.84, 7.9, 40.49, 77.27, 84.37, 42.5);

CREATE TABLE `process` (
  `ID` int(11) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `SIZE` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `process` (`ID`, `NAME`, `SIZE`) VALUES
(0, 'placeat quaerat magnam et voluptatem voluptas praesentium', 73.56),
(1, 'nisi alias sit dicta', 83.76),
(2, 'quaerat ullam quidem similique deleniti nesciunt sequi et', 74.94),
(3, 'eum rem aspernatur ut qui incidunt officiis quod consequatur', 64.77),
(4, 'aliquid magnam voluptas', 76.97),
(5, 'earum quis qui aut impedit', 51.27),
(6, 'voluptatem nemo maxime hic nisi voluptatem nam dolores', 80.86),
(7, 'ullam accusantium ullam qui voluptatem voluptas voluptatem et illum', 85.94),
(8, 'nulla quaerat eaque esse iste est sed voluptatem molestiae', 100),
(9, 'rerum aut enim itaque quo vero', 56.24),
(10, 'earum qui et', 16.47),
(11, 'non cumque reprehenderit iusto numquam', 33.05),
(12, 'est perferendis aut ut quia corrupti dolores', 95.58),
(13, 'asperiores eaque ut natus amet', 10.87),
(14, 'ab quia est velit', 60.83),
(15, 'iure quia rerum error praesentium', 77.32),
(16, 'aperiam molestias adipisci similique ut eum', 50.41),
(17, 'et pariatur et eaque', 49.73),
(18, 'modi maxime voluptatem aut consequatur nisi fugiat atque', 38.75),
(19, 'eum aut at ut ab molestias consequuntur maxime doloremque', 60.62);

CREATE TABLE `provider` (
  `ID` int(11) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `EMAIL` varchar(255) DEFAULT NULL,
  `PHONE_NUMBER` varchar(255) DEFAULT NULL,
  `HOMEPAGE` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `provider` (`ID`, `NAME`, `EMAIL`, `PHONE_NUMBER`, `HOMEPAGE`) VALUES
(0, 'consectetur doloremque asperiores laboriosam', 'aurelia_velit@gmail.com', '716.359.7681 x6186', 'www.vortals.net'),
(1, 'quos voluptatibus ea iusto nam vero ut', 'dudley_aspernatur@yahoo.com', '228-967-6029 x523', 'www.synergies.biz'),
(2, 'quibusdam consequuntur aut quos architecto suscipit dolor ex qui', 'shanel_laudantium@hotmail.com', '529-163-2716', 'www.users.co'),
(3, 'molestiae vitae fuga eum ratione voluptatum', 'dayana_sapiente@hotmail.com', '539-561-0890', 'www.eyeballs.org'),
(4, 'consequatur et veritatis cumque fugit', 'tressa_odio@yahoo.com', '(774) 222-9023 x28541', 'www.models.net'),
(5, 'labore rerum error doloribus nulla', 'lue_est@gmail.com', '(865) 379-6632 x01957', 'www.functionalities.name'),
(6, 'explicabo ad omnis et non voluptate quos assumenda', 'fernando_dolor@yahoo.com', '1-676-497-4906', 'www.platforms.biz'),
(7, 'aspernatur illo asperiores', 'lincoln_voluptates@hotmail.com', '1-380-965-9342 x68355', 'www.e-markets.info'),
(8, 'qui esse sunt beatae', 'quinten_maxime@gmail.com', '(136) 854-5165 x34534', 'www.applications.co'),
(9, 'sit vitae sint', 'dashawn_facilis@gmail.com', '158-268-6130 x067', 'www.metrics.com'),
(10, 'non vel possimus rerum exercitationem qui et', 'lavon_vitae@hotmail.com', '986.516.7089 x54731', 'www.markets.name'),
(11, 'quis debitis cumque', 'mariane_quo@gmail.com', '177.229.8877 x6764', 'www.e-services.name'),
(12, 'aut et aspernatur', 'kaden_in@gmail.com', '1-523-295-4605 x6482', 'www.communities.co'),
(13, 'ab earum odit et ut', 'junior_unde@hotmail.com', '1-705-768-9987 x496', 'www.web-services.name'),
(14, 'accusamus cum quaerat et', 'keaton_eveniet@gmail.com', '(181) 880-0916 x40690', 'www.solutions.biz'),
(15, 'ut rerum consectetur enim qui molestiae asperiores', 'jakob_aut@gmail.com', '(771) 719-4449 x2153', 'www.deliverables.co'),
(16, 'debitis dolor rem nihil', 'lucienne_ullam@yahoo.com', '(198) 619-1034 x1317', 'www.e-business.org'),
(17, 'eum illum omnis vel fuga et modi corrupti', 'viviane_unde@yahoo.com', '1-248-736-0211 x936', 'www.infomediaries.org'),
(18, 'odio officia reiciendis sit error dicta non dolorum', 'delpha_et@yahoo.com', '(520) 773-3109 x23641', 'www.metrics.info'),
(19, 'qui velit reiciendis nesciunt', 'tiffany_cum@hotmail.com', '470-203-0313 x2394', 'www.platforms.io');

CREATE TABLE `recipe_needs_processes` (
  `FK_PROCESS_ID` int(11) NOT NULL,
  `FK_ICE_CREAM_RECIPE_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `recipe_needs_processes` (`FK_PROCESS_ID`, `FK_ICE_CREAM_RECIPE_ID`) VALUES
(0, 10),
(1, 8),
(2, 11),
(3, 4),
(4, 14),
(5, 6),
(6, 13),
(7, 15),
(8, 18),
(9, 16),
(10, 3),
(11, 0),
(12, 12),
(13, 17),
(14, 9),
(15, 1),
(16, 5),
(17, 7),
(18, 19),
(19, 2);


ALTER TABLE `factory`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `FK_MANAGER_ID` (`FK_MANAGER_ID`);

ALTER TABLE `factory_supports_processes`
  ADD PRIMARY KEY (`FK_PROCESS_ID`,`FK_FACTORY_ID`),
  ADD KEY `FK_FACTORY_ID` (`FK_FACTORY_ID`);

ALTER TABLE `ice_cream_product`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `FK_FACTORY_ID` (`FK_FACTORY_ID`),
  ADD KEY `FK_ICE_CREAM_RECIPE_ID` (`FK_ICE_CREAM_RECIPE_ID`);

ALTER TABLE `ice_cream_recipe`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `FK_NUTRIENT_ID` (`FK_NUTRIENT_ID`);

ALTER TABLE `ice_cream_recipe_ingredient`
  ADD PRIMARY KEY (`FK_INGREDIENT_ID`,`FK_ICE_CREAM_RECIPE_ID`),
  ADD KEY `FK_ICE_CREAM_RECIPE_ID` (`FK_ICE_CREAM_RECIPE_ID`);

ALTER TABLE `ice_cream_recipe_instruction`
  ADD PRIMARY KEY (`ORDERING`,`FK_ICE_CREAM_RECIPE_ID`),
  ADD KEY `FK_ICE_CREAM_RECIPE_ID` (`FK_ICE_CREAM_RECIPE_ID`);

ALTER TABLE `ingredient`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `FK_NUTRIENT_ID` (`FK_NUTRIENT_ID`);

ALTER TABLE `ingredient_provider`
  ADD PRIMARY KEY (`FK_INGREDIENT_ID`,`FK_PROVIDER_ID`),
  ADD KEY `FK_PROVIDER_ID` (`FK_PROVIDER_ID`);

ALTER TABLE `manager`
  ADD PRIMARY KEY (`ID`);

ALTER TABLE `nutrient`
  ADD PRIMARY KEY (`ID`);

ALTER TABLE `process`
  ADD PRIMARY KEY (`ID`);

ALTER TABLE `provider`
  ADD PRIMARY KEY (`ID`);

ALTER TABLE `recipe_needs_processes`
  ADD PRIMARY KEY (`FK_PROCESS_ID`,`FK_ICE_CREAM_RECIPE_ID`),
  ADD KEY `FK_ICE_CREAM_RECIPE_ID` (`FK_ICE_CREAM_RECIPE_ID`);


ALTER TABLE `factory`
  ADD CONSTRAINT `factory_ibfk_1` FOREIGN KEY (`FK_MANAGER_ID`) REFERENCES `manager` (`ID`);

ALTER TABLE `factory_supports_processes`
  ADD CONSTRAINT `factory_supports_processes_ibfk_1` FOREIGN KEY (`FK_PROCESS_ID`) REFERENCES `process` (`ID`),
  ADD CONSTRAINT `factory_supports_processes_ibfk_2` FOREIGN KEY (`FK_FACTORY_ID`) REFERENCES `factory` (`ID`);

ALTER TABLE `ice_cream_product`
  ADD CONSTRAINT `ice_cream_product_ibfk_1` FOREIGN KEY (`FK_FACTORY_ID`) REFERENCES `factory` (`ID`),
  ADD CONSTRAINT `ice_cream_product_ibfk_2` FOREIGN KEY (`FK_ICE_CREAM_RECIPE_ID`) REFERENCES `ice_cream_recipe` (`ID`);

ALTER TABLE `ice_cream_recipe`
  ADD CONSTRAINT `ice_cream_recipe_ibfk_1` FOREIGN KEY (`FK_NUTRIENT_ID`) REFERENCES `nutrient` (`ID`);

ALTER TABLE `ice_cream_recipe_ingredient`
  ADD CONSTRAINT `ice_cream_recipe_ingredient_ibfk_1` FOREIGN KEY (`FK_INGREDIENT_ID`) REFERENCES `ingredient` (`ID`),
  ADD CONSTRAINT `ice_cream_recipe_ingredient_ibfk_2` FOREIGN KEY (`FK_ICE_CREAM_RECIPE_ID`) REFERENCES `ice_cream_recipe` (`ID`);

ALTER TABLE `ice_cream_recipe_instruction`
  ADD CONSTRAINT `ice_cream_recipe_instruction_ibfk_1` FOREIGN KEY (`FK_ICE_CREAM_RECIPE_ID`) REFERENCES `ice_cream_recipe` (`ID`);

ALTER TABLE `ingredient`
  ADD CONSTRAINT `ingredient_ibfk_1` FOREIGN KEY (`FK_NUTRIENT_ID`) REFERENCES `nutrient` (`ID`);

ALTER TABLE `ingredient_provider`
  ADD CONSTRAINT `ingredient_provider_ibfk_1` FOREIGN KEY (`FK_INGREDIENT_ID`) REFERENCES `ingredient` (`ID`),
  ADD CONSTRAINT `ingredient_provider_ibfk_2` FOREIGN KEY (`FK_PROVIDER_ID`) REFERENCES `provider` (`ID`);

ALTER TABLE `recipe_needs_processes`
  ADD CONSTRAINT `recipe_needs_processes_ibfk_1` FOREIGN KEY (`FK_PROCESS_ID`) REFERENCES `process` (`ID`),
  ADD CONSTRAINT `recipe_needs_processes_ibfk_2` FOREIGN KEY (`FK_ICE_CREAM_RECIPE_ID`) REFERENCES `ice_cream_recipe` (`ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
