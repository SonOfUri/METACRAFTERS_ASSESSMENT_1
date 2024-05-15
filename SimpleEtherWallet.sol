// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleEtherWallet {
    address public owner;

    // Constructor to set the contract deployer as the owner
    constructor() {
        owner = msg.sender;
    }

    // Modifier to restrict access to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    // Function to deposit Ether into the contract
    function deposit() public payable {
        // Using require to check for a valid deposit amount
        require(msg.value > 0, "Deposit amount must be greater than zero");
    }

    // Function to withdraw Ether from the contract
    function withdraw(uint _amount) public onlyOwner {
        // Using require to check if the contract has enough balance
        require(address(this).balance >= _amount, "Insufficient contract balance");

        // Using assert to ensure a critical invariant before and after the function call
        uint initialBalance = address(this).balance;
        payable(owner).transfer(_amount);
        assert(address(this).balance == initialBalance - _amount);
    }

    // Function to transfer ownership to a new owner
    function transferOwnership(address newOwner) public onlyOwner {
        // Using revert to handle invalid new owner address
        if (newOwner == address(0)) {
            revert("New owner address cannot be zero");
        }
        owner = newOwner;
    }

    // Function to check the contract balance
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
