//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {INonfungiblePositionManager} from "../../lib/v3-periphery/contracts/interfaces/INonfungiblePositionManager.sol";
import "./Lib.sol";

contract LendingStorage {
    
    /*
    * 
    *          1. Despositos de liquidez USDC, ETH, BTC           -- LEND
    *          2. Depositos de colateral en ERC721 liqPositions   -- COLLATERAL
    *          3. Retiros de liquidez USDC, ETH, BTC              -- BORROW
    *
    *
    *          Contratos
    *               1. MAIN para frontEnd
    *               2. LIQUIDITY Reserve (LENDS and BORROWs)
    *               3. LP erc721 Reserve (COLLATERALS)
    *               4. Executor
    *               5. STORAGE Data
    *               6. Maths
    * ✔
    */

    error InsufficientSupply(uint8 token, uint256 available, uint256 requested);
    error InvalidTokenType(uint8 token);

    mapping(address => Lib.Data[]) internal history;
    mapping(address => Lib.Supplies) internal supplies;

    function storeData(
            Lib.Data calldata _data,
            address _sender
        ) external {
           
            history[_sender].push(_data);
            
            if(_data.action == 0) {
                addSupply(_sender, _data.token, _data.value);
            } else if(_data.action == 1) {
                reduceSupply(_sender, _data.token, _data.value);
            }

    }

    function getHistory(address _addr) external view returns (Lib.Data[] memory) {
        return history[_addr];
    }

    function addSupply(
            address _sender, 
            uint8 _token, 
            uint256 _value
        ) internal {
            Lib.Supplies storage senderSupplies = supplies[_sender];
            if(_token == 0){
                senderSupplies.ethDeposited += _value;
            } else if(_token == 1){
                senderSupplies.usdcDeposited += _value;
            } else if(_token == 2){
                senderSupplies.wBtcDeposited += _value;
            }
    }

    function reduceSupply(
            address _sender, 
            uint8 _token, 
            uint256 _value
        ) internal {
            Lib.Supplies storage senderSupplies = supplies[_sender];
            if(_token == 0){
                if(senderSupplies.ethDeposited < _value) 
                    revert InsufficientSupply(0, senderSupplies.ethDeposited, _value);
                senderSupplies.ethDeposited -= _value;
            } else if(_token == 1){
                if(senderSupplies.usdcDeposited < _value) 
                    revert InsufficientSupply(1, senderSupplies.usdcDeposited, _value);
                senderSupplies.usdcDeposited -= _value;
            } else if(_token == 2){
                if(senderSupplies.wBtcDeposited < _value) 
                    revert InsufficientSupply(2, senderSupplies.wBtcDeposited, _value);
                senderSupplies.wBtcDeposited -= _value;
            } else {
                revert InvalidTokenType(_token);
            }
    }

}