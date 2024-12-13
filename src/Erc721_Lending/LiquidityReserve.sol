//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from "../../lib/openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LiquidityReserve {

    error TransferFailed(); 
    error TokenTransferFailed();

    function withdrawEth(address _recipient, uint256 _value) external { // ONLY_EXECUTOR
        (bool success,) = payable(_recipient).call{ value : _value }("");
        if(!success) revert TransferFailed();
    } 

    function withdrawTokens( address _token, address _recipient, uint256 _value ) external returns(bool) { // ONLY_EXECUTOR
        bool tokenTransferResult = IERC20(_token).transfer(_recipient, _value);
        if(!tokenTransferResult) revert TokenTransferFailed();
        return tokenTransferResult;
    }

    receive() external payable {}

}