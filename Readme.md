# SimpleEtherWallet Smart Contract

## Overview

The `SimpleEtherWallet` is a smart contract implemented in Solidity that allows users to deposit and withdraw Ether. The contract includes functionality for only the owner to withdraw funds and transfer ownership. It demonstrates the use of `require()`, `assert()`, and `revert()` for input validation, error handling, and maintaining critical invariants.

## Features

- **Deposit Ether**: Allows any user to deposit Ether into the contract.
- **Withdraw Ether**: Allows only the owner to withdraw Ether from the contract.
- **Transfer Ownership**: Allows the owner to transfer ownership to a new address.
- **Check Balance**: Allows anyone to check the contract's balance.

## Contract Details

### State Variables

- **`address public owner`**: Stores the address of the contract owner.

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
### deposit

Allows any user to deposit Ether into the contract.

`Uses require() to ensure the deposit amount is greater than zero.
withdraw`
```
function deposit() public payable {
    require(msg.value > 0, "Deposit amount must be greater than zero");
}
```


### withdraw

Allows the owner to withdraw a specified amount of Ether from the contract.

`Uses require() to check if the contract has enough balance.`

`Uses assert() to ensure the contract's balance is correctly updated after the withdrawal.
transferOwnership`

```
function withdraw(uint _amount) public onlyOwner {
    require(address(this).balance >= _amount, "Insufficient contract balance");

    uint initialBalance = address(this).balance;
    payable(owner).transfer(_amount);
    assert(address(this).balance == initialBalance - _amount);
}
```

### transferOwnership

Allows the owner to transfer ownership to a new address.

`Uses revert() to handle the case where the new owner address is zero.
getBalance`

```
function transferOwnership(address newOwner) public onlyOwner {
    if (newOwner == address(0)) {
        revert("New owner address cannot be zero");
    }
    owner = newOwner;
}
```


### getBalance

Allows anyone to check the contract's balance.
```
function getBalance() public view returns (uint) {
    return address(this).balance;
}
```