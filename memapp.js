const express = require("express"); // 모듈 임포트
const db = require("./db.js"); // db.js 모듈을 읽어와서 변수 db에 담는다.

const app = express(); // 인스턴스 생성
app.use(express.static("project"));
app.use(express.json());
