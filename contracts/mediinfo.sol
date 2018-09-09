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
