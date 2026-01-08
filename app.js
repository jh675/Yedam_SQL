// express 서버모듈
const express = require("express"); // 모듈 임포트
const db = require("./db.js"); // db.js 모듈을 읽어와서 변수 db에 담는다.

const app = express(); // 인스턴스 생성

app.use(express.static("public")); // 서버 모듈(백엔드)
// 현재 위치의 하위폴더 중 public라는 폴더 안에 저장하여 실행
app.use(express.json()); // express

// URL -> 실행함수 => 라우팅

// "/"
app.get(/*라우팅*/ "/" /* URL */, (req, res) => {
  // 여기서 /로 넘어오면 실행되는 함수.
  // req는 해당 경로로 요청을 보내는 것, res는 경로의 응답
  res.send("/ 김진환 홈에 오신 것을 환영합니다."); // send는 웹페이지에 출력.
}); // 실행함수(handler)

// 요청방식: GET vs POST

// get : 단순 조회. 적은 양의 데이터밖에 전달하지 못한다.

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

app.get("/boardLists", async (req, res) => {
  const selqry = "SELECT * FROM board ORDER BY 1";
  try {
    const conn = await db.getConn();
    const rs = await conn.execute(selqry); //rs에 selqry를 실행한 값을 저장
    res.send(rs.rows); // res.send로 rs의 rows(데이터)를 반환한다.
  } catch (e) {
    console.log("에러발생\n" + e);
    res.json({ retCode: "NG", retMsg: "DB 에러" });
  }
});

// 삭제 기능
// 요청방식은 get => '/rmBoard/:b_no'
// 반환결과 => ({retCode: 'OK' or 'NG'})
app.get("/delRows/:b_no", async (req, res) => {
  const b_no = req.params.b_no;
  console.log(b_no);
  const delqry = `DELETE FROM board WHERE b_no = ${b_no}`; // del 쿼리
  try {
    const conn = await db.getConn();
    await conn.execute(delqry);
    await conn.commit();
    res.json({ retCode: "OK", b_no });
  } catch (e) {
    console.log(`상세 에러: ${e}`);
    res.json({ retCode: "NG" });
  }
});

// post : 많은 양의 데이터를 전달할 수 있다.
app.post("/addBoard", async (req, res) => {
  console.log(req.body);
  const { b_no, b_title, b_content, b_writer } = req.body;
  const conn = await db.getConn();
  const insqry = `INSERT INTO board(b_no, b_title, b_content, b_writer)
                  VALUES(:b_no, :b_title, :b_content, :b_writer)`;
  try {
    const rs = await conn.execute(insqry, [b_no, b_title, b_content, b_writer]);
    console.log(rs);
    conn.commit();
    console.log(`1행의 삽입이 완료되었습니다\n처리 완료`);
    res.json({ b_no, b_title, b_content, b_writer });
    // res.send("처리완료");
  } catch (e) {
    console.log(e);
    res.send("처리중 에러");
  }
});

app.listen(3000, () => {
  // 서버 실행
  console.log("server excute. http://localhost:3000");
});

// (인스턴스를 담은 변수).listen(port_number, () => {
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
