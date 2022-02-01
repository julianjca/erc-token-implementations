// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

/// @notice an opinionated ERC721 implementation
/// @title ERC721
/// @author Julian <juliancanderson@gmail.com>
contract ERC721 {
    /*///////////////////////////////////////////////////////////////
                            ERC20 METADATA
    //////////////////////////////////////////////////////////////*/
    string private name;
    string private symbol;
    uint256 private totalSupply;

    /*///////////////////////////////////////////////////////////////
                                MAPPINGS
    //////////////////////////////////////////////////////////////*/
    mapping(address => uint256) private _balanceOf;
    mapping(address => mapping(address => uint256)) private _allowances;

    // https://ethereum.stackexchange.com/questions/8658/what-does-the-indexed-keyword-do
    // The indexed parameters for logged events will
    // allow you to search for these events using the indexed parameters as filters.

    /*///////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    /*///////////////////////////////////////////////////////////////
                            CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balanceOf[account];
    }
}
