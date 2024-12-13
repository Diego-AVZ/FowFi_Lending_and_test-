// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {LendingStorage} from "../../src/Erc721_Lending/LendingStorage.sol";
import {Lib} from "../../src/Erc721_Lending/Lib.sol";

contract LendingStorageTest is Test {

    LendingStorage public lendingStorage;

    function setUp() public {
        lendingStorage = new LendingStorage();
    }

    function test_StoreData() public {
        Lib.Data memory _testParam = Lib.Data(
            0,
            0,
            1000,
            978307200
        );
        lendingStorage.storeData(_testParam, address(0x123));
        Lib.Data[] memory storedData = lendingStorage.getHistory(address(0x123));
        assertEq(storedData[0].action, _testParam.action);
    }
}