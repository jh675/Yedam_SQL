// db.js 복습
const oracledb = require("oracledb"); // 모듈 임포트

// 조회된 데이터의 포맷을 객체(object)방식으로 출력
oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;
