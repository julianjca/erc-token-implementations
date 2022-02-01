// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.10;

import {DSTestPlus} from "./utils/DSTestPlus.sol";

import {ERC20} from "../ERC20.sol";

contract MockERC20 is ERC20 {
    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {}

    function mint(address to, uint256 value) public virtual {
        _mint(to, value);
    }

    function burn(address from, uint256 value) public virtual {
        _burn(from, value);
    }
}

contract ERC20Test is DSTestPlus {
    MockERC20 token;

    function setUp() public {
        token = new MockERC20("Token", "TKN");
    }

    function test_token_name() public {
        assertEq(token.name(), "Token");
    }

    function test_token_symbol() public {
        assertEq(token.symbol(), "TKN");
    }

    function test_total_supply() public {
        assertEq(token.totalSupply(), 0);
    }

    function test_decimals() public {
        assertEq(token.decimals(), 18);
    }

    function test_mint(address from, uint256 amount) public {
        token.mint(from, amount);

        assertEq(token.totalSupply(), amount);
        assertEq(token.balanceOf(from), amount);
    }

    function test_burn(
        address account,
        uint256 mintAmount,
        uint256 burnAmount
    ) public {
        if (mintAmount < burnAmount) {
            return;
        }

        token.mint(account, mintAmount);
        token.burn(account, burnAmount);

        assertEq(token.totalSupply(), mintAmount - burnAmount);
        assertEq(token.balanceOf(account), mintAmount - burnAmount);
    }
}
