//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {INonfungiblePositionManager} from "../../lib/v3-periphery/contracts/interfaces/INonfungiblePositionManager.sol";
import {IERC20} from "../../lib/openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Lib.sol";
import "./LendingStorage.sol";
import "./LiquidityReserve.sol";

contract uniswapLPLendingExecutor {

    error TransferFailed();
    error TokenTransferFailed();
    error InvalidValue();

    IERC20 internal usdc;
    IERC20 internal wBtc;
    LendingStorage internal data;
    LiquidityReserve internal liquidityReserve;

    function lend(
            uint8 _token,
            uint256 _value,
            address _sender
        ) public payable {
            IERC20 token;
            if(_token == 0){ 
                // native ETH
                if(msg.value != _value) revert InvalidValue(); 
                (bool success,) = payable(address(liquidityReserve)).call{ value : msg.value }("");
                if(!success) revert TransferFailed();
            } else if(_token == 1) {
                // USDC
                token = usdc;
            } else if(_token == 2) {
                // wBTC
                token = wBtc;
            }
            bool tokenTransferResult = token.transferFrom(_sender, address(liquidityReserve), _value);
            if(!tokenTransferResult) revert TokenTransferFailed();    
            storeData(
                0,
                _token,
                _value,
                _sender
            );
    }

    function withdraw(
            uint8 _token,
            uint256 _value,
            address _sender
        ) public {
            address token;
            storeData(
                1,
                _token,
                _value,
                _sender
            );
            if(_token == 0){ 
                // native ETH
                liquidityReserve.withdrawEth(_sender, _value);
            } else if(_token == 1) {
                // USDC
                token = address(usdc);
            } else if(_token == 2) {
                // wBTC
                token = address(wBtc);
            }
            bool tokenTransferResult = liquidityReserve.withdrawTokens(token, _sender, _value);
            if(!tokenTransferResult) revert TokenTransferFailed();    
    }

    function storeData(
            uint8 _action,
            uint8 _token,
            uint256 _value,
            address _sender
        ) internal {
            Lib.Data memory newData = Lib.Data(
                _action,
                _token,
                _value,
                block.timestamp
            );
            
            data.storeData(newData, _sender);
    }

}