const express = require("express"); // 모듈 임포트
const db = require("./db.js"); // db.js 모듈을 읽어와서 변수 db에 담는다.
const path = require("path");
const { outFormat } = require("oracledb");

const app = express(); // 인스턴스 생성
app.use(express.static(path.join(__dirname, "public")));
app.use(express.json());

app.get(/*라우팅*/ "/" /* URL */, (req, res) => {
  // 여기서 /로 넘어오면 실행되는 함수.
  // req는 해당 경로로 요청을 보내는 것, res는 경로의 응답
  // res.send("/ 김진환 홈에 오신 것을 환영합니다."); // send는 웹페이지에 출력.
  res.sendFile(path.join(__dirname, "public", "memProject.html"));
}); // 실행함수(handler)

// "/selMem" 라우팅 => 목록
app.get("/selMem", async (req, res) => {
  const selqry = "SELECT m_no, m_nm, m_tel, m_birth FROM pro_mem ORDER BY 1";
  try {
    const conn = await db.getConn();
    const rs = await conn.execute(selqry);
    res.send(rs.rows);
  } catch (e) {
    console.log(`에러 발생 => \n${e}`);
    res.json({ retCode: "NG", retMsg: "조회 실패" });
  }
});

// "/insMem" 라우팅 => 등록
app.post("/insMem", async (req, res) => {
  console.log(req.body);
  const { m_id, m_pw, m_nm, m_tel, m_email, m_birth, m_deptno } = req.body;
  console.log(m_id);
  const birth = m_birth ? m_birth : null;
  const insqry = `INSERT INTO pro_mem VALUES (mno_seq.NEXTVAL, :m_id, :m_pw, :m_nm, :m_tel, :m_email, :birth, :m_deptno, sysdate)`;
  try {
    const conn = await db.getConn();
    const rs = await conn.execute(insqry, [
      m_id,
      m_pw,
      m_nm,
      m_tel,
      m_email,
      birth,
      m_deptno,
    ]);
    console.log(rs);
    conn.commit();
    res.json({ m_id, m_pw, m_nm, m_tel, m_email, birth, m_deptno });
  } catch (e) {
    console.log(`에러 발생 => \n${e}`);
    res.json({ retCode: "NG", retMsg: "등록 실패" });
  }
});

// "/chkIdMem" 라우팅 => 체크
app.get("/chkIdMem/:m_id", async (req, res) => {
  const m_id = req.params.m_id;
  console.log(`넘겨받은 ID값은 '${m_id}' 입니다.`);
  const chkqry = `SELECT COUNT(m_id) AS "CNT" FROM pro_mem WHERE m_id = :m_id`;
  try {
    const conn = await db.getConn();
    const rs = await conn.execute(chkqry, { m_id });
    console.log(rs);
    if (rs.rows[0].CNT > 0) {
      res.json({ retCode: true, retMsg: "아이디가 중복됩니다." });
    } else {
      res.json({ retCode: false, retMsg: "사용가능한 아이디입니다." });
    }
  } catch (e) {
    console.log(`에러 발생 => \n${e}`);
    res.json({ retCode: "NG", retMsg: "중복 체크 실패" });
  }
});

// "/detailMem" 라우팅 => 상세
app.get("/detailMem/:m_no", async (req, res) => {
  const m_no = req.params.m_no;
  console.log(m_no);
  const selqry = `SELECT * FROM pro_mem WHERE m_no = :m_no`;
  try {
    const conn = await db.getConn();
    const rs = await conn.execute(
      selqry,
      { m_no },
      { outFormat: db.OUT_FORMAT_OBJECT }
    );
    console.log(rs.rows[0]);
    res.send(rs.rows[0]);
  } catch (e) {
    console.log(`에러 발생 => \n${e}`);
    res.json({ retCode: "NG", retMsg: "상세 조회 실패" });
  }
});

// "/updMem" 라우팅 => 수정
app.post("/updMem", async (req, res) => {});

app.listen(3000, () => {
  console.log(`개인프로젝트 서버 실행중.\nhttp://localhost:3000`);
});
