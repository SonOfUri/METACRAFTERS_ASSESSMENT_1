# StaffManagement Smart Contract

## Overview

The `StaffManagement` is a smart contract implemented in Solidity that manages staff information within an organization. The contract provides functions to add, update, remove, and retrieve staff details, ensuring that only the owner can modify the data. It demonstrates robust data handling with error checks using `require()`, ensures state consistency with `assert()`, and handles exceptional cases with `revert()`.

## Features

- **Add Staff**: Allows the owner to add a new staff member with details like name, age, and position.
- **Remove Staff**: Enables the owner to remove a staff member by their unique ID.
- **Update Staff**: Permits the owner to update details of an existing staff member.
- **Get Staff**: Allows anyone to retrieve the details of a staff member by their ID.
- **Ownership Control**: Includes functionality for restricted access to sensitive actions.

## Contract Details

### State Variables

- **`address public owner`**: Stores the address of the contract owner.
- **`uint public staffCount`**: Tracks the number of staff members added.

### Structs

- **`Staff`**: Represents a staff member with properties for `id`, `name`, `age`, and `position`.

### Mappings

- **`mapping(uint => Staff) public staff`**: Maps a unique ID to a `Staff` struct.

## Constructor

```
constructor() {
    owner = msg.sender;
}
```

## Modifiers
onlyOwner

Restricts access to certain functions to the owner.
```
modifier onlyOwner() {
    require(msg.sender == owner, "Only owner can call this function");
    _;
}
```

## Functions
### addStaff

Allows the owner to add a new staff member to the registry.

#### require() :

- Checks if the name string is not empty. This ensures that every staff member has a name.
- Verifies that the age is greater than 18, enforcing an age policy for staff members.
- Ensures the position string is not empty, confirming that each staff member has a designated role.


```
function addStaff(string memory _name, uint _age, string memory _position) public onlyOwner {
    require(bytes(_name).length > 0, "Name cannot be empty");
    require(_age > 18, "Age must be greater than 18");
    require(bytes(_position).length > 0, "Position cannot be empty");

    staffCount++;
    staff[staffCount] = Staff(staffCount, _name, _age, _position);
    emit StaffAdded(staffCount, _name, _age, _position);
}
```


### removeStaff

Enables the owner to remove a staff member by their ID.

#### require() :

- Confirms that the staff member exists before attempting deletion. This prevents users from attempting to delete a non-existent staff entry.

#### assert:

- Ensures that the staff member's data has indeed been deleted after the operation. It is used here as a safeguard to confirm that the deletion was successful and that no data remains in the mapping for that ID.

```
function removeStaff(uint _id) public onlyOwner {
    Staff memory staffMember = staff[_id];
    require(staffMember.id != 0, "Staff member does not exist");

    emit StaffRemoved(_id, staffMember.name);
    delete staff[_id];
    assert(staff[_id].id == 0);
}
```

### updateStaff

Permits the owner to update details of an existing staff member.


#### require() :

- Confirms that the staff member exists, ensuring the function does not attempt to update a non-existent entry.
- Verifies that the updated name, age, and position are valid, maintaining the integrity of the data.

```
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

```


### getStaff

Allows anyone to retrieve the details of a staff member by their ID.

#### revert:
- Used here to exit the function and revert any changes if the staff member does not exist. Unlike require, which automatically reverts, revert is used explicitly, allowing more complex logic before deciding to revert. This ensures that no details are provided for non-existent staff members.

```
function getStaff(uint _id) public view returns (uint, string memory, uint, string memory) {
    Staff memory staffMember = staff[_id];
    if (staffMember.id == 0) {
        revert("Staff member does not exist");
    }

    return (staffMember.id, staffMember.name, staffMember.age, staffMember.position);
}

```