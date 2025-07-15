// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {MyToken} from "../src/MyToken.sol";

contract MyTokenScript is Script {
    MyToken public _myToken;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        _myToken = new MyToken(10000);

        vm.stopBroadcast();
    }
}
