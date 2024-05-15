// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StaffManagement {
    address public owner;
    uint public staffCount = 0;

    struct Staff {
        uint id;
        string name;
        uint age;
        string position;
    }

    mapping(uint => Staff) public staff;

    // Modifier to restrict access to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    // Event to log the addition of a new staff member
    event StaffAdded(uint id, string name, uint age, string position);

    // Event to log the removal of a staff member
    event StaffRemoved(uint id, string name);

    // Constructor to set the contract deployer as the owner
    constructor() {
        owner = msg.sender;
    }

    // Function to add a new staff member
    function addStaff(string memory _name, uint _age, string memory _position) public onlyOwner {
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(_age > 18, "Age must be greater than 18");
        require(bytes(_position).length > 0, "Position cannot be empty");

        staffCount++;
        staff[staffCount] = Staff(staffCount, _name, _age, _position);

        emit StaffAdded(staffCount, _name, _age, _position);
    }

    // Function to remove a staff member
    function removeStaff(uint _id) public onlyOwner {
        Staff memory staffMember = staff[_id];

        require(staffMember.id != 0, "Staff member does not exist");

        emit StaffRemoved(_id, staffMember.name);

        delete staff[_id];

        // Assert that the staff member has been removed
        assert(staff[_id].id == 0);
    }

    // Function to update staff member details
    function updateStaff(uint _id, string memory _name, uint _age, string memory _position) public onlyOwner {
        Staff storage staffMember = staff[_id];

        require(staffMember.id != 0, "Staff member does not exist");
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(_age > 18, "Age must be greater than 18");
        require(bytes(_position).length > 0, "Position cannot be empty");

        staffMember.name = _name;
        staffMember.age = _age;
        staffMember.position = _position;
    }

    // Function to get a staff member's details
    function getStaff(uint _id) public view returns (uint, string memory, uint, string memory) {
        Staff memory staffMember = staff[_id];

        if (staffMember.id == 0) {
            revert("Staff member does not exist");
        }

        return (staffMember.id, staffMember.name, staffMember.age, staffMember.position);
    }
}
