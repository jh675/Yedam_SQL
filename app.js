// express 서버모듈
const express = require("express"); // 모듈 임포트
const db = require("./db.js"); // db.js 모듈을 읽어와서 변수 db에 담는다.

const app = express(); // 인스턴스 생성

// URL -> 실행함수 => 라우팅

// "/"
app.get("/", (req, res) => {
  // req는 해당 경로로 요청을 보내는 것, res는 경로의 응답
  res.send("/ 김진환 홈에 오신 것을 환영합니다."); // send는 웹페이지에 출력.
});

// "/customer"
app.get("/customer", (req, res) => {
  res.send("/customer 경로가 호출되었습니다.");
});

// "/product"
app.get("/product", (req, res) => {
  res.send("/product 경로가 호출되었습니다.");
});

// "/student" -> 화면에 출력
app.get("/student/:studno", async (req, res) => {
  console.log(req.params.studno);
  const studno = req.params.studno;
  const select = `SELECT * FROM student where studno = ${studno}`;
  const connection = await db.getConn();
  const result = await connection.execute(select);
  res.send(result.rows); // result.rows => 반환되는 값 중에서 rows의 값만 출력한다.
});

// "/employee" -> 사원목록을 출력하는 라우팅
app.get("/emp", async (req, res) => {
  const conn = await db.getConn();
  const result = await conn.execute("SELECT * FROM emp");
  res.send(result.rows);
});

app.listen(3000, () => {
  // 서버 실행
  console.log("server excute. http://localhost:3000");
});

// (인스턴스를 담은 변수).listen(3000, () => {
// 실행할 내용
// })

// 흐름
// 브라우저 요청
//    ↓
// Express 앱(app 인스턴스)
//    ↓ .get("/product")
// 핸들러 실행 (req, res)
//    ↓
// res.send() → 브라우저 응답
