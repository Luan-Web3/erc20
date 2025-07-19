// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {MyTokenScript} from "../script/MyToken.s.sol";
import {MyToken} from "../src/MyToken.sol";

contract MyTokenTest is Test {
    MyTokenScript public _deployer;
    MyToken public _myToken;
    address john;
    address alice;
    uint256 constant INITIAL_BALANCE_JOHN = 2000;

    function setUp() public {
        _deployer = new MyTokenScript();
        _myToken = _deployer.run();

        john = makeAddr("john");
        alice = makeAddr("alice");

        vm.prank(_deployer.deployer());
        _myToken.transfer(john, INITIAL_BALANCE_JOHN);
    }

    function testTokenName() public view {
        assertEq(_myToken.name(), "MyToken");
    }

    function testTokenSymbol() public view {
        assertEq(_myToken.symbol(), "MTK");
    }

    function testTokenDecimals() public view {
        assertEq(uint256(_myToken.decimals()), 18);
    }

    function testTransferSuccess() public {
        uint256 amount = 500;
        vm.prank(john);
        _myToken.transfer(alice, amount);

        assertEq(_myToken.balanceOf(alice), amount);
        assertEq(_myToken.balanceOf(john), INITIAL_BALANCE_JOHN - amount);
    }

    function testTransferFailsWhenInsufficientBalance() public {
        vm.prank(alice);
        vm.expectRevert();
        _myToken.transfer(john, 1);
    }

    function testApproveAndTransferFromSuccess() public {
        uint256 amount = 1000;

        vm.prank(john);
        _myToken.approve(alice, amount);

        vm.prank(alice);
        _myToken.transferFrom(john, alice, amount);

        assertEq(_myToken.balanceOf(alice), amount);
        assertEq(_myToken.balanceOf(john), INITIAL_BALANCE_JOHN - amount);
        assertEq(_myToken.allowance(john, alice), 0);
    }

    function testTransferFromFailsWithoutApproval() public {
        vm.prank(alice);
        vm.expectRevert();
        _myToken.transferFrom(john, alice, 1_000);
    }

    function testTransferFromFailsWhenOverAllowance() public {
        vm.prank(john);
        _myToken.approve(alice, 500);

        vm.prank(alice);
        vm.expectRevert();
        _myToken.transferFrom(john, alice, 1000);
    }

    function testTransferFromFailsWhenJohnHasNoBalance() public {
        vm.prank(john);
        _myToken.approve(alice, INITIAL_BALANCE_JOHN + 1);

        vm.prank(alice);
        vm.expectRevert();
        _myToken.transferFrom(john, alice, INITIAL_BALANCE_JOHN + 1);
    }
}
