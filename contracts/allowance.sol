
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

pragma solidity ^0.8.1;

contract Allowance is Ownable {
    using SafeMath for uint;
    
    mapping(address => uint) public allowanceAmount;
    
     event increasedAllowance (address _party, uint _increasedBy);
     event contractReceivedEth (address _from, uint _amount);
     event moneyWithdrawn (address _to, uint _amount);
     
     modifier checkAllowance () {
         require(allowanceAmount[msg.sender] >= msg.value, "Youre trying to spend more money than in your allowance");
         _;
     }
     
     receive () external payable {
        emit contractReceivedEth(msg.sender, msg.value);
    }  
    
    function getContractBalance() public view returns (uint) {
        return address(this).balance; 
    }
    
   function setAllowance(address _user, uint _increaseAmount) public onlyOwner  {
        
        allowanceAmount[_user] = allowanceAmount[_user].add(_increaseAmount);
        
        emit increasedAllowance(_user, _increaseAmount);
   }
   
   function withdrawMoney(address payable _to, uint _amount) public payable checkAllowance {
       allowanceAmount[msg.sender] = allowanceAmount[msg.sender].sub(_amount);
       _to.transfer(_amount);
       emit moneyWithdrawn(_to, _amount);
   }
   
}
