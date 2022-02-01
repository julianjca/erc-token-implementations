// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

contract ERC20 {
    string private _name;
    string private _symbol;
    uint256 private _totalSupply;
    uint8 private _decimals = 18;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    // https://ethereum.stackexchange.com/questions/8658/what-does-the-indexed-keyword-do
    // The indexed parameters for logged events will allow you to search for these events using the indexed parameters as filters.

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "Sender is empty address");
        require(recipient != address(0), "Recipient is empty address");

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "Amount exceed sender balance");

        _balances[recipient] += amount;
        _balances[sender] = senderBalance - amount;

        emit Transfer(sender, recipient, amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "Sender is empty address");
        require(spender != address(0), "Recipient is empty address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 allowance = _allowances[sender][recipient];
        require(allowance >= amount, "Allowance is lower than amount transfered");

        _approve(sender, recipient, allowance - amount);

        emit Transfer(sender, recipient, amount);
        return true;
    }

    // internal functions
    function _mint(address to, uint256 amount) internal virtual {
        _totalSupply += amount;
        _balances[to] += amount;
        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal virtual {
        _totalSupply -= amount;
        _balances[from] -= amount;
        emit Transfer(from, address(0), amount);
    }
}
