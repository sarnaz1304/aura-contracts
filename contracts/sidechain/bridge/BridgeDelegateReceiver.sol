// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import { Ownable } from "@openzeppelin/contracts-0.8/access/Ownable.sol";
import { IERC20 } from "@openzeppelin/contracts-0.8/token/ERC20/IERC20.sol";
import { IL1Coordinator } from "../interfaces/IL1Coordinator.sol";

/**
 * @title BridgeDelegateReceiver
 * @dev Receive bridged tokens from the L2 on L1
 */
contract BridgeDelegateReceiver is Ownable {
    address public immutable l1Coordinator;

    uint16 public immutable srcChainId;

    event SettleFeeDebt(uint256 amount);

    constructor(address _l1Coordinator, uint16 _srcChainId) {
        l1Coordinator = _l1Coordinator;
        srcChainId = _srcChainId;

        address debtToken = IL1Coordinator(_l1Coordinator).balToken();
        IERC20(debtToken).approve(_l1Coordinator, type(uint256).max);
    }

    function settleFeeDebt(uint256 _amount) external onlyOwner {
        IL1Coordinator(l1Coordinator).settleFeeDebt(srcChainId, _amount);

        emit SettleFeeDebt(_amount);
    }
}
