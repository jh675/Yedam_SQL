// 영역 선언
const listArea = document.getElementById("list-area");
const addArea = document.getElementById("add-area");
const detailArea = document.getElementById("detail-area");
// 버튼
const btnEdit = document.querySelector("#btnEdit");
const btnSave = document.querySelector("#btnSave");

// 상세 관련 객체 선언
const formFields = ["#dPw", "#dNm", "#dEmail", "#dTel", "#dDept"];

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

        m_id = "";
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
    { val: m_email, select: "mEmail", msg: "이메일을 입력해주세요" },
    { val: m_tel, select: "#mTel", msg: "연락처를 입력해주세요." },
    { val: m_deptno, select: "#mDeptno", msg: "부서번호를 입력해주세요" },
  ];

  console.log(requireField);

  // for문에 던져넣는다.
  for (const field of requireField) {
    // val값이 널인지 확인
    if (!field.val) {
      // 널값에 focus맞추고 탈주
      document.querySelector(field.select).focus();
      alert(field.msg);
      break;
    }
  }
  // 연락처의 형태 확인.
  formatTel(m_tel);

  // 넘겨줄 객체 생성
  const sndObject = { m_id, m_pw, m_nm, m_tel, m_email, m_birth, m_deptno };

  const sndJSON = JSON.stringify(sndObject);

  fetch("./insMem", {
    method: "post",
    headers: { "Content-Type": "application/json" },
    body: sndJSON,
  })
    .then((data) => {
      console.log(data.json());
    })
    .catch((e) => console.log(`에러 발생 => \n${e}`));
});

// 수정 버튼 클릭
btnEdit.addEventListener("click", () => {
  // 패스워드 확인 input 보이기
  document.querySelector("#dPwRe-div").style.display = "block";
  setField(false);
  editMode(true);
});

// 수정 완료 버튼 클릭
btnSave.addEventListener("click", () => {
  setField(true);
  editMode(false);

  document.querySelector("#dPwRe-div").style.display = "none";
  // 여기서 fetch로 서버에 업데이트 가능
});

// 버튼 클릭 시 해당 영역만 표시하는 함수
function showArea(area) {
  [listArea, addArea, detailArea].forEach((a) => (a.style.display = "none"));
  area.style.display = "block";
}

// 테이블 그리기
function drawTable(res) {
  const tbody = document.querySelector("tbody");
  res.forEach((ele) => {
    const insertHtml = `<tr>
      <td>${ele.M_NO}</td>
      <td>${ele.M_NM}</td>
      <td>${ele.M_TEL}</td>
      <td><button class="btn btn-primary btn-sm" onclick='detailMem(${ele.M_NO})'>상세</button></td>
      </tr>`;
    // https://developer.mozilla.org/ko/docs/Web/API/Element/insertAdjacentHTML 참고
    tbody.insertAdjacentHTML("beforeend", insertHtml);
  });
}

// 연락처 통일
function formatTel(tel) {
  const digits = tel.replace(/\D/g, "");
  if (digits.length === 11) {
    return digits.replace(/(\d{3})(\d{4})(\d{4})/, "$1-$2-$3");
  }
  // 형식이 이상하면 그대로 반환 혹은 에러 처리
  return null;
}

// 상세 조회 함수
function detailMem(m_no) {
  console.log(m_no);
  showArea(detailArea);

  fetch(`/detailMem/${m_no}`)
    .then((res) => res.json())
    .then((data) => {
      document.querySelector("#dNo").value = data.M_NO;
      document.querySelector("#dId").value = data.M_ID;
      document.querySelector("#dPw").value = data.M_PW;
      document.querySelector("#dNm").value = data.M_NM;
      document.querySelector("#dEmail").value = data.M_EMAIL;
      document.querySelector("#dTel").value = data.M_TEL;
      document.querySelector("#dDept").value = data.M_DEPTNO;

      // 날짜 변환
      document.querySelector("#dBirth").value = data.M_BIRTH
        ? data.M_BIRTH.split("T")[0]
        : "";
      // 항상 초기 상태로 세팅
      editMode(false);
    })
    .catch((e) => console.log(`에러 발생 => \n${e}`));
}

function editMode(eMode) {
  // 버튼 토글
  btnEdit.style.display = eMode ? "none" : "inline-block";
  btnSave.style.display = eMode ? "inline-block" : "none";
}

function setField(dMode) {
  formFields.forEach((selector) => {
    const el = document.querySelector(selector);
    if (el) el.disabled = dMode;
  });
}

// 초기 화면은 목록
showArea(listArea);
