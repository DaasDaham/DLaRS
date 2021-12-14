import { Box } from "@mui/material";
import HomePage from "./components/homepage/HomePage";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Manager from "./components/manager/Manager";
import Seller from "./components/seller/Seller";
import Bidder from "./components/bidder/Bidder";

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
