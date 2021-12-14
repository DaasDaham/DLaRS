# Decentralized Land Registry System 

We build a decentralized system for land registry using Ethereum Framework and ReactJS.

The smart contracts are present in the contracts folder and need to be deployed to a Ganache workspace to work.

To deploy the smart contract on Ganache, open a workspace on ganache and copy over the RPC url into truffle_config.js file.

Run `truffle migrate --reset` and now the contract is deloyed on Ganache.

Copy over the ABI from `build/contracts/dlars.json` and the contract address into DLaRS.js file.

Add the ganache network to metamask and import addresses into it.

Finally, run the application by doing `npm start` in the parent directory. 

Note: If there are errors, try running `npm install` and then do `npm start`.


# Folder structure

Contracts are placed in contract folder

Frontend files are present in src along with the compiled ABI.

# Team Members: Aman Aggarwal, Prasham Narayan and Saad Ahmad
