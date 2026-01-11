const express = require("express"); // 모듈 임포트
const db = require("./db.js"); // db.js 모듈을 읽어와서 변수 db에 담는다.
const path = require("path");
const { outFormat } = require("oracledb");

const app = express(); // 인스턴스 생성
app.use(express.static(path.join(__dirname, "public")));
app.use(express.json());

app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "memProject.html"));
});

// "/selMem" 라우팅 => 목록
app.get("/selMem", async (req, res) => {
  const selsql = "SELECT m_no, m_nm, m_tel, m_birth FROM pro_mem ORDER BY 1";
  try {
    const conn = await db.getConn();
    const rs = await conn.execute(selsql);
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
  const inssql = `INSERT INTO pro_mem VALUES (mno_seq.NEXTVAL, :m_id, :m_pw, :m_nm, :m_tel, :m_email, :birth, :m_deptno, sysdate)`;
  try {
    const conn = await db.getConn();
    const rs = await conn.execute(inssql, [
      m_id,
      m_pw,
      m_nm,
      m_tel,
      m_email,
      birth,
      m_deptno,
    ]);
    if (rs.rowsAffected > 0) {
      conn.commit();
      res.json({ retCode: "OK", retMsg: "등록이 완료되었습니다." });
    }
  } catch (e) {
    console.log(`에러 발생 => \n${e}`);
    res.json({
      retCode: "NG",
      retMsg: "등록을 실패하였습니다.\n다시 시도해주세요.",
    });
  }
});

// "/chkIdMem" 라우팅 => 체크
app.get("/chkIdMem/:m_id", async (req, res) => {
  const m_id = req.params.m_id;
  console.log(`넘겨받은 ID값은 '${m_id}' 입니다.`);
  const chksql = `SELECT COUNT(m_id) AS "CNT" FROM pro_mem WHERE m_id = :m_id`;
  try {
    const conn = await db.getConn();
    const rs = await conn.execute(chksql, { m_id });
    console.log(rs);
    if (rs.rows[0].CNT > 0) {
      res.json({ retCode: true, retMsg: "이미 존재하는 아아디입니다." });
    } else {
      res.json({ retCode: false, retMsg: "사용 가능한 아이디입니다." });
    }
  } catch (e) {
    console.log(`에러 발생 => \n${e}`);
    res.json({ retCode: "NG", retMsg: "중복 체크를 실패하였습니다." });
  }
});

// "/detailMem" 라우팅 => 상세
app.get("/detailMem/:m_no", async (req, res) => {
  const m_no = req.params.m_no;
  console.log(m_no);
  const selsql = `SELECT * FROM pro_mem WHERE m_no = :m_no`;
  try {
    const conn = await db.getConn();
    const rs = await conn.execute(
      selsql,
      { m_no },
      { outFormat: db.OUT_FORMAT_OBJECT }
    );
    res.send(rs.rows[0]);
  } catch (e) {
    console.log(`에러 발생 => \n${e}`);
    res.json({ retCode: "NG", retMsg: "상세 조회를 실패하였습니다" });
  }
});

// "/updMem" 라우팅 => 수정
app.put("/updMem", async (req, res) => {
  const updData = req.body;
  const mNoData = updData.m_no;
  if (!mNoData) {
    res.json({ retCode: "NG", retMsg: "회원번호를 찾을 수 없습니다." });
  }

  let setClauses = [];
  let params = [];

  for (const key in updData) {
    console.log(`key => ${key}`);
    if (key === "m_no" || key === "m_id" || key === "m_birth") {
      continue;
    }

    if (key === "m_pw") {
      if (updData[key] === "") {
        continue;
      }
    }

    const col = key.toUpperCase();
    setClauses.push(`${col} = :${key}`);

    if (updData[key] === "") {
      params.push(null);
    } else {
      params.push(updData[key]);
    }
  }

  if (setClauses.length === 0) {
    res.json({ retCode: "NG", retMsg: "수정된 내용이 없습니다." });
  }

  params.push(mNoData);

  const updsql = `UPDATE pro_mem SET ${setClauses.join(
    ", "
  )} WHERE M_NO = :m_no`;
  try {
    const conn = await db.getConn();
    const rs = await conn.execute(updsql, params);
    if (rs.rowsAffected > 0) {
      await conn.commit();
      res.json({ retCode: "OK", retMsg: "회원정보 수정이 완료되었습니다." });
    } else {
      res.json({ retCode: "NG", retMsg: "해당 회원을 찾을 수 없습니다" });
    }
  } catch (e) {
    console.log(`에러 발생 => \n${e}`);
    res.json({ retCode: "NG", retMsg: "수정을 실패하였습니다." });
  }
});

app.listen(3000, () => {
  console.log(`개인프로젝트 서버 실행중.\nhttp://localhost:3000`);
});
