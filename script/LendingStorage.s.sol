// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {LendingStorage} from "../src/Erc721_Lending/LendingStorage.sol";


contract Deploy is Script {
    function run() external {
        vm.startBroadcast();
        LendingStorage lendingStorage = new LendingStorage();
        console.log("Contract Address => ", address(lendingStorage));
        vm.stopBroadcast();
    }
}