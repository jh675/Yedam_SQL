// db.js
const oracledb = require("oracledb"); // import

// 조회된 데이터 -> 객체방식
oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;

// db정보 저장
const dbConfig = {
  user: "scott",
  password: "tiger",
  connectString: "192.168.0.17:1521/XE",
};
// DB 접속을 위한 session을 얻는 함수
async function getConn() {
  try {
    const conn = await oracledb.getConnection(dbConfig); // db 연결(session)
    return conn; // 연결(session)을 반환
  } catch (e) {
    return e; // 에러 반환
  }
}

//비동기처리 => 동기방식 처리
async function execute() {
  const insMem = `INSERT INTO  pro_mem
                  VALUES  (11, '김진환', '010-1235-6789', '1997-04-01', 5, sysdate)`;
  // session 획득
  try {
    // 정상적으로 연결되었을 경우
    console.log("DB Conection Success");
    const result = await conn.execute(insMem);
    conn.commit(); // 커밋
    console.log("DB Insert Success");
    console.log(result);
  } catch (err) {
    // 예외가 발생했을 경우(실패)
    console.log(`예외발생 => ${err}`);
  }
} // end of exe

// exe();

// 외부 js파일에서 사용할 수 있도록 익스포트
// module.exports = { 익스포트할 내용 };
module.exports = { getConn, execute };
