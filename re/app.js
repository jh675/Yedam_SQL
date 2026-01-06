// express 서버모듈
const express = require("express"); // 모듈을 임포트

const app = express(); // 인스턴스를 생성

// URL -> handler => 라우팅
// 한마디로 요약하자면 'URL(사용자요청)을 받아 적절한 handler(실행함수 혹은 처리할 코드)을 실행하는 과정'

app.get(
  // 라우팅 정의
  "/" /*<< 요청을 처리할 URL 경로 지정 */,
  /* 핸들러 함수 지정>>*/ (req, res) => {
    // 이 함수는 클라이언트가 지정된 URL('/')로 GET 요청을 보냈을 때 실행.
    // req: 클라이언트가 서버로 보낸 요청의 모든 정보(URL, 데이터 등)를 담은 객체
    // res: 서버가 클라이언트에게 보낼 응답을 만들고 전달하는 데 사용되는 객체 (예: 응답 본문, HTTP 상태 코드 등)
    res.send("Welcome, Main HomePage");
    // res.send("Hello World"); // 클라이언트에 응답을 보내지 않으면 요청이 계속 대기 상태로 있을 수 있다.
  }
);
// 위 코드를 분해하자면 다음과 같다.
// app => const app = express();로 생성된 Express 애플리케이션의 인스턴스.
// get => HTTP 요청 메서드 중 GET 방식의 요청을 처리하겠다는 의미. (POST, PUT, DELETE 등 다른 메서드도 있음)
// "/" => 이 라우트 핸들러가 처리할 URL 경로 (여기서는 루트 경로를 의미). 사용자 요청의 URL과 매칭.
// '(req, res) => {}' => 이 URL로 GET 요청이 들어왔을 때 실행될 핸들러(콜백) 함수.
// req => request의 약자. 클라이언트의 요청에 대한 모든 정보를 담고 있는 객체. (예: req.params, req.query, req.body 등)
// res => response의 약자. 서버가 클라이언트에게 보낼 응답을 구성하고 전달하는 데 사용되는 객체. (예: res.send(), res.json() 등)
// ------
// 인스턴스_변수.HTTP메소드("URL", (request, response) => { handler });
// ------

app.listen(2000, () => {
  console.log("server execute. http://localhost:2000");
});
// 위 코드를 분해하자면 다음과 같다.
// app => const app = express();로 생성된 Express 애플리케이션의 인스턴스.
// listen => 서버를 특정 포트(소괄호 안의 숫자(2000)가 지정한)에서 활성화하여, 외부로부터의 연결(웹 요청)을 지속적으로 기다리고 수신하는 메소드.
// 2000 => 포트 번호. 이론상 0 ~ 65535 사이에서 충돌 나지 않는 아무 번호나 사용 가능하지만,
//         80번(HTTP), 443번(HTTPS)과 같은 Well-known 포트나 0 ~ 1023번의 시스템 포트 대역은 사용하지 않는 것이 좋음.
// '() => {}' => 이 함수는 listen 메소드가 서버 가동을 성공적으로 시작했을 때 '딱 한 번' 실행되는 콜백 함수.
//               주로 서버가 정상적으로 실행되었는지 확인하고 알리는 용도로 사용.
