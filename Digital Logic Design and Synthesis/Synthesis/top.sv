/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : O-2018.06-SP4
// Date      : Sun Dec 26 19:21:17 2021
/////////////////////////////////////////////////////////////


module ecc_enc_dec ( PADDR, PENABLE, PSEL, PWDATA, PWRITE, clk, arstn, PRDATA, 
        data_out, operation_done, num_of_errors );
  input [19:0] PADDR;
  input [31:0] PWDATA;
  output [31:0] PRDATA;
  output [31:0] data_out;
  output [1:0] num_of_errors;
  input PENABLE, PSEL, PWRITE, clk, arstn;
  output operation_done;
  wire   \AMBA_WORD_registers[1][31] , \AMBA_WORD_registers[1][30] ,
         \AMBA_WORD_registers[1][29] , \AMBA_WORD_registers[1][28] ,
         \AMBA_WORD_registers[1][27] , \AMBA_WORD_registers[1][26] ,
         \AMBA_WORD_registers[1][25] , \AMBA_WORD_registers[1][24] ,
         \AMBA_WORD_registers[1][23] , \AMBA_WORD_registers[1][22] ,
         \AMBA_WORD_registers[1][21] , \AMBA_WORD_registers[1][20] ,
         \AMBA_WORD_registers[1][19] , \AMBA_WORD_registers[1][18] ,
         \AMBA_WORD_registers[1][17] , \AMBA_WORD_registers[1][16] ,
         \AMBA_WORD_registers[1][15] , \AMBA_WORD_registers[1][14] ,
         \AMBA_WORD_registers[1][13] , \AMBA_WORD_registers[1][12] ,
         \AMBA_WORD_registers[1][11] , \AMBA_WORD_registers[1][10] ,
         \AMBA_WORD_registers[1][9] , \AMBA_WORD_registers[1][8] ,
         \AMBA_WORD_registers[1][7] , \AMBA_WORD_registers[1][6] ,
         \AMBA_WORD_registers[1][5] , \AMBA_WORD_registers[1][4] ,
         \AMBA_WORD_registers[1][3] , \AMBA_WORD_registers[1][2] ,
         \AMBA_WORD_registers[1][1] , \AMBA_WORD_registers[1][0] ,
         \AMBA_WORD_registers[0][31] , \AMBA_WORD_registers[0][30] ,
         \AMBA_WORD_registers[0][29] , \AMBA_WORD_registers[0][28] ,
         \AMBA_WORD_registers[0][27] , \AMBA_WORD_registers[0][26] ,
         \two_bits_registers[0][1] , \two_bits_registers[0][0] ,
         \U_register_file/n192 , \U_register_file/n191 ,
         \U_register_file/n190 , \U_register_file/n189 ,
         \U_register_file/n188 , \U_register_file/n187 ,
         \U_register_file/n186 , \U_register_file/n185 ,
         \U_register_file/n184 , \U_register_file/n183 ,
         \U_register_file/n182 , \U_register_file/n181 ,
         \U_register_file/n180 , \U_register_file/n179 ,
         \U_register_file/n178 , \U_register_file/n177 ,
         \U_register_file/n176 , \U_register_file/n175 ,
         \U_register_file/n174 , \U_register_file/n173 ,
         \U_register_file/n172 , \U_register_file/n171 ,
         \U_register_file/n170 , \U_register_file/n169 ,
         \U_register_file/n168 , \U_register_file/n167 ,
         \U_register_file/n166 , \U_register_file/n165 ,
         \U_register_file/n164 , \U_register_file/n163 ,
         \U_register_file/n162 , \U_register_file/n161 ,
         \U_register_file/n160 , \U_register_file/n159 ,
         \U_register_file/n158 , \U_register_file/n157 ,
         \U_register_file/n156 , \U_register_file/n155 ,
         \U_register_file/n154 , \U_register_file/n153 ,
         \U_register_file/n152 , \U_register_file/n151 ,
         \U_register_file/n150 , \U_register_file/n149 ,
         \U_register_file/n148 , \U_register_file/n147 ,
         \U_register_file/n146 , \U_register_file/n145 ,
         \U_register_file/n144 , \U_register_file/n143 ,
         \U_register_file/n142 , \U_register_file/n141 ,
         \U_register_file/n140 , \U_register_file/n139 ,
         \U_register_file/n138 , \U_register_file/n137 ,
         \U_register_file/n136 , \U_register_file/n135 ,
         \U_register_file/n134 , \U_register_file/n133 ,
         \U_register_file/n132 , \U_register_file/n131 ,
         \U_register_file/n289 , \U_register_file/n288 ,
         \U_register_file/n287 , \U_register_file/n286 ,
         \U_register_file/n285 , \U_register_file/n284 ,
         \U_register_file/n283 , \U_register_file/n282 ,
         \U_register_file/n281 , \U_register_file/n280 ,
         \U_register_file/n279 , \U_register_file/n278 ,
         \U_register_file/n277 , \U_register_file/n276 ,
         \U_register_file/n275 , \U_register_file/n274 ,
         \U_register_file/n273 , \U_register_file/n272 , \U_op_done_logic/N0 ,
         n902, n903, n904, n905, n930, n931, n932, n933, n934, n935, n936,
         n937, n938, n939, n940, n941, n942, n943, n944, n945, n946, n947,
         n948, n949, n950, n951, n952, n953, n954, n955, n956, n957, n958,
         n959, n960, n961, n962, n963, n964, n965, n966, n967, n968, n969,
         n970, n971, n972, n973, n974, n975, n976, n977, n978, n979, n980,
         n981, n982, n983, n984, n985, n986, n987, n988, n989, n990, n991,
         n992, n993, n994, n995, n996, n997, n998, n999, n1000, n1001, n1002,
         n1003, n1004, n1005, n1006, n1007, n1008, n1009, n1010, n1011, n1012,
         n1013, n1014, n1015, n1016, n1017, n1018, n1019, n1020, n1021, n1022,
         n1023, n1024, n1025, n1026, n1027, n1028, n1029, n1030, n1031, n1032,
         n1033, n1034, n1035, n1036, n1037, n1038, n1039, n1040, n1041, n1042,
         n1043, n1044, n1045, n1046, n1047, n1048, n1049, n1050, n1051, n1052,
         n1053, n1054, n1055, n1056, n1057, n1058, n1059, n1060, n1061, n1062,
         n1063, n1064, n1065, n1066, n1067, n1068, n1069, n1070, n1071, n1072,
         n1073, n1074, n1075, n1076, n1077, n1078, n1079, n1080, n1081, n1082,
         n1083, n1084, n1085, n1086, n1087, n1088, n1089, n1090, n1091, n1092,
         n1093, n1094, n1095, n1096, n1097, n1098, n1099, n1100, n1101, n1102,
         n1103, n1104, n1105, n1106, n1107, n1108, n1109, n1110, n1111, n1112,
         n1113, n1114, n1115, n1116, n1117, n1118, n1119, n1120, n1121, n1122,
         n1123, n1124, n1125, n1126, n1127, n1128, n1129, n1130, n1131, n1132,
         n1133, n1134, n1135, n1136, n1137, n1138, n1139, n1140, n1141, n1142,
         n1143, n1144, n1145, n1146, n1147, n1148, n1149, n1150, n1151, n1152,
         n1153, n1154, n1155, n1156, n1157, n1158, n1159, n1160, n1161, n1162,
         n1163, n1164, n1165, n1166, n1167, n1168, n1169, n1170, n1171, n1172,
         n1173, n1174, n1175, n1176, n1177, n1178, n1179, n1180, n1181, n1182,
         n1183, n1184, n1185, n1186, n1187, n1188, n1189, n1190, n1191, n1192,
         n1193, n1194, n1195, n1196, n1197, n1198, n1199, n1200, n1201, n1202,
         n1203, n1204, n1205, n1206, n1207, n1208, n1209, n1210, n1211, n1212,
         n1213, n1214, n1215, n1216, n1217, n1218, n1219, n1220, n1221, n1222,
         n1223, n1224, n1225, n1226, n1227, n1228, n1229, n1230, n1231, n1232,
         n1233, n1234, n1235, n1236, n1237, n1238, n1239, n1240, n1241, n1242,
         n1243, n1244, n1245, n1246, n1247, n1248, n1249, n1250, n1251, n1252,
         n1253, n1254, n1255, n1256, n1257, n1258, n1259, n1260, n1261, n1262,
         n1263, n1264, n1265, n1266, n1267, n1268, n1269, n1270, n1271, n1272,
         n1273, n1274, n1275, n1276, n1277, n1278, n1279, n1280, n1281, n1282,
         n1283, n1284, n1285, n1286, n1287, n1288, n1289, n1290, n1291, n1292,
         n1293, n1294, n1295, n1296, n1297, n1298, n1299, n1300, n1301, n1302,
         n1303, n1304, n1305, n1306, n1307, n1308, n1309, n1310, n1311, n1312,
         n1313, n1314, n1315, n1316, n1317, n1318, n1319, n1320, n1321, n1322,
         n1323, n1324, n1325, n1326, n1327, n1328, n1329, n1330, n1331, n1332,
         n1333, n1334, n1335, n1336, n1337, n1338, n1339, n1340, n1341, n1342,
         n1343, n1344, n1345, n1346, n1347, n1348, n1349, n1350, n1351, n1352,
         n1353, n1354, n1355, n1356, n1357, n1358, n1359, n1360, n1361, n1362,
         n1363, n1364, n1365, n1366, n1367, n1368, n1369, n1370, n1371, n1372,
         n1373, n1374, n1375, n1376, n1377, n1378, n1379, n1380, n1381, n1382,
         n1383, n1384, n1385, n1386, n1387, n1388, n1389, n1390, n1391, n1392,
         n1393, n1394, n1395, n1396, n1397, n1398, n1399, n1400, n1401, n1402,
         n1403, n1404, n1405, n1406, n1407, n1408, n1409, n1410, n1411, n1412,
         n1413, n1414, n1415, n1416, n1417, n1418, n1419, n1420, n1421, n1422,
         n1423, n1424, n1425, n1426, n1427, n1428, n1429, n1430, n1431, n1432,
         n1433, n1434, n1435, n1436, n1437, n1438, n1439, n1440, n1441, n1442,
         n1443, n1444, n1445, n1446, n1447, n1448, n1449, n1450, n1451, n1452,
         n1453, n1454, n1455, n1456, n1457, n1458, n1459, n1460, n1461, n1462,
         n1463, n1464, n1465, n1466, n1467, n1468, n1469, n1470, n1471, n1472,
         n1473, n1474, n1475, n1476, n1477, n1478, n1479, n1480, n1481, n1482,
         n1483, n1484, n1485, n1486, n1487, n1488, n1489, n1490, n1491, n1492,
         n1493, n1494, n1495, n1496, n1497, n1498, n1499, n1500, n1501, n1502,
         n1503, n1504, n1505, n1506, n1507, n1508, n1509, n1510, n1511, n1512,
         n1513, n1514, n1515, n1516, n1517, n1518, n1519, n1520, n1521, n1522,
         n1523, n1524, n1525, n1526, n1527, n1528, n1529, n1530, n1531, n1532,
         n1533, n1534, n1535, n1536, n1537, n1538, n1539, n1540, n1541, n1542,
         n1543, n1544, n1545, n1546, n1547, n1548, n1549, n1550, n1551, n1552,
         n1553, n1554, n1555, n1556, n1557, n1558, n1559, n1560, n1561, n1562,
         n1563, n1564, n1565, n1566, n1567, n1568, n1569, n1570, n1571, n1572,
         n1573, n1574, n1575, n1576, n1577, n1578, n1579, n1580, n1581, n1582,
         n1583, n1584, n1585, n1586, n1587, n1588, n1589, n1590, n1591, n1592,
         n1593, n1594, n1595, n1596, n1597, n1598, n1599, n1600, n1601, n1602,
         n1603, n1604, n1605, n1606, n1607, n1608, n1609, n1610, n1611, n1612,
         n1613, n1614, n1615, n1616, n1617, n1618, n1619, n1620, n1621, n1622,
         n1623, n1624, n1625, n1626, n1627, n1628, n1629, n1630, n1631, n1632,
         n1633, n1634, n1635, n1636, n1637, n1638;
  wire   [31:0] \U_encoder/CodeWord3 ;

  DFFRHQX4 \U_register_file/two_bits_registers_reg[1][1]  ( .D(n902), .CK(clk), 
        .RN(arstn), .Q(\U_register_file/n288 ) );
  DFFRHQX1 \U_register_file/AMBA_WORD_registers_reg[1][23]  ( .D(
        \U_register_file/n184 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][23] ) );
  DFFRHQX1 \U_register_file/AMBA_WORD_registers_reg[1][22]  ( .D(
        \U_register_file/n183 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][22] ) );
  DFFRHQX1 \U_register_file/AMBA_WORD_registers_reg[1][27]  ( .D(
        \U_register_file/n188 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][27] ) );
  DFFRHQX1 \U_register_file/AMBA_WORD_registers_reg[1][0]  ( .D(n905), .CK(clk), .RN(arstn), .Q(\AMBA_WORD_registers[1][0] ) );
  DFFRHQX1 \U_register_file/AMBA_WORD_registers_reg[1][21]  ( .D(
        \U_register_file/n182 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][21] ) );
  DFFRHQX1 \U_register_file/AMBA_WORD_registers_reg[1][1]  ( .D(n904), .CK(clk), .RN(arstn), .Q(\AMBA_WORD_registers[1][1] ) );
  DFFRHQX1 \U_register_file/AMBA_WORD_registers_reg[1][29]  ( .D(
        \U_register_file/n190 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][29] ) );
  DFFRHQX1 \U_register_file/AMBA_WORD_registers_reg[1][30]  ( .D(
        \U_register_file/n191 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][30] ) );
  DFFRHQX1 \U_register_file/AMBA_WORD_registers_reg[1][26]  ( .D(
        \U_register_file/n187 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][26] ) );
  DFFRHQX1 \U_register_file/AMBA_WORD_registers_reg[1][20]  ( .D(
        \U_register_file/n181 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][20] ) );
  DFFRHQX1 \U_register_file/AMBA_WORD_registers_reg[1][28]  ( .D(
        \U_register_file/n189 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][28] ) );
  DFFRHQX1 \U_register_file/AMBA_WORD_registers_reg[1][7]  ( .D(
        \U_register_file/n168 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][7] ) );
  DFFRHQX1 \U_register_file/AMBA_WORD_registers_reg[1][6]  ( .D(
        \U_register_file/n167 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][6] ) );
  DFFRHQX4 \U_register_file/AMBA_WORD_registers_reg[0][13]  ( .D(
        \U_register_file/n144 ), .CK(clk), .RN(arstn), .Q(
        \U_encoder/CodeWord3 [19]) );
  DFFRHQX4 \U_register_file/AMBA_WORD_registers_reg[0][25]  ( .D(
        \U_register_file/n156 ), .CK(clk), .RN(arstn), .Q(
        \U_register_file/n272 ) );
  DFFRHQX4 \U_register_file/AMBA_WORD_registers_reg[0][11]  ( .D(
        \U_register_file/n142 ), .CK(clk), .RN(arstn), .Q(
        \U_register_file/n276 ) );
  DFFRHQX1 \U_register_file/AMBA_WORD_registers_reg[1][25]  ( .D(
        \U_register_file/n186 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][25] ) );
  DFFRHQX1 \U_register_file/AMBA_WORD_registers_reg[1][19]  ( .D(
        \U_register_file/n180 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][19] ) );
  DFFRHQX1 \U_register_file/AMBA_WORD_registers_reg[1][18]  ( .D(
        \U_register_file/n179 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][18] ) );
  DFFRHQX1 \U_register_file/AMBA_WORD_registers_reg[1][17]  ( .D(
        \U_register_file/n178 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][17] ) );
  DFFRHQX1 \U_register_file/AMBA_WORD_registers_reg[1][24]  ( .D(
        \U_register_file/n185 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][24] ) );
  DFFRHQX1 \U_register_file/AMBA_WORD_registers_reg[1][2]  ( .D(
        \U_register_file/n163 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][2] ) );
  DFFRHQX1 \U_register_file/AMBA_WORD_registers_reg[1][3]  ( .D(
        \U_register_file/n164 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][3] ) );
  DFFRHQX1 \U_register_file/AMBA_WORD_registers_reg[1][31]  ( .D(
        \U_register_file/n192 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][31] ) );
  DFFRHQX4 \U_register_file/AMBA_WORD_registers_reg[0][3]  ( .D(
        \U_register_file/n134 ), .CK(clk), .RN(arstn), .Q(
        \U_register_file/n284 ) );
  DFFRHQX4 \U_register_file/AMBA_WORD_registers_reg[0][10]  ( .D(
        \U_register_file/n141 ), .CK(clk), .RN(arstn), .Q(
        \U_register_file/n277 ) );
  DFFRHQX4 \U_register_file/AMBA_WORD_registers_reg[0][9]  ( .D(
        \U_register_file/n140 ), .CK(clk), .RN(arstn), .Q(
        \U_register_file/n278 ) );
  DFFRHQX4 \U_register_file/AMBA_WORD_registers_reg[0][17]  ( .D(
        \U_register_file/n148 ), .CK(clk), .RN(arstn), .Q(
        \U_encoder/CodeWord3 [23]) );
  DFFRHQX4 \U_register_file/AMBA_WORD_registers_reg[0][20]  ( .D(
        \U_register_file/n151 ), .CK(clk), .RN(arstn), .Q(
        \U_encoder/CodeWord3 [26]) );
  DFFRHQX4 \U_register_file/AMBA_WORD_registers_reg[0][12]  ( .D(
        \U_register_file/n143 ), .CK(clk), .RN(arstn), .Q(
        \U_encoder/CodeWord3 [18]) );
  DFFRHQX4 \U_register_file/AMBA_WORD_registers_reg[0][0]  ( .D(
        \U_register_file/n131 ), .CK(clk), .RN(arstn), .Q(
        \U_register_file/n287 ) );
  DFFRHQX4 \U_register_file/AMBA_WORD_registers_reg[0][5]  ( .D(
        \U_register_file/n136 ), .CK(clk), .RN(arstn), .Q(
        \U_register_file/n282 ) );
  DFFRHQX4 \U_register_file/AMBA_WORD_registers_reg[0][4]  ( .D(
        \U_register_file/n135 ), .CK(clk), .RN(arstn), .Q(
        \U_register_file/n283 ) );
  DFFRHQX4 \U_register_file/AMBA_WORD_registers_reg[0][16]  ( .D(
        \U_register_file/n147 ), .CK(clk), .RN(arstn), .Q(
        \U_encoder/CodeWord3 [22]) );
  DFFRHQX2 \U_register_file/two_bits_registers_reg[1][0]  ( .D(n903), .CK(clk), 
        .RN(arstn), .Q(\U_register_file/n289 ) );
  DFFRHQX2 \U_register_file/AMBA_WORD_registers_reg[0][21]  ( .D(
        \U_register_file/n152 ), .CK(clk), .RN(arstn), .Q(
        \U_register_file/n275 ) );
  DFFRHQX1 \U_register_file/AMBA_WORD_registers_reg[0][2]  ( .D(
        \U_register_file/n133 ), .CK(clk), .RN(arstn), .Q(
        \U_register_file/n285 ) );
  DFFRHQX2 \U_register_file/AMBA_WORD_registers_reg[0][15]  ( .D(
        \U_register_file/n146 ), .CK(clk), .RN(arstn), .Q(
        \U_encoder/CodeWord3 [21]) );
  DFFRHQX4 \U_register_file/AMBA_WORD_registers_reg[0][8]  ( .D(
        \U_register_file/n139 ), .CK(clk), .RN(arstn), .Q(
        \U_register_file/n279 ) );
  DFFSX2 \U_register_file/two_bits_registers_reg[0][0]  ( .D(n939), .CK(clk), 
        .SN(arstn), .Q(n1638), .QN(\two_bits_registers[0][0] ) );
  DFFRHQXL \U_register_file/AMBA_WORD_registers_reg[1][10]  ( .D(
        \U_register_file/n171 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][10] ) );
  DFFRHQXL \U_register_file/AMBA_WORD_registers_reg[1][8]  ( .D(
        \U_register_file/n169 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][8] ) );
  DFFRHQXL \U_register_file/AMBA_WORD_registers_reg[1][9]  ( .D(
        \U_register_file/n170 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][9] ) );
  DFFRHQXL \U_register_file/AMBA_WORD_registers_reg[1][14]  ( .D(
        \U_register_file/n175 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][14] ) );
  DFFRHQXL \U_register_file/AMBA_WORD_registers_reg[1][16]  ( .D(
        \U_register_file/n177 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][16] ) );
  DFFRHQXL \U_register_file/AMBA_WORD_registers_reg[1][12]  ( .D(
        \U_register_file/n173 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][12] ) );
  DFFRHQXL \U_register_file/AMBA_WORD_registers_reg[1][11]  ( .D(
        \U_register_file/n172 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][11] ) );
  DFFRHQXL \U_register_file/AMBA_WORD_registers_reg[1][13]  ( .D(
        \U_register_file/n174 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][13] ) );
  DFFRHQXL \U_register_file/AMBA_WORD_registers_reg[1][15]  ( .D(
        \U_register_file/n176 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][15] ) );
  DFFRHQX2 \U_register_file/AMBA_WORD_registers_reg[0][23]  ( .D(
        \U_register_file/n154 ), .CK(clk), .RN(arstn), .Q(
        \U_register_file/n274 ) );
  DFFRHQXL \U_register_file/AMBA_WORD_registers_reg[0][29]  ( .D(
        \U_register_file/n160 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[0][29] ) );
  DFFRHQXL \U_register_file/AMBA_WORD_registers_reg[0][27]  ( .D(
        \U_register_file/n158 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[0][27] ) );
  DFFRHQXL \U_register_file/AMBA_WORD_registers_reg[0][30]  ( .D(
        \U_register_file/n161 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[0][30] ) );
  DFFRHQXL \U_register_file/AMBA_WORD_registers_reg[0][26]  ( .D(
        \U_register_file/n157 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[0][26] ) );
  DFFRHQXL \U_register_file/AMBA_WORD_registers_reg[0][28]  ( .D(
        \U_register_file/n159 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[0][28] ) );
  DFFRHQXL \U_register_file/AMBA_WORD_registers_reg[0][31]  ( .D(
        \U_register_file/n162 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[0][31] ) );
  DFFRHQXL \U_register_file/AMBA_WORD_registers_reg[1][4]  ( .D(
        \U_register_file/n165 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][4] ) );
  DFFRHQXL \U_register_file/AMBA_WORD_registers_reg[1][5]  ( .D(
        \U_register_file/n166 ), .CK(clk), .RN(arstn), .Q(
        \AMBA_WORD_registers[1][5] ) );
  DFFRHQXL \U_op_done_logic/op_done_reg_reg  ( .D(\U_op_done_logic/N0 ), .CK(
        clk), .RN(arstn), .Q(operation_done) );
  DFFRHQX2 \U_register_file/AMBA_WORD_registers_reg[0][14]  ( .D(
        \U_register_file/n145 ), .CK(clk), .RN(arstn), .Q(
        \U_encoder/CodeWord3 [20]) );
  DFFRHQX2 \U_register_file/AMBA_WORD_registers_reg[0][19]  ( .D(
        \U_register_file/n150 ), .CK(clk), .RN(arstn), .Q(
        \U_encoder/CodeWord3 [25]) );
  DFFRHQX4 \U_register_file/AMBA_WORD_registers_reg[0][6]  ( .D(
        \U_register_file/n137 ), .CK(clk), .RN(arstn), .Q(
        \U_register_file/n281 ) );
  DFFRHQX4 \U_register_file/AMBA_WORD_registers_reg[0][22]  ( .D(
        \U_register_file/n153 ), .CK(clk), .RN(arstn), .Q(
        \U_encoder/CodeWord3 [28]) );
  DFFSX2 \U_register_file/two_bits_registers_reg[0][1]  ( .D(n940), .CK(clk), 
        .SN(arstn), .Q(n1637), .QN(\two_bits_registers[0][1] ) );
  DFFRHQX4 \U_register_file/AMBA_WORD_registers_reg[0][7]  ( .D(
        \U_register_file/n138 ), .CK(clk), .RN(arstn), .Q(
        \U_register_file/n280 ) );
  DFFRHQX4 \U_register_file/AMBA_WORD_registers_reg[0][24]  ( .D(
        \U_register_file/n155 ), .CK(clk), .RN(arstn), .Q(
        \U_register_file/n273 ) );
  DFFRHQX2 \U_register_file/AMBA_WORD_registers_reg[0][1]  ( .D(
        \U_register_file/n132 ), .CK(clk), .RN(arstn), .Q(
        \U_register_file/n286 ) );
  DFFRHQX1 \U_register_file/AMBA_WORD_registers_reg[0][18]  ( .D(
        \U_register_file/n149 ), .CK(clk), .RN(arstn), .Q(
        \U_encoder/CodeWord3 [24]) );
  OAI21X1 U904 ( .A0(n1413), .A1(n1412), .B0(n1411), .Y(data_out[11]) );
  NAND3X2 U905 ( .A(n1295), .B(n1294), .C(n1293), .Y(data_out[1]) );
  OAI21XL U906 ( .A0(n1391), .A1(n1390), .B0(n1423), .Y(n1395) );
  NOR2X2 U907 ( .A(n1363), .B(n1362), .Y(n1367) );
  NAND2XL U908 ( .A(n1632), .B(n1631), .Y(n1633) );
  OAI21X1 U909 ( .A0(n1342), .A1(n1341), .B0(n1340), .Y(n1343) );
  AOI31X1 U910 ( .A0(n1401), .A1(n1431), .A2(n1273), .B0(n1272), .Y(n1277) );
  OAI21X1 U911 ( .A0(n1608), .A1(n1365), .B0(n1489), .Y(n1366) );
  OAI21X1 U912 ( .A0(n1269), .A1(n1399), .B0(n1629), .Y(n1278) );
  OAI21XL U913 ( .A0(n1252), .A1(n1624), .B0(n1251), .Y(n1253) );
  OAI21XL U914 ( .A0(n1315), .A1(n1456), .B0(n1447), .Y(n1316) );
  NOR2X2 U915 ( .A(n1401), .B(n934), .Y(n1399) );
  NOR2X2 U916 ( .A(n1307), .B(n1283), .Y(n1451) );
  NAND3X1 U917 ( .A(n1314), .B(n1605), .C(n1454), .Y(n1459) );
  AOI21X2 U918 ( .A0(n1303), .A1(n1302), .B0(n1352), .Y(n1301) );
  AOI21X2 U919 ( .A0(n1454), .A1(n1466), .B0(n1262), .Y(n1261) );
  NOR3X2 U920 ( .A(n1475), .B(n1484), .C(n1624), .Y(n1479) );
  OAI21X2 U921 ( .A0(n1608), .A1(n1607), .B0(n1610), .Y(n1616) );
  NOR2X1 U922 ( .A(PWRITE), .B(n1378), .Y(n1493) );
  NOR3X1 U923 ( .A(PADDR[3]), .B(n1590), .C(n1374), .Y(n1494) );
  CLKINVX4 U924 ( .A(n1548), .Y(n935) );
  INVX4 U925 ( .A(n1291), .Y(n1483) );
  NOR3X2 U926 ( .A(n1624), .B(n1610), .C(n1609), .Y(n1614) );
  NAND2X1 U927 ( .A(n1466), .B(n1465), .Y(n1468) );
  NOR2X2 U928 ( .A(n1351), .B(n1406), .Y(n1307) );
  NAND2X2 U929 ( .A(n1628), .B(n1423), .Y(n1620) );
  INVX1 U930 ( .A(PADDR[2]), .Y(n1590) );
  OR2X2 U931 ( .A(n1369), .B(n1321), .Y(n1548) );
  CLKINVX3 U932 ( .A(n1482), .Y(n1475) );
  OR2X2 U933 ( .A(n1359), .B(n1297), .Y(n1405) );
  OR2X2 U934 ( .A(n1424), .B(n1609), .Y(n1430) );
  CLKINVX3 U935 ( .A(PWRITE), .Y(n1592) );
  NAND2X1 U936 ( .A(n1373), .B(PWRITE), .Y(n1369) );
  NOR2X2 U937 ( .A(n1609), .B(n1359), .Y(n1264) );
  CLKINVX3 U938 ( .A(num_of_errors[1]), .Y(n1239) );
  BUFX4 U939 ( .A(n1233), .Y(n1601) );
  NOR3X2 U940 ( .A(PADDR[5]), .B(PADDR[4]), .C(n1593), .Y(n1373) );
  INVX4 U941 ( .A(n1359), .Y(n1476) );
  NAND2X1 U942 ( .A(PENABLE), .B(PSEL), .Y(n1593) );
  NAND2XL U943 ( .A(num_of_errors[0]), .B(n1245), .Y(n1244) );
  INVX2 U944 ( .A(n1345), .Y(n1296) );
  INVX16 U945 ( .A(n1250), .Y(n1420) );
  NOR2X2 U946 ( .A(n1234), .B(n1222), .Y(n1223) );
  XOR2X1 U947 ( .A(n1178), .B(n1175), .Y(n1180) );
  INVXL U948 ( .A(n1159), .Y(n1173) );
  INVX1 U949 ( .A(n1206), .Y(n1184) );
  CLKINVX3 U950 ( .A(n1425), .Y(n1432) );
  OAI2BB1X1 U951 ( .A0N(n1132), .A1N(n1532), .B0(n1110), .Y(n1467) );
  CLKINVX3 U952 ( .A(n1611), .Y(n1130) );
  INVX1 U953 ( .A(n1164), .Y(n1166) );
  AOI2BB2X1 U954 ( .B0(\U_register_file/n287 ), .B1(n1311), .A0N(n1126), .A1N(
        n1308), .Y(n1127) );
  INVX1 U955 ( .A(n1132), .Y(n1023) );
  OAI21XL U956 ( .A0(\AMBA_WORD_registers[1][17] ), .A1(n1016), .B0(n1015), 
        .Y(n1017) );
  AOI2BB2X1 U957 ( .B0(n1311), .B1(n1003), .A0N(n1002), .A1N(n1308), .Y(n1004)
         );
  INVX8 U958 ( .A(n1390), .Y(n1393) );
  NAND2X1 U959 ( .A(\U_register_file/n281 ), .B(n1238), .Y(n1020) );
  INVX1 U960 ( .A(n1132), .Y(n1053) );
  INVX1 U961 ( .A(n1132), .Y(n1085) );
  OAI21XL U962 ( .A0(\AMBA_WORD_registers[1][21] ), .A1(n1033), .B0(n1032), 
        .Y(n1034) );
  XOR2X1 U963 ( .A(n1392), .B(\AMBA_WORD_registers[1][13] ), .Y(n989) );
  OAI21X1 U964 ( .A0(\AMBA_WORD_registers[1][30] ), .A1(n1099), .B0(n1098), 
        .Y(n1100) );
  OAI2BB1X1 U965 ( .A0N(\U_register_file/n279 ), .A1N(n1255), .B0(n987), .Y(
        n1392) );
  OAI21XL U966 ( .A0(\AMBA_WORD_registers[1][27] ), .A1(n960), .B0(n959), .Y(
        n961) );
  INVX1 U967 ( .A(n1408), .Y(n943) );
  OAI21X1 U968 ( .A0(n1636), .A1(n1545), .B0(n932), .Y(n1025) );
  AOI21X2 U969 ( .A0(\AMBA_WORD_registers[1][19] ), .A1(n1090), .B0(n1132), 
        .Y(n1089) );
  XOR2X1 U970 ( .A(\U_register_file/n274 ), .B(\U_register_file/n276 ), .Y(
        n1077) );
  NAND2X1 U971 ( .A(n1107), .B(\U_register_file/n275 ), .Y(n960) );
  XOR2X2 U972 ( .A(n1050), .B(\U_register_file/n277 ), .Y(n1040) );
  CLKINVX3 U973 ( .A(\U_register_file/n273 ), .Y(n1573) );
  INVX2 U974 ( .A(\U_encoder/CodeWord3 [20]), .Y(n1600) );
  BUFX16 U975 ( .A(n944), .Y(n1132) );
  INVX1 U976 ( .A(\U_register_file/n281 ), .Y(n1579) );
  NOR2BX2 U977 ( .AN(n1370), .B(n1238), .Y(n972) );
  CLKINVX3 U978 ( .A(\U_encoder/CodeWord3 [28]), .Y(n1561) );
  CLKINVX3 U979 ( .A(\U_register_file/n276 ), .Y(n1542) );
  NOR2BX2 U980 ( .AN(\two_bits_registers[0][0] ), .B(
        \two_bits_registers[0][1] ), .Y(n944) );
  INVX4 U981 ( .A(\U_register_file/n282 ), .Y(n1499) );
  INVX12 U982 ( .A(\U_encoder/CodeWord3 [21]), .Y(n1575) );
  INVX2 U983 ( .A(\U_encoder/CodeWord3 [25]), .Y(n1567) );
  INVX2 U984 ( .A(\U_encoder/CodeWord3 [24]), .Y(n1532) );
  CLKINVX4 U985 ( .A(\U_register_file/n272 ), .Y(n1571) );
  CLKINVX4 U986 ( .A(\U_encoder/CodeWord3 [23]), .Y(n1534) );
  INVX2 U987 ( .A(\U_encoder/CodeWord3 [19]), .Y(n1539) );
  BUFX3 U988 ( .A(n1071), .Y(n938) );
  OAI21XL U989 ( .A0(\AMBA_WORD_registers[1][24] ), .A1(n965), .B0(n964), .Y(
        n966) );
  NOR2X1 U990 ( .A(n1592), .B(n1378), .Y(n1500) );
  XOR2XL U991 ( .A(n1449), .B(n1448), .Y(n1450) );
  AOI211X1 U992 ( .A0(n1476), .A1(n1420), .B0(n1419), .C0(n1422), .Y(n1421) );
  OAI21XL U993 ( .A0(n1330), .A1(n1609), .B0(n1603), .Y(n1275) );
  AND2X1 U994 ( .A(n1132), .B(n1534), .Y(n1018) );
  NOR2X2 U995 ( .A(n1481), .B(n934), .Y(n1463) );
  OAI21X1 U996 ( .A0(n1292), .A1(n1399), .B0(n1448), .Y(n1293) );
  OAI21XL U997 ( .A0(n1417), .A1(n1635), .B0(n1416), .Y(data_out[14]) );
  INVX4 U998 ( .A(\U_register_file/n288 ), .Y(n1372) );
  XNOR2X1 U999 ( .A(n1214), .B(n1213), .Y(n1215) );
  INVX1 U1000 ( .A(n1265), .Y(n1267) );
  AOI22X1 U1001 ( .A0(n1429), .A1(n1428), .B0(n1612), .B1(n1427), .Y(n1434) );
  INVX1 U1002 ( .A(n1442), .Y(n1439) );
  INVX1 U1003 ( .A(n1400), .Y(n1398) );
  INVX1 U1004 ( .A(n1397), .Y(n1404) );
  INVX1 U1005 ( .A(n1000), .Y(n1003) );
  AOI22X1 U1006 ( .A0(n935), .A1(n1554), .B0(n1553), .B1(n931), .Y(
        \U_register_file/n159 ) );
  NAND2X1 U1007 ( .A(n931), .B(\U_register_file/n284 ), .Y(n1386) );
  AOI22X1 U1008 ( .A0(n935), .A1(n1564), .B0(n1563), .B1(n931), .Y(
        \U_register_file/n151 ) );
  AOI22X1 U1009 ( .A0(n935), .A1(n1572), .B0(n1571), .B1(n931), .Y(
        \U_register_file/n156 ) );
  AOI22X1 U1010 ( .A0(n935), .A1(n1568), .B0(n1567), .B1(n931), .Y(
        \U_register_file/n150 ) );
  AOI22X1 U1011 ( .A0(n935), .A1(n1566), .B0(n1565), .B1(n931), .Y(
        \U_register_file/n152 ) );
  AOI22X1 U1012 ( .A0(n935), .A1(n1580), .B0(n1579), .B1(n931), .Y(
        \U_register_file/n137 ) );
  AOI22X1 U1013 ( .A0(n935), .A1(n1562), .B0(n1561), .B1(n931), .Y(
        \U_register_file/n153 ) );
  AOI22X1 U1014 ( .A0(n935), .A1(n1578), .B0(n1577), .B1(n931), .Y(
        \U_register_file/n135 ) );
  AOI22X1 U1015 ( .A0(n935), .A1(n1576), .B0(n1575), .B1(n931), .Y(
        \U_register_file/n146 ) );
  AOI22X1 U1016 ( .A0(n935), .A1(n1574), .B0(n1573), .B1(n931), .Y(
        \U_register_file/n155 ) );
  AOI22X1 U1017 ( .A0(n935), .A1(n1582), .B0(n1581), .B1(n931), .Y(
        \U_register_file/n139 ) );
  AOI22X1 U1018 ( .A0(n935), .A1(n1552), .B0(n1551), .B1(n931), .Y(
        \U_register_file/n160 ) );
  NAND2X1 U1019 ( .A(n1050), .B(n1311), .Y(n1051) );
  AOI22X1 U1020 ( .A0(n936), .A1(n1505), .B0(n1546), .B1(n933), .Y(
        \U_register_file/n164 ) );
  AOI22X1 U1021 ( .A0(n936), .A1(n1512), .B0(n1540), .B1(n933), .Y(
        \U_register_file/n173 ) );
  AOI22X1 U1022 ( .A0(n936), .A1(n1560), .B0(n1517), .B1(n933), .Y(
        \U_register_file/n192 ) );
  AOI22X1 U1023 ( .A0(n936), .A1(n1556), .B0(n1521), .B1(n933), .Y(
        \U_register_file/n188 ) );
  AOI22X1 U1024 ( .A0(n936), .A1(n1506), .B0(n1587), .B1(n933), .Y(
        \U_register_file/n163 ) );
  AOI22X1 U1025 ( .A0(n936), .A1(n1570), .B0(n1535), .B1(n933), .Y(
        \U_register_file/n177 ) );
  AOI22X1 U1026 ( .A0(n936), .A1(n1566), .B0(n1528), .B1(n933), .Y(
        \U_register_file/n182 ) );
  AOI22X1 U1027 ( .A0(n936), .A1(n1510), .B0(n1537), .B1(n933), .Y(
        \U_register_file/n175 ) );
  AOI22X1 U1028 ( .A0(n936), .A1(n1562), .B0(n1527), .B1(n933), .Y(
        \U_register_file/n183 ) );
  AOI22X1 U1029 ( .A0(n936), .A1(n1584), .B0(n1545), .B1(n933), .Y(
        \U_register_file/n170 ) );
  AOI22X1 U1030 ( .A0(n936), .A1(n1507), .B0(n1525), .B1(n933), .Y(
        \U_register_file/n184 ) );
  AOI22X1 U1031 ( .A0(n936), .A1(n1578), .B0(n1504), .B1(n933), .Y(
        \U_register_file/n165 ) );
  AOI22X1 U1032 ( .A0(n936), .A1(n1582), .B0(n1516), .B1(n933), .Y(
        \U_register_file/n169 ) );
  AOI22X1 U1033 ( .A0(n936), .A1(n1515), .B0(n1514), .B1(n933), .Y(
        \U_register_file/n171 ) );
  AOI22X1 U1034 ( .A0(n936), .A1(n1554), .B0(n1520), .B1(n933), .Y(
        \U_register_file/n189 ) );
  AOI22X1 U1035 ( .A0(n936), .A1(n1564), .B0(n1529), .B1(n933), .Y(
        \U_register_file/n181 ) );
  AOI22X1 U1036 ( .A0(n936), .A1(n1502), .B0(n1501), .B1(n933), .Y(
        \U_register_file/n168 ) );
  AOI22X1 U1037 ( .A0(n936), .A1(n1580), .B0(n1503), .B1(n933), .Y(
        \U_register_file/n167 ) );
  AOI22X1 U1038 ( .A0(n936), .A1(n1558), .B0(n1522), .B1(n933), .Y(
        \U_register_file/n187 ) );
  OAI22XL U1039 ( .A0(n1547), .A1(n1544), .B0(n1546), .B1(n1586), .Y(PRDATA[3]) );
  AOI22X1 U1040 ( .A0(n936), .A1(n1576), .B0(n1536), .B1(n933), .Y(
        \U_register_file/n176 ) );
  AOI22X1 U1041 ( .A0(n936), .A1(n1550), .B0(n1518), .B1(n933), .Y(
        \U_register_file/n191 ) );
  AOI22X1 U1042 ( .A0(n936), .A1(n1552), .B0(n1519), .B1(n933), .Y(
        \U_register_file/n190 ) );
  AOI22X1 U1043 ( .A0(n936), .A1(n1572), .B0(n1523), .B1(n933), .Y(
        \U_register_file/n186 ) );
  AOI22X1 U1044 ( .A0(n936), .A1(n1513), .B0(n1543), .B1(n933), .Y(
        \U_register_file/n172 ) );
  AOI22X1 U1045 ( .A0(n936), .A1(n1568), .B0(n1530), .B1(n933), .Y(
        \U_register_file/n180 ) );
  AOI22X1 U1046 ( .A0(n936), .A1(n1509), .B0(n1533), .B1(n933), .Y(
        \U_register_file/n178 ) );
  AOI22X1 U1047 ( .A0(n936), .A1(n1511), .B0(n1538), .B1(n933), .Y(
        \U_register_file/n174 ) );
  AOI22X1 U1048 ( .A0(n936), .A1(n1508), .B0(n1531), .B1(n933), .Y(
        \U_register_file/n179 ) );
  AOI22X1 U1049 ( .A0(n936), .A1(n1574), .B0(n1524), .B1(n933), .Y(
        \U_register_file/n185 ) );
  INVX1 U1050 ( .A(n1601), .Y(n1428) );
  CLKINVX3 U1051 ( .A(n1132), .Y(n1101) );
  INVX8 U1052 ( .A(n1132), .Y(n930) );
  INVX8 U1053 ( .A(\U_register_file/n279 ), .Y(n1581) );
  NAND3X1 U1054 ( .A(n1451), .B(n1635), .C(n1324), .Y(n1339) );
  INVX8 U1055 ( .A(n1440), .Y(n1466) );
  NAND3X1 U1056 ( .A(n1332), .B(n1490), .C(n1331), .Y(n1337) );
  NOR2X1 U1057 ( .A(n1389), .B(n934), .Y(n1335) );
  NOR3X1 U1058 ( .A(n1456), .B(n1448), .C(n1406), .Y(n1281) );
  NOR2X1 U1059 ( .A(n1613), .B(n934), .Y(n1607) );
  AOI2BB2X2 U1060 ( .B0(n1311), .B1(n1180), .A0N(n1179), .A1N(n1308), .Y(n1181) );
  AND2X2 U1061 ( .A(n1246), .B(n1245), .Y(n1247) );
  XOR2X1 U1062 ( .A(n1323), .B(n1448), .Y(n1175) );
  INVX1 U1063 ( .A(n1610), .Y(n1422) );
  INVX4 U1064 ( .A(n1190), .Y(n1105) );
  AOI2BB2X1 U1065 ( .B0(n1242), .B1(n1596), .A0N(n1596), .A1N(n1242), .Y(n1213) );
  INVX4 U1066 ( .A(n1064), .Y(n1066) );
  AOI2BB2X1 U1067 ( .B0(n936), .B1(n1380), .A0N(\AMBA_WORD_registers[1][1] ), 
        .A1N(n936), .Y(n904) );
  AOI2BB2X1 U1068 ( .B0(n936), .B1(n1384), .A0N(\AMBA_WORD_registers[1][0] ), 
        .A1N(n936), .Y(n905) );
  NAND2X1 U1069 ( .A(n936), .B(PWDATA[5]), .Y(n1379) );
  OAI22XL U1070 ( .A0(n1536), .A1(n1586), .B0(n1575), .B1(n1544), .Y(
        PRDATA[15]) );
  AOI21X1 U1071 ( .A0(\AMBA_WORD_registers[1][17] ), .A1(n1016), .B0(n1132), 
        .Y(n1015) );
  INVX8 U1072 ( .A(n935), .Y(n931) );
  AND2X2 U1073 ( .A(n1132), .B(\U_register_file/n279 ), .Y(n1030) );
  AND2X2 U1074 ( .A(n1132), .B(\U_register_file/n276 ), .Y(n947) );
  INVX4 U1075 ( .A(n1132), .Y(n932) );
  CLKINVX3 U1076 ( .A(n1635), .Y(n1612) );
  INVX8 U1077 ( .A(n1500), .Y(n933) );
  INVX1 U1078 ( .A(\U_encoder/CodeWord3 [21]), .Y(n986) );
  CLKBUFX8 U1079 ( .A(\U_register_file/n286 ), .Y(n937) );
  OR2X2 U1080 ( .A(n1375), .B(n1593), .Y(n1378) );
  NAND2X2 U1081 ( .A(n1473), .B(n1472), .Y(data_out[12]) );
  OAI21X2 U1082 ( .A0(n1542), .A1(n1601), .B0(n1263), .Y(data_out[17]) );
  OAI21X2 U1083 ( .A0(n1355), .A1(n1354), .B0(n1353), .Y(n1356) );
  NAND3X2 U1084 ( .A(n1278), .B(n1277), .C(n1276), .Y(data_out[8]) );
  NAND2X2 U1085 ( .A(n1626), .B(n1625), .Y(n1634) );
  AOI21X2 U1086 ( .A0(n1342), .A1(n1341), .B0(n1352), .Y(n1340) );
  AOI21X2 U1087 ( .A0(n1486), .A1(n1466), .B0(n1415), .Y(n1414) );
  AOI211X2 U1088 ( .A0(n1432), .A1(n1361), .B0(n1360), .C0(n1619), .Y(n1363)
         );
  INVX1 U1089 ( .A(n1595), .Y(n1597) );
  XOR2X1 U1090 ( .A(n1630), .B(n1629), .Y(n1631) );
  NAND3X1 U1091 ( .A(n1464), .B(n1463), .C(n1467), .Y(n1473) );
  AOI22X1 U1092 ( .A0(n1389), .A1(n1329), .B0(n1612), .B1(n1328), .Y(n1338) );
  NAND3X1 U1093 ( .A(n1464), .B(n1432), .C(n1431), .Y(n1433) );
  NAND3X1 U1094 ( .A(n1401), .B(n1463), .C(n1400), .Y(n1402) );
  INVX2 U1095 ( .A(n1481), .Y(n1286) );
  BUFX16 U1096 ( .A(n1237), .Y(n1627) );
  BUFX12 U1097 ( .A(n1244), .Y(n934) );
  OAI21X2 U1098 ( .A0(n1188), .A1(n1187), .B0(n1186), .Y(n1211) );
  XOR2X2 U1099 ( .A(n1216), .B(n1215), .Y(n1217) );
  XOR2X2 U1100 ( .A(n1169), .B(n1168), .Y(n1170) );
  NAND2X2 U1101 ( .A(n1167), .B(n1166), .Y(n1165) );
  OAI21X2 U1102 ( .A0(n1504), .A1(n1130), .B0(n1129), .Y(n1131) );
  INVXL U1103 ( .A(n1605), .Y(n1455) );
  XOR2X2 U1104 ( .A(n978), .B(n977), .Y(n980) );
  NAND2X2 U1105 ( .A(n963), .B(n1265), .Y(n962) );
  INVX1 U1106 ( .A(n1273), .Y(n1629) );
  XNOR2X2 U1107 ( .A(n1059), .B(n975), .Y(n978) );
  AOI2BB2X1 U1108 ( .B0(n1303), .B1(n1251), .A0N(n1251), .A1N(n1303), .Y(n1195) );
  XOR2X2 U1109 ( .A(n1082), .B(\AMBA_WORD_registers[1][5] ), .Y(n1084) );
  OR2X2 U1110 ( .A(n1283), .B(n1125), .Y(n979) );
  OAI22XL U1111 ( .A0(n1601), .A1(n1499), .B0(n1408), .B1(n1635), .Y(n1409) );
  MXI2X1 U1112 ( .A(n1380), .B(n1322), .S0(n931), .Y(\U_register_file/n132 )
         );
  MXI2X1 U1113 ( .A(n1512), .B(n1541), .S0(n931), .Y(\U_register_file/n143 )
         );
  MXI2X1 U1114 ( .A(n1509), .B(n1534), .S0(n931), .Y(\U_register_file/n148 )
         );
  NAND2X1 U1115 ( .A(n931), .B(\U_encoder/CodeWord3 [19]), .Y(n1387) );
  NAND2X1 U1116 ( .A(n931), .B(\U_register_file/n287 ), .Y(n1383) );
  MXI2X1 U1117 ( .A(n1507), .B(n1526), .S0(n931), .Y(\U_register_file/n154 )
         );
  OAI22XL U1118 ( .A0(n1588), .A1(n1544), .B0(n1587), .B1(n1586), .Y(PRDATA[2]) );
  MXI2X1 U1119 ( .A(n1510), .B(n1600), .S0(n931), .Y(\U_register_file/n145 )
         );
  NAND2X1 U1120 ( .A(n931), .B(n1585), .Y(n1382) );
  NAND2X1 U1121 ( .A(n931), .B(\U_register_file/n280 ), .Y(n1388) );
  OAI22XL U1122 ( .A0(n1526), .A1(n1544), .B0(n1525), .B1(n1586), .Y(
        PRDATA[23]) );
  OAI22XL U1123 ( .A0(n1561), .A1(n1544), .B0(n1527), .B1(n1586), .Y(
        PRDATA[22]) );
  OAI22XL U1124 ( .A0(n1563), .A1(n1544), .B0(n1529), .B1(n1586), .Y(
        PRDATA[20]) );
  OAI22XL U1125 ( .A0(n1567), .A1(n1544), .B0(n1530), .B1(n1586), .Y(
        PRDATA[19]) );
  OAI22XL U1126 ( .A0(n1532), .A1(n1544), .B0(n1531), .B1(n1586), .Y(
        PRDATA[18]) );
  OAI22XL U1127 ( .A0(n1534), .A1(n1544), .B0(n1533), .B1(n1586), .Y(
        PRDATA[17]) );
  OAI22XL U1128 ( .A0(n1600), .A1(n1544), .B0(n1537), .B1(n1586), .Y(
        PRDATA[14]) );
  OAI22XL U1129 ( .A0(n1544), .A1(n1438), .B0(n1586), .B1(n1501), .Y(PRDATA[7]) );
  OAI22XL U1130 ( .A0(n1544), .A1(n1446), .B0(n1586), .B1(n1514), .Y(
        PRDATA[10]) );
  OAI22XL U1131 ( .A0(n1539), .A1(n1544), .B0(n1538), .B1(n1586), .Y(
        PRDATA[13]) );
  OAI22XL U1132 ( .A0(n1541), .A1(n1544), .B0(n1540), .B1(n1586), .Y(
        PRDATA[12]) );
  MXI2X1 U1133 ( .A(n1508), .B(n1532), .S0(n931), .Y(\U_register_file/n149 )
         );
  OAI21X2 U1134 ( .A0(\AMBA_WORD_registers[1][31] ), .A1(n1093), .B0(n1092), 
        .Y(n1094) );
  OAI21X2 U1135 ( .A0(n1112), .A1(n974), .B0(n1107), .Y(n973) );
  OAI21X1 U1136 ( .A0(\AMBA_WORD_registers[1][29] ), .A1(n953), .B0(n952), .Y(
        n954) );
  OAI22XL U1137 ( .A0(n1543), .A1(n1586), .B0(n1542), .B1(n1544), .Y(
        PRDATA[11]) );
  OAI22XL U1138 ( .A0(n1573), .A1(n1544), .B0(n1524), .B1(n1586), .Y(
        PRDATA[24]) );
  OAI22XL U1139 ( .A0(n1516), .A1(n1586), .B0(n1581), .B1(n1544), .Y(PRDATA[8]) );
  OAI22XL U1140 ( .A0(n1579), .A1(n1544), .B0(n1503), .B1(n1586), .Y(PRDATA[6]) );
  OAI22XL U1141 ( .A0(n1565), .A1(n1544), .B0(n1528), .B1(n1586), .Y(
        PRDATA[21]) );
  OAI22XL U1142 ( .A0(n1499), .A1(n1544), .B0(n1498), .B1(n1586), .Y(PRDATA[5]) );
  OAI22XL U1143 ( .A0(n1557), .A1(n1544), .B0(n1522), .B1(n1586), .Y(
        PRDATA[26]) );
  OAI22XL U1144 ( .A0(n1577), .A1(n1544), .B0(n1504), .B1(n1586), .Y(PRDATA[4]) );
  OAI22XL U1145 ( .A0(n1555), .A1(n1544), .B0(n1521), .B1(n1586), .Y(
        PRDATA[27]) );
  OAI22XL U1146 ( .A0(n1553), .A1(n1544), .B0(n1520), .B1(n1586), .Y(
        PRDATA[28]) );
  OAI22XL U1147 ( .A0(n1571), .A1(n1544), .B0(n1523), .B1(n1586), .Y(
        PRDATA[25]) );
  OAI22XL U1148 ( .A0(n1551), .A1(n1544), .B0(n1519), .B1(n1586), .Y(
        PRDATA[29]) );
  OAI22XL U1149 ( .A0(n1549), .A1(n1544), .B0(n1518), .B1(n1586), .Y(
        PRDATA[30]) );
  OAI22XL U1150 ( .A0(n1559), .A1(n1544), .B0(n1517), .B1(n1586), .Y(
        PRDATA[31]) );
  NOR2XL U1151 ( .A(n1573), .B(n1601), .Y(data_out[30]) );
  NOR2XL U1152 ( .A(n1571), .B(n1601), .Y(data_out[31]) );
  NOR2XL U1153 ( .A(n1526), .B(n1601), .Y(data_out[29]) );
  XOR2X1 U1154 ( .A(n1125), .B(n1124), .Y(n1126) );
  NOR2XL U1155 ( .A(n1561), .B(n1601), .Y(data_out[28]) );
  NOR2XL U1156 ( .A(n1565), .B(n1601), .Y(data_out[27]) );
  NOR2XL U1157 ( .A(n1563), .B(n1601), .Y(data_out[26]) );
  INVX8 U1158 ( .A(n1494), .Y(n1544) );
  NAND2X1 U1159 ( .A(n1132), .B(\U_register_file/n282 ), .Y(n1083) );
  NAND2X1 U1160 ( .A(n1132), .B(\U_register_file/n287 ), .Y(n1075) );
  NOR3X1 U1161 ( .A(PADDR[2]), .B(PADDR[3]), .C(n1369), .Y(n941) );
  INVX8 U1162 ( .A(n933), .Y(n936) );
  NOR3X1 U1163 ( .A(PADDR[2]), .B(n1369), .C(n1589), .Y(n1371) );
  NAND2X1 U1164 ( .A(n1373), .B(n1592), .Y(n1374) );
  INVX1 U1165 ( .A(\AMBA_WORD_registers[1][17] ), .Y(n1533) );
  INVX1 U1166 ( .A(\AMBA_WORD_registers[1][13] ), .Y(n1538) );
  INVX1 U1167 ( .A(\AMBA_WORD_registers[1][18] ), .Y(n1531) );
  INVX1 U1168 ( .A(\AMBA_WORD_registers[1][16] ), .Y(n1535) );
  INVX1 U1169 ( .A(\AMBA_WORD_registers[1][14] ), .Y(n1537) );
  INVX1 U1170 ( .A(\AMBA_WORD_registers[1][19] ), .Y(n1530) );
  INVX1 U1171 ( .A(\AMBA_WORD_registers[1][20] ), .Y(n1529) );
  INVX1 U1172 ( .A(\AMBA_WORD_registers[1][5] ), .Y(n1498) );
  INVX1 U1173 ( .A(\AMBA_WORD_registers[1][21] ), .Y(n1528) );
  INVX1 U1174 ( .A(\AMBA_WORD_registers[0][27] ), .Y(n1555) );
  INVX1 U1175 ( .A(\AMBA_WORD_registers[1][2] ), .Y(n1587) );
  INVX1 U1176 ( .A(\AMBA_WORD_registers[1][22] ), .Y(n1527) );
  INVX1 U1177 ( .A(\AMBA_WORD_registers[1][7] ), .Y(n1501) );
  INVX1 U1178 ( .A(\AMBA_WORD_registers[0][28] ), .Y(n1553) );
  INVX1 U1179 ( .A(\AMBA_WORD_registers[0][26] ), .Y(n1557) );
  INVX1 U1180 ( .A(\AMBA_WORD_registers[1][23] ), .Y(n1525) );
  INVX16 U1181 ( .A(\U_register_file/n284 ), .Y(n1547) );
  INVX1 U1182 ( .A(\AMBA_WORD_registers[1][24] ), .Y(n1524) );
  INVX1 U1183 ( .A(\AMBA_WORD_registers[1][6] ), .Y(n1503) );
  INVX1 U1184 ( .A(\AMBA_WORD_registers[1][29] ), .Y(n1519) );
  INVX1 U1185 ( .A(\AMBA_WORD_registers[0][30] ), .Y(n1549) );
  INVX1 U1186 ( .A(\AMBA_WORD_registers[1][25] ), .Y(n1523) );
  INVX1 U1187 ( .A(\AMBA_WORD_registers[1][27] ), .Y(n1521) );
  INVX1 U1188 ( .A(\AMBA_WORD_registers[1][0] ), .Y(n1074) );
  INVX1 U1189 ( .A(\AMBA_WORD_registers[1][31] ), .Y(n1517) );
  INVX1 U1190 ( .A(\AMBA_WORD_registers[1][3] ), .Y(n1546) );
  INVX1 U1191 ( .A(\AMBA_WORD_registers[1][30] ), .Y(n1518) );
  INVX1 U1192 ( .A(\AMBA_WORD_registers[1][26] ), .Y(n1522) );
  INVX1 U1193 ( .A(\AMBA_WORD_registers[1][28] ), .Y(n1520) );
  INVX1 U1194 ( .A(\AMBA_WORD_registers[0][29] ), .Y(n1551) );
  INVX1 U1195 ( .A(\AMBA_WORD_registers[0][31] ), .Y(n1559) );
  INVX1 U1196 ( .A(PWDATA[12]), .Y(n1512) );
  INVX1 U1197 ( .A(PWDATA[8]), .Y(n1582) );
  INVX1 U1198 ( .A(PWDATA[3]), .Y(n1505) );
  INVX1 U1199 ( .A(PWDATA[18]), .Y(n1508) );
  INVX1 U1200 ( .A(PWDATA[11]), .Y(n1513) );
  INVX1 U1201 ( .A(PWDATA[31]), .Y(n1560) );
  INVX1 U1202 ( .A(PWDATA[4]), .Y(n1578) );
  INVX1 U1203 ( .A(PWDATA[19]), .Y(n1568) );
  INVX1 U1204 ( .A(PWDATA[2]), .Y(n1506) );
  INVX1 U1205 ( .A(PWDATA[9]), .Y(n1584) );
  INVX1 U1206 ( .A(PWDATA[17]), .Y(n1509) );
  INVX1 U1207 ( .A(PWDATA[10]), .Y(n1515) );
  INVX1 U1208 ( .A(PWDATA[24]), .Y(n1574) );
  INVX1 U1209 ( .A(PWDATA[14]), .Y(n1510) );
  AOI211X1 U1210 ( .A0(PADDR[2]), .A1(PADDR[3]), .B0(PADDR[5]), .C0(PADDR[4]), 
        .Y(n1375) );
  INVX1 U1211 ( .A(PWDATA[29]), .Y(n1552) );
  INVX1 U1212 ( .A(PWDATA[27]), .Y(n1556) );
  INVX1 U1213 ( .A(PWDATA[25]), .Y(n1572) );
  INVX1 U1214 ( .A(PWDATA[20]), .Y(n1564) );
  INVX1 U1215 ( .A(PWDATA[22]), .Y(n1562) );
  INVX1 U1216 ( .A(PWDATA[21]), .Y(n1566) );
  INVX1 U1217 ( .A(PWDATA[26]), .Y(n1558) );
  INVX1 U1218 ( .A(PWDATA[13]), .Y(n1511) );
  INVX1 U1219 ( .A(PWDATA[16]), .Y(n1570) );
  NAND2BX1 U1220 ( .AN(PADDR[3]), .B(PADDR[2]), .Y(n1321) );
  INVX1 U1221 ( .A(PWDATA[7]), .Y(n1502) );
  INVX1 U1222 ( .A(PWDATA[6]), .Y(n1580) );
  INVX1 U1223 ( .A(PWDATA[28]), .Y(n1554) );
  INVX1 U1224 ( .A(PWDATA[15]), .Y(n1576) );
  INVX1 U1225 ( .A(PWDATA[30]), .Y(n1550) );
  INVX1 U1226 ( .A(PWDATA[23]), .Y(n1507) );
  NAND2X1 U1227 ( .A(n1238), .B(\U_register_file/n273 ), .Y(n1099) );
  OAI21X1 U1228 ( .A0(\AMBA_WORD_registers[1][23] ), .A1(n1096), .B0(n1095), 
        .Y(n1097) );
  XOR2X2 U1229 ( .A(\U_register_file/n280 ), .B(\U_register_file/n277 ), .Y(
        n1123) );
  NAND2X1 U1230 ( .A(\U_register_file/n280 ), .B(n1238), .Y(n987) );
  BUFX12 U1231 ( .A(n942), .Y(n1255) );
  INVX8 U1232 ( .A(\U_register_file/n278 ), .Y(n1583) );
  AOI22X1 U1233 ( .A0(\U_register_file/n282 ), .A1(\U_register_file/n278 ), 
        .B0(n1583), .B1(n1499), .Y(n976) );
  XOR2X1 U1234 ( .A(n1123), .B(n1122), .Y(n1124) );
  XNOR2X1 U1235 ( .A(\U_register_file/n283 ), .B(\U_register_file/n282 ), .Y(
        n1122) );
  OAI21X4 U1236 ( .A0(n1118), .A1(n1117), .B0(n1116), .Y(n1120) );
  NAND2X2 U1237 ( .A(n1118), .B(n1117), .Y(n1116) );
  XNOR2X2 U1238 ( .A(n1115), .B(n1114), .Y(n1118) );
  INVX8 U1239 ( .A(n1372), .Y(n1107) );
  NAND4BX2 U1240 ( .AN(n1436), .B(n1435), .C(n1434), .D(n1433), .Y(data_out[5]) );
  OAI21X1 U1241 ( .A0(n1608), .A1(n1469), .B0(n1425), .Y(n1435) );
  MXI2X4 U1242 ( .A(n1571), .B(\U_register_file/n272 ), .S0(
        \U_register_file/n274 ), .Y(n997) );
  NAND2X4 U1243 ( .A(n1255), .B(\U_register_file/n281 ), .Y(n1408) );
  MXI2X2 U1244 ( .A(n1579), .B(\U_register_file/n281 ), .S0(n976), .Y(n1039)
         );
  MXI2X1 U1245 ( .A(n1579), .B(\U_register_file/n281 ), .S0(
        \U_register_file/n277 ), .Y(n1057) );
  AOI2BB2X1 U1246 ( .B0(n1212), .B1(n1342), .A0N(n1342), .A1N(n1212), .Y(n1214) );
  AOI21X2 U1247 ( .A0(n1115), .A1(n999), .B0(n1372), .Y(n998) );
  AND2X1 U1248 ( .A(n1132), .B(\U_register_file/n277 ), .Y(n950) );
  INVX8 U1249 ( .A(\U_register_file/n288 ), .Y(n1232) );
  NAND2X2 U1250 ( .A(n1420), .B(n1609), .Y(n1602) );
  INVX1 U1251 ( .A(n1613), .Y(n1274) );
  XOR2XL U1252 ( .A(n1412), .B(n1225), .Y(n1228) );
  XOR2XL U1253 ( .A(n1401), .B(n1331), .Y(n1290) );
  INVXL U1254 ( .A(n1333), .Y(n1306) );
  AND2X1 U1255 ( .A(n1132), .B(\U_register_file/n278 ), .Y(n1026) );
  INVXL U1256 ( .A(n1484), .Y(n1485) );
  NAND2XL U1257 ( .A(n1238), .B(\U_register_file/n277 ), .Y(n1022) );
  NAND2X2 U1258 ( .A(n1475), .B(n1423), .Y(n1486) );
  OAI21X2 U1259 ( .A0(n1137), .A1(n1432), .B0(n1136), .Y(n1176) );
  NAND2X1 U1260 ( .A(n1137), .B(n1432), .Y(n1136) );
  AOI22XL U1261 ( .A0(n1447), .A1(n1489), .B0(n1185), .B1(n1313), .Y(n1187) );
  NAND2X1 U1262 ( .A(n1207), .B(n1311), .Y(n1208) );
  XOR2XL U1263 ( .A(n1206), .B(n1325), .Y(n1207) );
  XOR2XL U1264 ( .A(\U_register_file/n287 ), .B(n1056), .Y(n1071) );
  XOR2X2 U1265 ( .A(\U_register_file/n275 ), .B(\U_register_file/n273 ), .Y(
        n1045) );
  AOI21X1 U1266 ( .A0(n1148), .A1(n1147), .B0(n1283), .Y(n1146) );
  XOR2X2 U1267 ( .A(n1323), .B(n1163), .Y(n1147) );
  XNOR3X2 U1268 ( .A(n1178), .B(n1177), .C(n1176), .Y(n1179) );
  OAI2BB1X2 U1269 ( .A0N(n1085), .A1N(n1076), .B0(n1075), .Y(n1159) );
  XOR2X2 U1270 ( .A(n1185), .B(n1251), .Y(n1212) );
  NAND2X1 U1271 ( .A(n1221), .B(n1255), .Y(n1235) );
  INVX1 U1272 ( .A(n1331), .Y(n1325) );
  XOR2XL U1273 ( .A(n1001), .B(n1123), .Y(n1002) );
  XOR2XL U1274 ( .A(\U_encoder/CodeWord3 [23]), .B(\U_encoder/CodeWord3 [20]), 
        .Y(n992) );
  AOI22XL U1275 ( .A0(\U_register_file/n287 ), .A1(n1255), .B0(n1311), .B1(
        n937), .Y(n1426) );
  NAND2XL U1276 ( .A(n1238), .B(\U_register_file/n276 ), .Y(n1016) );
  AND2X1 U1277 ( .A(n1635), .B(n1238), .Y(n1245) );
  OAI21XL U1278 ( .A0(n1389), .A1(n1330), .B0(n1358), .Y(n1332) );
  OAI21XL U1279 ( .A0(n1456), .A1(n1333), .B0(n1326), .Y(n1329) );
  NAND3XL U1280 ( .A(n1420), .B(n1325), .C(n1490), .Y(n1326) );
  INVXL U1281 ( .A(n1327), .Y(n1328) );
  OAI21XL U1282 ( .A0(n1335), .A1(n1334), .B0(n1333), .Y(n1336) );
  INVXL U1283 ( .A(n1279), .Y(n1280) );
  INVXL U1284 ( .A(n1426), .Y(n1427) );
  INVX1 U1285 ( .A(n1622), .Y(n1269) );
  INVX1 U1286 ( .A(n1624), .Y(n1431) );
  OAI31X1 U1287 ( .A0(n1477), .A1(n1359), .A2(n1484), .B0(n1271), .Y(n1272) );
  AOI22XL U1288 ( .A0(n1270), .A1(n1612), .B0(n1585), .B1(n1428), .Y(n1271) );
  NOR2X1 U1289 ( .A(n1628), .B(n1627), .Y(n1630) );
  INVXL U1290 ( .A(n1623), .Y(n1621) );
  INVXL U1291 ( .A(n1251), .Y(n1249) );
  NOR2X2 U1292 ( .A(n1406), .B(n1405), .Y(n1407) );
  OAI2BB1X1 U1293 ( .A0N(\U_register_file/n280 ), .A1N(n1255), .B0(n1020), .Y(
        n1471) );
  AND2X1 U1294 ( .A(n1424), .B(n1423), .Y(n1469) );
  INVX1 U1295 ( .A(n1430), .Y(n1464) );
  NAND2XL U1296 ( .A(\U_register_file/n278 ), .B(n1238), .Y(n984) );
  OAI2BB1X2 U1297 ( .A0N(n1132), .A1N(n1526), .B0(n1097), .Y(n1262) );
  CLKINVX2 U1298 ( .A(n1282), .Y(n1351) );
  NAND3XL U1299 ( .A(n1373), .B(n1592), .C(n1590), .Y(n1497) );
  INVXL U1300 ( .A(\U_register_file/n277 ), .Y(n1446) );
  INVX4 U1301 ( .A(n937), .Y(n1322) );
  INVX4 U1302 ( .A(\U_encoder/CodeWord3 [26]), .Y(n1563) );
  NAND4X1 U1303 ( .A(n1339), .B(n1338), .C(n1337), .D(n1336), .Y(data_out[0])
         );
  AOI22X1 U1304 ( .A0(n1401), .A1(n1281), .B0(n1612), .B1(n1280), .Y(n1295) );
  OAI221X4 U1305 ( .A0(n1612), .A1(n1320), .B0(n1635), .B1(n1319), .C0(n1318), 
        .Y(data_out[2]) );
  INVXL U1306 ( .A(n1312), .Y(n1319) );
  NAND2X2 U1307 ( .A(n1317), .B(n1316), .Y(n1318) );
  AOI22X1 U1308 ( .A0(n1614), .A1(n1613), .B0(n1612), .B1(n1611), .Y(n1615) );
  AOI211X1 U1309 ( .A0(n1422), .A1(n1595), .B0(n1421), .C0(n1619), .Y(n1436)
         );
  OAI211X2 U1310 ( .A0(n1368), .A1(n1635), .B0(n1367), .C0(n1366), .Y(
        data_out[6]) );
  AOI21XL U1311 ( .A0(n1364), .A1(n1476), .B0(n934), .Y(n1365) );
  AOI211X1 U1312 ( .A0(n1612), .A1(n1480), .B0(n1479), .C0(n1478), .Y(n1492)
         );
  INVXL U1313 ( .A(n1474), .Y(n1480) );
  OAI211X1 U1314 ( .A0(n1404), .A1(n1635), .B0(n1403), .C0(n1402), .Y(
        data_out[15]) );
  OAI21XL U1315 ( .A0(n1399), .A1(n1440), .B0(n1398), .Y(n1403) );
  AOI22XL U1316 ( .A0(PADDR[3]), .A1(\U_register_file/n289 ), .B0(
        \two_bits_registers[0][0] ), .B1(n1589), .Y(n1496) );
  AOI22XL U1317 ( .A0(\U_register_file/n287 ), .A1(n1494), .B0(
        \AMBA_WORD_registers[1][0] ), .B1(n1493), .Y(n1495) );
  AOI22XL U1318 ( .A0(PADDR[3]), .A1(n1238), .B0(\two_bits_registers[0][1] ), 
        .B1(n1589), .Y(n1377) );
  AOI22XL U1319 ( .A0(n937), .A1(n1494), .B0(\AMBA_WORD_registers[1][1] ), 
        .B1(n1493), .Y(n1376) );
  INVXL U1320 ( .A(n1585), .Y(n1588) );
  INVXL U1321 ( .A(\U_register_file/n280 ), .Y(n1438) );
  OAI22XL U1322 ( .A0(n1569), .A1(n1544), .B0(n1535), .B1(n1586), .Y(
        PRDATA[16]) );
  MXI2XL U1323 ( .A(n1370), .B(n1384), .S0(n1371), .Y(n903) );
  AOI22XL U1324 ( .A0(n935), .A1(n1570), .B0(n1569), .B1(n931), .Y(
        \U_register_file/n147 ) );
  NAND2XL U1325 ( .A(n935), .B(PWDATA[5]), .Y(n1437) );
  NOR3XL U1326 ( .A(n1593), .B(n1592), .C(n1591), .Y(\U_op_done_logic/N0 ) );
  NAND2XL U1327 ( .A(n1590), .B(n1589), .Y(n1591) );
  AOI22XL U1328 ( .A0(n935), .A1(n1584), .B0(n1583), .B1(n931), .Y(
        \U_register_file/n140 ) );
  NAND2XL U1329 ( .A(n931), .B(\U_register_file/n277 ), .Y(n1381) );
  AOI22XL U1330 ( .A0(n935), .A1(n1560), .B0(n1559), .B1(n1548), .Y(
        \U_register_file/n162 ) );
  AOI22XL U1331 ( .A0(n935), .A1(n1558), .B0(n1557), .B1(n1548), .Y(
        \U_register_file/n157 ) );
  AOI22XL U1332 ( .A0(n935), .A1(n1550), .B0(n1549), .B1(n1548), .Y(
        \U_register_file/n161 ) );
  AOI22XL U1333 ( .A0(n935), .A1(n1556), .B0(n1555), .B1(n1548), .Y(
        \U_register_file/n158 ) );
  MXI2XL U1334 ( .A(n1372), .B(n1380), .S0(n1371), .Y(n902) );
  INVX16 U1335 ( .A(n1232), .Y(n1238) );
  NAND2X2 U1336 ( .A(n1255), .B(n1635), .Y(n1619) );
  OR2XL U1337 ( .A(n1635), .B(n1232), .Y(n1233) );
  OR2X4 U1338 ( .A(\two_bits_registers[0][1] ), .B(\two_bits_registers[0][0] ), 
        .Y(n1635) );
  INVX8 U1339 ( .A(n1493), .Y(n1586) );
  NAND3X1 U1340 ( .A(n1454), .B(n1622), .C(n1249), .Y(n1254) );
  OAI21X2 U1341 ( .A0(n1606), .A1(n1605), .B0(n1604), .Y(n1618) );
  NAND2X2 U1342 ( .A(n1449), .B(n1627), .Y(n1457) );
  INVX12 U1343 ( .A(n1449), .Y(n1252) );
  MX2X1 U1344 ( .A(n1638), .B(n1384), .S0(n941), .Y(n939) );
  NAND2X2 U1345 ( .A(n1236), .B(n1235), .Y(n1222) );
  MX2X1 U1346 ( .A(n1637), .B(n1380), .S0(n941), .Y(n940) );
  XNOR2X2 U1347 ( .A(n1062), .B(n1061), .Y(n1117) );
  XOR2X2 U1348 ( .A(n1106), .B(n1105), .Y(n1111) );
  NAND2X2 U1349 ( .A(n1358), .B(n1330), .Y(n1291) );
  XOR2X2 U1350 ( .A(n1111), .B(n1467), .Y(n1141) );
  OAI21XL U1351 ( .A0(\AMBA_WORD_registers[1][19] ), .A1(n1090), .B0(n1089), 
        .Y(n1091) );
  OAI21XL U1352 ( .A0(\AMBA_WORD_registers[1][26] ), .A1(n1087), .B0(n1086), 
        .Y(n1088) );
  XOR2X2 U1353 ( .A(n1141), .B(n1323), .Y(n1226) );
  OAI21XL U1354 ( .A0(n1628), .A1(n1624), .B0(n1623), .Y(n1625) );
  AOI21X1 U1355 ( .A0(n1242), .A1(n1241), .B0(n1352), .Y(n1240) );
  AOI21X1 U1356 ( .A0(n1410), .A1(n1423), .B0(n1409), .Y(n1411) );
  CLKINVX3 U1357 ( .A(\U_encoder/CodeWord3 [22]), .Y(n1569) );
  OAI21XL U1358 ( .A0(n1396), .A1(n1395), .B0(n1394), .Y(data_out[13]) );
  INVX1 U1359 ( .A(PWDATA[0]), .Y(n1384) );
  INVX1 U1360 ( .A(PWDATA[1]), .Y(n1380) );
  NOR2BX4 U1361 ( .AN(\U_register_file/n289 ), .B(n1238), .Y(n942) );
  AOI21X2 U1362 ( .A0(\U_register_file/n282 ), .A1(n1238), .B0(n943), .Y(n946)
         );
  INVX1 U1363 ( .A(\AMBA_WORD_registers[1][11] ), .Y(n1543) );
  OAI21X1 U1364 ( .A0(n946), .A1(n1543), .B0(n932), .Y(n945) );
  AOI21X2 U1365 ( .A0(n946), .A1(n1543), .B0(n945), .Y(n948) );
  OR2X4 U1366 ( .A(n948), .B(n947), .Y(n1425) );
  AOI22X2 U1367 ( .A0(n1238), .A1(\U_register_file/n283 ), .B0(n1255), .B1(
        \U_register_file/n282 ), .Y(n1260) );
  INVX1 U1368 ( .A(\AMBA_WORD_registers[1][10] ), .Y(n1514) );
  OAI21X1 U1369 ( .A0(n1260), .A1(n1514), .B0(n932), .Y(n949) );
  AOI21X2 U1370 ( .A0(n1260), .A1(n1514), .B0(n949), .Y(n951) );
  OR2X4 U1371 ( .A(n951), .B(n950), .Y(n1610) );
  XOR2X2 U1372 ( .A(n1425), .B(n1610), .Y(n1220) );
  NAND2X2 U1373 ( .A(n1107), .B(\U_register_file/n274 ), .Y(n953) );
  AOI21X2 U1374 ( .A0(\AMBA_WORD_registers[1][29] ), .A1(n953), .B0(n1132), 
        .Y(n952) );
  OAI21X4 U1375 ( .A0(\AMBA_WORD_registers[0][29] ), .A1(n930), .B0(n954), .Y(
        n1303) );
  NAND2X1 U1376 ( .A(n1107), .B(\U_encoder/CodeWord3 [25]), .Y(n956) );
  AOI21X2 U1377 ( .A0(\AMBA_WORD_registers[1][25] ), .A1(n956), .B0(n1132), 
        .Y(n955) );
  OAI21X1 U1378 ( .A0(\AMBA_WORD_registers[1][25] ), .A1(n956), .B0(n955), .Y(
        n958) );
  NAND2X1 U1379 ( .A(n1132), .B(n1571), .Y(n957) );
  AND2X2 U1380 ( .A(n958), .B(n957), .Y(n1298) );
  XNOR2X2 U1381 ( .A(n1303), .B(n1298), .Y(n963) );
  AOI21X1 U1382 ( .A0(\AMBA_WORD_registers[1][27] ), .A1(n960), .B0(n1132), 
        .Y(n959) );
  OAI21X4 U1383 ( .A0(\AMBA_WORD_registers[0][27] ), .A1(n930), .B0(n961), .Y(
        n1265) );
  OAI21X4 U1384 ( .A0(n963), .A1(n1265), .B0(n962), .Y(n1162) );
  NAND2X1 U1385 ( .A(n1107), .B(\U_encoder/CodeWord3 [24]), .Y(n965) );
  AOI21X1 U1386 ( .A0(\AMBA_WORD_registers[1][24] ), .A1(n965), .B0(n1132), 
        .Y(n964) );
  OAI21X2 U1387 ( .A0(\U_register_file/n273 ), .A1(n1101), .B0(n966), .Y(n1355) );
  NAND2X1 U1388 ( .A(n1107), .B(\U_encoder/CodeWord3 [28]), .Y(n968) );
  AOI21X1 U1389 ( .A0(\AMBA_WORD_registers[1][28] ), .A1(n968), .B0(n1132), 
        .Y(n967) );
  OAI21X1 U1390 ( .A0(\AMBA_WORD_registers[1][28] ), .A1(n968), .B0(n967), .Y(
        n969) );
  OAI21X2 U1391 ( .A0(\AMBA_WORD_registers[0][28] ), .A1(n1101), .B0(n969), 
        .Y(n1348) );
  INVX4 U1392 ( .A(n1348), .Y(n1189) );
  XNOR2X1 U1393 ( .A(n1355), .B(n1189), .Y(n971) );
  AND2X2 U1394 ( .A(n971), .B(n1162), .Y(n970) );
  AOI2BB1X4 U1395 ( .A0N(n1162), .A1N(n971), .B0(n970), .Y(n1227) );
  INVX4 U1396 ( .A(\U_register_file/n289 ), .Y(n1370) );
  BUFX12 U1397 ( .A(n972), .Y(n1311) );
  INVX1 U1398 ( .A(n1311), .Y(n1283) );
  INVX4 U1399 ( .A(\U_register_file/n283 ), .Y(n1577) );
  OAI22X1 U1400 ( .A0(n1577), .A1(n1581), .B0(\U_register_file/n279 ), .B1(
        \U_register_file/n283 ), .Y(n1059) );
  XOR2X4 U1401 ( .A(n1045), .B(n1532), .Y(n1079) );
  MXI2X4 U1402 ( .A(n1567), .B(\U_encoder/CodeWord3 [25]), .S0(n997), .Y(n1063) );
  XNOR2X4 U1403 ( .A(n1079), .B(n1063), .Y(n1112) );
  AOI22X1 U1404 ( .A0(\U_encoder/CodeWord3 [26]), .A1(
        \U_encoder/CodeWord3 [28]), .B0(n1561), .B1(n1563), .Y(n974) );
  AOI21X4 U1405 ( .A0(n1112), .A1(n974), .B0(n973), .Y(n975) );
  XNOR2X1 U1406 ( .A(n1039), .B(n1123), .Y(n977) );
  CLKBUFX8 U1407 ( .A(\U_register_file/n285 ), .Y(n1585) );
  XOR2X2 U1408 ( .A(\U_register_file/n287 ), .B(n1585), .Y(n1038) );
  XOR2X2 U1409 ( .A(n1038), .B(n937), .Y(n1125) );
  OAI2BB1X4 U1410 ( .A0N(n1283), .A1N(n980), .B0(n979), .Y(n1461) );
  AOI21X4 U1411 ( .A0(\AMBA_WORD_registers[1][3] ), .A1(n1461), .B0(n1132), 
        .Y(n981) );
  OAI21X4 U1412 ( .A0(\AMBA_WORD_registers[1][3] ), .A1(n1461), .B0(n981), .Y(
        n982) );
  OAI2BB1X4 U1413 ( .A0N(n1132), .A1N(n1547), .B0(n982), .Y(n991) );
  AOI22X2 U1414 ( .A0(n1255), .A1(\U_register_file/n278 ), .B0(n1238), .B1(
        \U_register_file/n279 ), .Y(n1417) );
  XOR2X1 U1415 ( .A(n1417), .B(\AMBA_WORD_registers[1][14] ), .Y(n983) );
  MX2X4 U1416 ( .A(n1600), .B(n983), .S0(n1053), .Y(n1273) );
  INVX1 U1417 ( .A(\AMBA_WORD_registers[1][15] ), .Y(n1536) );
  OAI2BB1X2 U1418 ( .A0N(\U_register_file/n277 ), .A1N(n1255), .B0(n984), .Y(
        n1397) );
  XOR2X1 U1419 ( .A(n1536), .B(n1397), .Y(n985) );
  MX2X4 U1420 ( .A(n986), .B(n985), .S0(n1053), .Y(n1623) );
  NAND2X1 U1421 ( .A(n1132), .B(\U_encoder/CodeWord3 [19]), .Y(n988) );
  OAI2BB1X4 U1422 ( .A0N(n1085), .A1N(n989), .B0(n988), .Y(n1484) );
  XOR2X4 U1423 ( .A(n1623), .B(n1484), .Y(n1177) );
  XNOR2X4 U1424 ( .A(n1273), .B(n1177), .Y(n1200) );
  NAND2X4 U1425 ( .A(n991), .B(n1200), .Y(n990) );
  OAI21X4 U1426 ( .A0(n991), .A1(n1200), .B0(n990), .Y(n1218) );
  XNOR3X4 U1427 ( .A(n1220), .B(n1227), .C(n1218), .Y(n1216) );
  XOR2X4 U1428 ( .A(n1123), .B(n992), .Y(n1080) );
  AOI22X4 U1429 ( .A0(\U_register_file/n284 ), .A1(n937), .B0(n1322), .B1(
        n1547), .Y(n1056) );
  INVX8 U1430 ( .A(n1056), .Y(n993) );
  XOR2X4 U1431 ( .A(n1585), .B(n993), .Y(n1000) );
  AOI22X1 U1432 ( .A0(\U_register_file/n278 ), .A1(n1581), .B0(
        \U_register_file/n279 ), .B1(n1583), .Y(n994) );
  XNOR2X4 U1433 ( .A(n1000), .B(n994), .Y(n1001) );
  AOI22X1 U1434 ( .A0(\U_register_file/n273 ), .A1(\U_encoder/CodeWord3 [21]), 
        .B0(n1575), .B1(n1573), .Y(n995) );
  XNOR2X2 U1435 ( .A(n1001), .B(n995), .Y(n996) );
  XNOR3X4 U1436 ( .A(n1080), .B(n997), .C(n996), .Y(n999) );
  OAI22X4 U1437 ( .A0(n1561), .A1(n1569), .B0(\U_encoder/CodeWord3 [22]), .B1(
        \U_encoder/CodeWord3 [28]), .Y(n1115) );
  OAI21X4 U1438 ( .A0(n999), .A1(n1115), .B0(n998), .Y(n1005) );
  INVX8 U1439 ( .A(n1255), .Y(n1308) );
  NAND2X4 U1440 ( .A(n1005), .B(n1004), .Y(n1312) );
  AND2X4 U1441 ( .A(n1312), .B(\AMBA_WORD_registers[1][2] ), .Y(n1007) );
  OAI21X4 U1442 ( .A0(\AMBA_WORD_registers[1][2] ), .A1(n1312), .B0(n932), .Y(
        n1006) );
  AOI2BB2X4 U1443 ( .B0(n1132), .B1(n1585), .A0N(n1007), .A1N(n1006), .Y(n1202) );
  AOI222X4 U1444 ( .A0(n1238), .A1(\U_register_file/n287 ), .B0(n1255), .B1(
        n937), .C0(n1585), .C1(n1311), .Y(n1368) );
  AOI21X2 U1445 ( .A0(\AMBA_WORD_registers[1][6] ), .A1(n1368), .B0(n1132), 
        .Y(n1008) );
  OAI21X2 U1446 ( .A0(\AMBA_WORD_registers[1][6] ), .A1(n1368), .B0(n1008), 
        .Y(n1010) );
  NAND2BX1 U1447 ( .AN(\U_register_file/n281 ), .B(n1132), .Y(n1009) );
  AND2X4 U1448 ( .A(n1010), .B(n1009), .Y(n1333) );
  AOI222X4 U1449 ( .A0(n1238), .A1(n937), .B0(n1255), .B1(n1585), .C0(
        \U_register_file/n284 ), .C1(n1311), .Y(n1474) );
  AOI21X2 U1450 ( .A0(\AMBA_WORD_registers[1][7] ), .A1(n1474), .B0(n1132), 
        .Y(n1011) );
  OAI21X2 U1451 ( .A0(\AMBA_WORD_registers[1][7] ), .A1(n1474), .B0(n1011), 
        .Y(n1013) );
  NAND2BX1 U1452 ( .AN(\U_register_file/n280 ), .B(n1132), .Y(n1012) );
  AND2X4 U1453 ( .A(n1013), .B(n1012), .Y(n1448) );
  XNOR2X4 U1454 ( .A(n1333), .B(n1448), .Y(n1163) );
  INVX4 U1455 ( .A(n1163), .Y(n1014) );
  XOR2X4 U1456 ( .A(n1202), .B(n1014), .Y(n1206) );
  CLKINVX3 U1457 ( .A(n1017), .Y(n1019) );
  OR2X4 U1458 ( .A(n1019), .B(n1018), .Y(n1412) );
  INVX8 U1459 ( .A(\U_encoder/CodeWord3 [18]), .Y(n1541) );
  INVX1 U1460 ( .A(\AMBA_WORD_registers[1][12] ), .Y(n1540) );
  XOR2X2 U1461 ( .A(n1540), .B(n1471), .Y(n1021) );
  MX2X4 U1462 ( .A(n1541), .B(n1021), .S0(n1023), .Y(n1185) );
  XOR2X1 U1463 ( .A(\AMBA_WORD_registers[1][16] ), .B(n1022), .Y(n1024) );
  MX2X4 U1464 ( .A(n1569), .B(n1024), .S0(n1023), .Y(n1251) );
  XOR2X2 U1465 ( .A(n1412), .B(n1212), .Y(n1172) );
  AOI22X4 U1466 ( .A0(n1238), .A1(\U_register_file/n284 ), .B0(n1255), .B1(
        \U_register_file/n283 ), .Y(n1636) );
  INVX1 U1467 ( .A(\AMBA_WORD_registers[1][9] ), .Y(n1545) );
  AOI21X2 U1468 ( .A0(n1636), .A1(n1545), .B0(n1025), .Y(n1027) );
  OR2X4 U1469 ( .A(n1027), .B(n1026), .Y(n1605) );
  NOR2X4 U1470 ( .A(n1308), .B(n1547), .Y(n1270) );
  AOI21X4 U1471 ( .A0(n1585), .A1(n1238), .B0(n1270), .Y(n1029) );
  INVX1 U1472 ( .A(\AMBA_WORD_registers[1][8] ), .Y(n1516) );
  OAI21X2 U1473 ( .A0(n1029), .A1(n1516), .B0(n932), .Y(n1028) );
  AOI21X4 U1474 ( .A0(n1029), .A1(n1516), .B0(n1028), .Y(n1031) );
  OR2X4 U1475 ( .A(n1031), .B(n1030), .Y(n1313) );
  INVX8 U1476 ( .A(n1313), .Y(n1447) );
  XNOR2X4 U1477 ( .A(n1605), .B(n1447), .Y(n1135) );
  INVX1 U1478 ( .A(\U_register_file/n275 ), .Y(n1565) );
  NAND2X1 U1479 ( .A(n1238), .B(\U_encoder/CodeWord3 [21]), .Y(n1033) );
  AOI21X1 U1480 ( .A0(\AMBA_WORD_registers[1][21] ), .A1(n1033), .B0(n1132), 
        .Y(n1032) );
  OAI2BB1X4 U1481 ( .A0N(n1132), .A1N(n1565), .B0(n1034), .Y(n1400) );
  NAND2X1 U1482 ( .A(n1238), .B(\U_encoder/CodeWord3 [20]), .Y(n1036) );
  AOI21X1 U1483 ( .A0(\AMBA_WORD_registers[1][20] ), .A1(n1036), .B0(n1132), 
        .Y(n1035) );
  OAI21X1 U1484 ( .A0(\AMBA_WORD_registers[1][20] ), .A1(n1036), .B0(n1035), 
        .Y(n1037) );
  OAI21X2 U1485 ( .A0(\U_encoder/CodeWord3 [26]), .A1(n932), .B0(n1037), .Y(
        n1415) );
  XNOR2X2 U1486 ( .A(n1400), .B(n1415), .Y(n1225) );
  XOR2X4 U1487 ( .A(n1135), .B(n1225), .Y(n1198) );
  XOR2X2 U1488 ( .A(n1172), .B(n1198), .Y(n1055) );
  XOR2X2 U1489 ( .A(n1038), .B(\U_register_file/n284 ), .Y(n1050) );
  XOR2X4 U1490 ( .A(n1040), .B(n1039), .Y(n1049) );
  AOI22X4 U1491 ( .A0(\U_encoder/CodeWord3 [19]), .A1(
        \U_encoder/CodeWord3 [23]), .B0(n1534), .B1(n1539), .Y(n1062) );
  AOI22X4 U1492 ( .A0(\U_encoder/CodeWord3 [18]), .A1(
        \U_encoder/CodeWord3 [26]), .B0(n1563), .B1(n1541), .Y(n1113) );
  XOR2X2 U1493 ( .A(n1062), .B(n1113), .Y(n1043) );
  AOI22X2 U1494 ( .A0(\U_encoder/CodeWord3 [22]), .A1(n1571), .B0(
        \U_register_file/n272 ), .B1(n1569), .Y(n1042) );
  NAND2X4 U1495 ( .A(n1043), .B(n1042), .Y(n1041) );
  OAI21X4 U1496 ( .A0(n1043), .A1(n1042), .B0(n1041), .Y(n1044) );
  XOR2X2 U1497 ( .A(n1045), .B(n1044), .Y(n1046) );
  AND2X4 U1498 ( .A(n1107), .B(n1046), .Y(n1048) );
  AOI22X4 U1499 ( .A0(n1049), .A1(n1048), .B0(n1370), .B1(n1372), .Y(n1047) );
  OAI21X4 U1500 ( .A0(n1049), .A1(n1048), .B0(n1047), .Y(n1052) );
  AND2X4 U1501 ( .A(n1052), .B(n1051), .Y(n1279) );
  XOR2X4 U1502 ( .A(n1279), .B(\AMBA_WORD_registers[1][1] ), .Y(n1054) );
  MX2X4 U1503 ( .A(n1322), .B(n1054), .S0(n1053), .Y(n1148) );
  XNOR3X2 U1504 ( .A(n1206), .B(n1055), .C(n1148), .Y(n1133) );
  XOR2X2 U1505 ( .A(n938), .B(n1057), .Y(n1060) );
  NAND2X4 U1506 ( .A(n1060), .B(n1059), .Y(n1058) );
  OAI21X4 U1507 ( .A0(n1060), .A1(n1059), .B0(n1058), .Y(n1070) );
  AOI22X2 U1508 ( .A0(\U_register_file/n276 ), .A1(n1575), .B0(
        \U_encoder/CodeWord3 [21]), .B1(n1542), .Y(n1061) );
  XOR2X4 U1509 ( .A(n1063), .B(n1117), .Y(n1064) );
  NAND2X4 U1510 ( .A(n1064), .B(\U_register_file/n275 ), .Y(n1065) );
  OAI2BB1X4 U1511 ( .A0N(n1066), .A1N(n1565), .B0(n1065), .Y(n1067) );
  NOR2X4 U1512 ( .A(n1372), .B(n1067), .Y(n1069) );
  AOI22X2 U1513 ( .A0(n1232), .A1(n1370), .B0(n1070), .B1(n1069), .Y(n1068) );
  OAI21X4 U1514 ( .A0(n1070), .A1(n1069), .B0(n1068), .Y(n1073) );
  NAND2X1 U1515 ( .A(n938), .B(n1311), .Y(n1072) );
  AND2X4 U1516 ( .A(n1073), .B(n1072), .Y(n1327) );
  XOR2X4 U1517 ( .A(n1327), .B(n1074), .Y(n1076) );
  XOR2X2 U1518 ( .A(\U_encoder/CodeWord3 [18]), .B(n1077), .Y(n1078) );
  XOR3X4 U1519 ( .A(n1079), .B(n1078), .C(n1122), .Y(n1081) );
  XOR3X4 U1520 ( .A(n1081), .B(n1125), .C(n1080), .Y(n1429) );
  OAI2BB1X4 U1521 ( .A0N(n1238), .A1N(n1429), .B0(n1426), .Y(n1082) );
  OAI2BB1X4 U1522 ( .A0N(n1085), .A1N(n1084), .B0(n1083), .Y(n1331) );
  XOR2X4 U1523 ( .A(n1159), .B(n1331), .Y(n1178) );
  NAND2X1 U1524 ( .A(n1238), .B(\U_encoder/CodeWord3 [26]), .Y(n1087) );
  AOI21X1 U1525 ( .A0(\AMBA_WORD_registers[1][26] ), .A1(n1087), .B0(n1132), 
        .Y(n1086) );
  OAI21X4 U1526 ( .A0(\AMBA_WORD_registers[0][26] ), .A1(n930), .B0(n1088), 
        .Y(n1596) );
  INVX4 U1527 ( .A(n1596), .Y(n1598) );
  NAND2X1 U1528 ( .A(n1238), .B(\U_encoder/CodeWord3 [19]), .Y(n1090) );
  OAI21X2 U1529 ( .A0(\U_encoder/CodeWord3 [25]), .A1(n930), .B0(n1091), .Y(
        n1390) );
  NAND2X2 U1530 ( .A(n1238), .B(\U_register_file/n272 ), .Y(n1093) );
  AOI21X2 U1531 ( .A0(\AMBA_WORD_registers[1][31] ), .A1(n1093), .B0(n1132), 
        .Y(n1092) );
  OAI21X4 U1532 ( .A0(\AMBA_WORD_registers[0][31] ), .A1(n930), .B0(n1094), 
        .Y(n1342) );
  INVX1 U1533 ( .A(\U_register_file/n274 ), .Y(n1526) );
  NAND2X2 U1534 ( .A(n1238), .B(\U_encoder/CodeWord3 [23]), .Y(n1096) );
  AOI21X2 U1535 ( .A0(\AMBA_WORD_registers[1][23] ), .A1(n1096), .B0(n1132), 
        .Y(n1095) );
  XOR2X4 U1536 ( .A(n1342), .B(n1262), .Y(n1191) );
  XNOR2X4 U1537 ( .A(n1393), .B(n1191), .Y(n1164) );
  XNOR2X4 U1538 ( .A(n1598), .B(n1164), .Y(n1106) );
  AOI21X1 U1539 ( .A0(\AMBA_WORD_registers[1][30] ), .A1(n1099), .B0(n1132), 
        .Y(n1098) );
  OAI21X4 U1540 ( .A0(\AMBA_WORD_registers[0][30] ), .A1(n1101), .B0(n1100), 
        .Y(n1242) );
  NAND2X1 U1541 ( .A(n1238), .B(\U_encoder/CodeWord3 [22]), .Y(n1103) );
  AOI21X1 U1542 ( .A0(\AMBA_WORD_registers[1][22] ), .A1(n1103), .B0(n1132), 
        .Y(n1102) );
  OAI21X1 U1543 ( .A0(\AMBA_WORD_registers[1][22] ), .A1(n1103), .B0(n1102), 
        .Y(n1104) );
  OAI2BB1X2 U1544 ( .A0N(n1132), .A1N(n1561), .B0(n1104), .Y(n1442) );
  XOR2X4 U1545 ( .A(n1242), .B(n1442), .Y(n1190) );
  NAND2X1 U1546 ( .A(n1107), .B(\U_encoder/CodeWord3 [18]), .Y(n1109) );
  AOI21X1 U1547 ( .A0(\AMBA_WORD_registers[1][18] ), .A1(n1109), .B0(n1132), 
        .Y(n1108) );
  OAI21XL U1548 ( .A0(\AMBA_WORD_registers[1][18] ), .A1(n1109), .B0(n1108), 
        .Y(n1110) );
  INVX1 U1549 ( .A(\AMBA_WORD_registers[1][4] ), .Y(n1504) );
  CLKINVX3 U1550 ( .A(n1112), .Y(n1121) );
  MXI2X2 U1551 ( .A(n1600), .B(\U_encoder/CodeWord3 [20]), .S0(n1113), .Y(
        n1114) );
  AOI21X4 U1552 ( .A0(n1121), .A1(n1120), .B0(n1372), .Y(n1119) );
  OAI21X2 U1553 ( .A0(n1121), .A1(n1120), .B0(n1119), .Y(n1128) );
  NAND2X4 U1554 ( .A(n1128), .B(n1127), .Y(n1611) );
  AOI2BB1X4 U1555 ( .A0N(\AMBA_WORD_registers[1][4] ), .A1N(n1611), .B0(n1132), 
        .Y(n1129) );
  OAI2BB1X4 U1556 ( .A0N(n1132), .A1N(\U_register_file/n283 ), .B0(n1131), .Y(
        n1323) );
  XNOR3X4 U1557 ( .A(n1133), .B(n1178), .C(n1226), .Y(n1134) );
  XOR2X4 U1558 ( .A(n1216), .B(n1134), .Y(num_of_errors[0]) );
  XNOR2X2 U1559 ( .A(n1135), .B(n1333), .Y(n1137) );
  INVX4 U1560 ( .A(n1176), .Y(n1145) );
  XNOR2X1 U1561 ( .A(n1212), .B(n1265), .Y(n1140) );
  XNOR2X4 U1562 ( .A(n1148), .B(n1623), .Y(n1155) );
  INVX8 U1563 ( .A(n1155), .Y(n1139) );
  NAND2X4 U1564 ( .A(n1140), .B(n1139), .Y(n1138) );
  OAI21X4 U1565 ( .A0(n1140), .A1(n1139), .B0(n1138), .Y(n1142) );
  XNOR2X4 U1566 ( .A(n1142), .B(n1141), .Y(n1144) );
  AOI21X4 U1567 ( .A0(n1144), .A1(n1145), .B0(n1372), .Y(n1143) );
  OAI21X4 U1568 ( .A0(n1145), .A1(n1144), .B0(n1143), .Y(n1158) );
  OAI21X4 U1569 ( .A0(n1148), .A1(n1147), .B0(n1146), .Y(n1157) );
  XOR2X2 U1570 ( .A(n1448), .B(n1331), .Y(n1149) );
  XOR2X4 U1571 ( .A(n1220), .B(n1149), .Y(n1150) );
  XOR2X4 U1572 ( .A(n1273), .B(n1150), .Y(n1152) );
  NAND2X4 U1573 ( .A(n1152), .B(n1447), .Y(n1151) );
  OAI21X4 U1574 ( .A0(n1152), .A1(n1447), .B0(n1151), .Y(n1154) );
  AOI21X4 U1575 ( .A0(n1155), .A1(n1154), .B0(n1308), .Y(n1153) );
  OAI21X4 U1576 ( .A0(n1155), .A1(n1154), .B0(n1153), .Y(n1156) );
  NAND3X4 U1577 ( .A(n1158), .B(n1157), .C(n1156), .Y(n1345) );
  BUFX4 U1578 ( .A(n1345), .Y(n1364) );
  XNOR2X2 U1579 ( .A(n1610), .B(n1400), .Y(n1161) );
  NAND2X1 U1580 ( .A(n1161), .B(n1273), .Y(n1160) );
  OAI21X2 U1581 ( .A0(n1161), .A1(n1273), .B0(n1160), .Y(n1169) );
  XNOR2X2 U1582 ( .A(n1163), .B(n1162), .Y(n1167) );
  OAI21X4 U1583 ( .A0(n1167), .A1(n1166), .B0(n1165), .Y(n1168) );
  XOR2X4 U1584 ( .A(n1170), .B(n1605), .Y(n1171) );
  XNOR3X2 U1585 ( .A(n1173), .B(n1172), .C(n1171), .Y(n1174) );
  NAND2X4 U1586 ( .A(n1174), .B(n1238), .Y(n1182) );
  AND2X4 U1587 ( .A(n1182), .B(n1181), .Y(n1183) );
  BUFX20 U1588 ( .A(n1183), .Y(n1359) );
  CLKINVX3 U1589 ( .A(n1200), .Y(n1197) );
  AOI22X2 U1590 ( .A0(n1200), .A1(n1184), .B0(n1206), .B1(n1197), .Y(n1188) );
  CLKINVX3 U1591 ( .A(n1185), .Y(n1489) );
  AOI21X2 U1592 ( .A0(n1188), .A1(n1187), .B0(n1308), .Y(n1186) );
  AOI2BB2X1 U1593 ( .B0(n1190), .B1(n1189), .A0N(n1189), .A1N(n1190), .Y(n1193) );
  XOR2X1 U1594 ( .A(n1448), .B(n1191), .Y(n1192) );
  XOR2X2 U1595 ( .A(n1193), .B(n1192), .Y(n1196) );
  NAND2X1 U1596 ( .A(n1196), .B(n1195), .Y(n1194) );
  OAI21X4 U1597 ( .A0(n1196), .A1(n1195), .B0(n1194), .Y(n1205) );
  INVX1 U1598 ( .A(n1198), .Y(n1199) );
  AOI22X2 U1599 ( .A0(n1200), .A1(n1199), .B0(n1198), .B1(n1197), .Y(n1201) );
  XNOR2X2 U1600 ( .A(n1202), .B(n1201), .Y(n1204) );
  AOI21X4 U1601 ( .A0(n1205), .A1(n1204), .B0(n1372), .Y(n1203) );
  OAI21X4 U1602 ( .A0(n1205), .A1(n1204), .B0(n1203), .Y(n1209) );
  AND2X4 U1603 ( .A(n1209), .B(n1208), .Y(n1210) );
  NAND2X4 U1604 ( .A(n1211), .B(n1210), .Y(n1234) );
  NAND2X2 U1605 ( .A(n1217), .B(n1238), .Y(n1236) );
  XOR2X1 U1606 ( .A(n1605), .B(n1489), .Y(n1219) );
  XNOR3X2 U1607 ( .A(n1220), .B(n1219), .C(n1218), .Y(n1221) );
  NAND2X4 U1608 ( .A(n1359), .B(n1223), .Y(n1224) );
  NOR2X4 U1609 ( .A(n1364), .B(n1224), .Y(n1248) );
  NAND2X4 U1610 ( .A(num_of_errors[0]), .B(n1255), .Y(n1231) );
  XNOR3X2 U1611 ( .A(n1228), .B(n1227), .C(n1226), .Y(n1246) );
  CLKINVX3 U1612 ( .A(n1246), .Y(n1229) );
  NAND2X2 U1613 ( .A(n1229), .B(n1238), .Y(n1230) );
  AND2X4 U1614 ( .A(n1231), .B(n1230), .Y(n1250) );
  AOI21X4 U1615 ( .A0(n1248), .A1(n1250), .B0(num_of_errors[0]), .Y(
        num_of_errors[1]) );
  NAND2X4 U1616 ( .A(n1364), .B(n1359), .Y(n1424) );
  BUFX20 U1617 ( .A(n1234), .Y(n1609) );
  INVX8 U1618 ( .A(n1609), .Y(n1344) );
  OR2X4 U1619 ( .A(n1424), .B(n1344), .Y(n1628) );
  INVX8 U1620 ( .A(n1628), .Y(n1443) );
  AOI21X4 U1621 ( .A0(n1311), .A1(num_of_errors[0]), .B0(n1222), .Y(n1237) );
  OR2X4 U1622 ( .A(n1627), .B(n1250), .Y(n1418) );
  INVX8 U1623 ( .A(n1418), .Y(n1350) );
  NAND2X2 U1624 ( .A(n1443), .B(n1350), .Y(n1241) );
  AND2X4 U1625 ( .A(n1239), .B(n1245), .Y(n1594) );
  INVX8 U1626 ( .A(n1594), .Y(n1352) );
  OAI21X1 U1627 ( .A0(n1242), .A1(n1241), .B0(n1240), .Y(n1243) );
  OAI21X2 U1628 ( .A0(n1601), .A1(n1532), .B0(n1243), .Y(data_out[24]) );
  NOR3X4 U1629 ( .A(n1296), .B(n1344), .C(n1359), .Y(n1449) );
  INVX8 U1630 ( .A(n934), .Y(n1423) );
  NAND2X4 U1631 ( .A(n1252), .B(n1423), .Y(n1454) );
  BUFX3 U1632 ( .A(n1250), .Y(n1330) );
  NAND2X4 U1633 ( .A(n1248), .B(n1247), .Y(n1413) );
  OAI21X4 U1634 ( .A0(n1330), .A1(n934), .B0(n1413), .Y(n1334) );
  AOI21X4 U1635 ( .A0(n1423), .A1(n1627), .B0(n1334), .Y(n1622) );
  OR2X4 U1636 ( .A(n1420), .B(n934), .Y(n1456) );
  OR2X4 U1637 ( .A(n1456), .B(n1627), .Y(n1624) );
  NAND2X1 U1638 ( .A(n1254), .B(n1253), .Y(n1259) );
  NAND3BX4 U1639 ( .AN(n1364), .B(n1344), .C(n1359), .Y(n1282) );
  INVX8 U1640 ( .A(n1627), .Y(n1406) );
  OR2X4 U1641 ( .A(n1282), .B(n1406), .Y(n1358) );
  NOR2X4 U1642 ( .A(n1483), .B(n1619), .Y(n1632) );
  NAND2X1 U1643 ( .A(n1449), .B(n1406), .Y(n1256) );
  XOR2X1 U1644 ( .A(n1256), .B(n1623), .Y(n1257) );
  NAND2X1 U1645 ( .A(n1632), .B(n1257), .Y(n1258) );
  OAI211X2 U1646 ( .A0(n1260), .A1(n1635), .B0(n1259), .C0(n1258), .Y(
        data_out[10]) );
  NAND2X4 U1647 ( .A(n1420), .B(n1627), .Y(n1481) );
  OAI21X4 U1648 ( .A0(n1286), .A1(n934), .B0(n1413), .Y(n1440) );
  AOI31X1 U1649 ( .A0(n1449), .A1(n1463), .A2(n1262), .B0(n1261), .Y(n1263) );
  NAND2X4 U1650 ( .A(n1364), .B(n1264), .Y(n1391) );
  OR2X2 U1651 ( .A(n1391), .B(n1418), .Y(n1361) );
  INVX1 U1652 ( .A(n1361), .Y(n1266) );
  OAI221XL U1653 ( .A0(n1267), .A1(n1266), .B0(n1265), .B1(n1361), .C0(n1594), 
        .Y(n1268) );
  OAI21XL U1654 ( .A0(n1601), .A1(n1575), .B0(n1268), .Y(data_out[21]) );
  NOR2X4 U1655 ( .A(n1359), .B(n1345), .Y(n1613) );
  AND2X4 U1656 ( .A(n1613), .B(n1609), .Y(n1401) );
  INVX1 U1657 ( .A(n1619), .Y(n1490) );
  NAND4X2 U1658 ( .A(n1296), .B(n1350), .C(n1490), .D(n1609), .Y(n1477) );
  OAI21X4 U1659 ( .A0(n1627), .A1(n1274), .B0(n1291), .Y(n1603) );
  NAND3X2 U1660 ( .A(n1275), .B(n1490), .C(n1484), .Y(n1276) );
  INVX1 U1661 ( .A(n1401), .Y(n1285) );
  NAND3X1 U1662 ( .A(n1358), .B(n1333), .C(n1418), .Y(n1284) );
  AOI21X1 U1663 ( .A0(n1285), .A1(n1420), .B0(n1284), .Y(n1288) );
  AOI21X1 U1664 ( .A0(n1401), .A1(n1286), .B0(n1333), .Y(n1287) );
  NOR3X2 U1665 ( .A(n1288), .B(n1287), .C(n1619), .Y(n1289) );
  AOI31X4 U1666 ( .A0(n1451), .A1(n1635), .A2(n1290), .B0(n1289), .Y(n1294) );
  OAI21X4 U1667 ( .A0(n1291), .A1(n1406), .B0(n1594), .Y(n1314) );
  CLKINVX3 U1668 ( .A(n1314), .Y(n1292) );
  NAND2X4 U1669 ( .A(n1296), .B(n1420), .Y(n1357) );
  OR2X2 U1670 ( .A(n1609), .B(n1357), .Y(n1297) );
  NOR2X4 U1671 ( .A(n1627), .B(n1405), .Y(n1606) );
  XOR2X1 U1672 ( .A(n1606), .B(n1298), .Y(n1299) );
  NAND2X1 U1673 ( .A(n1594), .B(n1299), .Y(n1300) );
  OAI21X1 U1674 ( .A0(n1601), .A1(n1539), .B0(n1300), .Y(data_out[19]) );
  NAND2X1 U1675 ( .A(n1401), .B(n1350), .Y(n1302) );
  OAI21X2 U1676 ( .A0(n1303), .A1(n1302), .B0(n1301), .Y(n1304) );
  OAI21X1 U1677 ( .A0(n1601), .A1(n1534), .B0(n1304), .Y(data_out[23]) );
  NAND3X1 U1678 ( .A(n1443), .B(n1306), .C(n1406), .Y(n1305) );
  OAI31X1 U1679 ( .A0(n1443), .A1(n1307), .A2(n1306), .B0(n1305), .Y(n1310) );
  NOR2X4 U1680 ( .A(n1483), .B(n1308), .Y(n1453) );
  NAND2X2 U1681 ( .A(n1443), .B(n1627), .Y(n1315) );
  XNOR2X1 U1682 ( .A(n1315), .B(n1448), .Y(n1309) );
  AOI22X1 U1683 ( .A0(n1311), .A1(n1310), .B0(n1453), .B1(n1309), .Y(n1320) );
  NAND3X1 U1684 ( .A(n1314), .B(n1313), .C(n1620), .Y(n1317) );
  XNOR2X1 U1685 ( .A(n1391), .B(n1323), .Y(n1324) );
  NOR2X4 U1686 ( .A(n1391), .B(n1406), .Y(n1389) );
  NAND2X2 U1687 ( .A(n1449), .B(n1350), .Y(n1341) );
  OAI21X1 U1688 ( .A0(n1601), .A1(n1567), .B0(n1343), .Y(data_out[25]) );
  NOR3X4 U1689 ( .A(n1345), .B(n1344), .C(n1476), .Y(n1482) );
  NAND2X1 U1690 ( .A(n1482), .B(n1350), .Y(n1347) );
  AOI21X2 U1691 ( .A0(n1348), .A1(n1347), .B0(n1352), .Y(n1346) );
  OAI21X1 U1692 ( .A0(n1348), .A1(n1347), .B0(n1346), .Y(n1349) );
  OAI21X1 U1693 ( .A0(n1601), .A1(n1569), .B0(n1349), .Y(data_out[22]) );
  NAND2X1 U1694 ( .A(n1351), .B(n1350), .Y(n1354) );
  AOI21X1 U1695 ( .A0(n1355), .A1(n1354), .B0(n1352), .Y(n1353) );
  OAI21X1 U1696 ( .A0(n1601), .A1(n1541), .B0(n1356), .Y(data_out[18]) );
  NAND4X2 U1697 ( .A(n1358), .B(n1357), .C(n1602), .D(n1481), .Y(n1419) );
  AOI211X1 U1698 ( .A0(n1359), .A1(n1420), .B0(n1419), .C0(n1432), .Y(n1360)
         );
  NOR3X1 U1699 ( .A(n1391), .B(n1489), .C(n1624), .Y(n1362) );
  NAND2X1 U1700 ( .A(n1609), .B(n1423), .Y(n1465) );
  NAND2X4 U1701 ( .A(n1622), .B(n1465), .Y(n1608) );
  INVX1 U1702 ( .A(PADDR[3]), .Y(n1589) );
  OAI21XL U1703 ( .A0(n1497), .A1(n1377), .B0(n1376), .Y(PRDATA[1]) );
  OAI21XL U1704 ( .A0(n936), .A1(n1498), .B0(n1379), .Y(\U_register_file/n166 ) );
  OAI21XL U1705 ( .A0(n931), .A1(n1515), .B0(n1381), .Y(\U_register_file/n141 ) );
  OAI21XL U1706 ( .A0(n1506), .A1(n931), .B0(n1382), .Y(\U_register_file/n133 ) );
  OAI21XL U1707 ( .A0(n931), .A1(n1384), .B0(n1383), .Y(\U_register_file/n131 ) );
  NAND2X1 U1708 ( .A(n931), .B(\U_register_file/n276 ), .Y(n1385) );
  OAI21XL U1709 ( .A0(n931), .A1(n1513), .B0(n1385), .Y(\U_register_file/n142 ) );
  OAI21XL U1710 ( .A0(n1505), .A1(n931), .B0(n1386), .Y(\U_register_file/n134 ) );
  OAI21XL U1711 ( .A0(n1511), .A1(n931), .B0(n1387), .Y(\U_register_file/n144 ) );
  OAI21XL U1712 ( .A0(n931), .A1(n1502), .B0(n1388), .Y(\U_register_file/n138 ) );
  AOI21X1 U1713 ( .A0(n1389), .A1(n1420), .B0(n1393), .Y(n1396) );
  AOI22X1 U1714 ( .A0(n1440), .A1(n1393), .B0(n1612), .B1(n1392), .Y(n1394) );
  XNOR2X2 U1715 ( .A(n1407), .B(n1412), .Y(n1410) );
  AOI31X4 U1716 ( .A0(n1482), .A1(n1463), .A2(n1415), .B0(n1414), .Y(n1416) );
  OR2X4 U1717 ( .A(n1430), .B(n1418), .Y(n1595) );
  OAI21XL U1718 ( .A0(n935), .A1(n1499), .B0(n1437), .Y(\U_register_file/n136 ) );
  INVX1 U1719 ( .A(n1620), .Y(n1441) );
  OAI21XL U1720 ( .A0(n1441), .A1(n1440), .B0(n1439), .Y(n1445) );
  NAND3X1 U1721 ( .A(n1443), .B(n1463), .C(n1442), .Y(n1444) );
  OAI211X1 U1722 ( .A0(n1601), .A1(n1446), .B0(n1445), .C0(n1444), .Y(
        data_out[16]) );
  XOR2X2 U1723 ( .A(n1457), .B(n1447), .Y(n1452) );
  AOI22X2 U1724 ( .A0(n1453), .A1(n1452), .B0(n1451), .B1(n1450), .Y(n1462) );
  OAI21X1 U1725 ( .A0(n1457), .A1(n1456), .B0(n1455), .Y(n1458) );
  NAND2X4 U1726 ( .A(n1459), .B(n1458), .Y(n1460) );
  OAI221X4 U1727 ( .A0(n1612), .A1(n1462), .B0(n1635), .B1(n1461), .C0(n1460), 
        .Y(data_out[3]) );
  AOI2BB1X4 U1728 ( .A0N(n1469), .A1N(n1468), .B0(n1467), .Y(n1470) );
  AOI21X4 U1729 ( .A0(n1471), .A1(n1612), .B0(n1470), .Y(n1472) );
  NOR3X1 U1730 ( .A(n1477), .B(n1489), .C(n1476), .Y(n1478) );
  OAI21X1 U1731 ( .A0(n1483), .A1(n1482), .B0(n1481), .Y(n1488) );
  AOI21X1 U1732 ( .A0(n1622), .A1(n1486), .B0(n1485), .Y(n1487) );
  AOI31X4 U1733 ( .A0(n1490), .A1(n1489), .A2(n1488), .B0(n1487), .Y(n1491) );
  NAND2X1 U1734 ( .A(n1492), .B(n1491), .Y(data_out[7]) );
  OAI21XL U1735 ( .A0(n1497), .A1(n1496), .B0(n1495), .Y(PRDATA[0]) );
  OAI22XL U1736 ( .A0(n1545), .A1(n1586), .B0(n1583), .B1(n1544), .Y(PRDATA[9]) );
  OAI221XL U1737 ( .A0(n1598), .A1(n1597), .B0(n1596), .B1(n1595), .C0(n1594), 
        .Y(n1599) );
  OAI21XL U1738 ( .A0(n1601), .A1(n1600), .B0(n1599), .Y(data_out[20]) );
  NAND3X2 U1739 ( .A(n1603), .B(n1605), .C(n1602), .Y(n1604) );
  AND2X4 U1740 ( .A(n1616), .B(n1615), .Y(n1617) );
  OAI21XL U1741 ( .A0(n1619), .A1(n1618), .B0(n1617), .Y(data_out[4]) );
  NAND3X1 U1742 ( .A(n1622), .B(n1621), .C(n1620), .Y(n1626) );
  OAI211X1 U1743 ( .A0(n1636), .A1(n1635), .B0(n1634), .C0(n1633), .Y(
        data_out[9]) );
endmodule

