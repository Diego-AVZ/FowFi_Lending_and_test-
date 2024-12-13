//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Lib {

    struct Data {
        uint8 action;
        uint8 token;
        uint256 value;
        uint256 date;
    }

    struct Supplies {
        uint256 ethDeposited;
        uint256 usdcDeposited;
        uint256 wBtcDeposited;
    }

}