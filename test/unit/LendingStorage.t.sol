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

    function test_StoreDataDeposit() public {
        Lib.Data memory _testParam = Lib.Data(
            0,
            0,
            1000,
            978307200
        );
        lendingStorage.storeData(_testParam, address(0x123));
        Lib.Data[] memory storedData = lendingStorage.getHistory(address(0x123));
        assertEq(storedData[0].action, _testParam.action);
        assertEq(storedData[0].token, _testParam.token);
        assertEq(storedData[0].value, _testParam.value);
        assertEq(storedData[0].date, _testParam.date);
    }
    
    function test_StoreDataWithdraw() public {
        Lib.Data memory _testParam1 = Lib.Data(
            0,
            0,
            0,
            978307200
        );
        lendingStorage.storeData(_testParam1, address(0x123));
        Lib.Data memory _testParam = Lib.Data(
            1, 
            0, 
            1000, 
            978307210 
        );
        //Lib.Supplies memory supplies = lendingStorage.getSupplies(address(0x123));
        vm.expectRevert(
            abi.encodeWithSelector(
                LendingStorage.InsufficientSupply.selector,
                0,
                0,
                1000
            )
        );
        lendingStorage.storeData(_testParam, address(0x123));
        //Lib.Supplies memory supplies2 = lendingStorage.getSupplies(address(0x123));
        //assertEq(supplies2.ethDeposited, 100);
    }

    function testFuzz_StoreData2() public {
        uint8 _a = 1;
        Lib.Data memory _testParam = Lib.Data(
            _a,
            1,
            12345,
            159
        );
        if(_a == 0){
            lendingStorage.storeData(_testParam, address(0x123));
            Lib.Data[] memory storedData = lendingStorage.getHistory(address(0x123));
            assertEq(storedData[0].action, _testParam.action);
            assertEq(storedData[0].token, _testParam.token);
            assertEq(storedData[0].value, _testParam.value);
            assertEq(storedData[0].date, _testParam.date);
        } else if(_a == 1){
            console.log("action = ", _a);
            vm.expectRevert(
                abi.encodeWithSelector(
                    LendingStorage.InsufficientSupply.selector,
                    1,
                    0,
                    12345
                )
            );
            lendingStorage.storeData(_testParam, address(0x123));
        } else{

        }
    }

    function testFuzz_StoreData3() public { // SAME AS "2", git testing
        uint8 _a = 1;
        Lib.Data memory _testParam = Lib.Data(
            _a,
            1,
            12345,
            159
        );
        if(_a == 0){
            lendingStorage.storeData(_testParam, address(0x123));
            Lib.Data[] memory storedData = lendingStorage.getHistory(address(0x123));
            assertEq(storedData[0].action, _testParam.action);
            assertEq(storedData[0].token, _testParam.token);
            assertEq(storedData[0].value, _testParam.value);
            assertEq(storedData[0].date, _testParam.date);
        } else if(_a == 1){
            console.log("action = ", _a);
            vm.expectRevert(
                abi.encodeWithSelector(
                    LendingStorage.InsufficientSupply.selector,
                    1,
                    0,
                    12345
                )
            );
            lendingStorage.storeData(_testParam, address(0x123));
        } else{

        }
    }
}