pragma solidity 0.8.1;
// SPDX-License-Identifier: UNLICENSED


contract DLars{

    //Structure for all the land Details
    struct landDetails {
        string city;
        string country;
        string landAdress;
        string pincode;
        address payable currentOwner;
        uint askingPrice;
        LandStatus status;
        bool isRegistered;
    }
    enum LandStatus {underBidding, registered}
    mapping(uint => landDetails) Lands;
    address manager;
    modifier onlyManager{ 
        //Ensuring only manager can add new Land
        require(msg.sender == manager);
        _;
    }
    modifier onlyOwner(uint landId){
        //Ensuring some features can only be accessed by current owner
        require(msg.sender == Lands[landId].currentOwner);
        _;
    }
    mapping(uint => auction) Auction;
    struct auction {
        //Auction are identified using their landId
	    address payable highestBidder;
	    uint highestBid;
        uint highestBidTimestamp;
    }   
    constructor() public{
        manager = msg.sender;
    }
    
    //This function creates unique landId using its properties
    function computeIdLand(string memory landAddress, string memory city,string memory pincode) private pure returns(uint){    
        return uint(keccak256(abi.encodePacked(landAddress, city, pincode)))%1000000000;
    }
    //This function registers land on DLaRS and can only be called by manager
    function registerLand(string memory landAddress, string memory city, string memory country, 
    string memory pincode, address payable currentOwner) public onlyManager returns(uint256){
        // Add a new entry in Land mapping with a new id
        // Status of the land will be registered

        uint landID = computeIdLand(landAddress, city, pincode);
        require(!Lands[landID].isRegistered);
        Lands[landID].city = city;
        Lands[landID].country = country;
        Lands[landID].pincode = pincode;
        Lands[landID].currentOwner = currentOwner;
        Lands[landID].status = LandStatus.registered;
        Lands[landID].isRegistered = true;
        return landID;
    }
    //This function puts up the land for auction, can only be called by the current owner    
    function putUpForAuction(uint landId, uint askingPrice) public onlyOwner(landId){
        // Changes land status to underBidding and land is up for auction.
        // Add entry in auction
        require(Lands[landId].status == LandStatus.registered);
        Auction[landId].highestBidder = payable(address(0));
        Auction[landId].highestBid = 0;
        Lands[landId].askingPrice = askingPrice;
        Auction[landId].highestBidTimestamp = block.timestamp;
        Lands[landId].status = LandStatus.underBidding;
    }

    function deleteFromAuction(uint landId) public onlyOwner(landId){
        // changes land status to registered only if there is no bid yet
        // only accessible by current owner of land
        require(Lands[landId].status == LandStatus.underBidding);
        require(Auction[landId].highestBid == 0);
        Lands[landId].status = LandStatus.registered;
        Lands[landId].askingPrice = 0;
    }

    function updateAskingPrice(uint landId, uint newAskingPrice) public onlyOwner(landId){
        // changes asking price in auction if there has not been a bid yet
        // only accessible by current owner of land
        require(Lands[landId].status == LandStatus.underBidding);
        require(Auction[landId].highestBid == 0);
        Lands[landId].askingPrice = newAskingPrice;
    }
    // function placeBid(address payable _receiver1, address payable _receiver2, uint256 amount) public payable {
    //     //PaymentReceived[_landId] = true;
    //     //payable(Lands[landId].currentOwner).transfer(currentBid-Auction[landId].highestBid);
    //     //uint amntToRed = msg.value-5000000000000000000;
    //     //_receiver1.transfer(amntToRed);
    //     //_receiver2.transfer(4000000000000000000);
    // }

    // function receiveBid() public payable{
    //     require(msg.value>0);
    // }

    // function withdraw(uint amnt) public{
    //     msg.sender.transfer(amnt);
    // }
    
    function placeBid(uint landId) public payable{
        //TO BE DONE
        uint currentBid = msg.value;
        require(msg.sender!=Lands[landId].currentOwner);
        require(Auction[landId].highestBid<currentBid);
        require(Lands[landId].askingPrice<=currentBid);
        require(Lands[landId].status==LandStatus.underBidding);
        if (Auction[landId].highestBid>0){
            Auction[landId].highestBidder.transfer(Auction[landId].highestBid);
        }
        uint toTransfer = currentBid-Auction[landId].highestBid;
        payable(Lands[landId].currentOwner).transfer(toTransfer);
        Auction[landId].highestBidder = payable(msg.sender);
        Auction[landId].highestBid = currentBid;
        Auction[landId].highestBidTimestamp = block.timestamp;
        // accessible by bidders only
        // params: pass auction Id and 
        // check current bid > last bid, pay amount, update highest bid, 
        // check if there was a last bidder, if yes revert amount of last bidder    

    }

    //This function allows the current owner to view the current highest bid
    function viewHighestBid(uint landId) public view returns(uint){
        // accessed by seller
        // returns highest bid value for the current land
        require(Lands[landId].status == LandStatus.underBidding);
        return Auction[landId].highestBid;
    }

    function terminateAuction(uint landId) public {
        //TO BE DONE
        require(Auction[landId].highestBidder == msg.sender);
        require((Auction[landId].highestBidTimestamp+2592000) < block.timestamp);
        require(Lands[landId].status == LandStatus.underBidding);
        Lands[landId].currentOwner = payable(msg.sender);
        Lands[landId].status = LandStatus.registered;
        // accessed by highest bidder, accessible only after 30 days of auction start 
        // change status of land to sold, change owner address, pay money to previous owner
        
    }

    //This function allows the current owner to approve the highest bid and proceed with the transaction
    function acceptHighestBid(uint landId) public onlyOwner(landId){
        // prompts auction contract to stop bidding and complete transaction 
        // (auction will take care of guarantee that money will be transferred)
        // Will internally call the transfer ownership function        
        require(Lands[landId].status == LandStatus.underBidding);
        require(Auction[landId].highestBid >= Lands[landId].askingPrice);
        transferOwnership(landId, Auction[landId].highestBidder);  
        Lands[landId].status = LandStatus.registered;     
    }

    //This function transfers the ownership from current owner to the new owner
    function transferOwnership(uint landId, address payable newOwnerId) private onlyOwner(landId){
        // change owner and remove from auction 
        // change land status to sold
        require(Lands[landId].currentOwner != newOwnerId);
        Lands[landId].currentOwner = newOwnerId;
    }
}
