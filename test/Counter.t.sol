// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;
    address public owner;
    address public nonOwner = address(0x123);

    function setUp() public {
        counter = new Counter();
        owner = counter.owner();
        counter.setNumber(0);
    }

    function test_Increment() public {
        counter.increment();
        console.log("My number is now:", counter.number());
        assertEq(counter.number(), 1);
    }

    function test_SetNumberOwner(uint256 y) public {
        vm.expectRevert("onlyOwner func");
        vm.prank(nonOwner);
        counter.setNumberOwner(y);

        vm.prank(owner);
        counter.setNumberOwner(y);
        assertEq(counter.number(), y);
    }

    function testFuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }
}
