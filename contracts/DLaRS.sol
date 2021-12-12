pragma solidity 0.8.1;
// SPDX-License-Identifier: UNLICENSED

contract DLars{

    //Structure for all the land Details
    struct landDetails {
        string city;
        string country;
        string landAddress;
        string pincode;
        address payable currentOwner;
        LandStatus status;
        bool isRegistered;                  // isRegistered is true if a land is already present in the mapping otherwise false
    }

    // enum named "LandStatus" denoting the stage of Auction the land is in
    enum LandStatus {underBidding, registered}

    // mapping storing the land details
    mapping(uint => landDetails) Lands;

    // address of the manager of contract
    address manager;

    // modifier ensuring only manager access
    modifier onlyManager{ 
        require(msg.sender == manager);
        _;
    }

    // modifier ensuring only current land owner access
    modifier onlyOwner(uint landId){
        //Ensuring some features can only be accessed by current owner
        require(msg.sender == Lands[landId].currentOwner);
        _;
    }

    // structure for all the auction details
    struct auction {
        //Auction are identified using their landId
	    address payable highestBidder;
	    uint highestBid;
        uint askingPrice;
        uint minBidInterval;
        uint highestBidTimestamp;
    }   

    // mapping storing the auction details for a land
    mapping(uint => auction) Auction;

    // constructor giving manager access to the deployer of the contract
    constructor() {
        manager = msg.sender;
    }
    
    //This function creates unique landId using its properties
    function computeIdLand(string memory landAddress, string memory city,string memory country, string memory pincode) private pure returns(uint){    
        return uint(keccak256(abi.encodePacked(landAddress, city, country, pincode)))%1000000000;
    }
    //This function registers land on DLaRS and can only be called by manager
    function registerLand(string memory landAddress, string memory city, string memory country, 
    string memory pincode, address payable currentOwner) public onlyManager returns(uint256){
        // Add a new entry in Land mapping with a new id
        // Status of the land will be registered

        uint landID = computeIdLand(landAddress, city, country, pincode);
        require(!Lands[landID].isRegistered);
        Lands[landID].landAddress = landAddress;
        Lands[landID].city = city;
        Lands[landID].country = country;
        Lands[landID].pincode = pincode;
        Lands[landID].currentOwner = currentOwner;
        Lands[landID].status = LandStatus.registered;
        Lands[landID].isRegistered = true;
        return landID;
    }

    //This function allows the current owner to view the current highest bid
    function viewLandDetails(uint landId) public view returns(string memory, string memory, string memory, string memory, LandStatus){
        // accessed by anyone
        // returns all the details of a land
        return (Lands[landId].city, 
                Lands[landId].country,
                Lands[landId].landAddress,
                Lands[landId].pincode,
                Lands[landId].status
                );
    }
    
    //This function puts up the land for auction, can only be called by the current owner    
    function putUpForAuction(uint landId, uint askingPrice, uint minBidInterval) public onlyOwner(landId){
        // Changes land status to underBidding and land is up for auction.
        // Add entry in auction
        require(Lands[landId].status == LandStatus.registered);
        require(minBidInterval > 0);
        Auction[landId].highestBidder = payable(address(0));
        Auction[landId].highestBid = 0;
        Auction[landId].askingPrice = askingPrice;
        Auction[landId].minBidInterval = minBidInterval;
        Auction[landId].highestBidTimestamp = block.timestamp;
        Lands[landId].status = LandStatus.underBidding;
    }

    function deleteFromAuction(uint landId) public onlyOwner(landId){
        // changes land status to registered only if there is no bid yet
        // only accessible by current owner of land
        require(Lands[landId].status == LandStatus.underBidding);
        require(Auction[landId].highestBid == 0);
        Lands[landId].status = LandStatus.registered;
        Auction[landId].askingPrice = 0;
        Auction[landId].minBidInterval = 0;
    }

    function updateAskingPrice(uint landId, uint newAskingPrice, uint newMinBidInterval) public onlyOwner(landId){
        // changes asking price in auction if there has not been a bid yet
        // only accessible by current owner of land
        require(Lands[landId].status == LandStatus.underBidding);
        require(Auction[landId].highestBid == 0);
        require(newMinBidInterval > 0);
        Auction[landId].askingPrice = newAskingPrice;
        Auction[landId].minBidInterval = newMinBidInterval;
    }
    
    function placeBid(uint landId) public payable{
        // params: pass auction Id and 
        // accessible by anyone except the seller
        // check current bid > last bid, pay amount, update highest bid, 
        // check if there was a last bidder, if yes revert amount of last bidder 
       
        uint currentBid = msg.value;
        require(msg.sender!=Lands[landId].currentOwner);
        require(Auction[landId].highestBid + Auction[landId].minBidInterval < currentBid);
        require(Auction[landId].askingPrice<=currentBid);
        require(Lands[landId].status==LandStatus.underBidding);
        if (Auction[landId].highestBid>0){
            Auction[landId].highestBidder.transfer(Auction[landId].highestBid);
        }
        uint toTransfer = currentBid-Auction[landId].highestBid;
        payable(Lands[landId].currentOwner).transfer(toTransfer);
        Auction[landId].highestBidder = payable(msg.sender);
        Auction[landId].highestBid = currentBid;
        Auction[landId].highestBidTimestamp = block.timestamp;

    }

    //This function allows the current owner to view the auction details including highest bid, initial asking price, highest bid's timestamp
    function viewAuctionDetails(uint landId) public view returns(uint,uint,uint){
        // accessed by seller
        // returns highest bid value for the current land
        require(Lands[landId].status == LandStatus.underBidding);
        return (Auction[landId].highestBid,
                Auction[landId].askingPrice,
                Auction[landId].highestBidTimestamp);
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
        require(Auction[landId].highestBid >= Auction[landId].askingPrice);
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