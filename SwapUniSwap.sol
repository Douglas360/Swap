// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.7.6;
pragma abicoder v2;

import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract SingleSwap {
    address public  immutable routerAddress;
    ISwapRouter public immutable swapRouter;
    address public owner;
       
    address public immutable LINK;
    address public immutable WETH;

    //address public constant LINK = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB;
    //address public constant WETH = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;

    //IERC20 public linkToken = IERC20(LINK);

    // For this example, we will set the pool fee to 0.3%.
    uint24 public constant poolFee = 3000;

    constructor(address _routerAddress) {
        routerAddress = _routerAddress;
        swapRouter = ISwapRouter(_routerAddress);
        owner = msg.sender;
    }

    function swapExactInputSingle(uint256 amountIn, address _tokenIn, address _tokenOut)
        external
        returns (uint256 amountOut)
    {
        IERC20 linkTokenIn = IERC20(_tokenIn);
        //IERC20 linkTokenOut = IERC20(_tokenOut);
        linkTokenIn.approve(address(swapRouter), amountIn);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: _tokenIn,
                tokenOut: _tokenOut,
                fee: poolFee,
                //recipient: address(this),
                recipient : owner,
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

        amountOut = swapRouter.exactInputSingle(params);
    }   
}
