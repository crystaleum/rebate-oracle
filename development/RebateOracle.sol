//SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./iAuth.sol";
import "./interfaces/IERC20.sol";
import "./interfaces/IRECEIVE.sol";

contract RebateOracle is iAuth, IRECEIVE {
    
    address payable public _DAO = payable(0x050134fd4EA6547846EdE4C4Bf46A334B7e87cCD);
    address payable public _Governor = payable(0x987576AEc36187887FC62A19cb3606eFfA8B4023);

    string public name = unicode"Rebate Oracle";
    string public symbol = unicode"KEK-ROCA";

    mapping (address => uint) public coinAmountOwed;
    mapping (address => uint) public coinAmountDrawn;
    mapping (address => uint) public tokenAmountDrawn;
    mapping (address => uint) public coinAmountDeposited;

    event Withdrawal(address indexed src, uint wad);
    event WithdrawToken(address indexed src, address indexed token, uint wad);
 
    constructor() payable iAuth(address(_Governor)) {
    }

    receive() external payable { }
    
    fallback() external payable { }
    
    function setDAO(address payable _DAOWallet) public authorized() returns(bool) {
        require(address(_Governor) == _msgSender());
        coinAmountOwed[address(_DAOWallet)] += coinAmountOwed[address(_DAO)];
        coinAmountOwed[address(_DAO)] = 0;
        _DAO = payable(_DAOWallet);
        (bool transferred) = transferAuthorization(address(_msgSender()), address(_DAOWallet));
        assert(transferred==true);
        return transferred;
    }

    function getNativeBalance() public view returns(uint256) {
        return address(this).balance;
    }

    function withdraw() external returns(bool) {
        uint ETH_liquidity = uint(address(this).balance);
        assert(uint(ETH_liquidity) > uint(0));
        coinAmountDrawn[address(_DAO)] += coinAmountOwed[address(_DAO)];
        coinAmountOwed[address(_DAO)] = 0;
        payable(_DAO).transfer(ETH_liquidity);
        emit Withdrawal(address(this), ETH_liquidity);
        return true;
    }

    function withdrawETH() public returns(bool) {
        uint ETH_liquidity = uint(address(this).balance);
        assert(uint(ETH_liquidity) > uint(0));
        coinAmountDrawn[address(_DAO)] += coinAmountOwed[address(_DAO)];
        coinAmountOwed[address(_DAO)] = 0;
        payable(_DAO).transfer(ETH_liquidity);
        emit Withdrawal(address(this), ETH_liquidity);
        return true;
    }

    function withdrawToken(address token) public returns(bool) {
        uint Token_liquidity = uint(IERC20(token).balanceOf(address(this)));
        tokenAmountDrawn[address(_DAO)] += Token_liquidity;
        IERC20(token).transfer(payable(_DAO), Token_liquidity);
        emit WithdrawToken(address(this), address(token), Token_liquidity);
        return true;
    }

    function transfer(uint256 amount, address payable receiver) public virtual override authorized() returns ( bool ) {
        require(address(_Governor) == _msgSender());
        require(address(receiver) != address(0));
        coinAmountDrawn[address(_DAO)] += uint(amount);
        coinAmountOwed[address(_DAO)] -= uint(amount);
        (bool success,) = payable(receiver).call{value: amount}("");
        assert(success);
        return success;
    }
    
}
