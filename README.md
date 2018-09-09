# DAPP Project Tutorial

## 1. Prerequistions

1. Node.js 설치
2. npm 최신 LTS버젼 설치
3. truffle
4. ganache
5. Metamask
6. Visual Studio Code
7. web3
8. lite-server

## 2. Install

### Nodejs 설치
OS 버전에 알맞게 다운받는다. 최신 LTS 버젼 추천 [다운로드 링크](https://nodejs.org/ko/download/)

### NPM 설치
Nodejs를 설치하면 자동으로 같이 설치된다.
- 확인 방법
    - 명령프롬포트(Ctrl+R, cmd 입력 후 엔터)를 실행, 아래 명령어 입력
    - node -v
    - npm -v
    - 오류 없이 버젼 숫자가 나오면 정상

### Truffle 설치
```
npm install -g truffle
```

### Ganache 설치
기존의 Test RPC가 Ganache로 대체되었다. Ganache-cli도 있으나 편의를 위해 GUI로 실행
[다운로드 링크](https://truffleframework.com/ganache)


### Metamask 설치
[크롬 익스텐션 링크](https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn)

### Visual Studio Code
[코드 설치 링크](https://code.visualstudio.com/download)

### NPM library 설치
```
npm install -g web3
npm install lite-server --save-dev
CXX=clang++ npm install ~~~ #혹시 오류가 난다면
```

## 3. Truffle init
- 먼저 프로젝트용 폴더를 생성한다. 그리고 명령프롬포트로 해당 경로로 진입
```
mkdir dapp_test
cd dapp_test
truffle init
```
- dapp_test 폴더로 가면 contracts와 migrations 폴더가 있고, 여러 파일들이 존재한다. 여기서 truffle.js를 열고 다음과 같이 적는다. 아래 설정은 Ganache의 포트 설정과 동일해야한다.
```
module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    }
  }
};
```
- Ganache를 실행하고, 명령 프롬포트로 아래의 명령어 실행
```
truffle compile
truffle migration
truffe test
```
- 잘 작동되는 것을 확인해본다

## 4. Coding smart contract

- Contract 폴더 내에 mediinfo.sol 파일을 만든다.
- mediinfo.sol 에서 의사만 환자 정보를 기록하는 스마트 컨트랙트를 만든다.
- 환자 정보는 환자의 EOA 주소, 이름, 질병코드 이다.


```
pragma solidity 0.4.24;

contract mediinfo {

    struct Patient {
        uint256 createdAt;
        string name;
        uint256 code;
    }

    mapping(address=>Patient) PatientOf;
    address doctor;
    

    modifier onlyDoctor() {
        require(msg.sender==doctor);
        _;
    }

    constructor() public {
        doctor = msg.sender;
    }

    function set_patient(address _paddr, string _name, uint256 _code) public onlyDoctor() {
        PatientOf[_paddr].createdAt = now;
        PatientOf[_paddr].name = _name;
        PatientOf[_paddr].code = _code;
        
    }

    function get_patient() public view returns(string, uint256, uint256) {
        return (PatientOf[msg.sender].name, PatientOf[msg.sender].code, PatientOf[msg.sender].createdAt);
    }

}
```

- 작성 한 후 Migration 폴더 내에 2_medi_migration.js 파일 생성
- 아래 내용 붙여넣기

```
var Medi = artifacts.require("./mediinfo.sol");

module.exports = function(deployer) {
  deployer.deploy(Medi);
};

```

- 아래 코드로 잘 작동하는지 확인
```
truffle compile
truffle migration
```


### 5. Web3 View
- lite-server 실행하기 위한 준비
- bs-config.json 파일을 프로젝트 폴더 내 최상위 경로에 생성
- 아래 내용 입력
```
{
    "port": 3000,
    "server": {
      "baseDir": ["./src","./build/contracts"]
    },
    "browser": ["chrome"]
}
```
- src폴더 생성
- web3.min.js 다운받아 넣기 [링크](https://github.com/ethereum/web3.js/tree/develop/dist)
- index.html 파일 생성

```
!<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Page Title</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" type="text/css" media="screen" href="main.css" />
    <script src="main.js"></script>
</head>
<body>
    
</body>


<script src="web3.min.js"></script>
<script>
    if (typeof web3 !== 'undefined') {
        web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:7545"));
    } else {
        // set the provider you want from Web3.providers
        web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:7545"));
    }
</script>
</html>
```

