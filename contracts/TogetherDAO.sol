// SPDX-License-Identifier:UNLICENSED
// solhint-disable-next-line
pragma solidity ^0.8.0;
import { IERC20 } from "./interface/IERC20.sol";
import { SafeMath } from "./interface/SafeMath.sol";

contract TogethDAO{
    using SafeMath for uint256;
    uint256 internal constant CONST_SQRTNUMBER = 18446744073709551616;
   
    uint256 internal constant CONST_PROPORTION = 10e4;
    uint256 internal constant MIN_FEE = 500;  //手续费的下限

    address payable public  owner;
    uint256 public currentIndex;  
    mapping (uint256 => Proposal) public proposalList;   //提案集合
    mapping (uint256 => address[]) public investorList;  //投资人地址集合
    uint256[]  public proportionList;     
    
    // IERC20 public acceptToken;
    struct Proposal{    
        address creator;
        address asset;
        uint256 createAt;
        address token;            //募资token        
        uint256 preAmount;        //需要募集金额  
        uint256 raisedAmount;     //已经募集金额  
        mapping (address => uint256) investor;  // 投资人及金额·列表  
        mapping (address => uint256) income;  // 投资人及金额·列表    
        uint256 foundraisingDDL;   //天   募资截止时间（上限？） 
        uint256 purchaseDDL;       //天   购买NFT截止时间     
        bool    state;            // 进行状态  true:进行中; false:结束
        
    }    
   
    // event Sent(address from, address to, uint amount);
    event Log(uint256,uint256);

      event CreateProposal(
        uint256 index,  
        address creator,
        address asset,
        address token,
        uint256 tokenAmount,
        uint256 secondsToTimeoutFoundraising,      
        uint256 secondsToTimeoutBuy,
        uint256 secondsToTimeoutSell   
    );
       event Contributed(
        uint256 proposal,
        address contributor,    
        address token,   
        uint256 amount           
    );
    event Expired(address triggeredBy);
 
    event Sell(
        address sender,
        uint256 index,
        address asset,        
        address token,
        uint256 amount
    );

    event Bought(
        address sender,
        uint256 index,
        address asset,        
        address token,
        uint256 amount
    );

    event Cancle(
        address triggeredBy,
        address targetAddress,   
        uint256 tokenid,     
        address propsal
    );
    event Claimed(
        address proposal,
        address indexed contributor,
        IERC20 token,
        uint256 tokenAmount
    );
    constructor() {
       owner = payable(msg.sender) ;
       currentIndex =0;   
    }

    function createProposal(address _asset, address _token,uint256 _amount,uint256 _foundraisingDDL,uint256 _purchaseDDL) public {       
        //募资截止时间一定小于购买NFT截止时间
        require(_foundraisingDDL < _purchaseDDL,"Invalid parameter");
        require(_amount < 1e60,"Invalid parameter");
        currentIndex++;     
        Proposal storage proposal = proposalList[currentIndex];        
        require(proposal.createAt == 0,"Proposal existed");
        //创建提案
        proposal.creator = msg.sender;
        proposal.asset = _asset;
        proposal.token = _token;
        proposal.preAmount = _amount;
        proposal.createAt = block.timestamp;
        proposal.foundraisingDDL = _foundraisingDDL;
        proposal.purchaseDDL = _purchaseDDL; 
        proposal.state = true ;

           emit CreateProposal(
            currentIndex,
            msg.sender,
            _asset,         
            _token,
            _amount,
            block.timestamp,
            _foundraisingDDL,
            _purchaseDDL         
        );

    }
     
    function invest(uint256 _index, uint256 _amount) external {
        Proposal storage proposal = proposalList[_index];
        //判断募资是否结束        
       
        uint256 ddl =proposal.foundraisingDDL.mul(24*3600);       
        require(proposal.createAt.add(ddl) > block.timestamp,"Expired") ; 
        //  uint256 c1 = proposal.preAmount.sub(proposal.raisedAmount);
        //投资金额不能超过募资金额       
        // require(c1 >= _amount,"Invalid parameter"); 
        //将资金转到合约账户  
            
        // require(IERC20(proposal.token).transfer(address(this),_amount),"Transfer failed");      
      
        proposal.raisedAmount =(proposal.raisedAmount).add(_amount);
         
        if(proposal.investor[msg.sender]==0){
            //投资人对同一个提案首次投资          
            investorList[_index].push(msg.sender);
        }
        //
        proposal.investor[msg.sender] = (proposal.investor[msg.sender]).add(_amount);

        emit Contributed(_index,msg.sender,proposal.token,_amount);
      
    }

      function buy(uint256 _index, uint256 _amount) external {
        Proposal storage proposal = proposalList[_index];
        //判断募资是否结束        
       
        uint256 ddl =proposal.foundraisingDDL.mul(24*3600);       
        require(proposal.createAt.add(ddl) > block.timestamp,"Expired") ; 
        //  uint256 c1 = proposal.preAmount.sub(proposal.raisedAmount);
        //投资金额不能超过募资金额       
        // require(c1 >= _amount,"Invalid parameter"); 
        //将资金转到合约账户  
            
        // require(IERC20(proposal.token).transfer(address(this),_amount),"Transfer failed");      
      
        proposal.raisedAmount =(proposal.raisedAmount).add(_amount);
         
        if(proposal.investor[msg.sender]==0){
            //投资人对同一个提案首次投资          
            investorList[_index].push(msg.sender);
        }
        //
        proposal.investor[msg.sender] = (proposal.investor[msg.sender]).add(_amount);
       emit Bought(msg.sender, _index,proposal.asset, proposal.token, _amount);
      
    }

     function sell(uint256 _index, uint256 _amount) external {
        Proposal storage proposal = proposalList[_index];
        //判断募资是否结束        
       
        uint256 ddl =proposal.foundraisingDDL.mul(24*3600);       
        require(proposal.createAt.add(ddl) > block.timestamp,"Expired") ; 
        //  uint256 c1 = proposal.preAmount.sub(proposal.raisedAmount);
        //投资金额不能超过募资金额       
        // require(c1 >= _amount,"Invalid parameter"); 
        //将资金转到合约账户  
            
        // require(IERC20(proposal.token).transfer(address(this),_amount),"Transfer failed");      
      
        proposal.raisedAmount =(proposal.raisedAmount).add(_amount);
         
        if(proposal.investor[msg.sender]==0){
            //投资人对同一个提案首次投资          
            investorList[_index].push(msg.sender);
        }
        //
        proposal.investor[msg.sender] = (proposal.investor[msg.sender]).add(_amount);
        emit Sell(msg.sender, _index,proposal.asset, proposal.token, _amount);
      
    }

     //返还收益和所消耗的手续费，提案完成
    function returnIncome(uint256 _index,uint256 _amount,uint256 _totalfee) external {
       require(owner==msg.sender,"No authorization");
      
       Proposal storage proposal = proposalList[_index];
       address[] memory investors = investorList[_index];
       uint256 number = _amount.add(_totalfee);
       for(uint256 i=0; i < investors.length; i++){
         //计算手续费
         address investor = investors[i];   
         uint256 proportion = feeProportion(_index, investor);
         uint256 fee =proportion.mul(_totalfee).div(CONST_PROPORTION); 
         //设置手续费的下限
         if (fee < MIN_FEE){
             fee = MIN_FEE;
         } 

         uint256 income = number.mul(investProportion(_index,investor)).sub(fee);   
         
         //平摊手续费          
         require(IERC20(proposal.token).transfer(investor,income),"ReturnIncome failed"); 
         proposal.income[investor] = income;
       }
       proposal.state = false;
    }

    //领取
    function claim(uint256 _index) external {  
        //TODO 扣除平台收益   
       Proposal storage proposal = proposalList[_index];    
       uint256  amount = proposal.income[msg.sender];      
       require(amount>0,"No income");
       require(IERC20(proposal.token).transferFrom(address(this),msg.sender,amount),"Claim failed");  
    }


     //计算投资占比 * 10e4
    function investProportion (uint256 _index,address investor) internal view returns (uint256 _proportion){     
        Proposal storage proposal = proposalList[_index];           
        _proportion =proposal.investor[investor].mul(CONST_PROPORTION).div( proposal.raisedAmount)  ;     
       return  _proportion;
    }

    //计算手续费比例 * 10e4
     function feeProportion (uint256 _index,address _investor) internal  returns (uint256 _proportion){ 
       address[] memory investors = investorList[_index];       
       for(uint256 i=0; i < investors.length; i++){
          uint256 number = investProportion(_index,investors[i]).mul(CONST_SQRTNUMBER).sqrt();  
         
          proportionList.push(number);
       }       
       uint256 sum = SafeMath.sum(proportionList);        
       uint256 amount = investProportion(_index,_investor).mul(CONST_SQRTNUMBER).sqrt();
       _proportion = amount.mul(CONST_PROPORTION).div(sum);

       return  _proportion;
    }

}