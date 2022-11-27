// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.1;

contract Factory {

    address public computedAddress;

    function getBytecode(address _owner) public pure returns (bytes memory) {
        bytes memory bytecode = type(TestContract).creationCode;

        return abi.encodePacked(bytecode, abi.encode(_owner));
    }


    function getAddress(bytes memory bytecode, uint _salt)
        public
        view
        returns (address)
    {
        bytes32 hash = keccak256(
            abi.encodePacked(bytes1(0xff), address(this), _salt, keccak256(bytecode))
        );

        // NOTE: cast last 20 bytes of hash to address
        return address(uint160(uint(hash)));
    }


    // This is the actul function that gets you the address
    // Returns the address of the newly deployed contract
    // first two functions only used for verification
    function deploy(uint _salt) public {

        TestContract _contract = new TestContract{
            salt:bytes32(_salt)
        }(msg.sender);

        computedAddress = address(_contract);
    }
}

contract TestContract {
    address public owner;

    constructor(address _owner) payable {
        owner = _owner;
    }
}