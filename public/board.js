// fetch를 통해 게시글 목록 가져오기
fetch("./boardLists")
  // return res.json()을 넘겨받는 곳
  .then((res) => {
    return res.json();
  })
  // return 후 then(변수명 => {})는 사실상 변수명 = res.json()과 같다.
  .then((result) => {
    drawTable(result);
  }) // result에 받은 것을 drawTable에 매개변수로 던져줘서 테이블을 그린다.
  .catch((e) => console.log(`에러발생 \n${e}`)); // 에러

// 삭제 함수
function deleteRow(bNo) {
  fetch(`./delRows/${bNo}`) // app.js로 정보를 던져준다.
    .then((res) => res.json()) // app.js 에서 처리해 반환시켜준 데이터를 JSON으로 처리하여 반환한다.
    .then((result) => {
      console.log(result);
      //위에서 반환된 값을 result에 담는다.
      if (result.retCode === "OK") {
        // result의 retCode가 OK이면 실행
        location.reload();
      } else if (result.retCode === "NG") {
        // result의 retCode가 NG면 실행
        console.log("Failed");
      }
    })
    // 에러
    .catch((e) => {
      console.log(`Error => \n${e}`);
    });
}

// 테이블 그리기 함수.
function drawTable(res) {
  // tbody subject
  const subject = document.querySelector("tbody");
  res.forEach((ele) => {
    const insertHtml = `<tr>
      <td>${ele.B_NO}</td>
      <td>${ele.B_TITLE}</td>
      <td>${ele.B_WRITER}</td>
      <!-- new Date(요소).toLocaleString()는 요소를 날짜 형식으로 바꾼 후 그것을 문자형으로 만들어준다. -->
      <td>${new Date(ele.B_REGDATE).toLocaleString()}</td>
      <td>${ele.B_COUNT}</td>
      <td><button onclick='deleteRow(${ele.B_NO})'>삭제</button></td>
      </tr>`;
    // https://developer.mozilla.org/ko/docs/Web/API/Element/insertAdjacentHTML 참고
    subject.insertAdjacentHTML("afterbegin", insertHtml);
  });
}

// form에 submit 이벤트 등록
document.querySelector("form").addEventListener("submit", (e) => {
  console.log(e);
  e.preventDefault(); // 새로고침 차단.
  const b_no = document.querySelector("#bNo").value;
  const b_title = document.querySelector("#bTitle").value;
  const b_content = document.querySelector("#bContent").value;
  const b_writer = document.querySelector("#bWriter").value;
  // 입력값을 체크
  if (!b_no || !b_title || !b_content || !b_writer) {
    // 하나라도 결과값이 T가 나오면 널값이 존재한다는 것.
    alert("NULL 확인");
    return;
  }

  // 객체 생성
  const data = { b_no, b_title, b_content, b_writer };

  // 서버로 전달. JSON.stringify() 함수를 사용
  const snd = JSON.stringify(data); // 위에서 선언한 data를 JSON 방식으로 snd에 담는다. 그냥 쉽게 말하면 객체 -> 텍스트 다.

  const obj = JSON.parse(snd); // 텍스트로 묶은걸 다시 풀어서 객체로 만들어준다. 쉽게말하면 텍스트 -> 객체

  // POST 요청
  // fetch("URL", {option object})
  fetch("./addBoard", {
    // 요청방식
    method: "post",
    // 서버에 알려주는 메타정보
    headers: { "Content-Type": "application/json" },
    body: snd,
  })
    // method: 요청방식 => GET, POST 중 지정한다. 쉽게 말해서 해당 URL로 전달을 하는 것.
    // headers: 서버에 어떤 형식의 데이터인지 알려주는 것. Content-Type는 어떤 타입으로 보낼것인가를 알려주는 것이며, application/json은 JSON 형식으로 보내겠다고 하는 것.
    // 참고로 headers가 없으면 express가 JSON인지 몰라서 파싱을 안한다.
    .then((data) => data.json()) // fetch()실행이 성공할 경우 실행.
    .then((result) => {
      console.log(result);
      if (result == "처리완료") {
        alert("성공");
      } else if (result == "처리중 에러") {
        alert("실패");
      }
    })
    .catch((e) => {
      console.log(`error 발생: ${e}`);
    }); // fetch()실행이 실패할 경우 실행.
});
