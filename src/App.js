import { Box } from "@mui/material";
import HomePage from "./components/homepage/HomePage";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Manager from "./components/manager/Manager";
import Seller from "./components/seller/Seller";
import Bidder from "./components/bidder/Bidder";
import Web3 from 'web3';
import { DLaRS_ABI, DLaRS_ADDRESS } from './DLaRS'

async function loadBlockchainData() {
  const web3 = new Web3(Web3.givenProvider || "HTTP://127.0.0.1:7545")
  const accounts = await web3.eth.getAccounts()
  this.setState({ account: accounts[0] })
  const dlars = new web3.eth.Contract(DLaRS_ABI, DLaRS_ADDRESS)
  this.setState({ dlars })
  const taskCount = await dlars.methods.taskCount().call()
  this.setState({ taskCount })
  for (var i = 1; i <= taskCount; i++) {
    const task = await dlars.methods.tasks(i).call()
    this.setState({
      tasks: [...this.state.tasks, task]
    })
  }
}

function App() {
  
  return (
    <BrowserRouter>
      <Box>
        <Routes>
          <Route path="/" element={<HomePage />} />
          <Route path="/manager" element={<Manager />} />
          <Route path="/seller" element={<Seller />} />
          <Route path="/bidder" element={<Bidder />} />
        </Routes>
      </Box>
    </BrowserRouter>
  );
}

export default App;
