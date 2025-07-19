// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {MyToken} from "../src/MyToken.sol";

contract MyTokenScript is Script {
    MyToken public _myToken;
    uint256 constant INITIAL_SUPPLY = 10000;
    address public deployer;

    function run() public returns (MyToken) {
        deployer = vm.addr(1);
        vm.startBroadcast(deployer);
        _myToken = new MyToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return _myToken;
    }
}
