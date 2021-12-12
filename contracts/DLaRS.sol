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
    
    //This function creates a unique landId using its properties
    function computeIdLand(string memory landAddress, string memory city,string memory country, string memory pincode) private pure returns(uint){    
        return uint(keccak256(abi.encodePacked(landAddress, city, country, pincode)))%1000000000;
    }

    //This function registers land on DLaRS and can only be called by manager
    function registerLand(string memory landAddress, string memory city, string memory country, 
    string memory pincode, address payable currentOwner) public onlyManager returns(uint256){
        // Add a new entry in Land mapping with a new id
        // Status of the land will be registered
        // compute the landID through a deterministic hash function
        uint landID = computeIdLand(landAddress, city, country, pincode);

        // ensure the land is not already registered
        require(!Lands[landID].isRegistered);

        // add land details as specified by the manager
        Lands[landID].landAddress = landAddress;
        Lands[landID].city = city;
        Lands[landID].country = country;
        Lands[landID].pincode = pincode;
        Lands[landID].currentOwner = currentOwner;
        Lands[landID].status = LandStatus.registered;

        // set isRegistered to be true indicating this land is already present in the mapping
        Lands[landID].isRegistered = true;

        // return the newly created landID for future reference
        return landID;
    }

    //This function allows anyone to view the land details
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
        // params:  askingPrice - initial price to start the auction
        //          minBidInterval - minimum bid raise amount
        // Changes land status to underBidding and land is up for auction.
        // Add entry in auction

        // ensures land is not already under bidding
        require(Lands[landId].status == LandStatus.registered);

        // ensure minimum bid raise amount is greater than zero
        require(minBidInterval > 0);

        Auction[landId].highestBidder = payable(address(0));
        Auction[landId].highestBid = 0;
        Auction[landId].askingPrice = askingPrice;
        Auction[landId].minBidInterval = minBidInterval;
        Auction[landId].highestBidTimestamp = block.timestamp;
        Lands[landId].status = LandStatus.underBidding;
    }

    // function to remove a land from auction if there has not been any bid yet on that land
    function deleteFromAuction(uint landId) public onlyOwner(landId){
        // changes land status to registered only if there is no bid yet
        // only accessible by current owner of land
        // reset askingprice, minBidInterval, and landstatus
        require(Lands[landId].status == LandStatus.underBidding);
        require(Auction[landId].highestBid == 0);
        Lands[landId].status = LandStatus.registered;
        Auction[landId].askingPrice = 0;
        Auction[landId].minBidInterval = 0;
    }

    // function to update askingprice and minbidinterval before any bid comes
    function updateAuctionDetails(uint landId, uint newAskingPrice, uint newMinBidInterval) public onlyOwner(landId){
        // changes asking price, minBidInterval in auction if there has not been a bid yet
        // only accessible by current owner of land
        require(Lands[landId].status == LandStatus.underBidding);
        require(Auction[landId].highestBid == 0);

        // ensure minBidInterval is greater than zero
        require(newMinBidInterval > 0);
        Auction[landId].askingPrice = newAskingPrice;
        Auction[landId].minBidInterval = newMinBidInterval;
    }
    
    // this function allows bidders to place a new bid on a piece of land
    function placeBid(uint landId) public payable{
        // params: pass auction Id and 
        // accessible by anyone except the seller
        // check current bid > last bid
        // bidder pay the whole bid amount
        // highest bid is updated
        // check if there was a last bidder, if yes revert amount of last bidder 
       
        uint currentBid = msg.value;
        require(msg.sender!=Lands[landId].currentOwner);
        require(Auction[landId].highestBid + Auction[landId].minBidInterval < currentBid);
        require(Auction[landId].askingPrice<=currentBid);
        require(Lands[landId].status==LandStatus.underBidding);

        // check for a previous bidder
        if (Auction[landId].highestBid>0){
            // in case of previous bidder, return their bid amount
            Auction[landId].highestBidder.transfer(Auction[landId].highestBid);
        }
        // bidder pay the difference of new bid and last highest bid to the seller
        uint toTransfer = currentBid-Auction[landId].highestBid;
        payable(Lands[landId].currentOwner).transfer(toTransfer);

        // current bidder is set as the highest bidder
        Auction[landId].highestBidder = payable(msg.sender);
        Auction[landId].highestBid = currentBid;
        Auction[landId].highestBidTimestamp = block.timestamp;

    }

    //This function allows the current owner to view the auction details including highest bid, initial asking price, highest bid's timestamp
    function viewAuctionDetails(uint landId) public view returns(uint,uint,uint){
        // params: landId to identify a land uniquely
        // returns highest bid value, initial asking price, last bid's timestamp for the current land
        require(Lands[landId].status == LandStatus.underBidding);
        return (Auction[landId].highestBid,
                Auction[landId].askingPrice,
                Auction[landId].highestBidTimestamp);
    }

    // this function allows the current highest bidder to stop the auction and take the ownership if it has been over 30 days that their bid has not been overtaken
    function terminateAuction(uint landId) public {
        // ensure function is only accessible by current highest bidder
        require(Auction[landId].highestBidder == msg.sender);

        // check the last bid was made atleast 30 days ago
        require((Auction[landId].highestBidTimestamp+2592000) < block.timestamp);

        // check the land is still under bidding process
        require(Lands[landId].status == LandStatus.underBidding);

        // take ownership and mark land as registered
        Lands[landId].currentOwner = payable(msg.sender);
        Lands[landId].status = LandStatus.registered;
    }

    //This function allows the current owner to approve the highest bid and proceed with the transfer of ownership
    function acceptHighestBid(uint landId) public onlyOwner(landId){
        // prompts the contract to stop bidding and complete transaction 
        // Will internally call the transfer ownership function

        // ensure land is underbidding and last bid is atleast the asking price        
        require(Lands[landId].status == LandStatus.underBidding);
        require(Auction[landId].highestBid >= Auction[landId].askingPrice);
        transferOwnership(landId, Auction[landId].highestBidder);
        Lands[landId].status = LandStatus.registered;     
    }

    //This function transfers the ownership from current owner to the new owner
    function transferOwnership(uint landId, address payable newOwnerId) private onlyOwner(landId){
        // change owner
        require(Lands[landId].currentOwner != newOwnerId);
        Lands[landId].currentOwner = newOwnerId;
    }
}