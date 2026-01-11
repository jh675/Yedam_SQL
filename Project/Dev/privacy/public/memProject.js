// 영역 선언
const listArea = document.getElementById("list-area");
const addArea = document.getElementById("add-area");
const detailArea = document.getElementById("detail-area");

// ********** 버튼 전역 변수 선언 **********
const btnEdit = document.querySelector("#btnEdit");
const btnSave = document.querySelector("#btnSave");

// ********** 상세 페이지의 모든 요소들을 전역 변수로 선언 **********
const dNo = document.querySelector("#dNo");
const dId = document.querySelector("#dId");
const dPw = document.querySelector("#dPw");
const dPwRe = document.querySelector("#dPwRe");
const dNm = document.querySelector("#dNm");
const dEmail = document.querySelector("#dEmail");
const dTel = document.querySelector("#dTel");
const dBirth = document.querySelector("#dBirth");
const dDept = document.querySelector("#dDept");
const dPwReDiv = document.querySelector("#dPwRe-div"); // 패스워드 확인 div
const detailAreaH3 = document.querySelector("#detail-area h3"); // 회원 상세 제목
const btnChangePw = document.querySelector("#btnChangePw"); // HTML에 추가된 패스워드 변경 버튼

const formFields = ["#dPw", "#dNm", "#dEmail", "#dTel", "#dDept"];

// ********** 항상 disabled 되어야 할 필드들 (ID, NO, BIRTH) **********
const alwaysDisabledFieldsSelectors = ["#dNo", "#dId", "#dBirth"];

document
  .getElementById("btn-list")
  .addEventListener("click", () => showArea(listArea));
document
  .getElementById("btn-add")
  .addEventListener("click", () => showArea(addArea));

// 목록 fetch
fetch("./selMem")
  .then((res) => {
    console.log(res);
    return res.json();
  })
  .then((result) => {
    console.log(result);
    drawTable(result);
  })
  .catch((e) => console.log(`에러 발생 => \n${e}`));

// 등록 중복체크
document.querySelector("#btnIdCheck").addEventListener("click", (e) => {
  const m_id = document.querySelector("#mId").value;

  if (!m_id) {
    alert("아이디를 입력해주세요");
    document.querySelector("#mId").focus();

    return;
  }

  fetch(`./chkIdMem/${m_id}`)
    .then((res) => res.json())
    .then((data) => {
      if (data.retCode) {
        alert(data.retMsg);

        document.querySelector("#mId").value = ""; // m_id = "" 가 아닌 value로 수정
        document.querySelector("#mId").focus();

        e.preventDefault();
        return;
      } else {
        alert("사용할 수 있는 아이디입니다.");

        document.querySelector("#check").checked = true;
        document.querySelector("#btnIdCheck").disabled = true;
        e.preventDefault();
      }
    })
    .catch((e) => console.log(`에러 발생 => \n${e}`));
});

// 등록 fetch
document.querySelector("form").addEventListener("submit", (e) => {
  const m_id = document.querySelector("#mId").value;
  const m_chk = document.querySelector("#check");
  const m_chkbtn = document.querySelector("#btnIdCheck");

  // 중복체크 여부 확인
  if (!m_chk.checked && !m_chkbtn.disabled) {
    // 중복체크를 하지 않았다면 아이디 입력창으로 이동
    alert("아이디 중복체크를 해주세요.");

    document.querySelector("#mId").focus();
    e.preventDefault();
    return;
  }

  const m_pw = document.querySelector("#mPw").value;
  const m_pwRe = document.querySelector("#mPwRe").value;

  // 패스워드 일치 확인
  if (m_pw != m_pwRe) {
    alert("패스워드가 일치하지 않습니다.");

    // 패스워드가 일치하지 않으면 해당 input 초기화
    document.querySelector("#mPw").value = "";
    document.querySelector("#mPwRe").value = "";

    // 패스워드에 포커스 맞추기
    document.querySelector("#mPw").focus();
    e.preventDefault();
    return;
  }

  const m_nm = document.querySelector("#mNm").value;
  const m_email = document.querySelector("#mEmail").value;
  const m_tel = document.querySelector("#mTel").value;
  const m_birth = document.querySelector("#mBirth").value;
  const m_deptno = document.querySelector("#mDeptno").value;

  // 다른 NOT NULL 제약이 잡혀있는 항목에 대해 널값이 없는지 확인한다.
  const requireField = [
    { val: m_id, select: "#mId", msg: "아이디를 입력해주세요." },
    { val: m_pw, select: "#mPw", msg: "패스워드를 입력해주세요." },
    { val: m_nm, select: "#mNm", msg: "이름을 입력해주세요." },
    { val: m_email, select: "#mEmail", msg: "이메일을 입력해주세요" }, // select "mEmail" -> "#mEmail"
    { val: m_tel, select: "#mTel", msg: "연락처를 입력해주세요." },
    { val: m_deptno, select: "#mDeptno", msg: "부서번호를 입력해주세요" },
  ];
  // for문에 던져넣는다.
  for (const field of requireField) {
    // val값이 널인지 확인
    if (!field.val) {
      // 널값에 focus맞추고 탈주
      document.querySelector(field.select).focus();
      alert(field.msg);
      e.preventDefault(); // submit 중단
      return; // 함수 탈출
    }
  }

  // 넘겨줄 객체 생성
  const insObject = { m_id, m_pw, m_nm, m_tel, m_email, m_birth, m_deptno };

  const insJSON = JSON.stringify(insObject);

  fetch("./insMem", {
    method: "post",
    headers: { "Content-Type": "application/json" },
    body: insJSON,
  })
    .then((res) => {
      // response를 받아서 JSON 파싱해야 해
      return res.json();
    })
    .then((data) => {
      console.log(data); // 파싱된 데이터를 콘솔에 출력
      if (data.retCode === "success") {
        alert("회원 등록 성공!");
        showArea(listArea); // 등록 후 목록 화면으로 이동 등
        // 목록 새로고침
        fetch("./selMem")
          .then((res) => res.json())
          .then((result) => drawTable(result))
          .catch((e) => console.log(`목록 새로고침 에러 => \n${e}`));
      } else {
        alert("회원 등록 실패: " + data.retMsg);
      }
    })
    .catch((e) => console.log(`에러 발생 => \n${e}`));

  e.preventDefault();
});

// ********** 연락처 통일 함수 (네 코드 그대로) **********
function formatTel(tel) {
  const digits = tel.replace(/\D/g, "");
  if (digits.length === 11) {
    return digits.replace(/(\d{3})(\d{4})(\d{4})/, "$1-$2-$3");
  }
  // 형식이 이상하면 그대로 반환 혹은 에러 처리
  return null;
}

// ********** 상세 조회 함수 (수정 반영) **********
function detailMem(m_no) {
  console.log(m_no);
  showArea(detailArea);

  fetch(`/detailMem/${m_no}`)
    .then((res) => res.json())
    .then((data) => {
      // 전역 변수로 선언된 요소들을 사용
      dNo.value = data.M_NO;
      dId.value = data.M_ID;
      dPw.value = data.M_PW;
      dNm.value = data.M_NM;
      dEmail.value = data.M_EMAIL;
      dTel.value = data.M_TEL;
      dDept.value = data.M_DEPTNO;

      // 날짜 변환
      dBirth.value = data.M_BIRTH ? data.M_BIRTH.split("T")[0] : "";

      // 항상 초기 상태로 세팅
      setAllDetailFieldsDisabled(true); // 모든 상세 필드를 비활성화하는 새로운 함수 호출
      dPwReDiv.style.display = "none"; // 패스워드 확인 입력창 숨기기
      btnChangePw.style.display = "none"; // 패스워드 변경 버튼도 숨기기

      editMode(false); // 수정/수정 완료 버튼 상태를 '수정' 버튼 보이도록 초기화
      detailAreaH3.innerHTML = "회원 상세"; // 제목 초기화
    })
    .catch((e) => console.log(`에러 발생 => \n${e}`));
}

// ********** 수정 버튼 클릭 (수정 반영) **********
btnEdit.addEventListener("click", () => {
  detailAreaH3.innerHTML = "회원 정보 수정";

  setField(false);

  dPw.disabled = true;
  dPwReDiv.style.display = "none";
  dPwRe.disabled = true;
  btnChangePw.style.display = "inline-block";

  editMode(true);
});

// ********** 패스워드 변경 버튼 클릭 이벤트 추가 **********
btnChangePw.addEventListener("click", () => {
  dPw.disabled = false;
  dPwReDiv.style.display = "block";
  dPwRe.disabled = false;
  btnChangePw.style.display = "none";

  // 패스워드를 변경하기 위해 눌렀을 경우 패스워드 초기화
  dPw.value = "";
  dPwRe.value = "";
  dPw.focus();
});

// ********** 수정 완료 버튼 클릭 (수정 반영) **********
btnSave.addEventListener("click", () => {
  // ************ 중요! 패스워드 유효성 검사 로직 추가 ************
  // dPwRe-div가 보인다는 것은 패스워드를 변경하려고 시도했다는 뜻이야.
  if (dPwReDiv.style.display === "block") {
    // 패스워드 변경 모드인데 빈 값인 경우
    if (dPw.value === "" || dPwRe.value === "") {
      alert(
        "새 패스워드를 입력하세요. 패스워드 변경을 취소하려면, 새 패스워드를 입력하지 않은 채 '수정 완료' 버튼을 다시 눌러주십시오."
      );
      dPw.focus(); // 첫 번째 패스워드 필드에 포커스
      return; // 저장 중단
    }
    // 패스워드가 일치하지 않는 경우
    if (dPw.value !== dPwRe.value) {
      alert("패스워드와 패스워드 확인이 일치하지 않습니다!");
      dPw.focus();
      return; // 일치하지 않으면 저장 중단
    }
    // 여기에 현재 패스워드와 새 패스워드의 유효성 검사 (길이, 복잡도 등) 추가 가능
  }
  // *****************************

  // 모든 필드를 초기 상태(비활성화)로 되돌리기
  setAllDetailFieldsDisabled(true);
  dPwReDiv.style.display = "none";
  btnChangePw.style.display = "none";

  detailAreaH3.innerHTML = "회원 상세";

  // 버튼 토글: '수정 완료' 버튼 숨기고 '수정' 버튼 보이기
  editMode(false);

  // ********** 여기서 fetch로 서버에 업데이트 가능 **********
  // 서버에 전송할 데이터 객체 생성
  const updObject = {
    m_no: dNo.value,
    m_id: dId.value, // ID는 disabled지만 필요하다면 함께 보냄
    m_nm: dNm.value,
    m_email: dEmail.value,
    m_tel: dTel.value,
    m_birth: dBirth.value,
    m_deptno: dDept.value,
  };

  // 패스워드가 변경 모드였으면 패스워드도 포함
  if (dPwReDiv.style.display === "block") {
    // dPwReDiv가 보였었다면 (패스워드 변경 시도했었다면)
    updObject.m_pw = dPw.value; // 변경된 패스워드 포함
  }

  // 연락처 유효성 검사 및 포맷팅 추가 (수정 완료 시)
  const formattedTel = formatTel(updObject.m_tel);
  if (!formattedTel) {
    alert("올바른 연락처 형식이 아닙니다.");
    dTel.focus();
    return;
  }
  updObject.m_tel = formattedTel; // 포맷팅된 연락처로 업데이트

  const updJSON = JSON.stringify(updObject);

  fetch("/updMem", {
    method: "PUT", // 또는 POST, PATCH 등 서버 API에 따라
    headers: { "Content-Type": "application/json" },
    body: updJSON,
  })
    .then((res) => res.json())
    .then((data) => {
      console.log(data);
      if (data.retCode === "OK") {
        alert(data.retMsg);
        // 필요하다면 목록 새로고침
        // fetch("./selMem")
        // .then((res) => res.json())
        // .then((result) => drawTable(result))
        // .catch((e) => console.log(`목록 새로고침 에러 => \n${e}`));
      } else if (data.retCode === "NG") {
        alert(data.retMsg);
      }
    })
    .catch((e) => console.log(`업데이트 에러 => \n${e}`));
});

function editMode(eMode) {
  // 버튼 토글
  btnEdit.style.display = eMode ? "none" : "inline-block";
  btnSave.style.display = eMode ? "inline-block" : "none";
}

function setField(dMode) {
  // 이 함수는 'formFields'에 정의된 selector들만 disabled 속성을 제어.
  // formFields는 전역에 ["#dPw", "#dNm", "#dEmail", "#dTel", "#dDept"]로 정의.
  formFields.forEach((selector) => {
    const el = document.querySelector(selector);
    if (el) el.disabled = dMode;
  });
}

// ********** 추가 함수: 모든 상세 필드를 일괄적으로 disabled 상태로 설정 **********
function setAllDetailFieldsDisabled(dMode) {
  // 1. 항상 비활성화 되어야 할 필드들 (회원번호, 아이디, 생일)은 항상 disabled = true
  alwaysDisabledFieldsSelectors.forEach((selector) => {
    const el = document.querySelector(selector);
    if (el) el.disabled = true;
  });

  // 2. formFields에 있는 모든 필드들은 dMode에 따라 제어
  formFields.forEach((selector) => {
    const el = document.querySelector(selector);
    if (el) el.disabled = dMode;
  });

  // dPwRe는 formFields에 없으니 직접 처리
  if (dPwRe) dPwRe.disabled = dMode;
}

// 버튼 클릭 시 해당 영역만 표시하는 함수
function showArea(area) {
  [listArea, addArea, detailArea].forEach((a) => (a.style.display = "none"));
  area.style.display = "block";
}

// 테이블 그리기
function drawTable(res) {
  const tbody = document.querySelector("tbody");
  tbody.innerHTML = ""; // 테이블 내용 초기화
  res.forEach((ele) => {
    const insertHtml = `<tr>
      <td>${ele.M_NO}</td>
      <td>${ele.M_NM}</td>
      <td>${ele.M_TEL}</td>
      <td><button class="btn btn-primary btn-sm" onclick='detailMem(${ele.M_NO})'>상세</button></td>
      </tr>`;
    tbody.insertAdjacentHTML("beforeend", insertHtml);
  });
}

// 초기 화면은 목록
showArea(listArea);
